<?php
defined('ABSPATH') || exit;

class TA_Data_Archiver {

    const CRON_HOOK  = 'ta_data_archive_run';
    const ARCHIVE_DIR = 'toursapp-archives/';

    const DEFAULTS = [
        'content_events_days' => 90,
        'api_logs_days'       => 30,
        'error_logs_days'     => 90,
        'auto_export'         => 1,
        'keep_files'          => 12,
    ];

    // ── Cron ─────────────────────────────────────────────────────────────

    public static function add_cron_interval(array $schedules): array {
        $schedules['ta_daily_2am'] = [
            'interval' => DAY_IN_SECONDS,
            'display'  => 'Daily at ~2 AM (ToursApp Archive)',
        ];
        return $schedules;
    }

    public static function schedule() {
        if (!wp_next_scheduled(self::CRON_HOOK)) {
            // Schedule at next 2 AM
            $next_2am = mktime(2, 0, 0);
            if ($next_2am < time()) $next_2am += DAY_IN_SECONDS;
            wp_schedule_event($next_2am, 'ta_daily_2am', self::CRON_HOOK);
        }
    }

    public static function unschedule() {
        $ts = wp_next_scheduled(self::CRON_HOOK);
        if ($ts) wp_unschedule_event($ts, self::CRON_HOOK);
    }

    // ── Main entry point (called by cron) ────────────────────────────────

    public static function run(): array {
        $log = [];

        try {
            self::ensure_archive_dir();

            // Step 1: Aggregate content events into daily stats BEFORE purging
            $agg = self::aggregate_content_events();
            $log[] = "Aggregated {$agg} rows into ta_content_stats_daily.";

            // Step 2: Export old raw data to CSV (if auto-export enabled)
            if (self::get('auto_export')) {
                $exports = self::export_old_data();
                foreach ($exports as $msg) $log[] = $msg;
            }

            // Step 3: Purge old raw records from DB
            $purged = self::purge_old_records();
            foreach ($purged as $msg) $log[] = $msg;

            // Step 4: Clean up excess archive files
            $cleaned = self::cleanup_archive_files();
            $log[] = "Cleaned up {$cleaned} old archive file(s).";

            // Save last run timestamp and log
            update_option('ta_archive_last_run', current_time('mysql'));
            update_option('ta_archive_last_log', $log);

        } catch (Exception $e) {
            $log[] = 'ERROR: ' . $e->getMessage();
            update_option('ta_archive_last_log', $log);
        }

        return $log;
    }

    // ── Step 1: Aggregate ─────────────────────────────────────────────────

