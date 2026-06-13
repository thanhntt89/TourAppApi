<?php
defined('ABSPATH') || exit;

class TA_Admin {

    public static function register_menu() {
        add_menu_page('ToursApp API', 'ToursApp API', 'manage_options', 'toursapp-api', [self::class, 'render_page'], 'dashicons-rest-api', 80);
        add_submenu_page('toursapp-api', 'Update Plugin', 'Update Plugin', 'update_plugins', 'toursapp-update', [self::class, 'render_update_page']);
        add_action('admin_init',                  [self::class, 'save_settings']);
        add_action('admin_post_ta_api_docs_export', [self::class, 'handle_docs_export']);
        // wp_ajax_ta_plugin_update registered in toursapp-api.php (admin_menu skips admin-ajax.php)
    }

    public static function ajax_plugin_update() {
        // Buffer ALL output to prevent JSON corruption
        while (ob_get_level()) ob_end_clean();
        ob_start();

        // Auth checks
        if (!check_ajax_referer('ta_plugin_update', 'ta_update_nonce', false)) {
            ob_end_clean();
            wp_send_json_error(['message' => 'Security check failed — please refresh and try again.', 'step' => 'auth']);
        }
        if (!current_user_can('update_plugins')) {
            ob_end_clean();
            wp_send_json_error(['message' => 'Insufficient permissions.', 'step' => 'auth']);
        }

        // Suppress PHP notice/warning output during file ops
        $prev = error_reporting(E_ERROR);

        list($error, $success, $version) = self::process_plugin_update();

        error_reporting($prev);

        // Grab anything that leaked into the buffer (PHP notices, WP debug, etc.)
        $leaked = ob_get_clean();

        if ($error) {
            $msg = $error ?: 'process_plugin_update returned empty error. Leaked: ' . substr(strip_tags($leaked), 0, 300);
            wp_send_json_error(['message' => $msg, 'debug' => $leaked ? substr($leaked, 0, 500) : null]);
        } else {
            wp_send_json_success(['message' => $success, 'version' => $version, 'debug' => $leaked ?: null]);
        }
    }

