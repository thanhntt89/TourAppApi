<?php
defined('ABSPATH') || exit;

class TA_Archive_Page {

    public static function register_menu() {
        add_submenu_page('toursapp-api', 'Data Archive', 'Archive', 'manage_options', 'toursapp-archive', [self::class, 'render']);
        add_action('admin_init', [self::class, 'handle_save']);
        add_action('wp_ajax_ta_archive_now',      [self::class, 'ajax_archive_now']);
        add_action('wp_ajax_ta_archive_dry_run',  [self::class, 'ajax_dry_run']);
        add_action('wp_ajax_ta_archive_delete',   [self::class, 'ajax_delete_file']);
    }

    // ── Save settings ─────────────────────────────────────────────────────

    public static function handle_save() {
        if (!isset($_POST['ta_archive_save_nonce'])) return;
        if (!wp_verify_nonce($_POST['ta_archive_save_nonce'], 'ta_archive_save')) return;
        if (!current_user_can('manage_options')) return;

        $data = [
            'content_events_days' => max(7,  (int) ($_POST['ta_archive_content_events_days'] ?? 90)),
            'api_logs_days'       => max(7,  (int) ($_POST['ta_archive_api_logs_days']       ?? 30)),
            'error_logs_days'     => max(7,  (int) ($_POST['ta_archive_error_logs_days']      ?? 90)),
            'auto_export'         => isset($_POST['ta_archive_auto_export']) ? 1 : 0,
            'keep_files'          => max(1,  (int) ($_POST['ta_archive_keep_files']           ?? 12)),
        ];

        TA_Data_Archiver::save_settings($data);

        // Schedule/unschedule cron based on settings
        TA_Data_Archiver::schedule();

        wp_redirect(add_query_arg(['page' => 'toursapp-archive', 'saved' => 1], admin_url('admin.php')));
        exit;
    }

    // ── AJAX handlers ─────────────────────────────────────────────────────

    public static function ajax_archive_now() {
        check_ajax_referer('ta_archive_action', '_nonce');
        if (!current_user_can('manage_options')) wp_send_json_error(['message' => 'Unauthorized']);

        $log = TA_Data_Archiver::run();
        wp_send_json_success(['log' => $log]);
    }

    public static function ajax_dry_run() {
        check_ajax_referer('ta_archive_action', '_nonce');
        if (!current_user_can('manage_options')) wp_send_json_error(['message' => 'Unauthorized']);

        $result = TA_Data_Archiver::dry_run();
        wp_send_json_success(['result' => $result]);
    }

    public static function ajax_delete_file() {
        check_ajax_referer('ta_archive_action', '_nonce');
        if (!current_user_can('manage_options')) wp_send_json_error(['message' => 'Unauthorized']);

        $filename = sanitize_file_name($_POST['filename'] ?? '');
        if (!$filename || strpos($filename, 'ta-') !== 0) {
            wp_send_json_error(['message' => 'Invalid filename.']);
        }

        $upload  = wp_upload_dir();
        $dirpath = trailingslashit($upload['basedir']) . TA_Data_Archiver::ARCHIVE_DIR;
        $full    = realpath($dirpath . $filename);

        // Security: ensure file is within archive directory
        if (!$full || strpos($full, realpath($dirpath)) !== 0) {
            wp_send_json_error(['message' => 'File not found.']);
        }

        if (@unlink($full)) {
            wp_send_json_success(['message' => "Deleted {$filename}."]);
        } else {
            wp_send_json_error(['message' => "Could not delete {$filename}."]);
        }
    }

    // ── Render page ───────────────────────────────────────────────────────

