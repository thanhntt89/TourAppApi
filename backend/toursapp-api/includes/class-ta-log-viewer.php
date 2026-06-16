<?php
defined('ABSPATH') || exit;

class TA_Log_Viewer {

    public static function register_menu() {
        add_submenu_page('toursapp-api', 'API Logs', 'API Logs', 'manage_options', 'toursapp-logs', [self::class, 'render']);
    }

    public static function handle_clear() {
        if (!current_user_can('manage_options')) wp_die('Unauthorized');
        if (!isset($_POST['_nonce']) || !wp_verify_nonce($_POST['_nonce'], 'ta_logs_clear')) wp_die('Invalid nonce');

        global $wpdb;
        $days = (int) ($_POST['days'] ?? 30);

        if ($days === 0) {
            // Delete all logs
            $deleted = $wpdb->query("DELETE FROM {$wpdb->prefix}ta_api_logs");
            $wpdb->query("DELETE FROM {$wpdb->prefix}ta_error_logs");
        } else {
            $deleted = $wpdb->query($wpdb->prepare(
                "DELETE FROM {$wpdb->prefix}ta_api_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL %d DAY)", $days
            ));
            $wpdb->query($wpdb->prepare(
                "DELETE FROM {$wpdb->prefix}ta_error_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL %d DAY)", $days
            ));
        }

        wp_redirect(add_query_arg(['page' => 'toursapp-logs', 'cleared' => (int) $deleted], admin_url('admin.php')));
        exit;
    }

    public static function handle_delete_row() {
        if (!current_user_can('manage_options')) wp_die('Unauthorized');
        if (!isset($_POST['_nonce']) || !wp_verify_nonce($_POST['_nonce'], 'ta_logs_delete_row')) wp_die('Invalid nonce');

        global $wpdb;
        $id = (int) ($_POST['log_id'] ?? 0);
        if ($id) {
            $wpdb->delete($wpdb->prefix . 'ta_api_logs',   ['id' => $id]);
            $wpdb->delete($wpdb->prefix . 'ta_error_logs', ['log_id' => $id]);
        }

        // Return to same page with same filters
        $redirect = add_query_arg(array_merge(
            array_intersect_key($_POST, array_flip(['uuid','endpoint','method','status','from','to','errors_only','paged'])),
            ['page' => 'toursapp-logs', 'deleted' => 1]
        ), admin_url('admin.php'));
        wp_redirect($redirect);
        exit;
    }

