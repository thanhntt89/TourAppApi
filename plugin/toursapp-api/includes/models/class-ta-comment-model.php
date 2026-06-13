<?php
defined('ABSPATH') || exit;

class TA_Comment_Model {

    private static $table = 'ta_comments';

    public static function create(string $uuid, string $content_type, int $content_id, string $text, int $photo_id = 0): int {
        global $wpdb;
        $wpdb->insert($wpdb->prefix . self::$table, [
            'device_uuid'  => $uuid,
            'content_type' => $content_type,
            'content_id'   => $content_id,
            'comment_text' => $text,
            'photo_id'     => $photo_id,
            'status'       => 'pending', // Admin must approve before public display
        ]);
        return (int) $wpdb->insert_id;
    }

    public static function update(int $id, string $text): bool {
        global $wpdb;
        return (bool) $wpdb->update(
            $wpdb->prefix . self::$table,
            ['comment_text' => $text],
            ['id' => $id]
        );
    }

    public static function delete(int $id): bool {
        global $wpdb;
        return (bool) $wpdb->delete($wpdb->prefix . self::$table, ['id' => $id]);
    }

    public static function get_by_id(int $id) {
        global $wpdb;
        return $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}" . self::$table . " WHERE id = %d",
            $id
        ), ARRAY_A);
    }

    public static function get_comments(string $content_type, int $content_id, array $args = []): array {
        global $wpdb;
        $table    = $wpdb->prefix . self::$table;
        $page     = max(1, (int) ($args['page'] ?? 1));
        $per_page = min((int) ($args['per_page'] ?? 20), 100);
        $sort     = ($args['sort'] ?? 'newest') === 'oldest' ? 'ASC' : 'DESC';
        $offset   = ($page - 1) * $per_page;

        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM {$table}
             WHERE content_type = %s AND content_id = %d AND status = 'approved'
             ORDER BY created_at {$sort}
             LIMIT %d OFFSET %d",
            $content_type, $content_id, $per_page, $offset
        ), ARRAY_A);

        return array_map([self::class, 'format_row'], $rows);
    }

    public static function count(string $content_type, int $content_id): int {
        global $wpdb;
        return (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$wpdb->prefix}" . self::$table .
            " WHERE content_type = %s AND content_id = %d AND status = 'approved'",
            $content_type, $content_id
        ));
    }

    public static function count_today(string $uuid): int {
        global $wpdb;
        return (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$wpdb->prefix}" . self::$table .
            " WHERE device_uuid = %s AND DATE(created_at) = CURDATE()",
            $uuid
        ));
    }

    public static function are_comments_allowed(string $content_type, int $content_id): bool {
        $field_map = [
            'place'     => 'place_allow_comments',
            'story'     => 'story_allow_comments',
            'sub_place' => 'sub_place_allow_comments',
            'sub_item'  => 'sub_item_allow_comments',
        ];
        $field = $field_map[$content_type] ?? null;
        if (!$field) return false;
        $val = get_field($field, $content_id);
        return $val === false ? true : (bool) $val;
    }

    private static function format_row(array $row): array {
        $photo = null;
        if (!empty($row['photo_id'])) {
            $photo = TA_Localize::format_image((int) $row['photo_id']);
        }
        return [
            'id'           => (int) $row['id'],
            'device_uuid'  => $row['device_uuid'],
            'comment_text' => $row['comment_text'],
            'photo'        => $photo,
            'created_at'   => $row['created_at'],
        ];
    }
}
