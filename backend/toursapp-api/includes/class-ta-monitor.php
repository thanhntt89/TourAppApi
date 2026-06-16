<?php
defined('ABSPATH') || exit;

/**
 * System Health Monitor — checks API load, errors, and sends alerts.
 *
 * Alert levels:
 *   INFO    — informational, no immediate action needed
 *   WARNING — degraded performance, investigate soon
 *   CRITICAL— system impaired, immediate action required
 *
 * Default thresholds (all configurable in WP Admin):
 *
 * | Metric                   | INFO          | WARNING        | CRITICAL        |
 * |--------------------------|---------------|----------------|-----------------|
 * | Error rate (5 min)       | < 5%          | 5–20%          | > 20%           |
 * | Avg response time (5min) | < 500ms       | 500–2000ms     | > 2000ms        |
 * | Request rate (5 min)     | < 500 req     | 500–2000 req   | > 2000 req      |
 * | 5xx errors (5 min)       | 0             | 1–5            | > 5             |
 * | No activity (minutes)    | —             | > 30 min       | > 60 min        |
 * | New users spike (1 day)  | —             | +200% vs avg   | +500% vs avg    |
 */
class TA_Monitor {

    const CRON_HOOK = 'ta_monitor_run';

    // Default threshold presets
    const DEFAULTS = [
        // Error rate %
        'error_rate_warning'     => 5,
        'error_rate_critical'    => 20,
        // Avg response ms
        'response_ms_warning'    => 500,
        'response_ms_critical'   => 2000,
        // Request count per 5 minutes
        'req_per_5min_warning'   => 500,
        'req_per_5min_critical'  => 2000,
        // 5xx count per 5 minutes
        'server_error_warning'   => 1,
        'server_error_critical'  => 5,
        // Minutes of no API activity before alert
        'silence_warning_min'    => 30,
        'silence_critical_min'   => 60,
        // Alert cooldown: don't repeat same alert within X minutes
        'alert_cooldown_min'     => 30,
        // Channels
        'email_enabled'          => 0,
        'email_recipients'       => '',
        'telegram_enabled'       => 0,
        'telegram_bot_token'     => '',
        'telegram_chat_id'       => '',
        // Extended operational checks
        'table_size_warning_mb'     => 200,
        'table_size_critical_mb'    => 500,
        'p95_warning_ms'            => 1500,
        'p95_critical_ms'           => 4000,
        'auth_fail_per_ip_warning'  => 10,
        'auth_fail_per_ip_critical' => 30,
    ];

    // ── Cron ─────────────────────────────────────────────────────────────

    public static function schedule() {
        if (!wp_next_scheduled(self::CRON_HOOK)) {
            wp_schedule_event(time(), 'every_5_minutes', self::CRON_HOOK);
        }
    }

    public static function unschedule() {
        $ts = wp_next_scheduled(self::CRON_HOOK);
        if ($ts) wp_unschedule_event($ts, self::CRON_HOOK);
    }

    public static function add_cron_interval($schedules) {
        $schedules['every_5_minutes'] = [
            'interval' => 300,
            'display'  => 'Every 5 Minutes',
        ];
        return $schedules;
    }

    // ── Main check (runs every 5 min via cron) ────────────────────────────

    public static function run() {
        $alerts = self::check_all();
        foreach ($alerts as $alert) {
            if (self::should_send($alert['type'])) {
                self::send_alert($alert);
                self::mark_sent($alert['type']);
            }
        }
    }

    // ── Health checks ─────────────────────────────────────────────────────

