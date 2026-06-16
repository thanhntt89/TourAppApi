<?php
defined('ABSPATH') || exit;

class TA_Analytics_Page {

    public static function register_menu() {
        add_submenu_page('toursapp-api', 'ToursApp Analytics', 'Analytics', 'manage_options', 'toursapp-analytics', [self::class, 'render']);
        add_action('admin_init', [self::class, 'handle_actions']);
        add_action('admin_init', [self::class, 'handle_export']); // fires BEFORE admin HTML output
    }

    // ── CSV Export ───────────────────────────────────────────────────────

    public static function handle_export() {
        // Only act when export is requested on our page
        if (!isset($_GET['page']) || $_GET['page'] !== 'toursapp-analytics') return;
        if (!isset($_GET['export']) || $_GET['export'] !== 'csv') return;
        if (!current_user_can('manage_options')) wp_die('Unauthorized');
        if (!isset($_GET['_nonce']) || !wp_verify_nonce($_GET['_nonce'], 'ta_analytics_export')) wp_die('Invalid nonce');

        global $wpdb;
        $wpdb->suppress_errors(true); // Prevent DB error messages from corrupting CSV

        $tab    = sanitize_text_field($_GET['tab'] ?? 'overview');
        $since  = sanitize_text_field($_GET['since'] ?? '-30 days');
        $metric = sanitize_text_field($_GET['metric'] ?? 'views');
        $ctype  = sanitize_text_field($_GET['ctype'] ?? '');

        // Validate $since format to prevent abuse
        $allowed_since = ['-7 days', '-30 days', '-90 days', '-365 days'];
        if (!in_array($since, $allowed_since, true)) $since = '-30 days';

        $filename = 'toursapp-analytics-' . $tab . '-' . date('Y-m-d') . '.csv';

        while (ob_get_level() > 0) ob_end_clean();
        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Pragma: no-cache');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header('Expires: 0');

        $out = fopen('php://output', 'w');
        fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF)); // UTF-8 BOM for Excel

        switch ($tab) {
            case 'overview':
                self::export_overview($out);
                break;
            case 'content':
                self::export_content($out, $metric, $ctype, $since);
                break;
            case 'api':
                self::export_api($out, $since);
                break;
            case 'users':
                self::export_users($out);
                break;
            case 'feedback':
                self::export_feedback($out);
                break;
            case 'retention':
                self::export_retention($out);
                break;
            case 'economy':
                self::export_economy($out);
                break;
            case 'full':
                self::export_full($out, $since);
                break;
        }

        fclose($out);
        exit;
    }

    private static function export_nonce_url(string $tab, array $extra = []): string {
        // Use admin.php?page=toursapp-analytics — handled by admin_init BEFORE HTML output
        return add_query_arg(array_merge([
            'page'   => 'toursapp-analytics',
            'export' => 'csv',
            'tab'    => $tab,
            '_nonce' => wp_create_nonce('ta_analytics_export'),
        ], $extra), admin_url('admin.php'));
    }

    private static function export_button(string $tab, string $label = 'Export CSV', array $extra = []): string {
        $url = self::export_nonce_url($tab, $extra);
        return '<button type="button" class="button" style="margin-left:8px" onclick="taDownloadCSV(\'' . esc_js($url) . '\')">⬇ ' . esc_html($label) . '</button>';
    }

    // ── Export: Overview ─────────────────────────────────────────────────

    private static function export_overview($out) {
        $ov  = TA_Analytics::overview();
        $vol = TA_Analytics::api_volume_by_day(30);

        fputcsv($out, ['=== OVERVIEW METRICS ===']);
        fputcsv($out, ['Metric', 'Value']);
        foreach ($ov as $key => $val) {
            fputcsv($out, [str_replace('_', ' ', ucfirst($key)), $val]);
        }

        fputcsv($out, []);
        fputcsv($out, ['=== API VOLUME BY DAY (Last 30 days) ===']);
        fputcsv($out, ['Date', 'Total Calls', 'Unique Users', 'Avg Response (ms)', 'Errors']);
        foreach ($vol as $row) {
            fputcsv($out, [$row['day'], $row['calls'], $row['unique_users'], $row['avg_ms'], $row['errors']]);
        }
    }

    // ── Export: Content ──────────────────────────────────────────────────

    private static function export_content($out, string $metric, string $ctype, string $since) {
        $rows = TA_Analytics::top_content($metric, $ctype, 200, $since);

        fputcsv($out, ['=== CONTENT ENGAGEMENT ANALYTICS ===']);
        fputcsv($out, ['Generated', date('Y-m-d H:i:s'), 'Period', $since, 'Filter', $ctype ?: 'all', 'Metric', $metric]);
        fputcsv($out, []);
        fputcsv($out, [
            'Content Type', 'Content ID', 'Title (VI)',
            'Total Events', 'Unique Users',
            'Page Views', 'Article Reads', 'Audio Plays', 'Audio Completes',
            'Avg Read Time (s)', 'Avg Completion %', 'Avg Scroll Depth %'
        ]);

        foreach ($rows as $row) {
            $title = TA_Analytics::get_content_title($row['content_type'], (int) $row['content_id']);
            fputcsv($out, [
                $row['content_type'],
                $row['content_id'],
                $title,
                $row['total_events'],
                $row['unique_users'],
                $row['views'],
                $row['article_reads'],
                $row['audio_plays'],
                $row['audio_completes'],
                $row['avg_read_sec'] ?: 0,
                $row['avg_completion_pct'] ?: 0,
                $row['avg_scroll_depth'] ?: 0,
            ]);
        }

        // Ratings
        fputcsv($out, []);
        fputcsv($out, ['=== CONTENT RATINGS ===']);
        fputcsv($out, ['Content Type', 'Content ID', 'Title', 'Avg Rating', 'Total Ratings', '5★', '4★', '3★', '2★', '1★']);
        global $wpdb;
        $ratings = $wpdb->get_results(
            "SELECT content_type, content_id,
                ROUND(AVG(rating),2) AS avg,
                COUNT(*) AS total,
                SUM(rating=5) AS r5, SUM(rating=4) AS r4,
                SUM(rating=3) AS r3, SUM(rating=2) AS r2, SUM(rating=1) AS r1
             FROM {$wpdb->prefix}ta_ratings GROUP BY content_type, content_id ORDER BY avg DESC",
            ARRAY_A
        ) ?: [];
        foreach ($ratings as $r) {
            $t = TA_Analytics::get_content_title($r['content_type'], (int) $r['content_id']);
            fputcsv($out, [$r['content_type'], $r['content_id'], $t, $r['avg'], $r['total'], $r['r5'], $r['r4'], $r['r3'], $r['r2'], $r['r1']]);
        }
    }

    // ── Export: API ──────────────────────────────────────────────────────

    private static function export_api($out, string $since) {
        $rows   = TA_Analytics::top_endpoints(100, $since);
        $errors = TA_Analytics::api_error_breakdown($since);
        $vol    = TA_Analytics::api_volume_by_day(30);

        fputcsv($out, ['=== API PERFORMANCE REPORT ===']);
        fputcsv($out, ['Generated', date('Y-m-d H:i:s'), 'Period', $since]);
        fputcsv($out, []);

        fputcsv($out, ['=== ENDPOINT STATS ===']);
        fputcsv($out, ['Method', 'Endpoint', 'Total Calls', 'Avg Response (ms)', 'Max Response (ms)', 'Error Count', 'Error %']);
        foreach ($rows as $row) {
            fputcsv($out, [
                $row['method'], $row['endpoint'],
                $row['total_calls'], $row['avg_ms'], $row['max_ms'],
                $row['error_count'], $row['error_pct'],
            ]);
        }

        fputcsv($out, []);
        fputcsv($out, ['=== ERROR BREAKDOWN ===']);
        fputcsv($out, ['Method', 'Endpoint', 'Status Code', 'Count']);
        foreach ($errors as $row) {
            fputcsv($out, [$row['method'], $row['endpoint'], $row['status_code'], $row['cnt']]);
        }

        fputcsv($out, []);
        fputcsv($out, ['=== DAILY VOLUME ===']);
        fputcsv($out, ['Date', 'Total Calls', 'Unique Users', 'Avg Response (ms)', 'Errors']);
        foreach ($vol as $row) {
            fputcsv($out, [$row['day'], $row['calls'], $row['unique_users'], $row['avg_ms'], $row['errors']]);
        }
    }

    // ── Export: Users ────────────────────────────────────────────────────

    private static function export_users($out) {
        $users    = TA_Analytics::top_users(500);
        $new_days = TA_Analytics::new_users_by_day(30);

        fputcsv($out, ['=== USER ACTIVITY EXPORT ===']);
        fputcsv($out, ['Generated', date('Y-m-d H:i:s')]);
        fputcsv($out, []);

        fputcsv($out, ['=== USER PROFILES ===']);
        fputcsv($out, ['Device UUID', 'Platform', 'App Version', 'Lang', 'API Calls', 'Check-ins', 'Wallet Balance', 'Journeys', 'Comments', 'Joined']);
        foreach ($users as $u) {
            fputcsv($out, [
                $u['device_uuid'], $u['platform'], $u['app_version'], $u['lang'],
                $u['api_calls'], $u['checkin_count'], $u['wallet_balance'],
                $u['journeys'], $u['comments'], $u['created_at'],
            ]);
        }

        fputcsv($out, []);
        fputcsv($out, ['=== NEW REGISTRATIONS BY DAY ===']);
        fputcsv($out, ['Date', 'Platform', 'New Users']);
        foreach ($new_days as $row) {
            fputcsv($out, [$row['day'], $row['platform'], $row['new_users']]);
        }

        // Check-in summary
        global $wpdb;
        $checkins = $wpdb->get_results(
            "SELECT device_uuid, COUNT(*) AS total, SUM(reward_amount) AS flowers_earned, MAX(created_at) AS last_checkin
             FROM {$wpdb->prefix}ta_checkins GROUP BY device_uuid ORDER BY total DESC LIMIT 200",
            ARRAY_A
        ) ?: [];

        fputcsv($out, []);
        fputcsv($out, ['=== CHECK-IN SUMMARY PER USER ===']);
        fputcsv($out, ['Device UUID', 'Total Check-ins', 'Flowers Earned', 'Last Check-in']);
        foreach ($checkins as $row) {
            fputcsv($out, [$row['device_uuid'], $row['total'], $row['flowers_earned'], $row['last_checkin']]);
        }
    }

    // ── Export: Feedback ─────────────────────────────────────────────────

    private static function export_feedback($out) {
        global $wpdb;

        fputcsv($out, ['=== FEEDBACK EXPORT ===']);
        fputcsv($out, ['Generated', date('Y-m-d H:i:s')]);
        fputcsv($out, []);

        // All comments
        $comments = $wpdb->get_results(
            "SELECT * FROM {$wpdb->prefix}ta_comments ORDER BY created_at DESC LIMIT 1000",
            ARRAY_A
        ) ?: [];

        fputcsv($out, ['=== COMMENTS ===']);
        fputcsv($out, ['ID', 'Device UUID', 'Content Type', 'Content ID', 'Content Title', 'Comment', 'Status', 'Created']);
        foreach ($comments as $c) {
            $title = TA_Analytics::get_content_title($c['content_type'], (int) $c['content_id']);
            fputcsv($out, [
                $c['id'], $c['device_uuid'], $c['content_type'], $c['content_id'],
                $title, $c['comment_text'], $c['status'], $c['created_at'],
            ]);
        }

        // All ratings
        $ratings = $wpdb->get_results(
            "SELECT r.*, p.post_title FROM {$wpdb->prefix}ta_ratings r
             LEFT JOIN {$wpdb->prefix}posts p ON p.ID = r.content_id
             ORDER BY r.created_at DESC LIMIT 2000",
            ARRAY_A
        ) ?: [];

        fputcsv($out, []);
        fputcsv($out, ['=== RATINGS ===']);
        fputcsv($out, ['ID', 'Device UUID', 'Content Type', 'Content ID', 'Content Title', 'Rating', 'Created', 'Updated']);
        foreach ($ratings as $r) {
            $title = TA_Analytics::get_content_title($r['content_type'], (int) $r['content_id']);
            fputcsv($out, [
                $r['id'], $r['device_uuid'], $r['content_type'], $r['content_id'],
                $title, $r['rating'], $r['created_at'], $r['updated_at'],
            ]);
        }
    }

    // ── Export: Economy ──────────────────────────────────────────────────

    private static function export_economy($out) {
        global $wpdb;
        $eco = TA_Analytics::economy_stats();

        fputcsv($out, ['=== ECONOMY REPORT ===']);
        fputcsv($out, ['Generated', date('Y-m-d H:i:s')]);
        fputcsv($out, []);

        fputcsv($out, ['Total Flowers Earned', $eco['total_earned']]);
        fputcsv($out, ['Total Flowers Spent',  $eco['total_spent']]);
        fputcsv($out, []);

        fputcsv($out, ['=== TRANSACTIONS BY TYPE ===']);
        fputcsv($out, ['Type', 'Count', 'Total Flowers']);
        foreach ($eco['by_type'] as $row) {
            fputcsv($out, [$row['type'], $row['txn_count'], $row['total_amount']]);
        }

        fputcsv($out, []);
        fputcsv($out, ['=== CONTENT UNLOCKS ===']);
        fputcsv($out, ['Content Type', 'Unlocks', 'Flowers Spent']);
        foreach ($eco['unlocks_by_type'] as $row) {
            fputcsv($out, [$row['content_type'], $row['cnt'], $row['total_cost']]);
        }

        // Wallet per user
        $wallets = $wpdb->get_results(
            "SELECT device_uuid, balance, total_earned, total_spent FROM {$wpdb->prefix}ta_wallet ORDER BY total_earned DESC LIMIT 200",
            ARRAY_A
        ) ?: [];

        fputcsv($out, []);
        fputcsv($out, ['=== WALLET STATS PER USER (Top 200) ===']);
        fputcsv($out, ['Device UUID', 'Current Balance', 'Total Earned', 'Total Spent']);
        foreach ($wallets as $w) {
            fputcsv($out, [$w['device_uuid'], $w['balance'], $w['total_earned'], $w['total_spent']]);
        }
    }

    // ── Export: Retention ────────────────────────────────────────────────

    private static function export_retention($out) {
        fputcsv($out, ['=== RETENTION & CHURN ANALYSIS ===']);
        fputcsv($out, ['Generated', date('Y-m-d H:i:s')]);
        fputcsv($out, []);

        // Segments summary
        $segs = TA_Analytics::user_segments();
        fputcsv($out, ['=== USER SEGMENTS ===']);
        fputcsv($out, ['Segment', 'Count', 'Percentage', 'Definition']);
        $defs = [
            'active'     => 'No activity in last 7 days',
            'dormant'    => 'No activity 7-14 days',
            'at_risk'    => 'No activity 15-30 days',
            'churned'    => 'No activity 31-90 days',
            'lost'       => 'No activity > 90 days',
            'never_used' => 'Registered but never made any API call',
        ];
        foreach ($defs as $key => $def) {
            $s = $segs[$key] ?? ['count' => 0, 'pct' => 0];
            fputcsv($out, [$key, $s['count'], $s['pct'] . '%', $def]);
        }

        // Retention cohorts
        fputcsv($out, []);
        fputcsv($out, ['=== WEEKLY RETENTION COHORTS ===']);
        fputcsv($out, ['Week', 'New Users', 'Day1 Count', 'Day1 %', 'Day7 Count', 'Day7 %', 'Day30 Count', 'Day30 %']);
        foreach (TA_Analytics::retention_cohorts(12) as $c) {
            fputcsv($out, [$c['week'], $c['new_users'], $c['day1_count'], $c['day1_pct'], $c['day7_count'], $c['day7_pct'], $c['day30_count'], $c['day30_pct']]);
        }

        // Churned users list
        fputcsv($out, []);
        fputcsv($out, ['=== CHURNED USERS (31-90 days inactive) ===']);
        fputcsv($out, ['Device UUID', 'Platform', 'Lang', 'Last Active', 'Days Inactive', 'Total Calls', 'Check-ins', 'Balance', 'Registered']);
        foreach (TA_Analytics::churn_list('churned', 200) as $u) {
            fputcsv($out, [$u['device_uuid'], $u['platform'], $u['lang'], $u['last_active_at'], $u['days_inactive'], $u['total_calls'], $u['checkins'], $u['balance'] ?? 0, $u['registered_at']]);
        }

        // Session frequency
        fputcsv($out, []);
        fputcsv($out, ['=== SESSION FREQUENCY (Top 50 Users) ===']);
        fputcsv($out, ['Device UUID', 'Platform', 'Active Days', 'Total Calls', 'Calls/Day', 'Lifespan (days)', 'First Seen', 'Last Seen']);
        foreach (TA_Analytics::session_frequency(50) as $u) {
            fputcsv($out, [$u['device_uuid'], $u['platform'], $u['active_days'], $u['total_calls'], $u['calls_per_day'], $u['lifespan_days'], $u['first_seen'], $u['last_seen']]);
        }
    }

    // ── Export: Full Dump ────────────────────────────────────────────────

    private static function export_full($out, string $since) {
        fputcsv($out, ['=== TOURSAPP FULL ANALYTICS EXPORT ===']);
        fputcsv($out, ['Generated', date('Y-m-d H:i:s'), 'Plugin Version', TA_VERSION]);
        fputcsv($out, ['Export Purpose', 'AI/ML analysis, system optimization, UX improvement']);
        fputcsv($out, []);

        self::export_overview($out);
        fputcsv($out, []);
        self::export_content($out, 'views', '', $since);
        fputcsv($out, []);
        self::export_api($out, $since);
        fputcsv($out, []);
        self::export_users($out);
        fputcsv($out, []);
        self::export_retention($out);
        fputcsv($out, []);
        self::export_feedback($out);
        fputcsv($out, []);
        self::export_economy($out);
    }

    // ── Tab: Retention ────────────────────────────────────────────────────

    private static function tab_retention() {
        $seg_filter = sanitize_text_field($_GET['seg'] ?? '');
        $segments   = TA_Analytics::user_segments();

        $seg_labels = [
            'active'     => ['🟢 Active',      'No activity in < 7 days',    '#d4edda', '#155724'],
            'dormant'    => ['🟡 Dormant',      'No activity 7–14 days',      '#fff3cd', '#856404'],
            'at_risk'    => ['🟠 At Risk',      'No activity 15–30 days',     '#ffe5d0', '#7c4a00'],
            'churned'    => ['🔴 Churned',      'No activity 31–90 days',     '#f8d7da', '#721c24'],
            'lost'       => ['⚫ Lost',          'No activity > 90 days',      '#e2e3e5', '#383d41'],
            'never_used' => ['⚪ Never Used',    'Registered but 0 API calls', '#f8f9fa', '#555'],
        ];

        echo '<div class="ta-stat-grid" style="grid-template-columns:repeat(6,1fr)">';
        foreach ($seg_labels as $key => [$label, $desc, $bg, $color]) {
            $cnt = $segments[$key]['count'] ?? 0;
            $pct = $segments[$key]['pct']   ?? 0;
            $url = add_query_arg(['page' => 'toursapp-analytics', 'tab' => 'retention', 'seg' => $key], admin_url('admin.php'));
            echo '<a href="' . esc_url($url) . '" style="text-decoration:none">
                <div class="ta-stat-box" style="background:' . esc_attr($bg) . ';border-color:' . esc_attr($color) . ';cursor:pointer' . ($seg_filter === $key ? ';outline:3px solid ' . $color : '') . '">
                    <span class="val" style="color:' . esc_attr($color) . ';font-size:24px">' . esc_html($cnt) . '</span>
                    <span class="lbl" style="color:' . esc_attr($color) . '">' . esc_html($label) . '</span>
                    <span style="font-size:11px;color:' . esc_attr($color) . ';opacity:0.8">' . esc_html($pct) . '% &nbsp;·&nbsp; ' . esc_html($desc) . '</span>
                </div></a>';
        }
        echo '</div>';

        // Retention cohorts
        echo '<div class="ta-section"><h3>Weekly Retention Cohorts</h3>';
        echo '<p style="color:#666;font-size:12px;margin-top:-8px">Of users who registered in each week, what % were still active after 1/7/30 days?</p>';
        $cohorts = TA_Analytics::retention_cohorts(8);
        echo '<table class="ta-table"><thead><tr>
            <th>Registration Week</th><th>New Users</th>
            <th>Day 1 Return</th><th>Day 1 %</th>
            <th>Day 7 Return</th><th>Day 7 %</th>
            <th>Day 30 Return</th><th>Day 30 %</th>
        </tr></thead><tbody>';
        foreach ($cohorts as $c) {
            $d1c = $c['day1_pct'] >= 20 ? 'ta-badge-green' : ($c['day1_pct'] >= 10 ? 'ta-badge-orange' : 'ta-badge-red');
            $d7c = $c['day7_pct'] >= 15 ? 'ta-badge-green' : ($c['day7_pct'] >= 5  ? 'ta-badge-orange' : 'ta-badge-red');
            $d30c= $c['day30_pct']>= 10 ? 'ta-badge-green' : ($c['day30_pct']>= 3  ? 'ta-badge-orange' : 'ta-badge-red');
            echo '<tr>
                <td>' . esc_html($c['week']) . '</td>
                <td><strong>' . esc_html($c['new_users']) . '</strong></td>
                <td>' . esc_html($c['day1_count']) . '</td>
                <td><span class="ta-badge ' . $d1c . '">' . esc_html($c['day1_pct']) . '%</span></td>
                <td>' . esc_html($c['day7_count']) . '</td>
                <td><span class="ta-badge ' . $d7c . '">' . esc_html($c['day7_pct']) . '%</span></td>
                <td>' . esc_html($c['day30_count']) . '</td>
                <td><span class="ta-badge ' . $d30c . '">' . esc_html($c['day30_pct']) . '%</span></td>
            </tr>';
        }
        echo '</tbody></table></div>';

        // Segment user list
        if ($seg_filter && isset($seg_labels[$seg_filter])) {
            [$seg_label] = $seg_labels[$seg_filter];
            $users = TA_Analytics::churn_list($seg_filter, 50);
            echo '<div class="ta-section"><h3>Users: ' . esc_html($seg_label) . ' (' . count($users) . ')</h3>';
            echo '<table class="ta-table"><thead><tr><th>UUID</th><th>Platform</th><th>Lang</th><th>Last Active</th><th>Days Inactive</th><th>Total Calls</th><th>Check-ins</th><th>Balance</th><th>Registered</th></tr></thead><tbody>';
            foreach ($users as $u) {
                $days = (int) $u['days_inactive'];
                $cls  = $days > 90 ? 'ta-badge-red' : ($days > 30 ? 'ta-badge-orange' : 'ta-badge-green');
                $uuid_short = substr($u['device_uuid'], 0, 14) . '...';
                echo '<tr>
                    <td><code title="' . esc_attr($u['device_uuid']) . '">' . esc_html($uuid_short) . '</code></td>
                    <td>' . esc_html($u['platform']) . '</td>
                    <td>' . esc_html($u['lang']) . '</td>
                    <td>' . esc_html($u['last_active_at'] ? substr($u['last_active_at'], 0, 10) : '—') . '</td>
                    <td><span class="ta-badge ' . esc_attr($cls) . '">' . esc_html($days > 0 ? $days . 'd' : 'today') . '</span></td>
                    <td>' . esc_html($u['total_calls']) . '</td>
                    <td>' . esc_html($u['checkins']) . '</td>
                    <td>' . esc_html($u['balance'] ?? 0) . ' 🌸</td>
                    <td style="font-size:11px;color:#888">' . esc_html(substr($u['registered_at'] ?? '', 0, 10)) . '</td>
                </tr>';
            }
            echo '</tbody></table></div>';
        }

        // Session frequency
        echo '<div class="ta-section"><h3>Session Frequency — Most Engaged Users</h3>';
        $freq = TA_Analytics::session_frequency(20);
        echo '<table class="ta-table"><thead><tr><th>UUID</th><th>Platform</th><th>Active Days</th><th>Total Calls</th><th>Calls/Day</th><th>Lifespan</th><th>First Seen</th><th>Last Seen</th></tr></thead><tbody>';
        foreach ($freq as $u) {
            $short = substr($u['device_uuid'], 0, 14) . '...';
            echo '<tr>
                <td><code title="' . esc_attr($u['device_uuid']) . '">' . esc_html($short) . '</code></td>
                <td>' . esc_html($u['platform']) . '</td>
                <td><strong>' . esc_html($u['active_days']) . '</strong></td>
                <td>' . esc_html($u['total_calls']) . '</td>
                <td>' . esc_html($u['calls_per_day']) . '</td>
                <td>' . esc_html($u['lifespan_days']) . ' days</td>
                <td style="font-size:11px;color:#888">' . esc_html(substr($u['first_seen'], 0, 10)) . '</td>
                <td style="font-size:11px;color:#888">' . esc_html(substr($u['last_seen'], 0, 10)) . '</td>
            </tr>';
        }
        echo '</tbody></table></div>';
    }

    public static function handle_actions() {
        if (!isset($_POST['ta_analytics_nonce'])) return;
        if (!wp_verify_nonce($_POST['ta_analytics_nonce'], 'ta_analytics_action')) return;
        if (!current_user_can('manage_options')) return;

        $action = sanitize_text_field($_POST['ta_action'] ?? '');
        $cid    = (int) ($_POST['comment_id'] ?? 0);

        if ($cid && in_array($action, ['approve', 'reject', 'delete'], true)) {
            if ($action === 'delete') {
                global $wpdb;
                $wpdb->delete($wpdb->prefix . 'ta_comments', ['id' => $cid]);
            } else {
                TA_Analytics::moderate_comment($cid, $action === 'approve' ? 'approved' : 'rejected');
            }
        }

        wp_redirect(add_query_arg(['page' => 'toursapp-analytics', 'tab' => sanitize_text_field($_POST['current_tab'] ?? 'overview'), 'moderated' => 1], admin_url('admin.php')));
        exit;
    }

    public static function render() {
        if (!current_user_can('manage_options')) return;

        $tab = sanitize_text_field($_GET['tab'] ?? 'overview');
        $uuid_search = sanitize_text_field($_GET['uuid'] ?? '');
        $tabs = [
            'overview'  => '📊 Overview',
            'content'   => '📄 Content',
            'api'       => '⚡ API',
            'users'     => '👤 Users',
            'retention' => '📉 Retention',
            'feedback'  => '💬 Feedback',
            'economy'   => '🌸 Economy',
        ];
        ?>
        <div class="wrap">
            <h1>ToursApp Analytics</h1>

            <?php if (isset($_GET['moderated'])): ?>
            <div class="notice notice-success is-dismissible"><p>Comment moderated.</p></div>
            <?php endif; ?>

            <style>
                .ta-stat-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(160px,1fr)); gap:12px; margin-bottom:24px; }
                .ta-stat-box { background:#fff; border:1px solid #ddd; border-radius:6px; padding:14px 16px; text-align:center; }
                .ta-stat-box .val { font-size:28px; font-weight:700; color:#2271b1; display:block; }
                .ta-stat-box .lbl { font-size:12px; color:#666; margin-top:4px; display:block; }
                .ta-tabs { display:flex; gap:4px; margin-bottom:20px; border-bottom:2px solid #ddd; }
                .ta-tab { padding:8px 16px; text-decoration:none; color:#555; border-radius:4px 4px 0 0; font-size:13px; }
                .ta-tab:hover { background:#f0f6fc; color:#2271b1; }
                .ta-tab.active { background:#2271b1; color:#fff; font-weight:600; }
                .ta-table { width:100%; border-collapse:collapse; font-size:13px; margin-bottom:24px; }
                .ta-table th { background:#2271b1; color:#fff; padding:7px 10px; text-align:left; }
                .ta-table td { padding:6px 10px; border-bottom:1px solid #eee; vertical-align:top; }
                .ta-table tr:hover td { background:#f8f9fa; }
                .ta-section { background:#fff; border:1px solid #ddd; border-radius:6px; padding:16px 20px; margin-bottom:20px; }
                .ta-section h3 { margin-top:0; font-size:15px; color:#1d2327; border-bottom:1px solid #eee; padding-bottom:8px; }
                .ta-badge { display:inline-block; padding:2px 7px; border-radius:10px; font-size:11px; font-weight:600; }
                .ta-badge-green { background:#d4edda; color:#155724; }
                .ta-badge-red { background:#f8d7da; color:#721c24; }
                .ta-badge-orange { background:#fff3cd; color:#856404; }
                .ta-progress { background:#eee; border-radius:10px; height:8px; display:inline-block; width:80px; vertical-align:middle; }
                .ta-progress-fill { background:#2271b1; height:8px; border-radius:10px; }
                .ta-2col { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
                .ta-tbl-wrap { overflow-x:auto; }
                @media(max-width:768px){
                    .ta-tabs { flex-wrap:wrap; }
                    .ta-stat-grid { grid-template-columns:repeat(2,1fr) !important; }
                    .ta-2col { grid-template-columns:1fr; }
                    .ta-section { overflow-x:auto; }
                    .ta-table { min-width:480px; }
                }
            </style>

            <div class="ta-tabs">
                <?php foreach ($tabs as $key => $label): ?>
                    <a href="<?php echo esc_url(add_query_arg(['page' => 'toursapp-analytics', 'tab' => $key], admin_url('admin.php'))); ?>"
                       class="ta-tab <?php echo $tab === $key ? 'active' : ''; ?>">
                        <?php echo esc_html($label); ?>
                    </a>
                <?php endforeach; ?>
            </div>

            <?php
            // Export bar
            $full_url = self::export_nonce_url('full', ['since' => '-30 days']);
            echo '<div style="display:flex;justify-content:flex-end;margin-bottom:12px;gap:8px">';
            echo self::export_button($tab, 'Export This Tab', ['since' => $_GET['since'] ?? '-30 days', 'metric' => $_GET['metric'] ?? 'views', 'ctype' => $_GET['ctype'] ?? '']);
            echo '<button type="button" class="button button-primary" onclick="taDownloadCSV(\'' . esc_js($full_url) . '\')">📦 Export All Data (CSV)</button>';
            echo '</div>';

            switch ($tab) {
                case 'overview': self::tab_overview(); break;
                case 'content':  self::tab_content();  break;
                case 'api':      self::tab_api();       break;
                case 'users':    self::tab_users($uuid_search); break;
                case 'feedback': self::tab_feedback();  break;
                case 'retention': self::tab_retention(); break;
                case 'economy':  self::tab_economy();   break;
            }
            ?>

        <script>
        // Download CSV without navigating away — uses hidden <a> with download attr
        function taDownloadCSV(url) {
            var btn = event && event.target ? event.target : null;
            if (btn) {
                var orig = btn.innerHTML;
                btn.disabled = true;
                btn.innerHTML = '⏳ Preparing…';
                setTimeout(function() { btn.disabled = false; btn.innerHTML = orig; }, 4000);
            }
            var a = document.createElement('a');
            a.href = url;
            a.download = '';          // hint browser to download, not navigate
            a.style.display = 'none';
            document.body.appendChild(a);
            a.click();
            setTimeout(function() { a.remove(); }, 1000);
        }
        </script>

        </div>
        <?php
    }

    // ── Tab: Overview ────────────────────────────────────────────────────

    private static function tab_overview() {
        $ov = TA_Analytics::overview();
        $stats = [
            ['Total Users',     $ov['total_users'],     ''],
            ['Active (7 days)', $ov['active_7d'],       ''],
            ['Active (30 days)',$ov['active_30d'],      ''],
            ['Total API Calls', number_format($ov['total_api_calls']), ''],
            ['Check-ins',       $ov['total_checkins'],  ''],
            ['Comments',        $ov['total_comments'],  ''],
            ['Ratings',         $ov['total_ratings'],   ''],
            ['Avg Rating',      $ov['avg_rating'] . ' ★', ''],
            ['Flowers Earned',  number_format($ov['flowers_earned']), '🌸'],
            ['Flowers Spent',   number_format($ov['flowers_spent']),  '🌸'],
            ['Content Unlocks', $ov['total_unlocks'],   ''],
            ['User Journeys',   $ov['total_journeys'],  ''],
        ];
        echo '<div class="ta-stat-grid">';
        foreach ($stats as [$lbl, $val, $icon]) {
            echo '<div class="ta-stat-box"><span class="val">' . esc_html($icon . $val) . '</span><span class="lbl">' . esc_html($lbl) . '</span></div>';
        }
        echo '</div>';

        // API volume table
        $vol = TA_Analytics::api_volume_by_day(14);
        echo '<div class="ta-section"><h3>API Calls — Last 14 Days</h3>';
        echo '<table class="ta-table"><thead><tr><th>Date</th><th>Calls</th><th>Unique Users</th><th>Avg Response</th><th>Errors</th></tr></thead><tbody>';
        foreach ($vol as $row) {
            $err_cls = $row['errors'] > 0 ? 'ta-badge-red' : '';
            echo '<tr><td>' . esc_html($row['day']) . '</td><td>' . esc_html(number_format($row['calls'])) . '</td><td>' . esc_html($row['unique_users']) . '</td><td>' . esc_html($row['avg_ms']) . 'ms</td><td><span class="ta-badge ' . esc_attr($err_cls) . '">' . esc_html($row['errors']) . '</span></td></tr>';
        }
        echo '</tbody></table></div>';
    }

    // ── Tab: Content ─────────────────────────────────────────────────────

    private static function tab_content() {
        $metric = sanitize_text_field($_GET['metric'] ?? 'views');
        $type   = sanitize_text_field($_GET['ctype'] ?? '');
        $since  = sanitize_text_field($_GET['since'] ?? '-30 days');

        $metrics = ['views' => 'Total Views', 'unique' => 'Unique Users', 'read_time' => 'Avg Read Time', 'completion' => 'Avg Audio Completion'];
        $types   = ['' => 'All Types', 'place' => 'Place', 'story' => 'Story', 'sub_place' => 'Sub-Place', 'sub_item' => 'Sub-Item'];
        $periods = ['-7 days' => 'Last 7 days', '-30 days' => 'Last 30 days', '-90 days' => 'Last 90 days'];
        ?>
        <form method="get" style="margin-bottom:16px">
            <input type="hidden" name="page" value="toursapp-analytics">
            <input type="hidden" name="tab" value="content">
            Metric: <select name="metric"><?php foreach ($metrics as $k => $v): ?><option value="<?php echo esc_attr($k); ?>" <?php selected($metric,$k); ?>><?php echo esc_html($v); ?></option><?php endforeach; ?></select>
            &nbsp; Type: <select name="ctype"><?php foreach ($types as $k => $v): ?><option value="<?php echo esc_attr($k); ?>" <?php selected($type,$k); ?>><?php echo esc_html($v); ?></option><?php endforeach; ?></select>
            &nbsp; Period: <select name="since"><?php foreach ($periods as $k => $v): ?><option value="<?php echo esc_attr($k); ?>" <?php selected($since,$k); ?>><?php echo esc_html($v); ?></option><?php endforeach; ?></select>
            &nbsp; <button type="submit" class="button">Apply</button>
        </form>
        <?php

        $rows = TA_Analytics::top_content($metric, $type, 30, $since);
        echo '<div class="ta-section"><h3>Top Content by ' . esc_html($metrics[$metric] ?? $metric) . '</h3>';
        echo '<table class="ta-table"><thead><tr><th>#</th><th>Content</th><th>Views</th><th>Unique Users</th><th>Article Reads</th><th>Audio Plays</th><th>Completes</th><th>Avg Read (s)</th><th>Avg Completion</th><th>Avg Scroll</th></tr></thead><tbody>';
        foreach ($rows as $i => $row) {
            $title = TA_Analytics::get_content_title($row['content_type'], (int) $row['content_id']);
            $comp_pct = $row['avg_completion_pct'] ? $row['avg_completion_pct'] . '%' : '—';
            echo '<tr>
                <td>' . ($i + 1) . '</td>
                <td><strong>' . esc_html($title) . '</strong><br><span style="color:#888;font-size:11px">' . esc_html($row['content_type']) . ' #' . esc_html($row['content_id']) . '</span></td>
                <td>' . esc_html($row['views']) . '</td>
                <td>' . esc_html($row['unique_users']) . '</td>
                <td>' . esc_html($row['article_reads']) . '</td>
                <td>' . esc_html($row['audio_plays']) . '</td>
                <td>' . esc_html($row['audio_completes']) . '</td>
                <td>' . esc_html($row['avg_read_sec'] ?: '—') . '</td>
                <td>' . esc_html($comp_pct) . '</td>
                <td>' . esc_html($row['avg_scroll_depth'] ? $row['avg_scroll_depth'] . '%' : '—') . '</td>
            </tr>';
        }
        echo '</tbody></table></div>';

        // Top & bottom rated
        echo '<div class="ta-2col">';
        self::render_rating_table('Top Rated', TA_Analytics::top_rated_content(10));
        self::render_rating_table('Needs Improvement (Low Rated)', TA_Analytics::bottom_rated_content(10));
        echo '</div>';
    }

    private static function render_rating_table(string $title, array $rows) {
        echo '<div class="ta-section"><h3>' . esc_html($title) . '</h3>';
        echo '<table class="ta-table"><thead><tr><th>Content</th><th>Avg ★</th><th>Ratings</th></tr></thead><tbody>';
        foreach ($rows as $row) {
            $t = TA_Analytics::get_content_title($row['content_type'], (int) $row['content_id']);
            $cls = $row['avg_rating'] >= 4 ? 'ta-badge-green' : ($row['avg_rating'] < 3 ? 'ta-badge-red' : 'ta-badge-orange');
            echo '<tr><td>' . esc_html($t) . '<br><span style="color:#888;font-size:11px">' . esc_html($row['content_type']) . ' #' . esc_html($row['content_id']) . '</span></td>'
               . '<td><span class="ta-badge ' . esc_attr($cls) . '">' . esc_html($row['avg_rating']) . ' ★</span></td>'
               . '<td>' . esc_html($row['total_ratings']) . '</td></tr>';
        }
        echo '</tbody></table></div>';
    }

    // ── Tab: API ─────────────────────────────────────────────────────────

    private static function tab_api() {
        $rows = TA_Analytics::top_endpoints(30, '-30 days');
        echo '<div class="ta-section"><h3>Most Used Endpoints — Last 30 Days</h3>';
        echo '<table class="ta-table"><thead><tr><th>Method</th><th>Endpoint</th><th>Calls</th><th>Avg (ms)</th><th>Max (ms)</th><th>Errors</th><th>Error %</th></tr></thead><tbody>';
        foreach ($rows as $row) {
            $m_colors = ['GET' => '#0a7a35', 'POST' => '#0073aa', 'PUT' => '#8b6914', 'DELETE' => '#b32d2e'];
            $mc = $m_colors[$row['method']] ?? '#555';
            $err_cls = $row['error_pct'] > 10 ? 'ta-badge-red' : ($row['error_pct'] > 0 ? 'ta-badge-orange' : 'ta-badge-green');
            $slow_cls = $row['avg_ms'] > 1000 ? 'color:#b32d2e;font-weight:bold' : ($row['avg_ms'] > 500 ? 'color:#856404' : '');
            echo '<tr>
                <td><span style="background:' . esc_attr($mc) . ';color:#fff;padding:1px 6px;border-radius:3px;font-size:11px;font-weight:bold">' . esc_html($row['method']) . '</span></td>
                <td><code style="font-size:12px">' . esc_html($row['endpoint']) . '</code></td>
                <td><strong>' . esc_html(number_format($row['total_calls'])) . '</strong></td>
                <td style="' . esc_attr($slow_cls) . '">' . esc_html($row['avg_ms']) . 'ms</td>
                <td>' . esc_html($row['max_ms']) . 'ms</td>
                <td>' . esc_html($row['error_count']) . '</td>
                <td><span class="ta-badge ' . esc_attr($err_cls) . '">' . esc_html($row['error_pct']) . '%</span></td>
            </tr>';
        }
        echo '</tbody></table></div>';

        $errors = TA_Analytics::api_error_breakdown('-7 days');
        if ($errors) {
            echo '<div class="ta-section"><h3>Error Breakdown — Last 7 Days</h3>';
            echo '<table class="ta-table"><thead><tr><th>Method</th><th>Endpoint</th><th>Status</th><th>Count</th></tr></thead><tbody>';
            foreach ($errors as $row) {
                echo '<tr><td>' . esc_html($row['method']) . '</td><td><code>' . esc_html($row['endpoint']) . '</code></td><td><span class="ta-badge ta-badge-red">' . esc_html($row['status_code']) . '</span></td><td>' . esc_html($row['cnt']) . '</td></tr>';
            }
            echo '</tbody></table></div>';
        }
    }

    // ── Tab: Users ────────────────────────────────────────────────────────

    private static function tab_users(string $uuid_search = '') {
        echo '<form method="get" style="margin-bottom:16px"><input type="hidden" name="page" value="toursapp-analytics"><input type="hidden" name="tab" value="users">';
        echo 'Search UUID: <input type="text" name="uuid" value="' . esc_attr($uuid_search) . '" style="width:100%;max-width:320px" placeholder="device-uuid-here">';
        echo ' <button type="submit" class="button button-primary">Search</button></form>';

        if ($uuid_search) {
            $profile = TA_Analytics::get_user_profile($uuid_search);
            if (empty($profile)) {
                echo '<div class="notice notice-error"><p>Device UUID not found.</p></div>';
            } else {
                self::render_user_profile($profile);
            }
            return;
        }

        // Top users table
        $rows = TA_Analytics::top_users(30);
        echo '<div class="ta-section"><h3>Most Active Users</h3>';
        echo '<table class="ta-table"><thead><tr><th>Device UUID</th><th>Platform</th><th>Lang</th><th>API Calls</th><th>Check-ins</th><th>Balance 🌸</th><th>Journeys</th><th>Comments</th><th>Joined</th><th></th></tr></thead><tbody>';
        foreach ($rows as $row) {
            $short_uuid = substr($row['device_uuid'], 0, 16) . '...';
            $profile_url = add_query_arg(['page' => 'toursapp-analytics', 'tab' => 'users', 'uuid' => $row['device_uuid']], admin_url('admin.php'));
            echo '<tr>
                <td><code title="' . esc_attr($row['device_uuid']) . '">' . esc_html($short_uuid) . '</code></td>
                <td>' . esc_html($row['platform']) . '</td>
                <td>' . esc_html($row['lang']) . '</td>
                <td><strong>' . esc_html(number_format($row['api_calls'])) . '</strong></td>
                <td>' . esc_html($row['checkin_count']) . '</td>
                <td>' . esc_html($row['wallet_balance']) . '</td>
                <td>' . esc_html($row['journeys']) . '</td>
                <td>' . esc_html($row['comments']) . '</td>
                <td style="font-size:11px;color:#888">' . esc_html(substr($row['created_at'] ?? '', 0, 10)) . '</td>
                <td><a href="' . esc_url($profile_url) . '" class="button button-small">Profile</a></td>
            </tr>';
        }
        echo '</tbody></table></div>';

        // New users by day
        $new_users = TA_Analytics::new_users_by_day(14);
        echo '<div class="ta-section"><h3>New Registrations — Last 14 Days</h3>';
        echo '<table class="ta-table"><thead><tr><th>Date</th><th>Platform</th><th>New Users</th></tr></thead><tbody>';
        foreach ($new_users as $row) {
            echo '<tr><td>' . esc_html($row['day']) . '</td><td>' . esc_html($row['platform']) . '</td><td>' . esc_html($row['new_users']) . '</td></tr>';
        }
        echo '</tbody></table></div>';
    }

    private static function render_user_profile(array $p) {
        $d = $p['device'];
        $w = $p['wallet'];
        echo '<div class="ta-section">';
        echo '<h3>Profile: <code>' . esc_html($d['device_uuid']) . '</code></h3>';
        echo '<table class="ta-table" style="width:auto"><tbody>';
        echo '<tr><th>Platform</th><td>' . esc_html($d['platform']) . ' ' . esc_html($d['app_version']) . '</td><th>Language</th><td>' . esc_html($d['lang']) . '</td></tr>';
        echo '<tr><th>Joined</th><td>' . esc_html($d['created_at']) . '</td><th>Referral</th><td><code>' . esc_html($d['referral_code']) . '</code></td></tr>';
        if ($w) {
            echo '<tr><th>Balance</th><td><strong>' . esc_html($w['balance']) . ' 🌸</strong></td><th>Earned / Spent</th><td>' . esc_html($w['total_earned']) . ' / ' . esc_html($w['total_spent']) . '</td></tr>';
        }
        echo '</tbody></table></div>';

        if ($p['checkins']) {
            echo '<div class="ta-section"><h3>Check-ins (' . count($p['checkins']) . ')</h3>';
            echo '<table class="ta-table"><thead><tr><th>Place</th><th>Method</th><th>Reward</th><th>Date</th></tr></thead><tbody>';
            foreach ($p['checkins'] as $c) {
                echo '<tr><td>' . esc_html($c['place_name'] ?: '#' . $c['place_id']) . '</td><td>' . esc_html($c['method']) . '</td><td>' . esc_html($c['reward_amount']) . ' 🌸</td><td>' . esc_html(substr($c['created_at'],0,10)) . '</td></tr>';
            }
            echo '</tbody></table></div>';
        }

        if ($p['api_summary']) {
            echo '<div class="ta-section"><h3>Top Endpoints Used</h3>';
            echo '<table class="ta-table"><thead><tr><th>Method</th><th>Endpoint</th><th>Calls</th><th>Avg ms</th></tr></thead><tbody>';
            foreach ($p['api_summary'] as $r) {
                echo '<tr><td>' . esc_html($r['method']) . '</td><td><code>' . esc_html($r['endpoint']) . '</code></td><td>' . esc_html($r['calls']) . '</td><td>' . esc_html($r['avg_ms']) . '</td></tr>';
            }
            echo '</tbody></table></div>';
        }

        if ($p['journeys']) {
            echo '<div class="ta-section"><h3>Custom Journeys</h3>';
            echo '<table class="ta-table"><thead><tr><th>Name</th><th>Status</th><th>Province</th><th>Created</th></tr></thead><tbody>';
            foreach ($p['journeys'] as $j) {
                echo '<tr><td>' . esc_html($j['name']) . '</td><td>' . esc_html($j['status']) . '</td><td>' . ($j['province_id'] ? get_the_title($j['province_id']) : 'Multi') . '</td><td>' . esc_html(substr($j['created_at'],0,10)) . '</td></tr>';
            }
            echo '</tbody></table></div>';
        }

        if ($p['txns']) {
            echo '<div class="ta-section"><h3>Wallet Transactions</h3>';
            echo '<table class="ta-table"><thead><tr><th>Type</th><th>Amount</th><th>Balance After</th><th>Note</th><th>Date</th></tr></thead><tbody>';
            foreach ($p['txns'] as $t) {
                $cls = $t['amount'] > 0 ? 'color:green' : 'color:red';
                echo '<tr><td>' . esc_html($t['type']) . '</td><td style="' . esc_attr($cls) . '">' . ($t['amount'] > 0 ? '+' : '') . esc_html($t['amount']) . '</td><td>' . esc_html($t['balance_after']) . '</td><td>' . esc_html($t['note']) . '</td><td>' . esc_html(substr($t['created_at'],0,10)) . '</td></tr>';
            }
            echo '</tbody></table></div>';
        }
    }

    // ── Tab: Feedback ─────────────────────────────────────────────────────

    private static function tab_feedback() {
        $pending  = TA_Analytics::pending_comments();
        $approved = TA_Analytics::recent_comments(30, 'approved');

        if ($pending) {
            echo '<div class="ta-section" style="border-color:#ffc107"><h3>⚠ Pending Moderation (' . count($pending) . ')</h3>';
            self::render_comment_table($pending, true);
            echo '</div>';
        }

        echo '<div class="ta-section"><h3>Recent Approved Comments</h3>';
        self::render_comment_table($approved, false);
        echo '</div>';
    }

    private static function render_comment_table(array $comments, bool $show_actions) {
        echo '<table class="ta-table"><thead><tr><th>Device</th><th>Content</th><th>Comment</th><th>Date</th>' . ($show_actions ? '<th>Actions</th>' : '') . '</tr></thead><tbody>';
        foreach ($comments as $c) {
            $uuid_short = substr($c['device_uuid'], 0, 12) . '...';
            $content_title = TA_Analytics::get_content_title($c['content_type'], (int) $c['content_id']);
            echo '<tr>
                <td><code title="' . esc_attr($c['device_uuid']) . '">' . esc_html($uuid_short) . '</code></td>
                <td>' . esc_html($content_title) . '<br><span style="font-size:11px;color:#888">' . esc_html($c['content_type']) . ' #' . esc_html($c['content_id']) . '</span></td>
                <td>' . esc_html(mb_substr($c['comment_text'], 0, 120)) . '</td>
                <td style="font-size:11px;color:#888">' . esc_html(substr($c['created_at'], 0, 10)) . '</td>';

            if ($show_actions) {
                echo '<td>
                    <form method="post" style="display:inline">
                        ' . wp_nonce_field('ta_analytics_action', 'ta_analytics_nonce', true, false) . '
                        <input type="hidden" name="comment_id" value="' . esc_attr($c['id']) . '">
                        <input type="hidden" name="current_tab" value="feedback">
                        <button name="ta_action" value="approve" class="button button-small button-primary">✓ Approve</button>
                        <button name="ta_action" value="reject" class="button button-small" style="margin-left:4px">✗ Reject</button>
                        <button name="ta_action" value="delete" class="button button-small" style="margin-left:4px;color:#b32d2e">🗑 Delete</button>
                    </form>
                </td>';
            }
            echo '</tr>';
        }
        echo '</tbody></table>';
    }

    // ── Tab: Economy ─────────────────────────────────────────────────────

    private static function tab_economy() {
        $eco = TA_Analytics::economy_stats();
        echo '<div class="ta-2col">';

        echo '<div class="ta-section"><h3>Transaction Types</h3>';
        echo '<table class="ta-table"><thead><tr><th>Type</th><th>Count</th><th>Total Flowers</th></tr></thead><tbody>';
        foreach ($eco['by_type'] as $row) {
            echo '<tr><td>' . esc_html($row['type']) . '</td><td>' . esc_html($row['txn_count']) . '</td><td>' . esc_html(number_format($row['total_amount'])) . ' 🌸</td></tr>';
        }
        echo '</tbody></table></div>';

        echo '<div class="ta-section"><h3>Content Unlocks</h3>';
        echo '<table class="ta-table"><thead><tr><th>Type</th><th>Unlocks</th><th>Flowers Spent</th></tr></thead><tbody>';
        foreach ($eco['unlocks_by_type'] as $row) {
            echo '<tr><td>' . esc_html($row['content_type']) . '</td><td>' . esc_html($row['cnt']) . '</td><td>' . esc_html(number_format($row['total_cost'])) . ' 🌸</td></tr>';
        }
        echo '</tbody></table>';
        echo '<p style="font-size:13px;color:#666">Total Earned: <strong>' . number_format($eco['total_earned']) . ' 🌸</strong> &nbsp;|&nbsp; Total Spent: <strong>' . number_format($eco['total_spent']) . ' 🌸</strong></p></div>';

        echo '</div>';
    }
}
