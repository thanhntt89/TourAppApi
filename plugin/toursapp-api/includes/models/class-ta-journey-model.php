<?php
defined('ABSPATH') || exit;

class TA_Journey_Model {

    public static function get_user_journeys(string $uuid, array $args = []): array {
        global $wpdb;
        $table = $wpdb->prefix . 'ta_user_journeys';

        $where  = ["device_uuid = %s"];
        $params = [$uuid];

        if (!empty($args['province_id'])) {
            $where[]  = "province_id = %d";
            $params[] = (int)$args['province_id'];
        }
        if (!empty($args['status'])) {
            $where[]  = "status = %s";
            $params[] = sanitize_text_field($args['status']);
        }

        $where_sql = implode(' AND ', $where);
        $rows = $wpdb->get_results(
            $wpdb->prepare("SELECT * FROM $table WHERE $where_sql ORDER BY updated_at DESC", ...$params),
            ARRAY_A
        );

        return $rows ?: [];
    }

    public static function get_by_id(int $id, string $uuid): ?array {
        global $wpdb;
        $row = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}ta_user_journeys WHERE id = %d AND device_uuid = %s",
            $id, $uuid
        ), ARRAY_A);
        return $row ?: null;
    }

    public static function create(string $uuid, array $data): int {
        global $wpdb;
        $wpdb->insert($wpdb->prefix . 'ta_user_journeys', [
            'device_uuid'      => $uuid,
            'province_id'      => (int)$data['province_id'],
            'name'             => sanitize_text_field($data['name']),
            'description'      => sanitize_textarea_field($data['description'] ?? ''),
            'source_journey_id' => !empty($data['source_journey_id']) ? (int)$data['source_journey_id'] : null,
            'status'           => 'planning',
        ]);

        $journey_id = (int)$wpdb->insert_id;

        if (!empty($data['stops']) && is_array($data['stops'])) {
            self::save_stops($journey_id, $data['stops']);
        }

        return $journey_id;
    }

    public static function update(int $id, array $data): bool {
        global $wpdb;
        $update = [];

        if (isset($data['name'])) {
            $update['name'] = sanitize_text_field($data['name']);
        }
        if (isset($data['description'])) {
            $update['description'] = sanitize_textarea_field($data['description']);
        }
        if (isset($data['status'])) {
            $update['status'] = sanitize_text_field($data['status']);
            if ($data['status'] === 'active' && empty($data['started_at'])) {
                $update['started_at'] = current_time('mysql');
            }
            if ($data['status'] === 'completed') {
                $update['completed_at'] = current_time('mysql');
            }
        }

        if (!empty($update)) {
            $wpdb->update($wpdb->prefix . 'ta_user_journeys', $update, ['id' => $id]);
        }

        if (isset($data['stops']) && is_array($data['stops'])) {
            $wpdb->delete($wpdb->prefix . 'ta_user_journey_stops', ['journey_id' => $id]);
            self::save_stops($id, $data['stops']);
        }

        return true;
    }

    public static function delete(int $id): bool {
        global $wpdb;
        $wpdb->delete($wpdb->prefix . 'ta_user_journey_stops', ['journey_id' => $id]);
        $wpdb->delete($wpdb->prefix . 'ta_user_journeys', ['id' => $id]);
        return true;
    }

    public static function get_stops(int $journey_id): array {
        global $wpdb;
        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}ta_user_journey_stops WHERE journey_id = %d ORDER BY stop_order ASC",
            $journey_id
        ), ARRAY_A);
        return $rows ?: [];
    }

    private static function save_stops(int $journey_id, array $stops): void {
        global $wpdb;
        foreach ($stops as $stop) {
            $wpdb->insert($wpdb->prefix . 'ta_user_journey_stops', [
                'journey_id' => $journey_id,
                'place_id'   => (int)$stop['place_id'],
                'stop_order' => (int)($stop['stop_order'] ?? 0),
                'day_number' => (int)($stop['day_number'] ?? 1),
                'note'       => sanitize_textarea_field($stop['note'] ?? ''),
                'status'     => sanitize_text_field($stop['status'] ?? 'planned'),
            ]);
        }
    }

    public static function get_progress(int $journey_id): array {
        global $wpdb;
        $table = $wpdb->prefix . 'ta_user_journey_stops';

        $total   = (int)$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) FROM $table WHERE journey_id = %d", $journey_id));
        $visited = (int)$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) FROM $table WHERE journey_id = %d AND status = 'visited'", $journey_id));

        return [
            'total_places'    => $total,
            'visited_count'   => $visited,
            'progress_percent' => $total > 0 ? (int)round(($visited / $total) * 100) : 0,
        ];
    }
}
