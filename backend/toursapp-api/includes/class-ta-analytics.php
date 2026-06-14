<?php
defined('ABSPATH') || exit;

class TA_Analytics {

    // ── Overview ─────────────────────────────────────────────────────────

    public static function overview(): array {
        global $wpdb;
        $p = $wpdb->prefix;

        return [
            'total_users'       => (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_devices"),
            'active_7d'         => (int) $wpdb->get_var("SELECT COUNT(DISTINCT device_uuid) FROM {$p}ta_api_logs WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)"),
            'active_30d'        => (int) $wpdb->get_var("SELECT COUNT(DISTINCT device_uuid) FROM {$p}ta_api_logs WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)"),
            'total_checkins'    => (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_checkins"),
            'total_api_calls'   => (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_api_logs"),
            'total_comments'    => (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_comments WHERE status='approved'"),
            'total_ratings'     => (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_ratings"),
            'avg_rating'        => round((float) $wpdb->get_var("SELECT AVG(rating) FROM {$p}ta_ratings"), 1),
            'flowers_earned'    => (int) $wpdb->get_var("SELECT SUM(total_earned) FROM {$p}ta_wallet"),
            'flowers_spent'     => (int) $wpdb->get_var("SELECT SUM(total_spent) FROM {$p}ta_wallet"),
            'total_unlocks'     => (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_unlocked_content"),
            'total_journeys'    => (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_user_journeys"),
        ];
    }

    // ── API Performance ───────────────────────────────────────────────────

    public static function top_endpoints(int $limit = 20, string $since = '-30 days'): array {
        global $wpdb;
        $since_dt = date('Y-m-d H:i:s', strtotime($since));
        return $wpdb->get_results($wpdb->prepare(
            "SELECT endpoint, method,
                COUNT(*) AS total_calls,
                ROUND(AVG(response_ms), 0) AS avg_ms,
                MAX(response_ms) AS max_ms,
                SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) AS error_count,
                ROUND(SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS error_pct
             FROM {$wpdb->prefix}ta_api_logs
             WHERE created_at >= %s
             GROUP BY endpoint, method
             ORDER BY total_calls DESC
             LIMIT %d",
            $since_dt, $limit
        ), ARRAY_A) ?: [];
    }

    public static function slowest_endpoints(int $limit = 10, string $since = '-7 days'): array {
        global $wpdb;
        $since_dt = date('Y-m-d H:i:s', strtotime($since));
        // Note: PERCENTILE_CONT is PostgreSQL-only. Use MAX as p95 approximation for MySQL.
        return $wpdb->get_results($wpdb->prepare(
            "SELECT endpoint, method,
                COUNT(*) AS calls,
                ROUND(AVG(response_ms), 0) AS avg_ms,
                MAX(response_ms) AS max_ms
             FROM {$wpdb->prefix}ta_api_logs
             WHERE created_at >= %s
             GROUP BY endpoint, method
             HAVING calls >= 5
             ORDER BY avg_ms DESC
             LIMIT %d",
            $since_dt, $limit
        ), ARRAY_A) ?: [];
    }

    public static function api_volume_by_day(int $days = 14): array {
        global $wpdb;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT DATE(created_at) AS day,
                COUNT(*) AS calls,
                COUNT(DISTINCT device_uuid) AS unique_users,
                ROUND(AVG(response_ms), 0) AS avg_ms,
                SUM(CASE WHEN status_code >= 400 THEN 1 ELSE 0 END) AS errors
             FROM {$wpdb->prefix}ta_api_logs
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL %d DAY)
             GROUP BY DATE(created_at)
             ORDER BY day DESC",
            $days
        ), ARRAY_A) ?: [];
    }

    public static function api_error_breakdown(string $since = '-7 days'): array {
        global $wpdb;
        $since_dt = date('Y-m-d H:i:s', strtotime($since));
        return $wpdb->get_results($wpdb->prepare(
            "SELECT endpoint, method, status_code, COUNT(*) AS cnt
             FROM {$wpdb->prefix}ta_api_logs
             WHERE created_at >= %s AND status_code >= 400
             GROUP BY endpoint, method, status_code
             ORDER BY cnt DESC
             LIMIT 20",
            $since_dt
        ), ARRAY_A) ?: [];
    }

    // ── Content Analytics ─────────────────────────────────────────────────

    public static function top_content(string $metric = 'views', string $content_type = '', int $limit = 20, string $since = '-30 days'): array {
        global $wpdb;
        $since_dt = date('Y-m-d H:i:s', strtotime($since));

        // Detect if requested period is outside raw data retention → fallback to aggregated daily stats
        $retention_days = class_exists('TA_Data_Archiver') ? (int) TA_Data_Archiver::get('content_events_days') : 90;
        $cutoff_dt      = date('Y-m-d H:i:s', strtotime("-{$retention_days} days"));

        if ($since_dt < $cutoff_dt) {
            return self::top_content_from_daily_stats($metric, $content_type, $limit, $since);
        }

        // Raw events query (recent data within retention window)
        $where = $wpdb->prepare("WHERE created_at >= %s", $since_dt);
        if ($content_type) {
            $where .= $wpdb->prepare(" AND content_type = %s", $content_type);
        }

        $order_col = 'COUNT(*)';
        if ($metric === 'read_time')  $order_col = 'AVG(duration_sec)';
        if ($metric === 'completion') $order_col = 'AVG(completion_pct)';
        if ($metric === 'unique')     $order_col = 'COUNT(DISTINCT device_uuid)';

        return $wpdb->get_results($wpdb->prepare(
            "SELECT content_type, content_id,
                COUNT(*) AS total_events,
                COUNT(DISTINCT device_uuid) AS unique_users,
                SUM(CASE WHEN event_type='page_view' THEN 1 ELSE 0 END) AS views,
                SUM(CASE WHEN event_type='article_read' THEN 1 ELSE 0 END) AS article_reads,
                SUM(CASE WHEN event_type='audio_play' THEN 1 ELSE 0 END) AS audio_plays,
                SUM(CASE WHEN event_type='audio_complete' THEN 1 ELSE 0 END) AS audio_completes,
                ROUND(AVG(CASE WHEN duration_sec > 0 THEN duration_sec END), 0) AS avg_read_sec,
                ROUND(AVG(CASE WHEN completion_pct > 0 THEN completion_pct END), 1) AS avg_completion_pct,
                ROUND(AVG(CASE WHEN scroll_depth > 0 THEN scroll_depth END), 1) AS avg_scroll_depth
             FROM {$wpdb->prefix}ta_content_events
             {$where}
             GROUP BY content_type, content_id
             ORDER BY {$order_col} DESC
             LIMIT %d",
            $limit
        ), ARRAY_A) ?: [];
    }

    /**
     * Fallback: query aggregated daily stats table when raw data has been purged.
     */
    private static function top_content_from_daily_stats(string $metric, string $content_type, int $limit, string $since): array {
        global $wpdb;
        $since_date = date('Y-m-d', strtotime($since));

        $where = $wpdb->prepare("WHERE date >= %s", $since_date);
        if ($content_type) {
            $where .= $wpdb->prepare(" AND content_type = %s", $content_type);
        }

        $order_col = 'SUM(event_count)';
        if ($metric === 'read_time')  $order_col = 'AVG(avg_duration)';
        if ($metric === 'completion') $order_col = 'AVG(avg_completion)';
        if ($metric === 'unique')     $order_col = 'MAX(unique_users)';

        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT content_type, content_id,
                SUM(event_count) AS total_events,
                MAX(unique_users) AS unique_users,
                SUM(CASE WHEN event_type='page_view' THEN event_count ELSE 0 END) AS views,
                SUM(CASE WHEN event_type='article_read' THEN event_count ELSE 0 END) AS article_reads,
                SUM(CASE WHEN event_type='audio_play' THEN event_count ELSE 0 END) AS audio_plays,
                SUM(CASE WHEN event_type='audio_complete' THEN event_count ELSE 0 END) AS audio_completes,
                ROUND(AVG(CASE WHEN avg_duration > 0 THEN avg_duration END), 0) AS avg_read_sec,
                ROUND(AVG(CASE WHEN avg_completion > 0 THEN avg_completion END), 1) AS avg_completion_pct,
                ROUND(AVG(CASE WHEN avg_scroll > 0 THEN avg_scroll END), 1) AS avg_scroll_depth
             FROM {$wpdb->prefix}ta_content_stats_daily
             {$where}
             GROUP BY content_type, content_id
             ORDER BY {$order_col} DESC
             LIMIT %d",
            $limit
        ), ARRAY_A) ?: [];

        // Tag results so UI can indicate they come from aggregated data
        foreach ($rows as &$row) {
            $row['_source'] = 'aggregated';
        }
        return $rows;
    }

    public static function content_event_trend(int $days = 14): array {
        global $wpdb;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT DATE(created_at) AS day, event_type, COUNT(*) AS cnt
             FROM {$wpdb->prefix}ta_content_events
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL %d DAY)
             GROUP BY DATE(created_at), event_type
             ORDER BY day DESC",
            $days
        ), ARRAY_A) ?: [];
    }

    // ── User Stats ────────────────────────────────────────────────────────

    public static function new_users_by_day(int $days = 14): array {
        global $wpdb;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT DATE(created_at) AS day, COUNT(*) AS new_users, platform
             FROM {$wpdb->prefix}ta_devices
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL %d DAY)
             GROUP BY DATE(created_at), platform
             ORDER BY day DESC",
            $days
        ), ARRAY_A) ?: [];
    }

    public static function top_users(int $limit = 20): array {
        global $wpdb;
        $p = $wpdb->prefix;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT d.device_uuid, d.platform, d.app_version, d.lang, d.created_at,
                (SELECT COUNT(*) FROM {$p}ta_checkins c WHERE c.device_uuid = d.device_uuid) AS checkin_count,
                (SELECT COUNT(*) FROM {$p}ta_api_logs l WHERE l.device_uuid = d.device_uuid) AS api_calls,
                (SELECT balance FROM {$p}ta_wallet w WHERE w.device_uuid = d.device_uuid) AS wallet_balance,
                (SELECT COUNT(*) FROM {$p}ta_user_journeys j WHERE j.device_uuid = d.device_uuid) AS journeys,
                (SELECT COUNT(*) FROM {$p}ta_comments co WHERE co.device_uuid = d.device_uuid) AS comments
             FROM {$p}ta_devices d
             ORDER BY api_calls DESC
             LIMIT %d",
            $limit
        ), ARRAY_A) ?: [];
    }

    public static function get_user_profile(string $uuid): array {
        global $wpdb;
        $p    = $wpdb->prefix;
        $device = $wpdb->get_row($wpdb->prepare("SELECT * FROM {$p}ta_devices WHERE device_uuid = %s", $uuid), ARRAY_A);
        if (!$device) return [];

        $wallet   = $wpdb->get_row($wpdb->prepare("SELECT * FROM {$p}ta_wallet WHERE device_uuid = %s", $uuid), ARRAY_A);
        $checkins = $wpdb->get_results($wpdb->prepare(
            "SELECT c.*, p.post_title as place_name FROM {$p}ta_checkins c LEFT JOIN {$p}posts p ON p.ID = c.place_id WHERE c.device_uuid = %s ORDER BY c.created_at DESC LIMIT 20", $uuid
        ), ARRAY_A) ?: [];
        $journeys = $wpdb->get_results($wpdb->prepare("SELECT * FROM {$p}ta_user_journeys WHERE device_uuid = %s ORDER BY created_at DESC", $uuid), ARRAY_A) ?: [];
        $txns     = $wpdb->get_results($wpdb->prepare("SELECT * FROM {$p}ta_wallet_txn WHERE device_uuid = %s ORDER BY created_at DESC LIMIT 30", $uuid), ARRAY_A) ?: [];
        $comments = $wpdb->get_results($wpdb->prepare("SELECT * FROM {$p}ta_comments WHERE device_uuid = %s ORDER BY created_at DESC LIMIT 20", $uuid), ARRAY_A) ?: [];
        $api_summary = $wpdb->get_results($wpdb->prepare(
            "SELECT endpoint, method, COUNT(*) AS calls, ROUND(AVG(response_ms),0) AS avg_ms FROM {$p}ta_api_logs WHERE device_uuid = %s GROUP BY endpoint, method ORDER BY calls DESC LIMIT 10", $uuid
        ), ARRAY_A) ?: [];
        $content_events = $wpdb->get_results($wpdb->prepare(
            "SELECT content_type, content_id, event_type, COUNT(*) AS cnt FROM {$p}ta_content_events WHERE device_uuid = %s GROUP BY content_type, content_id, event_type ORDER BY cnt DESC LIMIT 20", $uuid
        ), ARRAY_A) ?: [];

        return compact('device', 'wallet', 'checkins', 'journeys', 'txns', 'comments', 'api_summary', 'content_events');
    }

    // ── Feedback ──────────────────────────────────────────────────────────

    public static function recent_comments(int $limit = 30, string $status = 'approved'): array {
        global $wpdb;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}ta_comments
             WHERE status = %s
             ORDER BY created_at DESC
             LIMIT %d",
            $status, $limit
        ), ARRAY_A) ?: [];
    }

    public static function pending_comments(): array {
        return self::recent_comments(50, 'pending');
    }

    public static function top_rated_content(int $limit = 10): array {
        global $wpdb;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT content_type, content_id,
                COUNT(*) AS total_ratings,
                ROUND(AVG(rating), 1) AS avg_rating,
                SUM(CASE WHEN rating=5 THEN 1 ELSE 0 END) AS five_star,
                SUM(CASE WHEN rating<=2 THEN 1 ELSE 0 END) AS low_star
             FROM {$wpdb->prefix}ta_ratings
             GROUP BY content_type, content_id
             HAVING total_ratings >= 3
             ORDER BY avg_rating DESC, total_ratings DESC
             LIMIT %d",
            $limit
        ), ARRAY_A) ?: [];
    }

    public static function bottom_rated_content(int $limit = 10): array {
        global $wpdb;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT content_type, content_id,
                COUNT(*) AS total_ratings,
                ROUND(AVG(rating), 1) AS avg_rating
             FROM {$wpdb->prefix}ta_ratings
             GROUP BY content_type, content_id
             HAVING total_ratings >= 3
             ORDER BY avg_rating ASC, total_ratings DESC
             LIMIT %d",
            $limit
        ), ARRAY_A) ?: [];
    }

    // ── Economy ───────────────────────────────────────────────────────────

    public static function economy_stats(): array {
        global $wpdb;
        $p = $wpdb->prefix;
        return [
            'total_earned' => (int) $wpdb->get_var("SELECT SUM(total_earned) FROM {$p}ta_wallet"),
            'total_spent'  => (int) $wpdb->get_var("SELECT SUM(total_spent) FROM {$p}ta_wallet"),
            'by_type'      => $wpdb->get_results(
                "SELECT type, COUNT(*) AS txn_count, SUM(amount) AS total_amount FROM {$p}ta_wallet_txn GROUP BY type ORDER BY total_amount DESC",
                ARRAY_A
            ) ?: [],
            'unlocks_by_type' => $wpdb->get_results(
                "SELECT content_type, COUNT(*) AS cnt, SUM(cost) AS total_cost FROM {$p}ta_unlocked_content GROUP BY content_type",
                ARRAY_A
            ) ?: [],
        ];
    }

    // ── Helper ────────────────────────────────────────────────────────────

    public static function get_content_title(string $type, int $id): string {
        $post = get_post($id);
        if (!$post) return "#{$id}";
        $name = TA_Localize::get_field_localized($id, $type . '_name', TA_DEFAULT_LANG)
             ?: TA_Localize::get_field_localized($id, 'place_name', TA_DEFAULT_LANG)
             ?: $post->post_title;
        return $name ?: "#{$id}";
    }

    public static function moderate_comment(int $id, string $status) {
        global $wpdb;
        $wpdb->update($wpdb->prefix . 'ta_comments', ['status' => $status], ['id' => $id]);
    }

    // ── Retention & Churn ─────────────────────────────────────────────────

    /**
     * User activity segments based on days since last API call.
     * Returns counts + percentage.
     */
    public static function user_segments(): array {
        global $wpdb;
        $p = $wpdb->prefix;

        $rows = $wpdb->get_results(
            "SELECT d.device_uuid,
                d.created_at AS registered_at,
                MAX(l.created_at) AS last_active_at,
                COUNT(l.id) AS total_calls,
                DATEDIFF(NOW(), MAX(l.created_at)) AS days_inactive,
                DATEDIFF(NOW(), d.created_at) AS age_days
             FROM {$p}ta_devices d
             LEFT JOIN {$p}ta_api_logs l ON l.device_uuid = d.device_uuid
             GROUP BY d.device_uuid",
            ARRAY_A
        ) ?: [];

        $segments = [
            'active'       => 0,  // < 7 days
            'dormant'      => 0,  // 7–14 days
            'at_risk'      => 0,  // 15–30 days
            'churned'      => 0,  // 31–90 days
            'lost'         => 0,  // > 90 days
            'never_used'   => 0,  // 0 API calls
        ];
        $total = count($rows);

        foreach ($rows as $r) {
            if ($r['total_calls'] == 0) {
                $segments['never_used']++;
            } elseif ($r['days_inactive'] <= 7) {
                $segments['active']++;
            } elseif ($r['days_inactive'] <= 14) {
                $segments['dormant']++;
            } elseif ($r['days_inactive'] <= 30) {
                $segments['at_risk']++;
            } elseif ($r['days_inactive'] <= 90) {
                $segments['churned']++;
            } else {
                $segments['lost']++;
            }
        }

        // Add percentages
        $result = [];
        foreach ($segments as $key => $count) {
            $result[$key] = [
                'count' => $count,
                'pct'   => $total > 0 ? round($count / $total * 100, 1) : 0,
            ];
        }
        $result['total'] = $total;
        return $result;
    }

    /**
     * List users in a churn segment for follow-up.
     * segment: active|dormant|at_risk|churned|lost|never_used
     */
    public static function churn_list(string $segment = 'churned', int $limit = 50): array {
        global $wpdb;
        $p = $wpdb->prefix;

        $having_map = [
            'active'     => 'days_inactive <= 7 AND total_calls > 0',
            'dormant'    => 'days_inactive > 7 AND days_inactive <= 14',
            'at_risk'    => 'days_inactive > 14 AND days_inactive <= 30',
            'churned'    => 'days_inactive > 30 AND days_inactive <= 90',
            'lost'       => 'days_inactive > 90',
            'never_used' => 'total_calls = 0',
        ];
        $having = $having_map[$segment] ?? 'days_inactive > 30';

        return $wpdb->get_results($wpdb->prepare(
            "SELECT d.device_uuid, d.platform, d.lang, d.app_version, d.created_at AS registered_at,
                MAX(l.created_at) AS last_active_at,
                COUNT(l.id) AS total_calls,
                DATEDIFF(NOW(), MAX(l.created_at)) AS days_inactive,
                DATEDIFF(NOW(), d.created_at) AS age_days,
                (SELECT COUNT(*) FROM {$p}ta_checkins c WHERE c.device_uuid = d.device_uuid) AS checkins,
                (SELECT balance FROM {$p}ta_wallet w WHERE w.device_uuid = d.device_uuid) AS balance
             FROM {$p}ta_devices d
             LEFT JOIN {$p}ta_api_logs l ON l.device_uuid = d.device_uuid
             GROUP BY d.device_uuid
             HAVING {$having}
             ORDER BY last_active_at ASC
             LIMIT %d",
            $limit
        ), ARRAY_A) ?: [];
    }

    /**
     * Weekly retention cohorts.
     * Shows: of users who registered in week W, what % were still active after 1/7/30 days.
     */
    public static function retention_cohorts(int $weeks = 8): array {
        global $wpdb;
        $p = $wpdb->prefix;

        $cohorts = [];
        for ($i = $weeks - 1; $i >= 0; $i--) {
            $week_start = date('Y-m-d', strtotime("-{$i} weeks Monday"));
            $week_end   = date('Y-m-d', strtotime("-{$i} weeks Sunday"));

            $users = $wpdb->get_col($wpdb->prepare(
                "SELECT device_uuid FROM {$p}ta_devices WHERE DATE(created_at) BETWEEN %s AND %s",
                $week_start, $week_end
            ));
            $cohort_size = count($users);
            if (!$cohort_size) continue;

            // Build safe IN clause with individual %s placeholders
            $placeholders = implode(',', array_fill(0, $cohort_size, '%s'));
            $in_sql       = $wpdb->prepare($placeholders, $users);

            $d1 = (int) $wpdb->get_var($wpdb->prepare(
                "SELECT COUNT(DISTINCT device_uuid) FROM {$p}ta_api_logs
                 WHERE device_uuid IN ({$in_sql})
                 AND created_at > %s AND created_at <= DATE_ADD(%s, INTERVAL 1 DAY)",
                $week_end, $week_end
            ));

            $d7 = (int) $wpdb->get_var($wpdb->prepare(
                "SELECT COUNT(DISTINCT device_uuid) FROM {$p}ta_api_logs
                 WHERE device_uuid IN ({$in_sql})
                 AND created_at > %s AND created_at <= DATE_ADD(%s, INTERVAL 7 DAY)",
                $week_end, $week_end
            ));

            $d30 = (int) $wpdb->get_var($wpdb->prepare(
                "SELECT COUNT(DISTINCT device_uuid) FROM {$p}ta_api_logs
                 WHERE device_uuid IN ({$in_sql})
                 AND created_at > %s AND created_at <= DATE_ADD(%s, INTERVAL 30 DAY)",
                $week_end, $week_end
            ));

            $cohorts[] = [
                'week'        => $week_start . ' – ' . $week_end,
                'new_users'   => $cohort_size,
                'day1_count'  => $d1,
                'day1_pct'    => $cohort_size ? round($d1 / $cohort_size * 100, 1) : 0,
                'day7_count'  => $d7,
                'day7_pct'    => $cohort_size ? round($d7 / $cohort_size * 100, 1) : 0,
                'day30_count' => $d30,
                'day30_pct'   => $cohort_size ? round($d30 / $cohort_size * 100, 1) : 0,
            ];
        }
        return $cohorts;
    }

    /**
     * Average session frequency and interval per user (top active users).
     */
    public static function session_frequency(int $limit = 20): array {
        global $wpdb;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT l.device_uuid,
                COUNT(*) AS total_calls,
                COUNT(DISTINCT DATE(l.created_at)) AS active_days,
                ROUND(COUNT(*) / NULLIF(COUNT(DISTINCT DATE(l.created_at)), 0), 1) AS calls_per_day,
                MIN(l.created_at) AS first_seen,
                MAX(l.created_at) AS last_seen,
                DATEDIFF(MAX(l.created_at), MIN(l.created_at)) AS lifespan_days,
                d.platform
             FROM {$p}ta_api_logs l
             JOIN {$p}ta_devices d ON d.device_uuid = l.device_uuid
             GROUP BY l.device_uuid
             ORDER BY active_days DESC
             LIMIT %d",
            $limit
        ), ARRAY_A) ?: [];
    }
}
