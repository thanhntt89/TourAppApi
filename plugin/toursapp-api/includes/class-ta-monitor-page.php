<?php
defined('ABSPATH') || exit;

class TA_Monitor_Page {

    public static function register_menu() {
        add_submenu_page('toursapp-api', 'System Monitor', 'Monitor', 'manage_options', 'toursapp-monitor', [self::class, 'render']);
        add_action('admin_init', [self::class, 'handle_save']);
        add_action('admin_post_ta_monitor_test', [self::class, 'handle_test']);
    }

    public static function handle_save() {
        if (!isset($_POST['ta_monitor_save_nonce'])) return;
        if (!wp_verify_nonce($_POST['ta_monitor_save_nonce'], 'ta_monitor_save')) return;
        if (!current_user_can('manage_options')) return;

        $fields = array_keys(TA_Monitor::DEFAULTS);
        $data   = [];
        foreach ($fields as $key) {
            if (in_array($key, ['email_enabled', 'telegram_enabled'], true)) {
                $data[$key] = isset($_POST['ta_monitor_' . $key]) ? 1 : 0;
            } else {
                $data[$key] = sanitize_text_field($_POST['ta_monitor_' . $key] ?? '');
            }
        }

        // Schedule/unschedule cron based on whether any channel is enabled
        if ($data['email_enabled'] || $data['telegram_enabled']) {
            TA_Monitor::schedule();
        } else {
            TA_Monitor::unschedule();
        }

        TA_Monitor::save_settings($data);
        wp_redirect(add_query_arg(['page' => 'toursapp-monitor', 'saved' => 1], admin_url('admin.php')));
        exit;
    }

    public static function handle_test() {
        if (!current_user_can('manage_options')) wp_die('Unauthorized');
        if (!isset($_POST['_nonce']) || !wp_verify_nonce($_POST['_nonce'], 'ta_monitor_test')) wp_die('Invalid nonce');

        $results = TA_Monitor::send_test();
        set_transient('ta_monitor_test_results', $results, 60);
        wp_redirect(add_query_arg(['page' => 'toursapp-monitor', 'tested' => 1], admin_url('admin.php')));
        exit;
    }

