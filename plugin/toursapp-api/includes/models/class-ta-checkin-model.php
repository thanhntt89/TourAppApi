<?php
defined('ABSPATH') || exit;

class TA_Checkin_Model {

    public static function has_checked_in(string $uuid, int $place_id): bool {
        global $wpdb;
        return (bool)$wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$wpdb->prefix}ta_checkins WHERE device_uuid = %s AND place_id = %d",
            $uuid, $place_id
        ));
    }

    public static function get_checkin(string $uuid, int $place_id): ?array {
        global $wpdb;
        $row = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}ta_checkins WHERE device_uuid = %s AND place_id = %d",
            $uuid, $place_id
        ), ARRAY_A);
        return $row ?: null;
    }

    public static function create(string $uuid, int $place_id, string $method, ?float $lat, ?float $lng, int $reward): int {
        global $wpdb;
        $wpdb->insert($wpdb->prefix . 'ta_checkins', [
            'device_uuid'  => $uuid,
            'place_id'     => $place_id,
            'method'       => $method,
            'latitude'     => $lat,
            'longitude'    => $lng,
            'reward_amount' => $reward,
        ]);
        return (int)$wpdb->insert_id;
    }

    public static function get_history(string $uuid, array $args = []): array {
        global $wpdb;
        $table = $wpdb->prefix . 'ta_checkins';

        $where = ["c.device_uuid = %s"];
        $params = [$uuid];

        if (!empty($args['province_id'])) {
            $where[] = "pm_province.meta_value = %d";
            $params[] = (int)$args['province_id'];
        }

        $where_sql = implode(' AND ', $where);
        $page     = max(1, (int)($args['page'] ?? 1));
        $per_page = min(100, max(1, (int)($args['per_page'] ?? 20)));
        $offset   = ($page - 1) * $per_page;

        $total = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*)
             FROM $table c
             LEFT JOIN {$wpdb->postmeta} pm_province
                ON c.place_id = pm_province.post_id AND pm_province.meta_key = 'place_location'
             WHERE $where_sql",
            ...$params
        ));

        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT c.*
             FROM $table c
             LEFT JOIN {$wpdb->postmeta} pm_province
                ON c.place_id = pm_province.post_id AND pm_province.meta_key = 'place_location'
             WHERE $where_sql
             ORDER BY c.created_at DESC
             LIMIT %d OFFSET %d",
            ...array_merge($params, [$per_page, $offset])
        ), ARRAY_A);

        return [
            'items' => $rows ?: [],
            'total' => (int)$total,
            'page'  => $page,
            'per_page' => $per_page,
        ];
    }

    public static function get_stats(string $uuid): array {
        global $wpdb;
        $prefix = $wpdb->prefix;

        $checkins = (int)$wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$prefix}ta_checkins WHERE device_uuid = %s", $uuid
        ));

        $flowers = (int)$wpdb->get_var($wpdb->prepare(
            "SELECT COALESCE(SUM(reward_amount), 0) FROM {$prefix}ta_checkins WHERE device_uuid = %s", $uuid
        ));

        $audio = (int)$wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$prefix}ta_visit_history WHERE device_uuid = %s AND visit_type = 'audio_play'", $uuid
        ));

        $articles = (int)$wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$prefix}ta_visit_history WHERE device_uuid = %s AND visit_type = 'article_read'", $uuid
        ));

        return [
            'total_checkins'       => $checkins,
            'total_places_visited' => $checkins,
            'total_audio_played'   => $audio,
            'total_articles_read'  => $articles,
            'total_flowers_earned' => $flowers,
        ];
    }

    public static function is_content_unlocked(string $uuid, string $type, int $content_id): bool {
        global $wpdb;
        return (bool)$wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$wpdb->prefix}ta_unlocked_content WHERE device_uuid = %s AND content_type = %s AND content_id = %d",
            $uuid, $type, $content_id
        ));
    }

    public static function unlock_content(string $uuid, string $type, int $content_id, int $cost): void {
        global $wpdb;
        $wpdb->insert($wpdb->prefix . 'ta_unlocked_content', [
            'device_uuid'  => $uuid,
            'content_type' => $type,
            'content_id'   => $content_id,
            'cost'         => $cost,
        ]);
    }
}