    public static function handle_docs_export() {
        if (!current_user_can('manage_options')) wp_die('Unauthorized');
        if (!isset($_GET['_nonce']) || !wp_verify_nonce($_GET['_nonce'], 'ta_api_docs_export')) wp_die('Invalid nonce');

        $filename = 'toursapp-api-docs-v' . TA_VERSION . '-' . date('Y-m-d') . '.csv';

        // Same pattern as working analytics export
        while (ob_get_level() > 0) ob_end_clean();
        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Pragma: no-cache');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header('Expires: 0');

        $out = fopen('php://output', 'w');
        fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF)); // UTF-8 BOM for Excel

        fputcsv($out, ['Method', 'Endpoint', 'Namespace', 'Auth Required', 'Parameters', 'Description', 'Sample Output']);

        $descriptions   = self::get_descriptions();
        $sample_outputs = self::get_sample_outputs();

        foreach (self::get_routes() as $r) {
            $params = implode('; ', array_map(function ($p) {
                $s = $p['name'] . ' (' . $p['type'] . ')';
                if ($p['required']) $s .= ' *required';
                if (!empty($p['default'])) $s .= ' default:' . $p['default'];
                return $s;
            }, $r['params']));

            $desc   = $descriptions[$r['method'] . ' ' . $r['path']]   ?? ($r['description'] ?? '');
            $sample = $sample_outputs[$r['method'] . ' ' . $r['path']] ?? '';

            fputcsv($out, [
                $r['method'],
                '/' . TA_API_NAMESPACE . $r['path'],
                TA_API_NAMESPACE,
                $r['auth'] ? 'X-Device-UUID required' : 'Public',
                $params,
                $desc,
                $sample,
            ]);
        }

        fclose($out);
        exit;
    }

    // ── Plugin Updater ────────────────────────────────────────────────────

    /**
     * Process zip upload and return [error_string|null, success_string|null, new_version|null]
     */
    private static function process_plugin_update(): array {
        if (empty($_FILES['plugin_zip']) || $_FILES['plugin_zip']['error'] !== UPLOAD_ERR_OK) {
            return ['No file uploaded or upload error.', null, null];
        }

        $file = $_FILES['plugin_zip'];

        // Validate extension
        if (strtolower(pathinfo($file['name'], PATHINFO_EXTENSION)) !== 'zip') {
            return ['File must be a .zip archive.', null, null];
        }

        // Validate MIME type — with fallback for servers without fileinfo extension
        $zip_mimes = ['application/zip', 'application/x-zip-compressed', 'application/x-zip'];
        if (class_exists('finfo')) {
            $finfo = new finfo(FILEINFO_MIME_TYPE);
            $mime  = $finfo->file($file['tmp_name']);
            if (!in_array($mime, $zip_mimes, true)) {
                return ['Invalid file type. File must be a ZIP archive.', null, null];
            }
        } elseif (function_exists('mime_content_type')) {
            $mime = mime_content_type($file['tmp_name']);
            if (!in_array($mime, $zip_mimes, true)) {
                return ['Invalid file type. File must be a ZIP archive.', null, null];
            }
        }
        // If neither fileinfo nor mime_content_type available, trust the extension check above

        if ($file['size'] > 100 * 1024 * 1024) {
            return ['File too large (max 100MB).', null, null];
        }

        require_once ABSPATH . 'wp-admin/includes/file.php';
        add_filter('filesystem_method', function () { return 'direct'; }, 1);
        WP_Filesystem();
        global $wp_filesystem;

        if (!$wp_filesystem) {
            return ['Could not initialize filesystem. Please check file permissions.', null, null];
        }

        $plugin_dir = WP_PLUGIN_DIR . '/toursapp-api';
        $tmp_zip    = get_temp_dir() . 'ta_update_' . time() . '.zip';
        $tmp_dir    = get_temp_dir() . 'ta_update_' . time();

        if (!move_uploaded_file($file['tmp_name'], $tmp_zip)) {
            return ['Could not save uploaded file. Check server temp directory permissions.', null, null];
        }

        // Extract zip
        $unzip_result = unzip_file($tmp_zip, $tmp_dir);
        @unlink($tmp_zip);

        if (is_wp_error($unzip_result)) {
            $wp_filesystem->delete($tmp_dir, true);
            return ['Could not extract zip: ' . $unzip_result->get_error_message(), null, null];
        }

        // Find plugin root inside extracted dir (handles both zip structures)
        $src = $tmp_dir . '/toursapp-api';
        if (!is_dir($src)) {
            // Some zips have files at root level
            $src = $tmp_dir;
        }

        if (!file_exists($src . '/toursapp-api.php')) {
            $wp_filesystem->delete($tmp_dir, true);
            return ['Invalid plugin zip: toursapp-api.php not found. Make sure you are uploading the correct plugin zip.', null, null];
        }

        // Copy extracted files over existing plugin (overwrites, preserves unrelated files)
        $copy_result = copy_dir($src, $plugin_dir);
        $wp_filesystem->delete($tmp_dir, true);

        if (is_wp_error($copy_result)) {
            return ['Could not copy files: ' . $copy_result->get_error_message(), null, null];
        }

        // Re-activate plugin (in case it got deactivated)
        $plugin_file = 'toursapp-api/toursapp-api.php';
        if (!is_plugin_active($plugin_file)) {
            activate_plugin($plugin_file);
        }

        // Read new version from the freshly updated file
        $new_data = get_plugin_data($plugin_dir . '/toursapp-api.php', false, false);
        $new_ver  = $new_data['Version'] ?? 'updated';

        return [null, 'Plugin updated successfully.', $new_ver];
    }

    // Kept for backward compat — no longer used via admin-post
    public static function handle_plugin_update() {
        if (!current_user_can('update_plugins')) wp_die('Unauthorized');
        if (!isset($_POST['ta_update_nonce']) || !wp_verify_nonce($_POST['ta_update_nonce'], 'ta_plugin_update')) wp_die('Invalid nonce');

        // Capture ALL output to prevent "headers already sent"
        ob_start();

        $redirect_error = function ($code, $msg = '') {
            ob_end_clean();
            $args = ['page' => 'toursapp-update', 'update_error' => $code];
            if ($msg) $args['msg'] = urlencode($msg);
            wp_redirect(add_query_arg($args, admin_url('admin.php')));
            exit;
        };

        if (empty($_FILES['plugin_zip']) || $_FILES['plugin_zip']['error'] !== UPLOAD_ERR_OK) {
            $redirect_error('no_file');
        }

        $file = $_FILES['plugin_zip'];

        // Validate MIME type — with fallback for servers without fileinfo extension
        $zip_mimes = ['application/zip', 'application/x-zip-compressed', 'application/x-zip', 'application/octet-stream'];
        if (class_exists('finfo')) {
            $finfo = new finfo(FILEINFO_MIME_TYPE);
            $mime  = $finfo->file($file['tmp_name']);
            if (!in_array($mime, $zip_mimes, true) && substr($file['name'], -4) !== '.zip') {
                $redirect_error('not_zip');
            }
        } elseif (function_exists('mime_content_type')) {
            $mime = mime_content_type($file['tmp_name']);
            if (!in_array($mime, $zip_mimes, true) && substr($file['name'], -4) !== '.zip') {
                $redirect_error('not_zip');
            }
        }
        // If neither available, only extension was checked above — proceed

        require_once ABSPATH . 'wp-admin/includes/file.php';
        require_once ABSPATH . 'wp-admin/includes/misc.php';
        require_once ABSPATH . 'wp-admin/includes/class-wp-upgrader.php';
        if (file_exists(ABSPATH . 'wp-admin/includes/class-wp-ajax-upgrader-skin.php')) {
            require_once ABSPATH . 'wp-admin/includes/class-wp-ajax-upgrader-skin.php';
        }

        // Force direct filesystem (avoid FTP credential prompts)
        add_filter('filesystem_method', function () { return 'direct'; });
        WP_Filesystem();

        // Move upload to temp
        $tmp = wp_tempnam($file['name']);
        if (!move_uploaded_file($file['tmp_name'], $tmp)) {
            $redirect_error('upload_failed');
        }

        // Use WP_Ajax_Upgrader_Skin if available, else WP_Upgrader_Skin
        $skin = class_exists('WP_Ajax_Upgrader_Skin')
            ? new WP_Ajax_Upgrader_Skin()
            : new WP_Upgrader_Skin(['nonce' => wp_create_nonce('ta_plugin_update'), 'url' => '']);

        $upgrader = new Plugin_Upgrader($skin);

        // overwrite_package = replace existing plugin files in-place
        $result = $upgrader->install($tmp, ['overwrite_package' => true]);

        @unlink($tmp);
        ob_end_clean(); // Discard any upgrader output

        if (is_wp_error($result)) {
            wp_redirect(add_query_arg(['page' => 'toursapp-update', 'update_error' => 'install_failed', 'msg' => urlencode($result->get_error_message())], admin_url('admin.php')));
            exit;
        }

        if ($result === false || $result === null) {
            $skin_errors = method_exists($skin, 'get_errors') ? $skin->get_errors() : null;
            $err_msg = ($skin_errors && is_wp_error($skin_errors)) ? $skin_errors->get_error_message() : 'Unknown error during installation.';
            wp_redirect(add_query_arg(['page' => 'toursapp-update', 'update_error' => 'install_failed', 'msg' => urlencode($err_msg)], admin_url('admin.php')));
            exit;
        }

        // Re-activate plugin after update
        $plugin_file = 'toursapp-api/toursapp-api.php';
        if (!is_plugin_active($plugin_file)) {
            activate_plugin($plugin_file);
        }

        wp_redirect(add_query_arg(['page' => 'toursapp-update', 'updated' => 1], admin_url('admin.php')));
        exit;
    }

    public static function render_update_page() {
        if (!current_user_can('update_plugins')) return;

        // Handle upload submitted to this same page
        $update_error   = null;
        $update_success = null;
        $new_version    = null;

        if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['ta_update_nonce'])) {
            if (!wp_verify_nonce($_POST['ta_update_nonce'], 'ta_plugin_update')) {
                $update_error = 'Security check failed. Please try again.';
            } else {
                list($update_error, $update_success, $new_version) = self::process_plugin_update();
            }
        }

        // Re-read plugin data (may be fresh after update)
        $plugin_file = WP_PLUGIN_DIR . '/toursapp-api/toursapp-api.php';
        $data        = get_plugin_data($plugin_file, false, false);
        $current_ver = $data['Version'] ?? TA_VERSION;
        ?>
        <div class="wrap">
            <h1>Update ToursApp API Plugin</h1>

            <?php if ($update_success): ?>
            <div class="notice notice-success" style="border-left-color:#2271b1">
                <p>✅ <strong><?php echo esc_html($update_success); ?></strong>
                   New version: <strong><?php echo esc_html($new_version); ?></strong>
                   &nbsp;·&nbsp; DB tables: <strong><?php echo esc_html(self::count_db_tables()); ?></strong> preserved
                   &nbsp;·&nbsp; <a href="<?php echo esc_url(admin_url('admin.php?page=toursapp-update')); ?>">Update again</a>
                </p>
            </div>
            <?php endif; ?>

            <?php if ($update_error): ?>
            <div class="notice notice-error">
                <p>❌ <strong>Update failed:</strong> <?php echo esc_html($update_error); ?></p>
            </div>
            <?php endif; ?>

            <div style="background:#fff;border:1px solid #ddd;border-radius:6px;padding:20px;max-width:600px;margin-top:16px">
                <h2 style="margin-top:0">Current Version</h2>
                <table class="widefat" style="font-size:13px;margin-bottom:20px">
                    <tbody>
                        <tr><th style="width:140px">Plugin</th><td><?php echo esc_html($data['Name'] ?? 'ToursApp API'); ?></td></tr>
                        <tr><th>Version</th><td><strong><?php echo esc_html($current_ver); ?></strong></td></tr>
                        <tr><th>DB Tables</th><td><?php echo esc_html(self::count_db_tables()); ?> custom tables</td></tr>
                        <tr><th>Status</th><td><span style="color:#155724;font-weight:bold">✅ Active</span></td></tr>
                    </tbody>
                </table>

                <h2>Upload New Version</h2>
                <div style="background:#f0f6fc;border:1px solid #c3d9f0;border-radius:4px;padding:12px 16px;margin-bottom:16px;font-size:13px">
                    <strong>ℹ️ Safe update:</strong> This replaces plugin files only.
                    All database tables and settings are preserved.
                    Plugin is automatically re-activated after update.
                </div>

                <?php wp_nonce_field('ta_plugin_update', 'ta_update_nonce'); ?>

                <div id="ta-drop-zone" style="border:2px dashed #ccc;border-radius:6px;padding:24px;text-align:center;margin-bottom:8px;cursor:pointer;transition:border-color .2s,background .2s"
                     onclick="document.getElementById('ta-zip-input').click()">
                    <p style="font-size:24px;margin:0">📦</p>
                    <p style="margin:8px 0 4px;font-size:14px;font-weight:600">Click to select zip file</p>
                    <p style="margin:0;color:#888;font-size:12px" id="ta-zip-label">or drag & drop here</p>
                    <input type="file" id="ta-zip-input" name="plugin_zip" accept=".zip" style="display:none">
                </div>

                <div id="ta-progress-bar" style="display:none;margin-bottom:8px">
                    <div style="background:#eee;border-radius:4px;height:8px;overflow:hidden">
                        <div id="ta-progress-fill" style="background:#2271b1;height:8px;width:0;transition:width .3s"></div>
                    </div>
                    <span id="ta-progress-text" style="font-size:11px;color:#666">Uploading…</span>
                </div>
                <div id="ta-zip-error" style="display:none;background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;border-radius:4px;padding:8px 12px;font-size:13px;margin-bottom:10px"></div>
                <div id="ta-zip-success" style="display:none;background:#d4edda;color:#155724;border:1px solid #c3e6cb;border-radius:4px;padding:8px 12px;font-size:13px;margin-bottom:10px"></div>

                <p>
                    <button type="button" id="ta-install-btn" class="button button-primary button-large" disabled
                            style="opacity:0.5;cursor:not-allowed">
                        ⬆ Install Update
                    </button>
                </p>

                <hr style="margin:20px 0">

                <h3 style="color:#555;font-size:13px">Alternative: Update via WP Admin Upload</h3>
                <p style="font-size:12px;color:#666">
                    Go to <strong>Plugins → Add New → Upload Plugin</strong> →
                    upload the zip → click <strong>"Replace current with uploaded"</strong>.
                    This also preserves all data.
                </p>
                <a href="<?php echo esc_url(admin_url('plugin-install.php')); ?>" class="button">Open Plugin Upload Page</a>
            </div>
        </div>

        <script>
        (function() {
            var dropZone  = document.getElementById('ta-drop-zone');
            var input     = document.getElementById('ta-zip-input');
            var label     = document.getElementById('ta-zip-label');
            var btn       = document.getElementById('ta-install-btn');
            var errBox    = document.getElementById('ta-zip-error');
            var okBox     = document.getElementById('ta-zip-success');
            var progressBar  = document.getElementById('ta-progress-bar');
            var progressFill = document.getElementById('ta-progress-fill');
            var progressText = document.getElementById('ta-progress-text');
            var nonce     = document.getElementById('ta_update_nonce') ? document.getElementById('ta_update_nonce').value : '';

            function showError(msg) {
                errBox.innerHTML = '❌ ' + msg;
                errBox.style.display = 'block';
                okBox.style.display  = 'none';
                progressBar.style.display = 'none';
            }
            function showSuccess(msg) {
                okBox.innerHTML = '✅ ' + msg;
                okBox.style.display  = 'block';
                errBox.style.display = 'none';
                progressBar.style.display = 'none';
                // Reload page after 2s to reflect new version
                setTimeout(function() { window.location.reload(); }, 2000);
            }
            function clearMessages() {
                errBox.style.display = 'none';
                okBox.style.display  = 'none';
            }

            function validateFile(file) {
                if (!file) { showError('Please select a zip file first.'); return false; }
                if (!file.name.match(/\.zip$/i)) { showError('Invalid file type. Please select a .zip file.'); return false; }
                if (file.size > 50 * 1024 * 1024) { showError('File too large (max 50 MB).'); return false; }
                return true;
            }

            function fileSelected(file) {
                clearMessages();
                if (!validateFile(file)) {
                    btn.disabled = true;
                    btn.style.opacity = '0.5';
                    btn.style.cursor  = 'not-allowed';
                    label.textContent = 'No valid file selected';
                    dropZone.style.borderColor = '#b32d2e';
                    return;
                }
                label.innerHTML = '✅ <strong>' + file.name + '</strong> (' + Math.round(file.size/1024) + ' KB)';
                dropZone.style.borderColor = '#2271b1';
                dropZone.style.background  = '#f0f6fc';
                btn.disabled = false;
                btn.style.opacity = '1';
                btn.style.cursor  = 'pointer';
            }

            input.addEventListener('change', function() { fileSelected(this.files[0]); });

            dropZone.addEventListener('dragover',  function(e) { e.preventDefault(); this.style.borderColor = '#2271b1'; });
            dropZone.addEventListener('dragleave', function()  { if (!input.files[0]) this.style.borderColor = '#ccc'; });
            dropZone.addEventListener('drop', function(e) {
                e.preventDefault();
                var file = e.dataTransfer.files[0];
                if (file) {
                    var dt = new DataTransfer(); dt.items.add(file); input.files = dt.files;
                    fileSelected(file);
                }
            });

            // AJAX upload via admin-ajax.php — bypasses nginx/openresty restrictions on admin.php POST
            btn.addEventListener('click', function() {
                var file = input.files[0];
                if (!file || !validateFile(file)) return;

                var formData = new FormData();
                formData.append('action', 'ta_plugin_update');
                formData.append('ta_update_nonce', nonce);
                formData.append('plugin_zip', file);

                btn.disabled = true;
                btn.style.opacity = '0.7';
                btn.textContent   = '⏳ Uploading…';
                progressBar.style.display = 'block';
                progressFill.style.width  = '0';
                progressText.textContent  = 'Uploading…';
                clearMessages();

                var xhr = new XMLHttpRequest();
                xhr.open('POST', '<?php echo esc_js(admin_url('admin-ajax.php')); ?>', true);

                // Upload progress
                xhr.upload.onprogress = function(e) {
                    if (e.lengthComputable) {
                        var pct = Math.round(e.loaded / e.total * 80); // 0-80% upload
                        progressFill.style.width  = pct + '%';
                        progressText.textContent  = 'Uploading… ' + pct + '%';
                    }
                };

                xhr.onload = function() {
                    progressFill.style.width  = '100%';
                    progressText.textContent  = 'Processing…';
                    btn.textContent = '⬆ Install Update';
                    btn.disabled = false;
                    btn.style.opacity = '1';

                    try {
                        var res = JSON.parse(xhr.responseText);
                        if (res.success) {
                            var dbg = res.data.debug ? '<br><small style="opacity:.6">Debug: ' + res.data.debug + '</small>' : '';
                            showSuccess(res.data.message + ' New version: <strong>' + (res.data.version || '?') + '</strong>. Reloading…' + dbg);
                        } else {
                            var d   = res.data || {};
                            var msg = d.message || 'Installation failed — server returned no message.';
                            var dbg = d.debug   ? '<br><details><summary style="cursor:pointer;font-size:11px">Server debug output</summary><pre style="font-size:10px;max-height:120px;overflow:auto;background:#f5f5f5;padding:6px;white-space:pre-wrap">' + (d.debug + '').replace(/</g,'&lt;') + '</pre></details>' : '';
                            showError(msg + dbg);
                        }
                    } catch(e) {
                        showError('Server returned non-JSON (possible PHP fatal error):<br><pre style="font-size:10px;max-height:120px;overflow:auto;background:#f5f5f5;padding:6px;white-space:pre-wrap">' + xhr.responseText.substring(0, 800).replace(/</g,'&lt;') + '</pre>');
                    }
                };

                xhr.onerror = function() {
                    btn.textContent = '⬆ Install Update';
                    btn.disabled = false;
                    btn.style.opacity = '1';
                    showError('Network error. Please check your connection and try again.');
                };

                xhr.send(formData);
            });
        })();
        </script>
        <?php
    }

    /**
     * Auto-detect live routes from WordPress REST server.
     * Always accurate — no hardcoded list needed.
     */
    public static function get_live_routes(): array {
        // Trigger REST API route registration if not done yet
        if (!did_action('rest_api_init')) {
            do_action('rest_api_init', rest_get_server());
        }

        $our_ns    = '/' . TA_API_NAMESPACE;
        $all       = rest_get_server()->get_routes();
        $routes    = [];
        $m_order   = ['GET' => 0, 'POST' => 1, 'PUT' => 2, 'DELETE' => 3];

        foreach ($all as $route_pattern => $handlers) {
            if ($route_pattern === $our_ns) continue;
            if (strpos($route_pattern, $our_ns . '/') !== 0) continue;

            // Convert regex path pattern → readable form: (?P<id>\d+) → {id}
            $readable = preg_replace('/\(\?P<([^>]+)>[^)]+\)/', '{$1}', $route_pattern);
            $path     = str_replace($our_ns, '', $readable);

            foreach ($handlers as $handler) {
                if (!isset($handler['methods'])) continue;

                $methods = is_array($handler['methods'])
                    ? array_keys(array_filter($handler['methods']))
                    : (array) $handler['methods'];

                foreach ($methods as $method) {
                    $perm = $handler['permission_callback'] ?? '__return_true';
                    $is_auth = !in_array($perm, ['__return_true', '__return_false'], true);

                    $params = [];
                    foreach ((array) ($handler['args'] ?? []) as $pname => $parg) {
                        // Skip URL path params already visible in the route pattern
                        if (strpos($readable, '{' . $pname . '}') !== false) continue;
                        $params[] = [
                            'name'     => $pname,
                            'type'     => $parg['type'] ?? 'string',
                            'required' => !empty($parg['required']),
                            'default'  => isset($parg['default']) ? (string) $parg['default'] : '',
                            'enum'     => $parg['enum'] ?? [],
                        ];
                    }

                    $routes[] = [
                        'method'        => $method,
                        'path'          => $path,
                        'auth'          => $is_auth,
                        'params'        => $params,
                        'description'   => self::get_descriptions()[$method . ' ' . $path] ?? '',
                        'sample_output' => self::get_sample_outputs()[$method . ' ' . $path] ?? '',
                    ];
                }
            }
        }

        usort($routes, function ($a, $b) use ($m_order) {
            $cmp = strcmp($a['path'], $b['path']);
            return $cmp !== 0 ? $cmp : ($m_order[$a['method']] ?? 9) - ($m_order[$b['method']] ?? 9);
        });

        return $routes;
    }

    private static function get_descriptions(): array {
        static $d = null;
        if ($d !== null) return $d;
        $d = [
            // Device
            'POST /device/register'                        => 'Register or update a device. Creates wallet on first registration.',
            // Provinces
            'GET /provinces'                               => 'List all active provinces.',
            'GET /provinces/{id}'                          => 'Get province detail.',
            'GET /provinces/{province_id}/locations'       => 'List locations within a province. Supports distance sort with lat/lng.',
            'GET /locations/{id}'                          => 'Location detail. Add include=places to embed child places.',
            // Places
            'GET /places'                                  => 'List places with filters and pagination.',
            'GET /places/{id}'                             => 'Place detail: article, audio, gallery, paywall status, rating summary.',
            'GET /places/nearby'                           => 'Places within GPS radius (Haversine). Requires lat + lng.',
            'GET /places/qr/{code}'                        => 'Look up a place by its QR code string.',
            'GET /places/search'                           => 'Full-text keyword search across place names.',
            // Sub-places & Sub-items
            'GET /sub-places'                              => 'List sub-places for a place (place_id required).',
            'GET /sub-places/{id}'                         => 'Sub-place detail with audio.',
            'GET /sub-items'                               => 'List sub-items for a sub-place (sub_place_id required).',
            // Journeys
            'GET /journeys'                                => 'List preset journeys for a province.',
            'GET /journeys/{id}'                           => 'Preset journey detail with ordered stops.',
            // Stories
            'GET /stories'                                 => 'List stories. Filter by province, place, type, featured.',
            'GET /stories/{id}'                            => 'Story detail: content, audio (per-lang), related places/provinces, paywall info.',
            // News
            'GET /news'                                    => 'List news and alerts for a province.',
            // User actions (auth required)
            'POST /user/checkin'                           => 'Check in at a place via GPS (geofence validated) or QR code. Earns flowers.',
            'POST /user/unlock'                            => 'Unlock paid article or audio content by spending flowers.',
            'GET /user/history'                            => 'Checkin history with stats (total check-ins, flowers earned).',
            'GET /user/wallet'                             => 'Wallet balance + last 10 transactions.',
            'POST /user/share'                             => 'Record social share or referral. Awards flowers.',
            'POST /user/referral/redeem'                   => 'Redeem an invitation referral code. One-time per device.',
            'GET /user/track'                              => 'Record content engagement (page view, article read, audio play, completion).',
            'POST /user/track'                             => 'Record content engagement event. Only logs if tracking enabled on content.',
            // User journeys
            'GET /user/journeys'                           => 'List custom journeys created by this device.',
            'POST /user/journeys'                          => 'Create custom journey. Free plan: max 5 journeys (403 journey_limit_reached if exceeded). Unlock unlimited_journeys feature to remove limit. Cross-province requires feature unlock.',
            'PUT /user/journeys/{id}'                      => 'Update custom journey name, description, status, or stops.',
            'DELETE /user/journeys/{id}'                   => 'Delete a custom journey.',
            // Features
            'GET /user/features'                           => 'List all feature gates and current device access status.',
            'GET /user/features/{feature}'                 => 'Single feature status + progress (for achievement mode).',
            'POST /user/features/{feature}/unlock'         => 'Unlock a paid feature or verify achievement condition.',
            // Comments
            'GET /content/{type}/{id}/comments'            => 'List approved comments for a content item.',
            'POST /content/{type}/{id}/comments'           => 'Post a comment. Rate limit: 10 per device per day.',
            'PUT /content/{type}/{id}/comments/{cid}'      => 'Edit own comment.',
            'DELETE /content/{type}/{id}/comments/{cid}'   => 'Delete own comment.',
            // Ratings
            'GET /content/{type}/{id}/rating'              => 'Rating summary: avg, total, 1–5 distribution. Includes your_rating if UUID sent.',
            'POST /content/{type}/{id}/rating'             => 'Submit or update rating (1–5 stars). One rating per device per content.',
            // Upload
            'POST /user/upload-photo'                      => 'Upload a comment photo. Max 2MB. jpg/png/webp only.',
            // Analytics
            'GET /analytics/content/{id}'                  => 'Engagement stats for one content item (views, read time, audio completion).',
            'GET /analytics/top-content'                   => 'Ranked content by metric: views, unique, read_time, completion, shares.',
            // Downloads
            'POST /user/downloads/start'                   => 'Record start of offline package download.',
            'POST /user/downloads/complete'                => 'Mark offline download as completed or failed.',
            'GET /user/downloads'                          => 'List device\'s download history.',
            // Sync
            'GET /sync/check'                              => 'Check for content updates since a timestamp.',
            'GET /sync/package/{province_id}'              => 'Full offline data bundle for a province.',
            'GET /sync/media/{province_id}'                => 'Media file manifest for offline download.',
        ];
        return $d;
    }

    private static function get_sample_outputs(): array {
        static $s = null;
        if ($s !== null) return $s;
        $s = [
            'POST /device/register' => '{"device_uuid":"abc-123","is_new":true,"wallet_balance":0,"referral_code":"HG-A1B2C3","last_province_id":null}',
            'GET /provinces'        => '[{"id":1,"name":"Hà Giang","description":"...","feature_image":{"url":"...","alt":"","width":800,"height":600},"latitude":22.82,"longitude":104.98,"detection_radius_km":50,"is_active":true,"total_locations":4,"total_places":24,"sort_order":1}]',
            'GET /places'           => '{"success":true,"data":[{"id":5,"order_number":1,"name":"Mã Pí Lèng","info":"...","feature_image":{"url":"...","alt":"","width":800,"height":600},"latitude":23.12,"longitude":105.43,"is_featured":true,"sort_order":1,"sub_places_count":3}],"meta":{"total":24,"page":1,"per_page":20,"pages":2}}',
            'GET /places/{id}'      => '{"id":5,"hierarchical_index":"1.1","order_number":1,"name":"Mã Pí Lèng","info":"...","article":"<p>...</p>","feature_image":{"url":"..."},"gallery":[{"url":"...","alt":""}],"audio":{"url":"...","size":1024,"duration":180.5},"latitude":23.12,"longitude":105.43,"geofence_radius":200,"qr_code":"MPL-001","is_featured":true,"show_article_free":false,"show_audio_free":true,"article_offline":true,"audio_offline":true,"article_cost":5,"checkin_reward":10,"sort_order":1,"location":{"id":1,"number":1,"name":"Đồng Văn"},"user_status":{"is_checked_in":false,"is_article_unlocked":false,"is_audio_unlocked":false}}',
            'POST /user/checkin'    => '{"checkin_id":42,"place_id":5,"place_name":"Mã Pí Lèng","method":"gps","reward":{"amount":10,"currency":"buckwheat_flower","new_balance":35},"unlocked":{"article":false,"audio":false},"created_at":"2026-06-13 10:00:00"}',
            'POST /user/unlock'     => '{"content_type":"article","content_id":5,"cost":5,"new_balance":30,"unlocked_at":"2026-06-13 10:05:00"}',
            'GET /user/wallet'      => '{"balance":35,"total_earned":50,"total_spent":15,"referral_code":"HG-A1B2C3","recent_transactions":[{"id":1,"type":"earn_checkin","amount":10,"balance_after":35,"note":"Check-in at Mã Pí Lèng","created_at":"2026-06-13 10:00:00"}]}',
            'GET /stories/{id}'     => '{"id":3,"type":"legend","name":"Truyền thuyết Mã Pí Lèng","summary":"...","feature_image":{"url":"..."},"is_featured":true,"sort_order":1,"content":"<p>...</p>","article":{"is_free":true,"cost":0},"audio_info":{"is_free":true,"cost":0,"duration":180.5},"audio":{"url":"https://cdn.../story-vi.mp3","duration":180.5,"size":1024},"allow_comments":true,"allow_ratings":true,"enable_tracking":true,"related_places":[{"id":5,"name":"Mã Pí Lèng","feature_image":{"url":"..."}}],"related_provinces":[{"id":1,"name":"Hà Giang"}]}',
            'GET /content/{type}/{id}/rating' => '{"average":4.3,"total":28,"distribution":{"1":0,"2":1,"3":3,"4":10,"5":14},"your_rating":5}',
            'GET /content/{type}/{id}/comments' => '{"success":true,"data":[{"id":7,"device_uuid":"abc-123","comment_text":"Đẹp lắm!","photo":null,"created_at":"2026-06-13 10:00:00"}],"meta":{"total":12}}',
            'POST /user/track'      => '{"event_id":99}',
            'GET /analytics/content/{id}' => '{"total_events":150,"unique_devices":42,"by_event":{"page_view":{"total":80,"unique_devices":35,"avg_duration":0,"avg_scroll":65.2,"avg_completion":0},"article_read":{"total":50,"unique_devices":30,"avg_duration":120.5,"avg_scroll":85.0,"avg_completion":0}}}',
            'GET /analytics/top-content' => '[{"content_type":"place","content_id":"5","total_events":"150","unique_devices":"42","avg_duration":"120.5","avg_completion":"68.0"}]',
            'GET /user/features'    => '[{"feature":"cross_province","label":"Cross-Province Journeys","enabled":true,"mode":"achievement","has_access":false,"achievement":{"required":10,"current":6,"progress":60}},{"feature":"unlimited_journeys","label":"Unlimited Custom Journeys","enabled":true,"mode":"paid","has_access":false,"cost":20,"unlocked":false}]',
            'GET /sync/check'       => '{"has_updates":true,"last_modified":"2026-06-13 10:00:00","changes":{"provinces":{"updated":0,"last_modified":null},"locations":{"updated":1,"last_modified":"2026-06-13"},"places":{"updated":3,"last_modified":"2026-06-13"},"sub_places":{"updated":0,"last_modified":null},"sub_items":{"updated":0,"last_modified":null},"journeys":{"updated":0,"last_modified":null},"news":{"updated":1,"last_modified":"2026-06-13"}},"estimated_download_size_mb":4.2}',
            'POST /user/journeys'   => '{"id":12,"type":"user","name":"3 ngày Hà Giang","description":"","province_id":1,"source_journey_id":null,"status":"planning","total_places":0,"visited_count":0,"progress_percent":0,"stops":[],"created_at":"2026-06-13 10:00:00","updated_at":"2026-06-13 10:00:00"}',
        ];
        return $s;
    }

    private static function count_db_tables(): int {
        global $wpdb;
        return (int) $wpdb->get_var(
            $wpdb->prepare("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s AND table_name LIKE %s",
                DB_NAME, $wpdb->prefix . 'ta_%')
        );
    }

    public static function save_settings() {
        if (!isset($_POST['ta_api_save_nonce'])) return;
        if (!wp_verify_nonce($_POST['ta_api_save_nonce'], 'ta_api_settings')) return;
        if (!current_user_can('manage_options')) return;

        update_option('ta_api_strict_mode', isset($_POST['ta_api_strict_mode']) ? 1 : 0);

        // API Signature settings
        update_option(TA_Signature::OPTION_ENABLED, isset($_POST['ta_api_signature_enabled']) ? 1 : 0);
        if (!empty($_POST['ta_regenerate_secret'])) {
            update_option(TA_Signature::OPTION_SECRET, TA_Signature::generate_secret());
        } elseif (isset($_POST['ta_api_app_secret'])) {
            $custom_secret = sanitize_text_field($_POST['ta_api_app_secret']);
            if ($custom_secret !== '' && strlen($custom_secret) >= 32) {
                update_option(TA_Signature::OPTION_SECRET, $custom_secret);
            }
        }
        if (!get_option(TA_Signature::OPTION_SECRET)) {
            update_option(TA_Signature::OPTION_SECRET, TA_Signature::generate_secret());
        }

        $routes   = self::get_live_routes();
        $disabled = [];
        foreach ($routes as $r) {
            $key = '/' . TA_API_NAMESPACE . $r['path'] . ':' . $r['method'];
            if (!isset($_POST['ta_ep_enabled'][$key])) {
                $disabled[] = $key;
            }
        }
        update_option('ta_api_disabled_endpoints', $disabled);

        // Save feature settings
        foreach (array_keys(TA_Feature_Access::FEATURES) as $feature) {
            update_option('ta_feature_' . $feature . '_enabled', isset($_POST['ta_feature_' . $feature . '_enabled']) ? 1 : 0);
            $mode = sanitize_text_field($_POST['ta_feature_' . $feature . '_mode'] ?? 'free');
            update_option('ta_feature_' . $feature . '_mode', in_array($mode, ['free', 'paid', 'achievement'], true) ? $mode : 'free');
            update_option('ta_feature_' . $feature . '_cost', (int) ($_POST['ta_feature_' . $feature . '_cost'] ?? 10));
            update_option('ta_feature_' . $feature . '_achievement', (int) ($_POST['ta_feature_' . $feature . '_achievement'] ?? 10));
        }

        wp_redirect(add_query_arg('saved', '1', menu_page_url('toursapp-api', false)));
        exit;
    }

    public static function render_page() {
        if (!current_user_can('manage_options')) return;

        // Use live auto-detected routes from WordPress REST server
        $routes     = self::get_live_routes();
        $strict     = (int) get_option('ta_api_strict_mode', 0);
        $disabled   = (array) get_option('ta_api_disabled_endpoints', []);
        // Generate export URL at render time (baked into onclick — no global JS var needed)
        $export_url = add_query_arg([
            'action' => 'ta_api_docs_export',
            '_nonce' => wp_create_nonce('ta_api_docs_export'),
        ], admin_url('admin-post.php'));
        ?>
        <div class="wrap">
            <h1>ToursApp API — Settings</h1>

            <?php if (isset($_GET['saved'])): ?>
            <div class="notice notice-success is-dismissible"><p>Settings saved.</p></div>
            <?php endif; ?>

            <form method="post">
                <?php wp_nonce_field('ta_api_settings', 'ta_api_save_nonce'); ?>

                <div style="background:#fff;border:1px solid #ddd;padding:16px 20px;margin-bottom:20px;border-radius:4px;">
                    <h2 style="margin-top:0">Global Settings</h2>
                    <table class="form-table" style="margin:0">
                        <tr>
                            <th style="padding:8px 0;width:200px">Strict Mode (Required params)</th>
                            <td>
                                <label>
                                    <input type="checkbox" name="ta_api_strict_mode" value="1" <?php checked($strict, 1); ?>>
                                    <strong>Enable</strong>
                                </label>
                                <p class="description" style="margin-top:4px">
                                    OFF = all <code>*required</code> params become optional (recommended for testing).<br>
                                    ON = missing required params return HTTP 400.
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <th style="padding:8px 0;width:200px">API Request Signing</th>
                            <td>
                                <label>
                                    <input type="checkbox" name="ta_api_signature_enabled" value="1" <?php checked((int) get_option(TA_Signature::OPTION_ENABLED, 0), 1); ?>>
                                    <strong>Enable HMAC Signature Validation</strong>
                                </label>
                                <p class="description" style="margin-top:4px">
                                    ON = all API requests must include valid <code>X-Signature</code>, <code>X-Timestamp</code>, <code>X-Nonce</code> headers.<br>
                                    OFF = signature headers ignored (recommended for development/testing).
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <th style="padding:8px 0">App Secret</th>
                            <td>
                                <?php $sig_secret = get_option(TA_Signature::OPTION_SECRET, ''); ?>
                                <input type="password" name="ta_api_app_secret" id="ta-secret-input" value="<?php echo esc_attr($sig_secret); ?>" style="font-family:monospace;font-size:12px;width:500px;padding:4px 8px" placeholder="Auto-generated if left empty" autocomplete="off">
                                <button type="button" class="button button-small" onclick="var el=document.getElementById('ta-secret-input');var show=el.type==='password';el.type=show?'text':'password';this.textContent=show?'Hide Secret':'Show Secret';">Show Secret</button>
                                <p class="description" style="margin-top:4px">You can paste a custom secret or leave empty to auto-generate. <strong>Minimum 32 characters required.</strong></p>
                                <br><br>
                                <label>
                                    <input type="checkbox" name="ta_regenerate_secret" value="1">
                                    <span style="color:#b32d2e">Regenerate secret on save</span>
                                </label>
                                <p class="description">Warning: regenerating the secret will invalidate all existing app clients until they are updated with the new secret.</p>
                                <?php if ($sig_secret): ?>
                                <details style="margin-top:12px">
                                    <summary style="cursor:pointer;color:#2271b1;font-size:13px">Test with cURL</summary>
                                    <?php
                                        $test_path  = '/' . TA_API_NAMESPACE . '/provinces';
                                        $test_ts    = time();
                                        $test_nonce = bin2hex(random_bytes(8));
                                        $test_sig   = TA_Signature::generate('GET', $test_path, (string)$test_ts, $test_nonce, '');
                                        $base_url   = rest_url(TA_API_NAMESPACE . '/provinces');
                                    ?>
                                    <pre style="background:#1e1e1e;color:#d4d4d4;padding:12px;border-radius:4px;font-size:12px;overflow-x:auto;margin-top:8px">curl -H "X-Signature: <?php echo esc_html($test_sig); ?>" \
     -H "X-Timestamp: <?php echo esc_html($test_ts); ?>" \
     -H "X-Nonce: <?php echo esc_html($test_nonce); ?>" \
     "<?php echo esc_url($base_url); ?>"</pre>
                                    <p class="description" style="margin-top:4px">This signature is valid for 5 minutes from page load.</p>
                                </details>
                                <?php endif; ?>
                            </td>
                        </tr>
                    </table>
                </div>

                <!-- Feature Settings -->
                <div style="background:#fff;border:1px solid #ddd;padding:16px 20px;margin-bottom:20px;border-radius:4px;">
                    <h2 style="margin-top:0">Feature Access</h2>
                    <p style="color:#666;margin-top:-8px;margin-bottom:16px;font-size:13px">
                        Control which premium features are available, and how users unlock them.
                    </p>
                    <table class="widefat" style="font-size:13px">
                        <thead>
                            <tr>
                                <th style="width:22%">Feature</th>
                                <th style="width:80px">Enable</th>
                                <th style="width:200px">Mode</th>
                                <th style="width:130px">Cost (flowers)</th>
                                <th style="width:160px">Achievement (check-ins)</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php foreach (TA_Feature_Access::FEATURES as $feature => $label):
                            $f_enabled = (int) get_option('ta_feature_' . $feature . '_enabled', 0);
                            $f_mode    = get_option('ta_feature_' . $feature . '_mode', 'free');
                            $f_cost    = (int) get_option('ta_feature_' . $feature . '_cost', 10);
                            $f_ach     = (int) get_option('ta_feature_' . $feature . '_achievement', 10);
                        ?>
                        <tr>
                            <td><strong><?php echo esc_html($label); ?></strong><br><code style="font-size:11px"><?php echo esc_html($feature); ?></code></td>
                            <td>
                                <input type="checkbox" name="ta_feature_<?php echo esc_attr($feature); ?>_enabled" value="1" <?php checked($f_enabled, 1); ?>>
                            </td>
                            <td>
                                <select name="ta_feature_<?php echo esc_attr($feature); ?>_mode" style="width:100%">
                                    <option value="free"        <?php selected($f_mode, 'free'); ?>>🆓 Free (everyone)</option>
                                    <option value="paid"        <?php selected($f_mode, 'paid'); ?>>💸 Paid (flowers)</option>
                                    <option value="achievement" <?php selected($f_mode, 'achievement'); ?>>🏆 Achievement (check-ins)</option>
                                </select>
                            </td>
                            <td>
                                <input type="number" name="ta_feature_<?php echo esc_attr($feature); ?>_cost" value="<?php echo esc_attr($f_cost); ?>" min="1" style="width:80px">
                                <span style="color:#888">flowers</span>
                            </td>
                            <td>
                                <input type="number" name="ta_feature_<?php echo esc_attr($feature); ?>_achievement" value="<?php echo esc_attr($f_ach); ?>" min="1" style="width:80px">
                                <span style="color:#888">places</span>
                            </td>
                            <td style="color:#666;font-size:12px">
                                <?php if ($feature === 'cross_province'): ?>
                                    Allow users to build journeys spanning multiple provinces.<br>
                                    API: <code>GET /user/features/cross_province</code>
                                <?php endif; ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>

                <div style="background:#fff;border:1px solid #ddd;padding:16px 20px;border-radius:4px;">
                    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                        <h2 style="margin:0">Endpoints
                            <span style="font-size:13px;font-weight:normal;color:#666;margin-left:8px;">
                                Namespace: <code><?php echo esc_html(TA_API_NAMESPACE); ?></code>
                                &nbsp;|&nbsp; Version: <code><?php echo esc_html(TA_VERSION); ?></code>
                                &nbsp;|&nbsp; <strong><?php echo count($routes); ?></strong> endpoints
                            </span>
                        </h2>
                        <div>
                            <button type="button" class="button" id="ta-enable-all">Enable All</button>
                            <button type="button" class="button" id="ta-disable-all" style="margin-left:4px">Disable All</button>
                            <button type="button" class="button button-primary" style="margin-left:8px"
                                onclick="taExportApiCSV(this)">⬇ Export CSV</button>
                        </div>
                    </div>

            <style>
                #ta-api-table { border-collapse: collapse; width: 100%; font-size: 13px; }
                #ta-api-table th { background: #2271b1; color: #fff; padding: 8px 10px; text-align: left; }
                #ta-api-table td { padding: 7px 10px; border-bottom: 1px solid #ddd; vertical-align: top; }
                #ta-api-table tr:hover td { background: #f0f6fc; }
                #ta-api-table tr.ta-ep-disabled td { opacity: 0.45; }
                #ta-api-table tr.ta-ep-disabled td:first-child { opacity: 1; }
                .ta-method { display:inline-block; padding:2px 7px; border-radius:3px; font-weight:bold; font-size:11px; }
                .ta-GET    { background:#0a7a35; color:#fff; }
                .ta-POST   { background:#0073aa; color:#fff; }
                .ta-PUT    { background:#8b6914; color:#fff; }
                .ta-DELETE { background:#b32d2e; color:#fff; }
                .ta-auth-yes  { color: #b32d2e; font-weight: bold; }
                .ta-auth-no   { color: #555; }
                .ta-param code { background:#f0f0f0; padding:1px 4px; border-radius:2px; margin-right:4px; }
                .ta-toggle { display:inline-flex;align-items:center;cursor:pointer; }
                .ta-toggle input { width:34px;height:18px;cursor:pointer; }
            </style>

            <style>
                .ta-sample-box { display:none; background:#1e1e1e; color:#9cdcfe; font-size:11px; font-family:monospace; padding:8px 10px; border-radius:4px; margin-top:4px; white-space:pre-wrap; max-height:120px; overflow:auto; }
                .ta-sample-btn { background:none; border:1px solid #555; color:#888; font-size:10px; padding:1px 5px; border-radius:3px; cursor:pointer; margin-top:4px; }
                .ta-sample-btn:hover { border-color:#2271b1; color:#2271b1; }
            </style>
            <table id="ta-api-table">
                <thead>
                    <tr>
                        <th style="width:50px">On/Off</th>
                        <th style="width:65px">Method</th>
                        <th style="width:26%">Endpoint</th>
                        <th style="width:80px">Auth</th>
                        <th style="width:22%">Parameters</th>
                        <th>Description</th>
                        <th style="width:80px">Sample</th>
                    </tr>
                </thead>
                <tbody>
                <?php foreach ($routes as $ri => $route):
                    $ep_key     = '/' . TA_API_NAMESPACE . $route['path'] . ':' . $route['method'];
                    $is_enabled = !in_array($ep_key, $disabled, true);
                    $sample_id  = 'ta-sample-' . $ri;
                ?>
                    <tr class="<?php echo $is_enabled ? '' : 'ta-ep-disabled'; ?>">
                        <td>
                            <label class="ta-toggle">
                                <input type="checkbox" name="ta_ep_enabled[<?php echo esc_attr($ep_key); ?>]"
                                       value="1" <?php checked($is_enabled); ?>
                                       onchange="this.closest('tr').classList.toggle('ta-ep-disabled',!this.checked)">
                            </label>
                        </td>
                        <td><span class="ta-method ta-<?php echo esc_attr($route['method']); ?>"><?php echo esc_html($route['method']); ?></span></td>
                        <td><code style="font-size:11px">/<?php echo esc_html(TA_API_NAMESPACE . $route['path']); ?></code></td>
                        <td class="<?php echo $route['auth'] ? 'ta-auth-yes' : 'ta-auth-no'; ?>">
                            <?php echo $route['auth'] ? '🔒 Device UUID' : 'Public'; ?>
                        </td>
                        <td class="ta-param">
                            <?php foreach ($route['params'] as $param): ?>
                                <div>
                                    <code><?php echo esc_html($param['name']); ?></code>
                                    <em style="font-size:11px"><?php echo esc_html($param['type']); ?></em>
                                    <?php if ($param['required']): ?><span style="color:#c00;font-size:10px">*</span><?php endif; ?>
                                    <?php if (!empty($param['default'])): ?><span style="color:#888;font-size:10px">=<?php echo esc_html($param['default']); ?></span><?php endif; ?>
                                </div>
                            <?php endforeach; ?>
                        </td>
                        <td style="font-size:12px;color:#ccc"><?php echo esc_html($route['description']); ?></td>
                        <td>
                            <?php if (!empty($route['sample_output'])): ?>
                            <button type="button" class="ta-sample-btn"
                                onclick="var b=document.getElementById('<?php echo esc_attr($sample_id); ?>');b.style.display=b.style.display==='none'?'block':'none'">
                                { } Preview
                            </button>
                            <pre class="ta-sample-box" id="<?php echo esc_attr($sample_id); ?>"><?php
                                $decoded = json_decode($route['sample_output'], true);
                                echo esc_html($decoded ? json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) : $route['sample_output']);
                            ?></pre>
                            <?php else: ?>
                            <span style="color:#555;font-size:11px">—</span>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
                </div><!-- /.endpoints panel -->

                <p style="margin-top:16px">
                    <?php submit_button('Save Settings', 'primary', 'submit', false); ?>
                </p>
            </form>

            <script>
            document.getElementById('ta-enable-all').addEventListener('click', function() {
                document.querySelectorAll('#ta-api-table input[type=checkbox]').forEach(function(cb) {
                    cb.checked = true;
                    cb.closest('tr').classList.remove('ta-ep-disabled');
                });
            });
            document.getElementById('ta-disable-all').addEventListener('click', function() {
                document.querySelectorAll('#ta-api-table input[type=checkbox]').forEach(function(cb) {
                    cb.checked = false;
                    cb.closest('tr').classList.add('ta-ep-disabled');
                });
            });
            </script>

            <script>
            // Client-side CSV export — reads from the rendered table, no server request needed
            function taExportApiCSV(btn) {
                var orig = btn.innerHTML;
                btn.disabled = true;
                btn.innerHTML = '⏳ Building…';

                try {
                    var rows = [['Method','Endpoint','Auth Required','Parameters','Description','Sample Output']];
                    document.querySelectorAll('#ta-api-table tbody tr').forEach(function(tr) {
                        var tds = tr.querySelectorAll('td');
                        if (tds.length < 6) return;
                        var method  = tds[1] ? tds[1].textContent.trim() : '';
                        var ep      = tds[2] ? tds[2].textContent.trim() : '';
                        var auth    = tds[3] ? tds[3].textContent.trim().replace(/[🔒]/g,'').trim() : '';
                        var params  = tds[4] ? tds[4].textContent.trim().replace(/\s+/g,' ') : '';
                        var desc    = tds[5] ? tds[5].textContent.trim() : '';
                        var pre     = tds[6] ? tds[6].querySelector('pre') : null;
                        var sample  = pre ? pre.textContent.trim() : '';
                        if (!method && !ep) return; // skip empty rows
                        rows.push([method, ep, auth, params, desc, sample]);
                    });

                    var csv = rows.map(function(row) {
                        return row.map(function(cell) {
                            var s = String(cell).replace(/"/g, '""');
                            return (s.indexOf(',') !== -1 || s.indexOf('"') !== -1 || s.indexOf('\n') !== -1 || s.indexOf('\r') !== -1)
                                ? '"' + s + '"' : s;
                        }).join(',');
                    }).join('\r\n');

                    var bom  = '﻿'; // UTF-8 BOM for Excel
                    var blob = new Blob([bom + csv], {type: 'text/csv;charset=utf-8'});
                    var url  = URL.createObjectURL(blob);
                    var a    = document.createElement('a');
                    a.href     = url;
                    a.download = 'toursapp-api-docs-<?php echo esc_js(TA_VERSION); ?>-<?php echo esc_js(date('Y-m-d')); ?>.csv';
                    a.style.display = 'none';
                    document.body.appendChild(a);
                    a.click();
                    setTimeout(function() { URL.revokeObjectURL(url); a.remove(); }, 1000);
                } catch(e) {
                    alert('Export failed: ' + e.message);
                }

                setTimeout(function() { btn.disabled = false; btn.innerHTML = orig; }, 1500);
            }
            </script>
        </div>
        <?php
    }

    private static function export_csv() {
        $routes = self::get_routes();
        $filename = 'toursapp-api-v' . TA_VERSION . '.csv';

        // Clear all output buffers before sending headers
        while (ob_get_level() > 0) {
            ob_end_clean();
        }

        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Pragma: no-cache');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header('Expires: 0');

        $out = fopen('php://output', 'w');
        fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF)); // UTF-8 BOM for Excel

        fputcsv($out, ['Method', 'Endpoint', 'Auth Required', 'Parameters', 'Description']);

        foreach ($routes as $r) {
            $params = implode('; ', array_map(function ($p) {
                $s = $p['name'] . '(' . $p['type'] . ')';
                if ($p['required']) $s .= '*';
                if (!empty($p['default'])) $s .= '='. $p['default'];
                return $s;
            }, $r['params']));

            fputcsv($out, [
                $r['method'],
                '/' . TA_API_NAMESPACE . $r['path'],
                $r['auth'] ? 'X-Device-UUID required' : 'Public',
                $params,
                $r['description'],
            ]);
        }

        fclose($out);
        exit;
    }

    private static function get_routes(): array {
        return [
            // Device
            ['method' => 'POST',   'path' => '/device/register',    'auth' => false, 'description' => 'Register or update a device', 'params' => [
                ['name' => 'device_uuid',  'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'device_name',  'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'platform',     'type' => 'string',  'required' => false, 'default' => 'android'],
                ['name' => 'app_version',  'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'lang',         'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'push_token',   'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'referral_code','type' => 'string',  'required' => false, 'default' => ''],
            ]],
            // Provinces
            ['method' => 'GET', 'path' => '/provinces',            'auth' => false, 'description' => 'List all active provinces', 'params' => [
                ['name' => 'lang', 'type' => 'string', 'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/provinces/{id}',       'auth' => false, 'description' => 'Get province detail', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            // Locations
            ['method' => 'GET', 'path' => '/provinces/{province_id}/locations', 'auth' => false, 'description' => 'List locations in a province', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'sort',        'type' => 'string',  'required' => false, 'default' => 'location_number'],
                ['name' => 'lat',         'type' => 'number',  'required' => false, 'default' => ''],
                ['name' => 'lng',         'type' => 'number',  'required' => false, 'default' => ''],
            ]],
            ['method' => 'GET', 'path' => '/locations/{id}', 'auth' => false, 'description' => 'Get location detail (include=places)', 'params' => [
                ['name' => 'id',      'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',    'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'include', 'type' => 'string',  'required' => false, 'default' => ''],
            ]],
            // Places
            ['method' => 'GET', 'path' => '/places',             'auth' => false, 'description' => 'List places with filters', 'params' => [
                ['name' => 'province_id',  'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'location_id',  'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'lang',         'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'featured',     'type' => 'boolean', 'required' => false, 'default' => ''],
                ['name' => 'search',       'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'sort',         'type' => 'string',  'required' => false, 'default' => 'order'],
                ['name' => 'page',         'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page',     'type' => 'integer', 'required' => false, 'default' => '20'],
            ]],
            ['method' => 'GET', 'path' => '/places/{id}',        'auth' => false, 'description' => 'Get place detail', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/places/nearby',      'auth' => false, 'description' => 'Get nearby places by GPS', 'params' => [
                ['name' => 'lat',         'type' => 'number',  'required' => true,  'default' => ''],
                ['name' => 'lng',         'type' => 'number',  'required' => true,  'default' => ''],
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'radius',      'type' => 'number',  'required' => false, 'default' => '5'],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/places/qr/{code}',   'auth' => false, 'description' => 'Look up place by QR code', 'params' => [
                ['name' => 'code', 'type' => 'string', 'required' => true, 'default' => ''],
                ['name' => 'lang', 'type' => 'string', 'required' => false, 'default' => 'vi'],
            ]],
            // Sub-Places & Sub-Items
            ['method' => 'GET', 'path' => '/sub-places',         'auth' => false, 'description' => 'List sub-places for a place', 'params' => [
                ['name' => 'place_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',     'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/sub-places/{id}',    'auth' => false, 'description' => 'Get sub-place detail', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/sub-items',          'auth' => false, 'description' => 'List sub-items for a sub-place', 'params' => [
                ['name' => 'sub_place_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',         'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            // Journeys
            ['method' => 'GET', 'path' => '/journeys',           'auth' => false, 'description' => 'List preset journeys', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'featured',    'type' => 'boolean', 'required' => false, 'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/journeys/{id}',      'auth' => false, 'description' => 'Get preset journey detail with stops', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            // Stories
            ['method' => 'GET', 'path' => '/stories',            'auth' => false, 'description' => 'List stories (filter by province/place/type)', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'place_id',    'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'type',        'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'featured',    'type' => 'boolean', 'required' => false, 'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'page',        'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page',    'type' => 'integer', 'required' => false, 'default' => '20'],
            ]],
            ['method' => 'GET', 'path' => '/stories/{id}',       'auth' => false, 'description' => 'Get story detail with related places', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            // News
            ['method' => 'GET', 'path' => '/news',               'auth' => false, 'description' => 'List news and alerts', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'type',        'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'page',        'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page',    'type' => 'integer', 'required' => false, 'default' => '20'],
            ]],
            // User — Auth required
            ['method' => 'POST', 'path' => '/user/checkin',      'auth' => true, 'description' => 'Check in at a place (GPS or QR)', 'params' => [
                ['name' => 'place_id',  'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'method',    'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'latitude',  'type' => 'number',  'required' => false, 'default' => ''],
                ['name' => 'longitude', 'type' => 'number',  'required' => false, 'default' => ''],
                ['name' => 'qr_code',   'type' => 'string',  'required' => false, 'default' => ''],
            ]],
            ['method' => 'POST', 'path' => '/user/unlock',       'auth' => true, 'description' => 'Unlock paid content with flowers', 'params' => [
                ['name' => 'content_type', 'type' => 'string',  'required' => true, 'default' => ''],
                ['name' => 'content_id',   'type' => 'integer', 'required' => true, 'default' => ''],
            ]],
            ['method' => 'GET',  'path' => '/user/history',      'auth' => true, 'description' => 'Get user checkin history', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'type',        'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'page',        'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page',    'type' => 'integer', 'required' => false, 'default' => '20'],
            ]],
            ['method' => 'GET',  'path' => '/user/wallet',       'auth' => true, 'description' => 'Get wallet balance and recent transactions', 'params' => []],
            ['method' => 'POST', 'path' => '/user/share',        'auth' => true, 'description' => 'Record a social share or referral', 'params' => [
                ['name' => 'share_type',    'type' => 'string', 'required' => true,  'default' => ''],
                ['name' => 'platform',      'type' => 'string', 'required' => false, 'default' => ''],
                ['name' => 'referral_code', 'type' => 'string', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'POST', 'path' => '/user/referral/redeem', 'auth' => true, 'description' => 'Redeem an invitation referral code', 'params' => [
                ['name' => 'referral_code', 'type' => 'string', 'required' => true, 'default' => ''],
            ]],
            // User Journeys
            ['method' => 'GET',    'path' => '/user/journeys',      'auth' => true, 'description' => 'List user custom journeys', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'POST',   'path' => '/user/journeys',      'auth' => true, 'description' => 'Create a custom journey', 'params' => [
                ['name' => 'province_id',       'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'name',              'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'source_journey_id', 'type' => 'integer', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'PUT',    'path' => '/user/journeys/{id}', 'auth' => true, 'description' => 'Update a custom journey', 'params' => [
                ['name' => 'name',        'type' => 'string', 'required' => false, 'default' => ''],
                ['name' => 'description', 'type' => 'string', 'required' => false, 'default' => ''],
                ['name' => 'status',      'type' => 'string', 'required' => false, 'default' => ''],
                ['name' => 'stops',       'type' => 'array',  'required' => false, 'default' => ''],
            ]],
            ['method' => 'DELETE', 'path' => '/user/journeys/{id}', 'auth' => true, 'description' => 'Delete a custom journey', 'params' => []],
            // Engagement
            ['method' => 'POST', 'path' => '/user/track',           'auth' => true, 'description' => 'Record content engagement event', 'params' => [
                ['name' => 'content_type',   'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'content_id',     'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'event_type',     'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'duration_sec',   'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'scroll_depth',   'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'completion_pct', 'type' => 'integer', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'GET', 'path' => '/analytics/content/{id}',  'auth' => false, 'description' => 'Get engagement stats for one content item', 'params' => [
                ['name' => 'content_type', 'type' => 'string', 'required' => true,  'default' => ''],
                ['name' => 'since',        'type' => 'string', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'GET', 'path' => '/analytics/top-content',   'auth' => false, 'description' => 'Get top content ranked by metric', 'params' => [
                ['name' => 'content_type', 'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'metric',       'type' => 'string',  'required' => false, 'default' => 'views'],
                ['name' => 'limit',        'type' => 'integer', 'required' => false, 'default' => '10'],
                ['name' => 'since',        'type' => 'string',  'required' => false, 'default' => ''],
            ]],
            // Comments & Ratings
            ['method' => 'GET',    'path' => '/content/{type}/{id}/comments',      'auth' => false, 'description' => 'List comments for a content item', 'params' => [
                ['name' => 'page',     'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page', 'type' => 'integer', 'required' => false, 'default' => '20'],
                ['name' => 'sort',     'type' => 'string',  'required' => false, 'default' => 'newest'],
            ]],
            ['method' => 'POST',   'path' => '/content/{type}/{id}/comments',      'auth' => true,  'description' => 'Post a comment (max 10/day)', 'params' => [
                ['name' => 'comment_text', 'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'photo_id',     'type' => 'integer', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'PUT',    'path' => '/content/{type}/{id}/comments/{cid}','auth' => true,  'description' => 'Edit own comment', 'params' => [
                ['name' => 'comment_text', 'type' => 'string', 'required' => true, 'default' => ''],
            ]],
            ['method' => 'DELETE', 'path' => '/content/{type}/{id}/comments/{cid}','auth' => true,  'description' => 'Delete own comment', 'params' => []],
            ['method' => 'GET',    'path' => '/content/{type}/{id}/rating',         'auth' => false, 'description' => 'Get rating summary (avg, count, distribution)', 'params' => []],
            ['method' => 'POST',   'path' => '/content/{type}/{id}/rating',         'auth' => true,  'description' => 'Submit or update rating (1-5 stars)', 'params' => [
                ['name' => 'rating', 'type' => 'integer', 'required' => true, 'default' => ''],
            ]],
            ['method' => 'POST',   'path' => '/user/upload-photo',                 'auth' => true,  'description' => 'Upload comment photo (max 2MB, jpg/png/webp)', 'params' => [
                ['name' => 'photo', 'type' => 'file', 'required' => true, 'default' => ''],
            ]],
            // Downloads
            ['method' => 'GET',  'path' => '/user/downloads',          'auth' => true, 'description' => 'List user offline download records', 'params' => []],
            ['method' => 'POST', 'path' => '/user/downloads/start',    'auth' => true, 'description' => 'Record start of offline package download', 'params' => [
                ['name' => 'province_id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'download_type', 'type' => 'string',  'required' => false, 'default' => 'full'],
                ['name' => 'lang',          'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'POST', 'path' => '/user/downloads/complete', 'auth' => true, 'description' => 'Record completion of offline package download', 'params' => [
                ['name' => 'download_id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'file_count',    'type' => 'integer', 'required' => false, 'default' => '0'],
                ['name' => 'total_size_mb', 'type' => 'number',  'required' => false, 'default' => '0'],
                ['name' => 'status',        'type' => 'string',  'required' => false, 'default' => 'completed'],
            ]],
            // Sync
            ['method' => 'GET', 'path' => '/sync/check',                'auth' => false, 'description' => 'Check for content updates since timestamp', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'since',       'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/sync/package/{province_id}','auth' => false, 'description' => 'Download full offline data package for a province', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'since',       'type' => 'string',  'required' => false, 'default' => ''],
            ]],
            ['method' => 'GET', 'path' => '/sync/media/{province_id}',  'auth' => false, 'description' => 'Get media file list for offline download', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'type',        'type' => 'string',  'required' => false, 'default' => 'all'],
            ]],
        ];
    }
}