    public static function check_all(): array {
        global $wpdb;
        $p   = $wpdb->prefix;
        $alerts = [];
        $window = 5; // minutes

        // Fetch last 5 minutes of logs
        $stats = $wpdb->get_row(
            "SELECT
                COUNT(*) AS total,
                SUM(CASE WHEN status_code >= 500 THEN 1 ELSE 0 END) AS server_errors,
                SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) AS client_errors,
                ROUND(AVG(response_ms), 0) AS avg_ms,
                MAX(response_ms) AS max_ms,
                MAX(created_at) AS last_call
             FROM {$p}ta_api_logs
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL {$window} MINUTE)",
            ARRAY_A
        );

        if (!$stats) return [];

        $total        = (int) $stats['total'];
        $server_errs  = (int) $stats['server_errors'];
        $all_errs     = (int) $stats['client_errors'];
        $avg_ms       = (int) $stats['avg_ms'];
        $error_rate   = $total > 0 ? round($all_errs / $total * 100, 1) : 0;
        $last_call    = $stats['last_call'];

        // 1. Error rate
        $err_crit = self::get('error_rate_critical');
        $err_warn = self::get('error_rate_warning');
        if ($error_rate >= $err_crit) {
            $alerts[] = self::make_alert('error_rate', 'CRITICAL',
                "Error rate is {$error_rate}% (threshold: {$err_crit}%)",
                "🚨 HIGH ERROR RATE: {$error_rate}% of {$total} requests in last {$window} min failed.\nThreshold: {$err_crit}%"
            );
        } elseif ($error_rate >= $err_warn) {
            $alerts[] = self::make_alert('error_rate', 'WARNING',
                "Error rate is {$error_rate}% (threshold: {$err_warn}%)",
                "⚠️ Elevated error rate: {$error_rate}% of {$total} requests in last {$window} min."
            );
        }

        // 2. Response time
        $ms_crit = self::get('response_ms_critical');
        $ms_warn = self::get('response_ms_warning');
        if ($avg_ms >= $ms_crit) {
            $alerts[] = self::make_alert('response_time', 'CRITICAL',
                "Avg response time is {$avg_ms}ms (threshold: {$ms_crit}ms)",
                "🚨 SLOW API: Avg response {$avg_ms}ms over last {$window} min.\nThreshold: {$ms_crit}ms"
            );
        } elseif ($avg_ms >= $ms_warn) {
            $alerts[] = self::make_alert('response_time', 'WARNING',
                "Avg response time is {$avg_ms}ms",
                "⚠️ Slow API: Avg response {$avg_ms}ms over last {$window} min."
            );
        }

        // 3. Request volume (overload)
        $req_crit = self::get('req_per_5min_critical');
        $req_warn = self::get('req_per_5min_warning');
        if ($total >= $req_crit) {
            $alerts[] = self::make_alert('high_traffic', 'CRITICAL',
                "High traffic: {$total} requests in {$window} min (threshold: {$req_crit})",
                "🚨 TRAFFIC OVERLOAD: {$total} requests in {$window} min.\nThreshold: {$req_crit}"
            );
        } elseif ($total >= $req_warn) {
            $alerts[] = self::make_alert('high_traffic', 'WARNING',
                "Elevated traffic: {$total} requests in {$window} min",
                "⚠️ High traffic: {$total} requests in {$window} min."
            );
        }

        // 4. Server errors (5xx)
        $srv_crit = self::get('server_error_critical');
        $srv_warn = self::get('server_error_warning');
        if ($server_errs >= $srv_crit) {
            $alerts[] = self::make_alert('server_errors', 'CRITICAL',
                "{$server_errs} server errors (5xx) in {$window} min",
                "🚨 SERVER ERRORS: {$server_errs} 5xx responses in {$window} min.\nCheck error logs immediately."
            );
        } elseif ($server_errs >= $srv_warn && $server_errs > 0) {
            $alerts[] = self::make_alert('server_errors', 'WARNING',
                "{$server_errs} server errors (5xx) in {$window} min",
                "⚠️ Server errors: {$server_errs} 5xx responses in {$window} min."
            );
        }

        // 5. Silence detection (no API calls)
        if ($last_call) {
            $silence_min = (int) ((time() - strtotime($last_call)) / 60);
            $sil_crit = self::get('silence_critical_min');
            $sil_warn = self::get('silence_warning_min');
            if ($silence_min >= $sil_crit) {
                $alerts[] = self::make_alert('silence', 'CRITICAL',
                    "No API activity for {$silence_min} minutes",
                    "🚨 API SILENCE: No requests received for {$silence_min} minutes.\nApp may be down or unreachable."
                );
            } elseif ($silence_min >= $sil_warn) {
                $alerts[] = self::make_alert('silence', 'WARNING',
                    "No API activity for {$silence_min} minutes",
                    "⚠️ No API activity for {$silence_min} minutes."
                );
            }
        }

        // 6. DB table size (data + indexes across all ta_ tables)
        $size_mb = (float) $wpdb->get_var($wpdb->prepare(
            "SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024, 1)
             FROM information_schema.tables
             WHERE table_schema = DATABASE() AND table_name LIKE %s",
            $wpdb->esc_like($p . 'ta_') . '%'
        ));
        $sz_crit = (float) self::get('table_size_critical_mb');
        $sz_warn = (float) self::get('table_size_warning_mb');
        if ($size_mb >= $sz_crit) {
            $alerts[] = self::make_alert('table_size', 'CRITICAL',
                "DB tables {$size_mb}MB (threshold: {$sz_crit}MB)",
                "🚨 DB TABLES CRITICAL: ToursApp tables are using {$size_mb}MB.\nArchiver may have failed. Check immediately."
            );
        } elseif ($size_mb >= $sz_warn) {
            $alerts[] = self::make_alert('table_size', 'WARNING',
                "DB tables {$size_mb}MB (threshold: {$sz_warn}MB)",
                "⚠️ DB tables growing: {$size_mb}MB. Review archiver retention settings."
            );
        }

        // 7. Archiver health — should complete every ~24 hours
        $last_archive = get_option('ta_archive_last_run');
        if ($last_archive) {
            $hours_ago = (time() - strtotime($last_archive)) / 3600;
            if ($hours_ago > 50) {
                $alerts[] = self::make_alert('archiver_health', 'CRITICAL',
                    'Archiver last ran ' . round($hours_ago) . ' hours ago',
                    '🚨 ARCHIVER OVERDUE: Last successful run was ' . round($hours_ago) . " hours ago.\nDB tables are not being purged — risk of disk full."
                );
            } elseif ($hours_ago > 26) {
                $alerts[] = self::make_alert('archiver_health', 'WARNING',
                    'Archiver last ran ' . round($hours_ago) . ' hours ago',
                    '⚠️ Archiver overdue: last successful run ' . round($hours_ago) . ' hours ago.'
                );
            }
        }

        // 8. P95 response time per endpoint (15-minute window, minimum 5 data points)
        $p95_crit = (int) self::get('p95_critical_ms');
        $p95_warn = (int) self::get('p95_warning_ms');
        $ep_rows  = $wpdb->get_results(
            "SELECT endpoint, response_ms
             FROM {$p}ta_api_logs
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL 15 MINUTE)
             ORDER BY endpoint, response_ms",
            ARRAY_A
        );
        if (!empty($ep_rows)) {
            $by_ep = [];
            foreach ($ep_rows as $r) {
                $by_ep[$r['endpoint']][] = (int) $r['response_ms'];
            }
            $slow_crit = [];
            $slow_warn = [];
            foreach ($by_ep as $ep => $times) {
                if (count($times) < 5) continue;
                $p95_val = $times[(int) ceil(0.95 * count($times)) - 1];
                if ($p95_val >= $p95_crit)     $slow_crit[] = "{$ep} ({$p95_val}ms)";
                elseif ($p95_val >= $p95_warn) $slow_warn[] = "{$ep} ({$p95_val}ms)";
            }
            if (!empty($slow_crit)) {
                $list = implode(', ', array_slice($slow_crit, 0, 5));
                $alerts[] = self::make_alert('p95_slow', 'CRITICAL',
                    "P95 critical: {$list}",
                    "🚨 SLOW ENDPOINTS P95:\n{$list}\nThreshold: {$p95_crit}ms over 15 min."
                );
            } elseif (!empty($slow_warn)) {
                $list = implode(', ', array_slice($slow_warn, 0, 5));
                $alerts[] = self::make_alert('p95_slow', 'WARNING',
                    "P95 warning: {$list}",
                    "⚠️ Slow endpoints P95:\n{$list}\nThreshold: {$p95_warn}ms over 15 min."
                );
            }
        }

        // 9. Auth failure spike — per-IP burst of 401s in 5 minutes
        $af_crit  = (int) self::get('auth_fail_per_ip_critical');
        $af_warn  = (int) self::get('auth_fail_per_ip_warning');
        $ip_fails = $wpdb->get_results(
            $wpdb->prepare(
                "SELECT ip_address, COUNT(*) AS cnt
                 FROM {$p}ta_api_logs
                 WHERE created_at >= DATE_SUB(NOW(), INTERVAL 5 MINUTE)
                   AND status_code = 401
                 GROUP BY ip_address
                 HAVING cnt >= %d
                 ORDER BY cnt DESC
                 LIMIT 10",
                $af_warn
            ),
            ARRAY_A
        );
        if (!empty($ip_fails)) {
            $crit_ips = array_filter($ip_fails, fn($r) => (int) $r['cnt'] >= $af_crit);
            $warn_ips = array_filter($ip_fails, fn($r) => (int) $r['cnt'] <  $af_crit);
            if (!empty($crit_ips)) {
                $top = array_map(fn($r) => "{$r['ip_address']} ({$r['cnt']}x)", array_slice(array_values($crit_ips), 0, 5));
                $alerts[] = self::make_alert('auth_fail', 'CRITICAL',
                    'Auth attack: ' . implode(', ', $top),
                    "🚨 AUTH ATTACK DETECTED:\n" . implode("\n", $top) . "\n\nConsider blocking these IPs."
                );
            } elseif (!empty($warn_ips)) {
                $top = array_map(fn($r) => "{$r['ip_address']} ({$r['cnt']}x)", array_slice(array_values($warn_ips), 0, 5));
                $alerts[] = self::make_alert('auth_fail', 'WARNING',
                    'Auth failures: ' . implode(', ', $top),
                    "⚠️ Elevated auth failures:\n" . implode("\n", $top)
                );
            }
        }

        return $alerts;
    }

    /**
     * Get current system health status (for dashboard display).
     */
    public static function get_health_status(): array {
        global $wpdb;
        $p = $wpdb->prefix;

        $stats_5m = $wpdb->get_row(
            "SELECT COUNT(*) AS total,
                SUM(CASE WHEN status_code >= 500 THEN 1 ELSE 0 END) AS server_errors,
                SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) AS all_errors,
                ROUND(AVG(response_ms), 0) AS avg_ms,
                MAX(created_at) AS last_call
             FROM {$p}ta_api_logs
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL 5 MINUTE)",
            ARRAY_A
        );

        $total       = (int) ($stats_5m['total'] ?? 0);
        $error_rate  = $total > 0 ? round(($stats_5m['all_errors'] / $total) * 100, 1) : 0;
        $avg_ms      = (int) ($stats_5m['avg_ms'] ?? 0);
        $server_errs = (int) ($stats_5m['server_errors'] ?? 0);

        $overall = 'OK';
        if ($error_rate >= self::get('error_rate_critical') || $avg_ms >= self::get('response_ms_critical') || $server_errs >= self::get('server_error_critical')) {
            $overall = 'CRITICAL';
        } elseif ($error_rate >= self::get('error_rate_warning') || $avg_ms >= self::get('response_ms_warning') || $server_errs >= self::get('server_error_warning')) {
            $overall = 'WARNING';
        }

        return [
            'status'         => $overall,
            'last_5min'      => [
                'total_requests' => $total,
                'error_rate'     => $error_rate,
                'avg_ms'         => $avg_ms,
                'server_errors'  => $server_errs,
                'last_call'      => $stats_5m['last_call'] ?? null,
            ],
            'thresholds'     => [
                'error_rate'   => ['warning' => self::get('error_rate_warning'), 'critical' => self::get('error_rate_critical')],
                'response_ms'  => ['warning' => self::get('response_ms_warning'), 'critical' => self::get('response_ms_critical')],
                'server_errors'=> ['warning' => self::get('server_error_warning'), 'critical' => self::get('server_error_critical')],
            ],
        ];
    }

    // ── Alert helpers ─────────────────────────────────────────────────────

    private static function make_alert(string $type, string $level, string $detail, string $message): array {
        return compact('type', 'level', 'detail', 'message');
    }

    private static function should_send(string $type): bool {
        $cooldown = self::get('alert_cooldown_min') * 60;
        $last_sent = (int) get_option('ta_alert_last_' . $type, 0);
        return (time() - $last_sent) >= $cooldown;
    }

    private static function mark_sent(string $type) {
        update_option('ta_alert_last_' . $type, time());
    }

    private static function send_alert(array $alert) {
        $site_name = get_bloginfo('name');
        $site_url  = home_url();
        $time      = current_time('Y-m-d H:i:s');
        $level_icon = $alert['level'] === 'CRITICAL' ? '🚨' : '⚠️';
        $log_url   = admin_url('admin.php?page=toursapp-logs&errors_only=1');

        $full_message = "[{$alert['level']}] {$site_name}\n"
            . "{$level_icon} {$alert['message']}\n\n"
            . "🌐 Site: {$site_url}\n"
            . "🕐 Time: {$time}\n"
            . "📋 Logs: {$log_url}";

        if (self::get('email_enabled')) {
            self::send_email($alert, $full_message, $site_name);
        }
        if (self::get('telegram_enabled')) {
            self::send_telegram($full_message);
        }
    }

    private static function send_email(array $alert, string $message, string $site_name) {
        $recipients = array_filter(array_map('trim', explode(',', self::get('email_recipients'))));
        if (empty($recipients)) return;

        $subject = "[{$alert['level']}] {$site_name} — ToursApp API Alert";
        $body    = nl2br(esc_html($message));
        $headers = ['Content-Type: text/html; charset=UTF-8'];
        $html_body = '<pre style="font-family:monospace;font-size:14px;padding:16px;background:#f5f5f5;border-radius:6px">'
                   . $body . '</pre>';

        foreach ($recipients as $email) {
            wp_mail($email, $subject, $html_body, $headers);
        }
    }

    private static function send_telegram(string $message) {
        $token   = self::get('telegram_bot_token');
        $chat_id = self::get('telegram_chat_id');
        if (!$token || !$chat_id) return;

        wp_remote_post("https://api.telegram.org/bot{$token}/sendMessage", [
            'timeout' => 10,
            'body'    => [
                'chat_id'    => $chat_id,
                'text'       => $message,
                'parse_mode' => 'HTML',
            ],
        ]);
    }

    /**
     * Test alert — 'all', 'email', or 'telegram'.
     * $overrides: live form values from JS, bypasses DB (no Save required).
     */
    public static function send_test(string $channel = 'all', array $overrides = []): array {
        $results  = [];
        $now      = gmdate('Y-m-d H:i') . ' UTC';
        $site     = esc_html(home_url());

        // HTML message — same approach as Python TelegramBot (parse_mode HTML)
        $tg_msg = implode("\n", [
            '✅ <b>TEST ALERT</b>',
            '━━━━━━━━━━━━━━━━━━━━━',
            "🌐 Site: {$site}",
            "🕐 {$now}",
            '',
            'If you receive this, <b>ToursApp Monitor alerts are working correctly.</b>',
            '━━━━━━━━━━━━━━━━━━━━━',
        ]);

        // Plain text for email
        $email_msg = "✅ TEST ALERT\n\nSite: {$site}\nTime: {$now}\n\nIf you receive this, ToursApp Monitor alerts are working correctly.";

        if (in_array($channel, ['all', 'email'], true)) {
            $recipients_raw = isset($overrides['email_recipients']) ? $overrides['email_recipients'] : self::get('email_recipients');
            $recipients = array_filter(array_map('trim', explode(',', $recipients_raw)));
            if (empty($recipients)) {
                $results[] = '✗ Email: no recipients configured.';
            } else {
                foreach ($recipients as $email) {
                    $ok = wp_mail($email, '[TEST] ToursApp API Monitor', nl2br($email_msg), ['Content-Type: text/html; charset=UTF-8']);
                    $results[] = 'Email → ' . $email . ': ' . ($ok ? '✓ accepted by wp_mail' : '✗ wp_mail() returned false — check SMTP config');
                }
            }
        }

        if (in_array($channel, ['all', 'telegram'], true)) {
            $token   = trim(isset($overrides['telegram_bot_token']) ? $overrides['telegram_bot_token'] : self::get('telegram_bot_token'));
            $chat_id = trim(isset($overrides['telegram_chat_id'])   ? $overrides['telegram_chat_id']   : self::get('telegram_chat_id'));
            if (!$token || !$chat_id) {
                $results[] = '✗ Telegram: bot token or chat ID is empty.';
            } else {
                $resp = wp_remote_post("https://api.telegram.org/bot{$token}/sendMessage", [
                    'timeout' => 15,
                    'body'    => [
                        'chat_id'              => $chat_id,
                        'text'                 => $tg_msg,
                        'parse_mode'           => 'HTML',
                        'disable_notification' => false,
                    ],
                ]);
                if (is_wp_error($resp)) {
                    $results[] = '✗ Telegram network error: ' . $resp->get_error_message();
                } else {
                    $code    = (int) wp_remote_retrieve_response_code($resp);
                    $body    = wp_remote_retrieve_body($resp);
                    $decoded = json_decode($body, true);
                    if ($code === 200 && !empty($decoded['ok'])) {
                        $msg_id    = $decoded['result']['message_id'] ?? '?';
                        $results[] = '✓ Telegram: sent (message_id=' . $msg_id . ')';
                    } else {
                        $detail    = $decoded['description'] ?? $body;
                        $results[] = '✗ Telegram [HTTP ' . $code . ']: ' . $detail;
                    }
                }
            }
        }

        if (empty($results)) $results[] = 'Nothing to test — configure email recipients or Telegram token/chat ID.';
        return $results;
    }

    // ── Settings helpers ──────────────────────────────────────────────────

    public static function get(string $key) {
        return get_option('ta_monitor_' . $key, self::DEFAULTS[$key] ?? '');
    }

    public static function save_settings(array $data) {
        foreach (self::DEFAULTS as $key => $default) {
            if (isset($data[$key])) {
                update_option('ta_monitor_' . $key, $data[$key]);
            }
        }
    }

    /**
     * Send an alert directly from background processes (e.g., archiver on exception).
     * Respects the configured cooldown to avoid flooding on repeated failures.
     */
    public static function send_direct_alert(string $type, string $level, string $message): void {
        if (!self::should_send($type)) return;
        $alert = self::make_alert($type, $level, $message, $message);
        self::send_alert($alert);
        self::mark_sent($type);
    }
}
