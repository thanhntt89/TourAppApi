<?php
defined('ABSPATH') || exit;

class TA_Engagement_Model {

    private static $table = 'ta_content_events';

    private static $allowed_types   = ['place', 'story', 'sub_place', 'sub_item'];
    private static $allowed_events  = ['page_view', 'article_read', 'audio_play', 'audio_complete', 'share'];

    public static function record(string $uuid, string $content_type, int $content_id, string $event_type, array $data = []): int {
        global $wpdb;

        $wpdb->insert(
            $wpdb->prefix . self::$table,
            [
                'device_uuid'    => $uuid,
                'content_type'   => $content_type,
                'content_id'     => $content_id,
                'event_type'     => $event_type,
                'duration_sec'   => isset($data['duration_sec'])   ? (int) $data['duration_sec']   : 0,
                'scroll_depth'   => isset($data['scroll_depth'])   ? (int) $data['scroll_depth']   : 0,
                'completion_pct' => isset($data['completion_pct']) ? (int) $data['completion_pct'] : 0,
                'extra'          => isset($data['extra'])          ? substr((string) $data['extra'], 0, 500) : null,
            ]
        );

        return (int) $wpdb->insert_id;
    }

    public static function get_content_stats(string $content_type, int $content_id, $since = null): array {
        global $wpdb;
        $table = $wpdb->prefix . self::$table;

        $where = $wpdb->prepare('WHERE content_type = %s AND content_id = %d', $content_type, $content_id);
        if ($since) {
            $where .= $wpdb->prepare(' AND created_at >= %s', $since);
        }

        $rows = $wpdb->get_results("
            SELECT
                event_type,
                COUNT(*) AS total,
                COUNT(DISTINCT device_uuid) AS unique_devices,
                AVG(duration_sec) AS avg_duration,
                AVG(scroll_depth) AS avg_scroll,
                AVG(completion_pct) AS avg_completion
            FROM {$table}
            {$where}
            GROUP BY event_type
        ", ARRAY_A);

        $stats = [
            'total_events'    => 0,
            'unique_devices'  => 0,
            'by_event'        => [],
        ];

        $device_sets = [];
        foreach ($rows as $row) {
            $stats['total_events']         += (int) $row['total'];
            $device_sets[$row['event_type']] = (int) $row['unique_devices'];
            $stats['by_event'][$row['event_type']] = [
                'total'          => (int) $row['total'],
                'unique_devices' => (int) $row['unique_devices'],
                'avg_duration'   => round((float) $row['avg_duration'], 1),
                'avg_scroll'     => round((float) $row['avg_scroll'], 1),
                'avg_completion' => round((float) $row['avg_completion'], 1),
            ];
        }

        $stats['unique_devices'] = (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(DISTINCT device_uuid) FROM {$table} WHERE content_type = %s AND content_id = %d",
            $content_type, $content_id
        ));

        return $stats;
    }

    public static function get_top_content(array $args = []): array {
        global $wpdb;
        $table = $wpdb->prefix . self::$table;

        $content_type = $args['content_type'] ?? null;
        $event_filter = $args['event_type']   ?? null;
        $metric       = $args['metric']       ?? 'views';
        $order        = strtoupper($args['order'] ?? 'DESC') === 'ASC' ? 'ASC' : 'DESC';
        $limit        = min((int) ($args['limit'] ?? 10), 100);
        $since        = $args['since']        ?? null;

        $where = 'WHERE 1=1';
        if ($content_type) {
            $where .= $wpdb->prepare(' AND content_type = %s', $content_type);
        }
        if ($event_filter) {
            $where .= $wpdb->prepare(' AND event_type = %s', $event_filter);
        } else {
            // Default metric mapping
            switch ($metric) {
                case 'read_time':
                    $where .= " AND event_type = 'article_read'"; break;
                case 'completion':
                    $where .= " AND event_type IN ('audio_play','audio_complete')"; break;
                case 'shares':
                    $where .= " AND event_type = 'share'"; break;
            }
        }
        if ($since) {
            $where .= $wpdb->prepare(' AND created_at >= %s', $since);
        }

        if ($metric === 'read_time') {
            $order_col = 'AVG(duration_sec)';
        } elseif ($metric === 'completion') {
            $order_col = 'AVG(completion_pct)';
        } elseif ($metric === 'unique') {
            $order_col = 'COUNT(DISTINCT device_uuid)';
        } else {
            $order_col = 'COUNT(*)';
        }

        return $wpdb->get_results("
            SELECT
                content_type,
                content_id,
                COUNT(*) AS total_events,
                COUNT(DISTINCT device_uuid) AS unique_devices,
                AVG(duration_sec) AS avg_duration,
                AVG(completion_pct) AS avg_completion
            FROM {$table}
            {$where}
            GROUP BY content_type, content_id
            ORDER BY {$order_col} {$order}
            LIMIT {$limit}
        ", ARRAY_A);
    }

    public static function is_tracking_enabled(string $content_type, int $content_id): bool {
        $field_map = [
            'place'     => 'place_enable_tracking',
            'story'     => 'story_enable_tracking',
            'sub_place' => 'sub_place_enable_tracking',
            'sub_item'  => 'sub_item_enable_tracking',
        ];
        $field = $field_map[$content_type] ?? null;
        if (!$field) return false;
        // Default true if not set.
        $val = get_field($field, $content_id);
        return ($val === false || $val === null) ? true : (bool) $val;
    }

    public static function allowed_types(): array  { return self::$allowed_types; }
    public static function allowed_events(): array { return self::$allowed_events; }
}