    public static function render() {
        if (!current_user_can('manage_options')) return;

        $health      = TA_Monitor::get_health_status();
        $test_results = get_transient('ta_monitor_test_results');
        if ($test_results) delete_transient('ta_monitor_test_results');

        $status_color = ['OK' => '#155724', 'WARNING' => '#856404', 'CRITICAL' => '#721c24'];
        $status_bg    = ['OK' => '#d4edda', 'WARNING' => '#fff3cd', 'CRITICAL' => '#f8d7da'];
        $status_icon  = ['OK' => '✅', 'WARNING' => '⚠️', 'CRITICAL' => '🚨'];
        $s = $health['status'];
        ?>
        <div class="wrap">
            <h1>System Monitor</h1>

            <?php if (isset($_GET['saved'])): ?><div class="notice notice-success is-dismissible"><p>Settings saved.</p></div><?php endif; ?>
            <?php if ($test_results): ?>
            <div class="notice notice-info is-dismissible"><p><strong>Test results:</strong><br><?php echo esc_html(implode('<br>', $test_results)); ?></p></div>
            <?php endif; ?>

            <style>
                .ta-health-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(180px,1fr)); gap:12px; margin-bottom:24px; }
                .ta-health-box { background:#fff; border:1px solid #ddd; border-radius:6px; padding:14px 16px; }
                .ta-health-box .val { font-size:26px; font-weight:700; display:block; }
                .ta-health-box .lbl { font-size:12px; color:#666; display:block; margin-top:4px; }
                .ta-health-box .bar { height:4px; border-radius:2px; margin-top:8px; background:#eee; }
                .ta-health-box .bar-fill { height:4px; border-radius:2px; }
                .ta-section-box { background:#fff; border:1px solid #ddd; border-radius:6px; padding:18px 20px; margin-bottom:20px; }
                .ta-section-box h2 { margin-top:0; font-size:16px; border-bottom:1px solid #eee; padding-bottom:10px; }
                .ta-threshold-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; }
                .ta-threshold-item { display:flex; flex-direction:column; gap:4px; }
                .ta-threshold-item label { font-size:13px; font-weight:600; }
                .ta-threshold-item .hint { font-size:11px; color:#888; }
                .ta-threshold-item input { width:100%; font-size:14px; padding:5px 8px; }
                .ta-level-warn { color:#856404; font-weight:bold; }
                .ta-level-crit { color:#721c24; font-weight:bold; }
            </style>

            <!-- Health Status -->
            <div style="background:<?php echo esc_attr($status_bg[$s]); ?>;border:2px solid <?php echo esc_attr($status_color[$s]); ?>;border-radius:8px;padding:16px 20px;margin-bottom:20px;display:flex;align-items:center;gap:16px">
                <span style="font-size:36px"><?php echo esc_html($status_icon[$s]); ?></span>
                <div>
                    <div style="font-size:20px;font-weight:700;color:<?php echo esc_attr($status_color[$s]); ?>">System Status: <?php echo esc_html($s); ?></div>
                    <div style="font-size:13px;color:<?php echo esc_attr($status_color[$s]); ?>;margin-top:4px">Last 5 minutes —
                        <?php echo esc_html($health['last_5min']['total_requests']); ?> requests ·
                        <?php echo esc_html($health['last_5min']['error_rate']); ?>% errors ·
                        <?php echo esc_html($health['last_5min']['avg_ms']); ?>ms avg ·
                        <?php echo esc_html($health['last_5min']['server_errors']); ?> 5xx
                    </div>
                </div>
                <a href="<?php echo esc_url(admin_url('admin.php?page=toursapp-monitor')); ?>" class="button" style="margin-left:auto">🔄 Refresh</a>
            </div>

            <!-- Live Metrics -->
            <?php
            $m5 = $health['last_5min'];
            $th = $health['thresholds'];
            $err_pct  = (float) $m5['error_rate'];
            $avg_ms   = (int)   $m5['avg_ms'];
            $srv_err  = (int)   $m5['server_errors'];
            $metrics  = [
                ['Requests (5 min)',     $m5['total_requests'],  '',      '#2271b1',  0,  $th['response_ms']['critical']],
                ['Error Rate',           $err_pct . '%',         '',
                    $err_pct >= $th['error_rate']['critical'] ? '#721c24' :
                    ($err_pct >= $th['error_rate']['warning'] ? '#856404' : '#155724'), 0, 100],
                ['Avg Response',         $avg_ms . 'ms',         '',
                    $avg_ms >= $th['response_ms']['critical'] ? '#721c24' :
                    ($avg_ms >= $th['response_ms']['warning'] ? '#856404' : '#155724'), 0, $th['response_ms']['critical']],
                ['Server Errors (5xx)',  $srv_err,               '',
                    $srv_err >= $th['server_errors']['critical'] ? '#721c24' :
                    ($srv_err >= $th['server_errors']['warning'] ? '#856404' : '#155724'), 0, $th['server_errors']['critical']],
                ['Last Activity',        $m5['last_call'] ? substr($m5['last_call'], 11, 8) : '—', '', '#555', 0, 0],
            ];
            echo '<div class="ta-health-grid">';
            foreach ($metrics as [$lbl, $val, $unit, $color]) {
                echo '<div class="ta-health-box"><span class="val" style="color:' . esc_attr($color) . '">' . esc_html($val) . '</span><span class="lbl">' . esc_html($lbl) . '</span></div>';
            }
            echo '</div>';
            ?>

            <form method="post">
                <?php wp_nonce_field('ta_monitor_save', 'ta_monitor_save_nonce'); ?>

                <!-- Thresholds -->
                <div class="ta-section-box">
                    <h2>Alert Thresholds</h2>
                    <p style="color:#666;font-size:13px;margin-top:-8px">
                        These values define when alerts are triggered. Checked every 5 minutes.
                    </p>

                    <table class="widefat" style="font-size:13px;margin-bottom:16px">
                        <thead>
                            <tr>
                                <th>Metric</th>
                                <th>Description</th>
                                <th class="ta-level-warn">⚠️ WARNING threshold</th>
                                <th class="ta-level-crit">🚨 CRITICAL threshold</th>
                                <th>Recommended</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php
                        $threshold_rows = [
                            [
                                'Error Rate %',
                                'Percentage of API requests returning 4xx or 5xx in last 5 minutes',
                                'error_rate_warning',   'error_rate_critical',   '%',
                                'Warning: 5% · Critical: 20%'
                            ],
                            [
                                'Avg Response Time',
                                'Average response time of all API calls in last 5 minutes',
                                'response_ms_warning',  'response_ms_critical',  'ms',
                                'Warning: 500ms · Critical: 2000ms'
                            ],
                            [
                                'Request Volume',
                                'Total number of API requests in last 5 minutes (overload detection)',
                                'req_per_5min_warning', 'req_per_5min_critical', 'req/5min',
                                'Warning: 500 · Critical: 2000'
                            ],
                            [
                                'Server Errors (5xx)',
                                'Number of 5xx (server error) responses in last 5 minutes',
                                'server_error_warning',  'server_error_critical', 'errors',
                                'Warning: 1 · Critical: 5'
                            ],
                            [
                                'Silence Duration',
                                'Minutes without any API activity (app may be down)',
                                'silence_warning_min',  'silence_critical_min',  'minutes',
                                'Warning: 30 min · Critical: 60 min'
                            ],
                        ];
                        foreach ($threshold_rows as [$label, $desc, $warn_key, $crit_key, $unit, $rec]):
                        ?>
                        <tr>
                            <td><strong><?php echo esc_html($label); ?></strong></td>
                            <td style="color:#666;font-size:12px"><?php echo esc_html($desc); ?></td>
                            <td>
                                <div style="display:flex;align-items:center;gap:6px">
                                    <input type="number" name="ta_monitor_<?php echo esc_attr($warn_key); ?>"
                                        value="<?php echo esc_attr(TA_Monitor::get($warn_key)); ?>"
                                        style="width:80px" min="0">
                                    <span style="color:#888;font-size:11px"><?php echo esc_html($unit); ?></span>
                                </div>
                            </td>
                            <td>
                                <div style="display:flex;align-items:center;gap:6px">
                                    <input type="number" name="ta_monitor_<?php echo esc_attr($crit_key); ?>"
                                        value="<?php echo esc_attr(TA_Monitor::get($crit_key)); ?>"
                                        style="width:80px" min="0">
                                    <span style="color:#888;font-size:11px"><?php echo esc_html($unit); ?></span>
                                </div>
                            </td>
                            <td style="color:#888;font-size:12px"><?php echo esc_html($rec); ?></td>
                        </tr>
                        <?php endforeach; ?>
                        </tbody>
                    </table>

                    <div style="display:flex;gap:20px;align-items:center">
                        <label style="font-size:13px">
                            Alert cooldown:
                            <input type="number" name="ta_monitor_alert_cooldown_min"
                                value="<?php echo esc_attr(TA_Monitor::get('alert_cooldown_min')); ?>"
                                style="width:70px" min="5"> minutes
                        </label>
                        <span style="color:#888;font-size:12px">Don't repeat the same alert type within this cooldown period.</span>
                    </div>
                </div>

                <!-- Email -->
                <div class="ta-section-box">
                    <h2>📧 Email Alerts</h2>
                    <table class="form-table" style="margin:0">
                        <tr>
                            <th style="width:180px;padding:8px 0">Enable Email Alerts</th>
                            <td><label><input type="checkbox" name="ta_monitor_email_enabled" value="1" <?php checked(TA_Monitor::get('email_enabled'), 1); ?>> Send alerts via email</label></td>
                        </tr>
                        <tr>
                            <th style="padding:8px 0">Recipients</th>
                            <td>
                                <input type="text" name="ta_monitor_email_recipients"
                                    value="<?php echo esc_attr(TA_Monitor::get('email_recipients')); ?>"
                                    style="width:400px" placeholder="admin@example.com, ops@example.com">
                                <p class="description">Comma-separated email addresses.</p>
                            </td>
                        </tr>
                    </table>
                </div>

                <!-- Telegram -->
                <div class="ta-section-box">
                    <h2>✈️ Telegram Alerts</h2>
                    <p style="color:#666;font-size:13px;margin-top:-8px">
                        Create a bot via <a href="https://t.me/BotFather" target="_blank">@BotFather</a>,
                        get the token. Add the bot to a group/channel and get the chat ID
                        (message <a href="https://t.me/userinfobot" target="_blank">@userinfobot</a> or use
                        <code>https://api.telegram.org/bot{TOKEN}/getUpdates</code>).
                    </p>
                    <table class="form-table" style="margin:0">
                        <tr>
                            <th style="width:180px;padding:8px 0">Enable Telegram</th>
                            <td><label><input type="checkbox" name="ta_monitor_telegram_enabled" value="1" <?php checked(TA_Monitor::get('telegram_enabled'), 1); ?>> Send alerts via Telegram</label></td>
                        </tr>
                        <tr>
                            <th style="padding:8px 0">Bot Token</th>
                            <td><input type="text" name="ta_monitor_telegram_bot_token"
                                value="<?php echo esc_attr(TA_Monitor::get('telegram_bot_token')); ?>"
                                style="width:400px" placeholder="1234567890:ABCdef..."></td>
                        </tr>
                        <tr>
                            <th style="padding:8px 0">Chat ID</th>
                            <td>
                                <input type="text" name="ta_monitor_telegram_chat_id"
                                    value="<?php echo esc_attr(TA_Monitor::get('telegram_chat_id')); ?>"
                                    style="width:200px" placeholder="-1001234567890 or @channelname">
                                <p class="description">Group/channel chat ID. Use negative ID for groups.</p>
                            </td>
                        </tr>
                    </table>
                </div>

                <p>
                    <?php submit_button('Save Settings', 'primary', 'submit', false); ?>
                    &nbsp;
                    <form method="post" action="<?php echo esc_url(admin_url('admin-post.php')); ?>" style="display:inline">
                        <input type="hidden" name="action" value="ta_monitor_test">
                        <?php wp_nonce_field('ta_monitor_test', '_nonce'); ?>
                        <button type="submit" class="button">📨 Send Test Alert</button>
                    </form>
                </p>
            </form>

            <!-- Next cron run -->
            <?php
            $next = wp_next_scheduled(TA_Monitor::CRON_HOOK);
            $cron_active = TA_Monitor::get('email_enabled') || TA_Monitor::get('telegram_enabled');
            ?>
            <div style="background:#f8f9fa;border:1px solid #ddd;border-radius:4px;padding:10px 14px;font-size:12px;color:#666;margin-top:8px">
                <?php if ($cron_active && $next): ?>
                    ✅ Monitor cron active — next check in <strong><?php echo human_time_diff($next); ?></strong>
                    (<?php echo date('H:i:s', $next); ?>)
                <?php elseif ($cron_active): ?>
                    ⏳ Cron will be scheduled after saving settings.
                <?php else: ?>
                    ⏸ Monitor cron inactive — enable email or Telegram above and save to activate.
                <?php endif; ?>
            </div>
        </div>
        <?php
    }
}
