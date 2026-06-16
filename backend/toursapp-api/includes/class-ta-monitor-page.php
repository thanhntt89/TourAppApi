<?php
defined('ABSPATH') || exit;

class TA_Monitor_Page {

    public static function register_menu() {
        add_submenu_page('toursapp-api', 'System Monitor', 'Monitor', 'manage_options', 'toursapp-monitor', [self::class, 'render']);
        add_action('admin_init', [self::class, 'handle_save']);
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

    public static function handle_test_ajax() {
        if (!current_user_can('manage_options')) wp_send_json_error('Unauthorized', 403);
        if (!check_ajax_referer('ta_monitor_test_ajax', '_nonce', false)) wp_send_json_error('Invalid nonce', 403);

        $channel = sanitize_text_field($_POST['channel'] ?? 'all');
        if (!in_array($channel, ['all', 'email', 'telegram'], true)) $channel = 'all';

        // Accept live form values so test works without Save first
        $overrides = [];
        if (isset($_POST['email_recipients']))   $overrides['email_recipients']   = sanitize_text_field($_POST['email_recipients']);
        if (isset($_POST['telegram_bot_token'])) $overrides['telegram_bot_token'] = sanitize_text_field($_POST['telegram_bot_token']);
        if (isset($_POST['telegram_chat_id']))   $overrides['telegram_chat_id']   = sanitize_text_field($_POST['telegram_chat_id']);

        $results = TA_Monitor::send_test($channel, $overrides);
        wp_send_json_success(['results' => $results]);
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
            <div class="notice notice-info is-dismissible"><p><strong>Test results:</strong><br><?php echo implode('<br>', array_map('esc_html', $test_results)); ?></p></div>
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
                            [
                                'Table Size (DB)',
                                'Total size of all ToursApp custom tables (data + indexes). Signals archiver falling behind.',
                                'table_size_warning_mb', 'table_size_critical_mb', 'MB',
                                'Warning: 200MB · Critical: 500MB',
                            ],
                            [
                                'P95 Response Time',
                                'Slowest 95th-percentile endpoint response in a 15-minute window. Catches outliers that the average hides.',
                                'p95_warning_ms', 'p95_critical_ms', 'ms',
                                'Warning: 1500ms · Critical: 4000ms',
                            ],
                            [
                                'Auth Failures / IP',
                                '401 errors from a single IP in 5 minutes. Elevated values indicate bot or brute-force activity.',
                                'auth_fail_per_ip_warning', 'auth_fail_per_ip_critical', '401s / 5 min',
                                'Warning: 10 · Critical: 30',
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
                        <tr>
                            <th style="padding:8px 0"></th>
                            <td>
                                <button type="button" class="button ta-test-btn" data-channel="email">📧 Send Test Email</button>
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
                        <tr>
                            <th style="padding:8px 0"></th>
                            <td>
                                <button type="button" class="button ta-test-btn" data-channel="telegram">✈️ Send Test Telegram</button>
                            </td>
                        </tr>
                    </table>
                </div>

                <p>
                    <?php submit_button('Save Settings', 'primary', 'submit', false); ?>
                    &nbsp;
                    <button type="button" class="button ta-test-btn" data-channel="all">📨 Send Test All Channels</button>
                </p>

                <div id="ta-test-result" style="display:none;margin:8px 0 0;padding:10px 14px;background:#f0f4ff;border:1px solid #b0c4de;border-radius:4px;font-size:13px;line-height:1.7"></div>
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

            <!-- WP Cron Reliability -->
            <?php $using_real_cron = defined('DISABLE_WP_CRON') && DISABLE_WP_CRON; ?>
            <div class="ta-section-box" style="margin-top:20px;border-left:4px solid <?php echo $using_real_cron ? '#28a745' : '#ffc107'; ?>">
                <h2 style="color:<?php echo $using_real_cron ? '#155724' : '#856404'; ?>">
                    <?php echo $using_real_cron ? '✅ OS Cron Active (Reliable)' : '⚠️ WP Pseudo-Cron (Unreliable)'; ?>
                </h2>
                <?php if ($using_real_cron): ?>
                    <p style="color:#155724;margin:0">
                        <code>DISABLE_WP_CRON</code> is defined — this server uses real OS cron to trigger WordPress jobs.
                        Monitor checks fire every 5 minutes regardless of traffic.
                    </p>
                <?php else: ?>
                    <p style="color:#856404;margin:0 0 12px">
                        <strong>WP Cron only fires when someone visits the site.</strong>
                        During quiet hours (2–6 AM when Ha Giang has no traffic), the 5-minute monitor may not run for several hours — missing error spikes or outages.
                    </p>
                    <p style="margin:0 0 6px"><strong>Step 1 — add to server crontab (<code>crontab -e</code>):</strong></p>
                    <pre style="background:#1e1e1e;color:#d4d4d4;padding:10px 14px;border-radius:4px;font-size:12px;margin:0 0 12px;overflow-x:auto">*/5 * * * * curl -s "<?php echo esc_url(home_url()); ?>/wp-cron.php?doing_wp_cron" &gt; /dev/null 2&gt;&amp;1</pre>
                    <p style="margin:0 0 6px"><strong>Step 2 — disable WP pseudo-cron in <code>wp-config.php</code>:</strong></p>
                    <pre style="background:#1e1e1e;color:#d4d4d4;padding:10px 14px;border-radius:4px;font-size:12px;margin:0">define('DISABLE_WP_CRON', true);</pre>
                <?php endif; ?>
            </div>

            <script>
            (function($) {
                var nonce = <?php echo wp_json_encode(wp_create_nonce('ta_monitor_test_ajax')); ?>;
                var labels = {};

                $('.ta-test-btn').each(function() {
                    labels[$(this).data('channel')] = $(this).html();
                });

                $(document).on('click', '.ta-test-btn', function() {
                    var $btn     = $(this);
                    var channel  = $btn.data('channel');
                    var $result  = $('#ta-test-result');

                    $btn.prop('disabled', true).text('Sending…');
                    $result.hide().empty();

                    // Gửi kèm giá trị form hiện tại — không cần Save trước
                    var postData = { action: 'ta_monitor_test', channel: channel, _nonce: nonce };
                    if (channel === 'email' || channel === 'all') {
                        postData.email_recipients = $('input[name="ta_monitor_email_recipients"]').val() || '';
                    }
                    if (channel === 'telegram' || channel === 'all') {
                        postData.telegram_bot_token = $('input[name="ta_monitor_telegram_bot_token"]').val() || '';
                        postData.telegram_chat_id   = $('input[name="ta_monitor_telegram_chat_id"]').val() || '';
                    }

                    $.post(ajaxurl, postData)
                        .done(function(resp) {
                            $btn.prop('disabled', false).html(labels[channel]);
                            if (resp.success && resp.data && resp.data.results) {
                                var lines = resp.data.results.map(function(r) {
                                    var esc   = $('<div>').text(r).html();
                                    var color = r.indexOf('✓') === 0 ? '#155724' : (r.indexOf('✗') === 0 ? '#721c24' : '#333');
                                    return '<span style="color:' + color + '">' + esc + '</span>';
                                }).join('<br>');
                                $result.html('<strong>Test result:</strong><br>' + lines).show();
                            } else {
                                var errMsg = (resp && resp.data) ? resp.data : 'Unknown error';
                                $result.html('<span style="color:#c00">✗ ' + $('<div>').text(errMsg).html() + '</span>').show();
                            }
                        })
                        .fail(function(xhr) {
                            $btn.prop('disabled', false).html(labels[channel]);
                            $result.html('<span style="color:#c00">✗ AJAX failed (HTTP ' + xhr.status + ') — check browser console.</span>').show();
                        });
                });
            })(jQuery);
            </script>
        </div>
        <?php
    }
}
