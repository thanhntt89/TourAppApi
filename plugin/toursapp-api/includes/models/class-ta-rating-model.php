<?php
defined('ABSPATH') || exit;

class TA_Rating_Model {

    private static $table = 'ta_ratings';

    public static function upsert(string $uuid, string $content_type, int $content_id, int $rating) {
        global $wpdb;
        $table = $wpdb->prefix . self::$table;

        $existing = $wpdb->get_var($wpdb->prepare(
            "SELECT id FROM {$table} WHERE device_uuid = %s AND content_type = %s AND content_id = %d",
            $uuid, $content_type, $content_id
        ));

        if ($existing) {
            $wpdb->update($table, ['rating' => $rating], [
                'device_uuid'  => $uuid,
                'content_type' => $content_type,
                'content_id'   => $content_id,
            ]);
        } else {
            $wpdb->insert($table, [
                'device_uuid'  => $uuid,
                'content_type' => $content_type,
                'content_id'   => $content_id,
                'rating'       => $rating,
            ]);
        }
    }

    public static function get_summary(string $content_type, int $content_id): array {
        global $wpdb;
        $table = $wpdb->prefix . self::$table;

        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT rating, COUNT(*) AS cnt FROM {$table}
             WHERE content_type = %s AND content_id = %d
             GROUP BY rating",
            $content_type, $content_id
        ), ARRAY_A);

        $dist  = [1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0];
        $total = 0;
        $sum   = 0;
        foreach ($rows as $r) {
            $star         = (int) $r['rating'];
            $cnt          = (int) $r['cnt'];
            $dist[$star]  = $cnt;
            $total       += $cnt;
            $sum         += $star * $cnt;
        }

        return [
            'average'      => $total > 0 ? round($sum / $total, 1) : 0,
            'total'        => $total,
            'distribution' => $dist,
        ];
    }

    public static function get_user_rating(string $uuid, string $content_type, int $content_id) {
        global $wpdb;
        $val = $wpdb->get_var($wpdb->prepare(
            "SELECT rating FROM {$wpdb->prefix}" . self::$table .
            " WHERE device_uuid = %s AND content_type = %s AND content_id = %d",
            $uuid, $content_type, $content_id
        ));
        return $val !== null ? (int) $val : null;
    }

    public static function are_ratings_allowed(string $content_type, int $content_id): bool {
        $field_map = [
            'place'     => 'place_allow_ratings',
            'story'     => 'story_allow_ratings',
            'sub_place' => 'sub_place_allow_ratings',
            'sub_item'  => 'sub_item_allow_ratings',
        ];
        $field = $field_map[$content_type] ?? null;
        if (!$field) return false;
        $val = get_field($field, $content_id);
        return $val === false ? true : (bool) $val;
    }
}