    public static function render() {
        if (!current_user_can('manage_options')) return;

        $stats  = TA_Data_Archiver::get_stats();
        $nonce  = wp_create_nonce('ta_archive_action');
        ?>
        <div class="wrap">
            <h1>Data Archive</h1>

            <?php if (isset($_GET['saved'])): ?>
            <div class="notice notice-success is-dismissible"><p>✅ Settings saved.</p></div>
            <?php endif; ?>

            <style>
                .ta-arch-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:12px; margin-bottom:24px; }
                .ta-arch-box { background:#fff; border:1px solid #ddd; border-radius:6px; padding:14px 16px; }
                .ta-arch-box .val { font-size:22px; font-weight:700; color:#2271b1; display:block; }
                .ta-arch-box .lbl { font-size:12px; color:#666; margin-top:4px; display:block; }
                .ta-arch-box .sub { font-size:11px; color:#999; display:block; margin-top:2px; }
                .ta-section { background:#fff; border:1px solid #ddd; border-radius:6px; padding:16px 20px; margin-bottom:20px; }
                .ta-section h2 { margin-top:0; font-size:15px; border-bottom:1px solid #eee; padding-bottom:8px; }
                .ta-file-table { width:100%; border-collapse:collapse; font-size:13px; }
                .ta-file-table th { background:#2271b1; color:#fff; padding:7px 10px; text-align:left; }
                .ta-file-table td { padding:6px 10px; border-bottom:1px solid #eee; }
                .ta-log-box { background:#1e1e1e; color:#9cdcfe; font-size:12px; padding:12px; border-radius:4px; max-height:200px; overflow:auto; font-family:monospace; white-space:pre; }
                #ta-dry-result { background:#f8f9fa; border:1px solid #ddd; border-radius:4px; padding:12px; font-size:12px; font-family:monospace; max-height:300px; overflow:auto; white-space:pre-wrap; }
                /* Tables: horizontal scroll on small screens */
                .ta-table-wrap { overflow-x:auto; -webkit-overflow-scrolling:touch; margin-bottom:16px; }
                .ta-table-wrap table { min-width:600px; margin-bottom:0 !important; }
                @media (max-width: 782px) {
                    .ta-section { padding:12px 14px; }
                    .ta-arch-grid { grid-template-columns:repeat(auto-fill,minmax(120px,1fr)); gap:8px; }
                }
            </style>

            <!-- Status Dashboard -->
            <div class="ta-section">
                <h2>📊 Current Database Status</h2>
                <div class="ta-arch-grid">
                    <?php foreach (['ta_content_events','ta_api_logs','ta_error_logs','ta_content_stats_daily'] as $t):
                        $s = $stats[$t] ?? ['rows' => 0, 'oldest' => '—'];
                        $label_map = [
                            'ta_content_events'      => 'Content Events (raw)',
                            'ta_api_logs'            => 'API Logs',
                            'ta_error_logs'          => 'Error Logs',
                            'ta_content_stats_daily' => 'Daily Stats (aggregated)',
                        ];
                    ?>
                    <div class="ta-arch-box">
                        <span class="val"><?php echo esc_html(number_format($s['rows'])); ?></span>
                        <span class="lbl"><?php echo esc_html($label_map[$t]); ?></span>
                        <span class="sub">Oldest: <?php echo esc_html($s['oldest']); ?></span>
                    </div>
                    <?php endforeach; ?>
                    <div class="ta-arch-box">
                        <span class="val"><?php echo esc_html($stats['archives']['file_count']); ?></span>
                        <span class="lbl">Archive Files</span>
                        <span class="sub"><?php echo esc_html($stats['archives']['total_size']); ?> total</span>
                    </div>
                    <div class="ta-arch-box">
                        <span class="val" style="font-size:14px"><?php echo esc_html($stats['next_run']); ?></span>
                        <span class="lbl">Next Archive Run</span>
                        <span class="sub">Last: <?php echo esc_html($stats['last_run']); ?></span>
                    </div>
                </div>

                <?php if (!empty($stats['last_log'])): ?>
                <details><summary style="cursor:pointer;font-size:13px;color:#555">Last run log</summary>
                <div class="ta-log-box"><?php echo esc_html(implode("\n", $stats['last_log'])); ?></div>
                </details>
                <?php endif; ?>
            </div>

            <!-- Settings -->
            <div class="ta-section">
                <h2>⚙️ Retention Settings</h2>
                <form method="post">
                    <?php wp_nonce_field('ta_archive_save', 'ta_archive_save_nonce'); ?>
                    <div class="ta-table-wrap"><table class="widefat" style="font-size:13px;margin-bottom:16px">
                        <thead><tr>
                            <th>Table</th>
                            <th>Keep in DB for</th>
                            <th>Data older than this will be exported + purged</th>
                        </tr></thead>
                        <tbody>
                        <?php
                        $retention_rows = [
                            ['Content Events (ta_content_events)', 'content_events_days', 'Raw interaction events: page views, audio plays, reads'],
                            ['API Logs (ta_api_logs)',              'api_logs_days',       'Every API request log'],
                            ['Error Logs (ta_error_logs)',          'error_logs_days',     'Detailed 4xx/5xx error records'],
                        ];
                        foreach ($retention_rows as [$label, $key, $desc]):
                        ?>
                        <tr>
                            <td><strong><?php echo esc_html($label); ?></strong><br><span style="color:#888;font-size:11px"><?php echo esc_html($desc); ?></span></td>
                            <td>
                                <input type="number" name="ta_archive_<?php echo esc_attr($key); ?>"
                                    value="<?php echo esc_attr(TA_Data_Archiver::get($key)); ?>"
                                    min="7" style="width:80px"> days
                            </td>
                            <td style="color:#888;font-size:12px">
                                Cutoff: <strong><?php echo date('Y-m-d', strtotime('-' . (int) TA_Data_Archiver::get($key) . ' days')); ?></strong>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                        </tbody>
                    </table></div>

                    <div style="display:flex;gap:24px;align-items:flex-start;flex-wrap:wrap">
                        <label style="font-size:13px">
                            <input type="checkbox" name="ta_archive_auto_export" value="1" <?php checked(TA_Data_Archiver::get('auto_export'), 1); ?>>
                            <strong>Auto-export CSV</strong> before purging<br>
                            <span style="color:#888;font-size:12px;margin-left:20px">Save raw data to archive files before deletion</span>
                        </label>
                        <label style="font-size:13px">
                            Keep last <input type="number" name="ta_archive_keep_files"
                                value="<?php echo esc_attr(TA_Data_Archiver::get('keep_files')); ?>"
                                min="1" style="width:60px"> archive sets
                            <span style="color:#888;font-size:11px;display:block;margin-top:2px">Each "set" = 3 files (events + api + errors) for one month</span>
                        </label>
                    </div>

                    <p style="margin-top:16px">
                        <?php submit_button('Save Settings', 'primary', 'submit', false); ?>
                    </p>
                </form>
            </div>

            <!-- Manual Controls -->
            <div class="ta-section">
                <h2>🚀 Manual Controls</h2>
                <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap">
                    <button type="button" id="ta-archive-now" class="button button-primary">🗜 Archive Now</button>
                    <button type="button" id="ta-dry-run" class="button">🔍 Dry Run (Preview)</button>
                    <span id="ta-action-status" style="font-size:13px;color:#666"></span>
                </div>
                <div id="ta-archive-log" style="display:none;margin-top:12px"></div>
                <div id="ta-dry-result" style="display:none;margin-top:12px"></div>
            </div>

            <!-- Archive Files -->
            <div class="ta-section">
                <h2>📁 Archive Files <span style="font-size:12px;font-weight:normal;color:#666">(stored in wp-content/uploads/toursapp-archives/ — not publicly accessible)</span></h2>
                <?php if (empty($stats['archives']['files'])): ?>
                <p style="color:#888">No archive files yet. Files are created automatically during archive runs.</p>
                <?php else: ?>
                <div class="ta-table-wrap"><table class="ta-file-table">
                    <thead><tr><th>Filename</th><th>Size</th><th>Created</th><th>Action</th></tr></thead>
                    <tbody>
                    <?php foreach (array_reverse($stats['archives']['files']) as $file): ?>
                    <tr>
                        <td><code><?php echo esc_html($file['name']); ?></code></td>
                        <td><?php echo esc_html($file['size']); ?></td>
                        <td><?php echo esc_html($file['date']); ?></td>
                        <td>
                            <button type="button" class="button button-small ta-delete-file"
                                data-file="<?php echo esc_attr($file['name']); ?>"
                                style="color:#b32d2e;border-color:#b32d2e">🗑 Delete</button>
                        </td>
                    </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table></div>
                <?php endif; ?>
            </div>
        </div>

        <script>
        (function() {
            var nonce = '<?php echo esc_js($nonce); ?>';
            var ajaxUrl = '<?php echo esc_js(admin_url('admin-ajax.php')); ?>';

            function setStatus(msg) {
                document.getElementById('ta-action-status').textContent = msg;
            }

            // Archive Now
            document.getElementById('ta-archive-now').addEventListener('click', function() {
                if (!confirm('Run archive process now? This will aggregate, export (if enabled), and purge old data.')) return;
                this.disabled = true;
                setStatus('⏳ Running archive…');
                document.getElementById('ta-archive-log').style.display = 'none';
                document.getElementById('ta-dry-result').style.display = 'none';

                var fd = new FormData();
                fd.append('action', 'ta_archive_now');
                fd.append('_nonce', nonce);

                fetch(ajaxUrl, {method:'POST', body:fd})
                    .then(function(r){return r.json();})
                    .then(function(res) {
                        var btn = document.getElementById('ta-archive-now');
                        btn.disabled = false;
                        if (res.success) {
                            setStatus('✅ Archive complete.');
                            var logBox = document.getElementById('ta-archive-log');
                            logBox.innerHTML = '<div class="ta-log-box">' + res.data.log.join('\n') + '</div>';
                            logBox.style.display = 'block';
                            setTimeout(function(){location.reload();}, 3000);
                        } else {
                            setStatus('❌ ' + (res.data && res.data.message ? res.data.message : 'Failed.'));
                        }
                    })
                    .catch(function(){
                        document.getElementById('ta-archive-now').disabled = false;
                        setStatus('❌ Network error.');
                    });
            });

            // Dry Run
            document.getElementById('ta-dry-run').addEventListener('click', function() {
                this.disabled = true;
                setStatus('⏳ Calculating…');
                document.getElementById('ta-archive-log').style.display = 'none';

                var fd = new FormData();
                fd.append('action', 'ta_archive_dry_run');
                fd.append('_nonce', nonce);

                fetch(ajaxUrl, {method:'POST', body:fd})
                    .then(function(r){return r.json();})
                    .then(function(res) {
                        document.getElementById('ta-dry-run').disabled = false;
                        var box = document.getElementById('ta-dry-result');
                        if (res.success) {
                            setStatus('');
                            box.textContent = JSON.stringify(res.data.result, null, 2);
                            box.style.display = 'block';
                        } else {
                            setStatus('❌ Failed.');
                        }
                    })
                    .catch(function(){
                        document.getElementById('ta-dry-run').disabled = false;
                        setStatus('❌ Network error.');
                    });
            });

            // Delete file
            document.querySelectorAll('.ta-delete-file').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var fn = this.dataset.file;
                    if (!confirm('Delete ' + fn + '? This cannot be undone.')) return;
                    var fd = new FormData();
                    fd.append('action', 'ta_archive_delete');
                    fd.append('_nonce', nonce);
                    fd.append('filename', fn);
                    fetch(ajaxUrl, {method:'POST', body:fd})
                        .then(function(r){return r.json();})
                        .then(function(res){
                            if (res.success) location.reload();
                            else alert(res.data && res.data.message ? res.data.message : 'Delete failed.');
                        });
                });
            });
        })();
        </script>
        <?php
    }
}