    public static function render() {
        if (!current_user_can('manage_options')) return;

        global $wpdb;
        $wpdb->suppress_errors(true);
        $p = $wpdb->prefix;

        // Filters
        $f_uuid     = sanitize_text_field($_GET['uuid']     ?? '');
        $f_endpoint = sanitize_text_field($_GET['endpoint'] ?? '');
        $f_method   = sanitize_text_field($_GET['method']   ?? '');
        $f_status   = sanitize_text_field($_GET['status']   ?? '');
        // Validate date format strictly — prevents SQL injection via date fields
        $raw_from   = sanitize_text_field($_GET['from'] ?? '');
        $raw_to     = sanitize_text_field($_GET['to']   ?? '');
        $f_from     = preg_match('/^\d{4}-\d{2}-\d{2}$/', $raw_from) ? $raw_from : date('Y-m-d', strtotime('-7 days'));
        $f_to       = preg_match('/^\d{4}-\d{2}-\d{2}$/', $raw_to)   ? $raw_to   : date('Y-m-d');
        $f_error    = isset($_GET['errors_only']) && $_GET['errors_only'] === '1';
        $page       = max(1, (int) ($_GET['paged'] ?? 1));
        $per_page   = 50;

        // Build WHERE using prepare() for every condition — no raw interpolation
        $where_parts  = [];
        $where_values = [];

        // Date range — already validated as YYYY-MM-DD above
        $where_parts[]  = 'l.created_at BETWEEN %s AND %s';
        $where_values[] = $f_from . ' 00:00:00';
        $where_values[] = $f_to   . ' 23:59:59';

        if ($f_uuid)   { $where_parts[] = 'l.device_uuid = %s'; $where_values[] = $f_uuid; }
        if ($f_endpoint) { $where_parts[] = 'l.endpoint LIKE %s'; $where_values[] = '%' . $wpdb->esc_like($f_endpoint) . '%'; }
        if ($f_method) { $where_parts[] = 'l.method = %s'; $where_values[] = strtoupper($f_method); }

        // Status range — no user input interpolated, only known safe values
        if ($f_status === '2xx') $where_parts[] = 'l.status_code BETWEEN 200 AND 299';
        if ($f_status === '4xx') $where_parts[] = 'l.status_code BETWEEN 400 AND 499';
        if ($f_status === '5xx') $where_parts[] = 'l.status_code >= 500';
        if ($f_error)            $where_parts[] = 'l.status_code >= 400';

        $where_sql = 'WHERE ' . implode(' AND ', $where_parts);
        $prepared  = $wpdb->prepare($where_sql, $where_values);

        $offset = ($page - 1) * $per_page;

        $total = (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_api_logs l $prepared");
        $rows  = $wpdb->get_results(
            "SELECT l.*, e.error_code, e.error_message, e.request_params, e.response_body, e.user_agent, e.id AS error_log_id
             FROM {$p}ta_api_logs l
             LEFT JOIN {$p}ta_error_logs e ON e.log_id = l.id
             $prepared
             ORDER BY l.id DESC
             LIMIT {$per_page} OFFSET {$offset}",
            ARRAY_A
        ) ?: [];

        $total_pages = ceil($total / $per_page);
        ?>
        <div class="wrap">
            <h1 style="display:flex;align-items:center;gap:12px">API Logs
                <span style="font-size:14px;font-weight:normal;color:#666"><?php echo number_format($total); ?> entries found</span>
            </h1>

            <?php if (isset($_GET['cleared'])): ?>
            <div class="notice notice-success is-dismissible"><p>✅ Cleared <strong><?php echo (int)$_GET['cleared']; ?></strong> log entries.</p></div>
            <?php endif; ?>
            <?php if (isset($_GET['deleted'])): ?>
            <div class="notice notice-success is-dismissible"><p>✅ Log entry deleted.</p></div>
            <?php endif; ?>

            <style>
                .ta-log-filters { background:#fff; border:1px solid #ddd; padding:14px 16px; border-radius:4px; margin-bottom:16px; display:flex; flex-wrap:wrap; gap:10px; align-items:flex-end; }
                .ta-log-filters label { display:flex; flex-direction:column; font-size:12px; color:#555; gap:3px; }
                .ta-log-filters input, .ta-log-filters select { font-size:13px; }
                .ta-log-table { width:100%; border-collapse:collapse; font-size:12px; }
                .ta-log-table th { background:#1d2327; color:#fff; padding:7px 8px; text-align:left; position:sticky; top:32px; }
                .ta-log-table td { padding:5px 8px; border-bottom:1px solid #f0f0f0; vertical-align:top; }
                .ta-log-table tr:hover td { background:#f8f9fa; }
                .ta-log-table tr.ta-err-row td { background:#fff5f5; }
                .ta-log-table tr.ta-err-row:hover td { background:#ffe8e8; }
                .ta-status { display:inline-block; padding:1px 6px; border-radius:3px; font-size:11px; font-weight:bold; }
                .ta-2xx { background:#d4edda; color:#155724; }
                .ta-4xx { background:#fff3cd; color:#856404; }
                .ta-5xx { background:#f8d7da; color:#721c24; }
                .ta-method-badge { display:inline-block; padding:1px 5px; border-radius:2px; font-size:10px; font-weight:bold; color:#fff; }
                .ta-slow { color:#b32d2e; font-weight:bold; }
                .ta-detail-row td { background:#f8f9fa !important; padding:10px 16px; }
                .ta-detail-row pre { margin:0; white-space:pre-wrap; font-size:11px; max-height:200px; overflow:auto; background:#fff; padding:8px; border:1px solid #ddd; border-radius:3px; }
                .ta-uuid-link { font-family:monospace; font-size:11px; color:#0073aa; text-decoration:none; }
                .ta-uuid-link:hover { text-decoration:underline; }
                @media(max-width:768px){
                    .ta-log-filters label { min-width:calc(50% - 8px); }
                    .ta-log-filters input[type=date] { width:100% !important; box-sizing:border-box; }
                    .ta-log-filters input[type=text] { width:100% !important; box-sizing:border-box; }
                }
            </style>

            <!-- Filters -->
            <form method="get" class="ta-log-filters">
                <input type="hidden" name="page" value="toursapp-logs">
                <label>From<input type="date" name="from" value="<?php echo esc_attr($f_from); ?>" style="width:130px"></label>
                <label>To<input type="date" name="to" value="<?php echo esc_attr($f_to); ?>" style="width:130px"></label>
                <label>Device UUID<input type="text" name="uuid" value="<?php echo esc_attr($f_uuid); ?>" style="width:200px" placeholder="partial match"></label>
                <label>Endpoint<input type="text" name="endpoint" value="<?php echo esc_attr($f_endpoint); ?>" style="width:180px" placeholder="/toursapp/v1/..."></label>
                <label>Method
                    <select name="method">
                        <option value="">All</option>
                        <?php foreach (['GET','POST','PUT','DELETE'] as $m): ?>
                        <option value="<?php echo $m; ?>" <?php selected($f_method, $m); ?>><?php echo $m; ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>
                <label>Status
                    <select name="status">
                        <option value="">All</option>
                        <option value="2xx" <?php selected($f_status,'2xx'); ?>>2xx Success</option>
                        <option value="4xx" <?php selected($f_status,'4xx'); ?>>4xx Client Error</option>
                        <option value="5xx" <?php selected($f_status,'5xx'); ?>>5xx Server Error</option>
                    </select>
                </label>
                <label style="flex-direction:row;align-items:center;gap:6px">
                    <input type="checkbox" name="errors_only" value="1" <?php checked($f_error); ?>>
                    Errors only (4xx+5xx)
                </label>
                <button type="submit" class="button button-primary">Filter</button>
                <a href="<?php echo esc_url(admin_url('admin.php?page=toursapp-logs')); ?>" class="button">Reset</a>
            </form>

            <!-- Toolbar -->
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;flex-wrap:wrap;gap:8px">
                <div style="font-size:12px;color:#666">
                    Page <?php echo $page; ?> of <?php echo max(1, $total_pages); ?>
                    &nbsp;·&nbsp; Showing <?php echo count($rows); ?> of <?php echo number_format($total); ?> entries
                </div>
                <div style="display:flex;gap:6px;align-items:center">
                    <?php
                    $total_all    = (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_api_logs");
                    $deletable_30 = (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_api_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY)");
                    // Smart default: if no old logs exist, pre-select "All time"
                    $default_days  = ($deletable_30 === 0 && $total_all > 0) ? 0 : 30;
                    $default_count = $default_days === 0 ? $total_all : $deletable_30;
                    $btn_enabled   = $default_count > 0;
                    ?>
                    <form method="post" action="<?php echo esc_url(admin_url('admin-post.php')); ?>" id="ta-clear-form" style="display:flex;gap:6px;align-items:center">
                        <input type="hidden" name="action" value="ta_logs_clear">
                        <?php wp_nonce_field('ta_logs_clear', '_nonce'); ?>
                        <span style="font-size:12px;color:#666">Delete logs older than</span>
                        <select name="days" id="ta-clear-days" style="font-size:12px" onchange="taUpdateClearCount(this.value)">
                            <option value="7"  <?php selected($default_days, 7);   ?>>7 days</option>
                            <option value="30" <?php selected($default_days, 30);  ?>>30 days</option>
                            <option value="90" <?php selected($default_days, 90);  ?>>90 days</option>
                            <option value="365"<?php selected($default_days, 365); ?>>1 year</option>
                            <option value="0"  <?php selected($default_days, 0);   ?>>All time</option>
                        </select>
                        <button type="button" id="ta-clear-btn"
                            class="button"
                            style="<?php echo !$btn_enabled ? 'opacity:0.5;cursor:not-allowed' : ''; ?>"
                            <?php echo !$btn_enabled ? 'disabled' : ''; ?>
                            data-count="<?php echo $default_count; ?>"
                            onclick="taConfirmClear(this)">
                            🗑 Clear (<span id="ta-clear-count"><?php echo $default_count; ?></span>)
                        </button>
                    </form>
                    <!-- Inline confirmation (hidden by default) -->
                    <div id="ta-clear-confirm" style="display:none;background:#fff3cd;border:1px solid #ffc107;border-radius:4px;padding:8px 12px;font-size:13px;display:none;align-items:center;gap:8px">
                        <span id="ta-clear-confirm-text"></span>
                        <button type="button" class="button button-small" style="background:#b32d2e;color:#fff;border-color:#b32d2e"
                            onclick="document.getElementById('ta-clear-form').submit()">Yes, delete</button>
                        <button type="button" class="button button-small" onclick="taHideClearConfirm()">Cancel</button>
                    </div>
                </div>
            </div>

            <!-- Log table -->
            <div style="overflow-x:auto"><table class="ta-log-table">
                <thead>
                    <tr>
                        <th style="width:40px">#</th>
                        <th style="width:140px">Time</th>
                        <th style="width:50px">Method</th>
                        <th>Endpoint</th>
                        <th style="width:60px">Status</th>
                        <th style="width:70px">Time (ms)</th>
                        <th style="width:140px">Device UUID</th>
                        <th style="width:100px">IP</th>
                        <th style="width:40px">Detail</th>
                        <th style="width:40px">Del</th>
                    </tr>
                </thead>
                <tbody>
                <?php
                $m_colors = ['GET' => '#0a7a35', 'POST' => '#0073aa', 'PUT' => '#8b6914', 'DELETE' => '#b32d2e'];
                foreach ($rows as $i => $row):
                    $is_err   = $row['status_code'] >= 400;
                    $status_cls = $row['status_code'] >= 500 ? 'ta-5xx' : ($row['status_code'] >= 400 ? 'ta-4xx' : 'ta-2xx');
                    $slow_cls   = $row['response_ms'] > 2000 ? 'ta-slow' : ($row['response_ms'] > 1000 ? 'color:#856404' : '');
                    $mc         = $m_colors[$row['method']] ?? '#555';
                    $uuid_short = $row['device_uuid'] ? substr($row['device_uuid'], 0, 16) . '...' : '—';
                    $detail_id  = 'log-detail-' . $row['id'];
                    $user_url   = add_query_arg(['page' => 'toursapp-analytics', 'tab' => 'users', 'uuid' => $row['device_uuid']], admin_url('admin.php'));
                ?>
                <tr class="<?php echo $is_err ? 'ta-err-row' : ''; ?>">
                    <td style="color:#999;font-size:10px"><?php echo esc_html(($page - 1) * $per_page + $i + 1); ?></td>
                    <td style="font-size:11px;color:#555;white-space:nowrap"><?php echo esc_html($row['created_at']); ?></td>
                    <td><span class="ta-method-badge" style="background:<?php echo esc_attr($mc); ?>"><?php echo esc_html($row['method']); ?></span></td>
                    <td style="font-size:11px"><code><?php echo esc_html($row['endpoint']); ?></code></td>
                    <td><span class="ta-status <?php echo esc_attr($status_cls); ?>"><?php echo esc_html($row['status_code']); ?></span></td>
                    <td style="<?php echo esc_attr($slow_cls); ?>"><?php echo esc_html($row['response_ms']); ?>ms</td>
                    <td>
                        <?php if ($row['device_uuid']): ?>
                        <a href="<?php echo esc_url($user_url); ?>" class="ta-uuid-link" title="<?php echo esc_attr($row['device_uuid']); ?>">
                            <?php echo esc_html($uuid_short); ?>
                        </a>
                        <?php else: ?><span style="color:#999">—</span><?php endif; ?>
                    </td>
                    <td style="font-size:11px;color:#666"><?php echo esc_html($row['ip_address']); ?></td>
                    <td>
                        <?php if ($is_err && $row['error_code']): ?>
                        <button type="button"
                            onclick="var d=document.getElementById('<?php echo esc_attr($detail_id); ?>');d.style.display=d.style.display==='none'?'':'none'"
                            style="background:none;border:none;cursor:pointer;font-size:14px" title="View error detail">🔍</button>
                        <?php endif; ?>
                    </td>
                    <td>
                        <button type="button"
                            style="background:none;border:none;cursor:pointer;font-size:13px;color:#b32d2e;padding:2px 4px"
                            title="Delete this log entry"
                            onclick="taConfirmDeleteRow(<?php echo (int)$row['id']; ?>, this)">✕</button>
                        <form id="ta-del-row-<?php echo (int)$row['id']; ?>" method="post"
                              action="<?php echo esc_url(admin_url('admin-post.php')); ?>" style="display:none">
                            <input type="hidden" name="action" value="ta_logs_delete_row">
                            <input type="hidden" name="log_id" value="<?php echo (int)$row['id']; ?>">
                            <?php wp_nonce_field('ta_logs_delete_row', '_nonce'); ?>
                        </form>
                    </td>
                </tr>
                <?php if ($is_err && $row['error_code']): ?>
                <tr id="<?php echo esc_attr($detail_id); ?>" style="display:none">
                    <td colspan="9" class="ta-detail-row">
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
                            <div>
                                <strong style="color:#b32d2e">Error: <?php echo esc_html($row['error_code']); ?></strong><br>
                                <span style="color:#555;font-size:12px"><?php echo esc_html($row['error_message']); ?></span>
                                <?php if ($row['user_agent']): ?>
                                <br><span style="color:#888;font-size:11px">UA: <?php echo esc_html(substr($row['user_agent'], 0, 100)); ?></span>
                                <?php endif; ?>
                            </div>
                            <?php if ($row['request_params']): ?>
                            <div>
                                <strong style="font-size:12px">Request Params:</strong>
                                <pre><?php echo esc_html(json_encode(json_decode($row['request_params']), JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE)); ?></pre>
                            </div>
                            <?php endif; ?>
                            <?php if ($row['response_body']): ?>
                            <div style="grid-column:1/-1">
                                <strong style="font-size:12px">Response Body:</strong>
                                <pre><?php echo esc_html(json_encode(json_decode($row['response_body']), JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE)); ?></pre>
                            </div>
                            <?php endif; ?>
                        </div>
                    </td>
                </tr>
                <?php endif; ?>
                <?php endforeach; ?>
                </tbody>
            </table></div>

            <!-- Pagination -->
            <?php if ($total_pages > 1): ?>
            <div style="margin-top:16px;display:flex;gap:4px;flex-wrap:wrap">
                <?php
                $base_url = add_query_arg(array_merge($_GET, ['page' => 'toursapp-logs']), admin_url('admin.php'));
                for ($pg = 1; $pg <= min($total_pages, 50); $pg++):
                    $url = add_query_arg('paged', $pg, $base_url);
                    $active = $pg === $page;
                ?>
                <a href="<?php echo esc_url($url); ?>"
                   style="padding:4px 10px;border:1px solid <?php echo $active ? '#2271b1' : '#ddd'; ?>;background:<?php echo $active ? '#2271b1' : '#fff'; ?>;color:<?php echo $active ? '#fff' : '#555'; ?>;border-radius:3px;text-decoration:none;font-size:13px">
                    <?php echo $pg; ?>
                </a>
                <?php endfor; ?>
                <?php if ($total_pages > 50): ?>
                <span style="padding:4px;color:#888">... <?php echo $total_pages; ?> pages total</span>
                <?php endif; ?>
            </div>
            <?php endif; ?>
        </div>

        <script>
        // ── Clear logs: inline confirm ────────────────────────────────────
        var taDeleteCounts = <?php
            $counts = [];
            foreach ([7, 30, 90, 365] as $d) {
                $counts[$d] = (int) $wpdb->get_var($wpdb->prepare(
                    "SELECT COUNT(*) FROM {$p}ta_api_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL %d DAY)", $d
                ));
            }
            $counts[0] = $total_all; // "All time"
            echo wp_json_encode($counts);
        ?>;

        function taUpdateClearCount(days) {
            var d   = parseInt(days);
            var cnt = taDeleteCounts[d] !== undefined ? taDeleteCounts[d] : 0;
            var btn  = document.getElementById('ta-clear-btn');
            var span = document.getElementById('ta-clear-count');
            span.textContent = cnt;
            btn.dataset.count = cnt;
            if (cnt === 0) {
                btn.disabled = true;
                btn.style.opacity = '0.5';
                btn.style.cursor  = 'not-allowed';
            } else {
                btn.disabled = false;
                btn.style.opacity = '1';
                btn.style.cursor  = 'pointer';
            }
            taHideClearConfirm();
        }

        function taConfirmClear(btn) {
            var cnt  = parseInt(btn.dataset.count || 0);
            var days = document.getElementById('ta-clear-days').value;
            if (cnt === 0) return;
            var box  = document.getElementById('ta-clear-confirm');
            var text = document.getElementById('ta-clear-confirm-text');
            var label = days === '0' ? 'ALL ' + cnt : cnt + ' entries older than ' + days + ' days';
            text.textContent = '⚠️ Delete ' + label + ' log entries? This cannot be undone.';
            box.style.display = 'flex';
            btn.disabled = true;
            btn.style.opacity = '0.5';
        }

        function taHideClearConfirm() {
            var box = document.getElementById('ta-clear-confirm');
            box.style.display = 'none';
            var cnt = parseInt(document.getElementById('ta-clear-btn').dataset.count || 0);
            if (cnt > 0) {
                var btn = document.getElementById('ta-clear-btn');
                btn.disabled = false;
                btn.style.opacity = '1';
                btn.style.cursor  = 'pointer';
            }
        }

        // ── Delete single row: inline confirm ─────────────────────────────
        var taDeleteRowTarget = null;
        var taDeleteRowConfirmEl = null;

        function taConfirmDeleteRow(logId, btn) {
            // Hide any previous confirm
            if (taDeleteRowConfirmEl) {
                taDeleteRowConfirmEl.remove();
                taDeleteRowConfirmEl = null;
                if (taDeleteRowTarget) {
                    taDeleteRowTarget.style.display = '';
                    taDeleteRowTarget = null;
                }
            }

            var tr  = btn.closest('tr');
            var row = document.createElement('tr');
            row.innerHTML = '<td colspan="10" style="background:#fff3cd;padding:8px 12px;font-size:13px">'
                + '⚠️ Delete this log entry? This cannot be undone.&nbsp;&nbsp;'
                + '<button type="button" class="button button-small" style="background:#b32d2e;color:#fff;border-color:#b32d2e" '
                + 'onclick="document.getElementById(\'ta-del-row-' + logId + '\').submit()">Yes, delete</button>'
                + '&nbsp;<button type="button" class="button button-small" onclick="taCancelDeleteRow()">Cancel</button>'
                + '</td>';
            tr.after(row);
            taDeleteRowConfirmEl = row;
            taDeleteRowTarget    = btn;
            btn.style.display    = 'none';
        }

        function taCancelDeleteRow() {
            if (taDeleteRowConfirmEl) {
                taDeleteRowConfirmEl.remove();
                taDeleteRowConfirmEl = null;
            }
            if (taDeleteRowTarget) {
                taDeleteRowTarget.style.display = '';
                taDeleteRowTarget = null;
            }
        }
        </script>
        <?php
    }
}
