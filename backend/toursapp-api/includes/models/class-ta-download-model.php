<?php
defined('ABSPATH') || exit;

class TA_Download_Model {

    private static $table = 'ta_downloads';

    public static function start(string $uuid, int $province_id, string $type = 'full', string $lang = 'vi'): int {
        global $wpdb;
        $wpdb->insert($wpdb->prefix . self::$table, [
            'device_uuid'   => $uuid,
            'province_id'   => $province_id,
            'download_type' => $type,
            'lang'          => $lang,
            'status'        => 'started',
        ]);
        return (int) $wpdb->insert_id;
    }

    public static function complete(int $id, array $data): bool {
        global $wpdb;
        return (bool) $wpdb->update(
            $wpdb->prefix . self::$table,
            [
                'status'        => $data['status'] ?? 'completed',
                'file_count'    => (int) ($data['file_count'] ?? 0),
                'total_size_mb' => (float) ($data['total_size_mb'] ?? 0),
                'completed_at'  => current_time('mysql'),
            ],
            ['id' => $id]
        );
    }

    public static function get_user_downloads(string $uuid): array {
        global $wpdb;
        return $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}" . self::$table .
            " WHERE device_uuid = %s ORDER BY started_at DESC",
            $uuid
        ), ARRAY_A) ?: [];
    }
}