    public static function aggregate_content_events(): int {
        global $wpdb;
        $p       = $wpdb->prefix;
        $cutoff  = date('Y-m-d H:i:s', strtotime('-' . (int) self::get('content_events_days') . ' days'));

        $wpdb->suppress_errors(true);

        $wpdb->query($wpdb->prepare("
            INSERT INTO {$p}ta_content_stats_daily
                (date, content_type, content_id, event_type,
                 event_count, unique_users, avg_duration, avg_scroll, avg_completion)
            SELECT
                DATE(created_at),
                content_type,
                content_id,
                event_type,
                COUNT(*),
                COUNT(DISTINCT device_uuid),
                COALESCE(AVG(NULLIF(duration_sec, 0)), 0),
                COALESCE(AVG(NULLIF(scroll_depth, 0)), 0),
                COALESCE(AVG(NULLIF(completion_pct, 0)), 0)
            FROM {$p}ta_content_events
            WHERE created_at < %s
            GROUP BY DATE(created_at), content_type, content_id, event_type
            ON DUPLICATE KEY UPDATE
                event_count    = event_count + VALUES(event_count),
                unique_users   = GREATEST(unique_users, VALUES(unique_users)),
                avg_duration   = (avg_duration + VALUES(avg_duration)) / 2,
                avg_scroll     = (avg_scroll + VALUES(avg_scroll)) / 2,
                avg_completion = (avg_completion + VALUES(avg_completion)) / 2
        ", $cutoff));

        return (int) $wpdb->rows_affected;
    }

    // ── Step 2: Export to CSV ─────────────────────────────────────────────

    public static function export_old_data(): array {
        $log     = [];
        $dir     = self::archive_dir_path();
        $month   = date('Y-m');

        $exports = [
            'events'  => [
                'table'   => 'ta_content_events',
                'cutoff'  => self::get('content_events_days'),
                'columns' => ['id','device_uuid','content_type','content_id','event_type','duration_sec','scroll_depth','completion_pct','extra','created_at'],
            ],
            'api'     => [
                'table'   => 'ta_api_logs',
                'cutoff'  => self::get('api_logs_days'),
                'columns' => ['id','device_uuid','endpoint','method','status_code','response_ms','ip_address','created_at'],
            ],
            'errors'  => [
                'table'   => 'ta_error_logs',
                'cutoff'  => self::get('error_logs_days'),
                'columns' => ['id','log_id','device_uuid','endpoint','method','status_code','error_code','error_message','ip_address','created_at'],
            ],
        ];

        foreach ($exports as $key => $cfg) {
            $filename = "ta-{$key}-{$month}.csv";
            $filepath = $dir . $filename;

            // Skip if already exported this month
            if (file_exists($filepath)) continue;

            $count = self::export_table_to_csv(
                $cfg['table'],
                $cfg['columns'],
                $cfg['cutoff'],
                $filepath
            );

            if ($count !== false) {
                $log[] = "Exported {$count} rows from {$cfg['table']} → {$filename}.";
            } else {
                $log[] = "Warning: could not export {$cfg['table']}.";
            }
        }

        return $log;
    }

    private static function export_table_to_csv(string $table, array $columns, int $days, string $filepath) {
        global $wpdb;
        $cutoff = date('Y-m-d H:i:s', strtotime("-{$days} days"));
        $cols   = implode(', ', array_map(function ($c) { return "`{$c}`"; }, $columns));

        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT {$cols} FROM {$wpdb->prefix}{$table} WHERE created_at < %s ORDER BY created_at ASC",
            $cutoff
        ), ARRAY_A);

        if ($rows === false || empty($rows)) return 0;

        $fh = fopen($filepath, 'w');
        if (!$fh) return false;

        // UTF-8 BOM for Excel
        fwrite($fh, "\xEF\xBB\xBF");
        fputcsv($fh, $columns);
        foreach ($rows as $row) {
            fputcsv($fh, $row);
        }
        fclose($fh);

        return count($rows);
    }

    // ── Step 3: Purge ─────────────────────────────────────────────────────

    public static function purge_old_records(): array {
        global $wpdb;
        $log = [];

        $tables = [
            'ta_content_events' => (int) self::get('content_events_days'),
            'ta_api_logs'       => (int) self::get('api_logs_days'),
            'ta_error_logs'     => (int) self::get('error_logs_days'),
        ];

        foreach ($tables as $table => $days) {
            $cutoff = date('Y-m-d H:i:s', strtotime("-{$days} days"));
            $wpdb->query($wpdb->prepare(
                "DELETE FROM {$wpdb->prefix}{$table} WHERE created_at < %s",
                $cutoff
            ));
            $deleted = $wpdb->rows_affected;
            if ($deleted > 0) {
                $log[] = "Purged {$deleted} rows from {$table} (older than {$days} days).";
            }
        }

        return $log;
    }

    // ── Step 4: Cleanup archive files ────────────────────────────────────

    public static function cleanup_archive_files(): int {
        $dir   = self::archive_dir_path();
        $keep  = max(1, (int) self::get('keep_files'));
        $files = glob($dir . 'ta-*.csv');
        if (!$files) return 0;

        // Group by prefix type to keep $keep sets (not $keep files)
        $prefixes = ['ta-events-', 'ta-api-', 'ta-errors-'];
        $deleted  = 0;

        foreach ($prefixes as $prefix) {
            $typed = array_filter($files, function ($f) use ($prefix) {
                return strpos(basename($f), $prefix) === 0;
            });
            sort($typed); // oldest first
            $excess = array_slice($typed, 0, max(0, count($typed) - $keep));
            foreach ($excess as $f) {
                if (@unlink($f)) $deleted++;
            }
        }

        return $deleted;
    }

    // ── Dry run ───────────────────────────────────────────────────────────

    public static function dry_run(): array {
        global $wpdb;
        $p   = $wpdb->prefix;
        $out = [];

        $tables = [
            'ta_content_events' => self::get('content_events_days'),
            'ta_api_logs'       => self::get('api_logs_days'),
            'ta_error_logs'     => self::get('error_logs_days'),
        ];

        foreach ($tables as $table => $days) {
            $cutoff = date('Y-m-d H:i:s', strtotime("-{$days} days"));
            $count  = (int) $wpdb->get_var($wpdb->prepare(
                "SELECT COUNT(*) FROM {$p}{$table} WHERE created_at < %s", $cutoff
            ));
            $total  = (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}{$table}");
            $out[]  = [
                'table'        => $table,
                'total_rows'   => $total,
                'would_purge'  => $count,
                'would_keep'   => $total - $count,
                'retention_days' => $days,
                'cutoff_date'  => substr($cutoff, 0, 10),
            ];
        }

        // Aggregate preview
        $agg_cutoff = date('Y-m-d H:i:s', strtotime('-' . (int) self::get('content_events_days') . ' days'));
        $agg_rows   = (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$p}ta_content_events WHERE created_at < %s", $agg_cutoff
        ));
        $out[] = ['aggregate_preview' => "{$agg_rows} content_events rows would be aggregated into ta_content_stats_daily."];

        return $out;
    }

    // ── Stats for admin page ──────────────────────────────────────────────

    public static function get_stats(): array {
        global $wpdb;
        $p = $wpdb->prefix;

        $tables = [
            'ta_content_events',
            'ta_api_logs',
            'ta_error_logs',
            'ta_content_stats_daily',
        ];

        $stats = [];
        foreach ($tables as $t) {
            $count  = (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}{$t}");
            $oldest = $wpdb->get_var("SELECT MIN(created_at) FROM {$p}{$t}");
            if (!$oldest && $t === 'ta_content_stats_daily') {
                $oldest = $wpdb->get_var("SELECT MIN(date) FROM {$p}{$t}");
            }
            $stats[$t] = [
                'rows'   => $count,
                'oldest' => $oldest ? substr($oldest, 0, 10) : '—',
            ];
        }

        // Archive files
        $dir        = self::archive_dir_path();
        $files      = glob($dir . 'ta-*.csv') ?: [];
        $total_size = array_sum(array_map('filesize', $files));

        $stats['archives'] = [
            'file_count' => count($files),
            'total_size' => self::format_bytes($total_size),
            'files'      => array_map(function ($f) {
                return [
                    'name'     => basename($f),
                    'size'     => self::format_bytes(filesize($f)),
                    'size_raw' => filesize($f),
                    'date'     => date('Y-m-d H:i', filemtime($f)),
                ];
            }, $files),
        ];

        $stats['last_run'] = get_option('ta_archive_last_run', 'Never');
        $stats['last_log'] = get_option('ta_archive_last_log', []);

        $next = wp_next_scheduled(self::CRON_HOOK);
        $stats['next_run'] = $next ? human_time_diff($next) . ' (' . date('H:i', $next) . ')' : 'Not scheduled';

        return $stats;
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    public static function get(string $key) {
        return get_option('ta_archive_' . $key, self::DEFAULTS[$key] ?? '');
    }

    public static function save_settings(array $data) {
        foreach (self::DEFAULTS as $key => $default) {
            if (isset($data[$key])) {
                update_option('ta_archive_' . $key, $data[$key]);
            }
        }
    }

    private static function archive_dir_path(): string {
        $upload = wp_upload_dir();
        return trailingslashit($upload['basedir']) . self::ARCHIVE_DIR;
    }

    public static function archive_dir_url(): string {
        $upload = wp_upload_dir();
        return trailingslashit($upload['baseurl']) . self::ARCHIVE_DIR;
    }

    public static function ensure_archive_dir() {
        $dir = self::archive_dir_path();
        if (!is_dir($dir)) {
            wp_mkdir_p($dir);
        }
        // Block direct HTTP access
        $htaccess = $dir . '.htaccess';
        if (!file_exists($htaccess)) {
            file_put_contents($htaccess, "Order deny,allow\nDeny from all\n");
        }
        $index = $dir . 'index.php';
        if (!file_exists($index)) {
            file_put_contents($index, "<?php // Silence is golden.\n");
        }
    }

    public static function format_bytes(int $bytes): string {
        if ($bytes >= 1048576) return round($bytes / 1048576, 1) . ' MB';
        if ($bytes >= 1024)    return round($bytes / 1024, 1) . ' KB';
        return $bytes . ' B';
    }
}
