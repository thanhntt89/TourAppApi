<?php
defined('ABSPATH') || exit;

class TA_Library_Model {

    // ── Favorites ──────────────────────────────────────────────────────────

    public static function add_favorite(string $uuid, string $type, int $id): bool {
        global $wpdb;
        $wpdb->insert($wpdb->prefix . 'ta_user_favorites', [
            'device_uuid'  => $uuid,
            'content_type' => $type,
            'content_id'   => $id,
        ]);
        return $wpdb->insert_id > 0;
    }

    public static function remove_favorite(string $uuid, string $type, int $id): bool {
        global $wpdb;
        return (bool) $wpdb->delete($wpdb->prefix . 'ta_user_favorites', [
            'device_uuid'  => $uuid,
            'content_type' => $type,
            'content_id'   => $id,
        ]);
    }

    public static function is_favorite(string $uuid, string $type, int $id): bool {
        global $wpdb;
        return (bool) $wpdb->get_var($wpdb->prepare(
            "SELECT id FROM {$wpdb->prefix}ta_user_favorites WHERE device_uuid=%s AND content_type=%s AND content_id=%d",
            $uuid, $type, $id
        ));
    }

    public static function get_favorites(string $uuid, string $type = ''): array {
        global $wpdb;
        if ($type) {
            return $wpdb->get_results($wpdb->prepare(
                "SELECT * FROM {$wpdb->prefix}ta_user_favorites WHERE device_uuid=%s AND content_type=%s ORDER BY created_at DESC",
                $uuid, $type
            ), ARRAY_A) ?: [];
        }
        return $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}ta_user_favorites WHERE device_uuid=%s ORDER BY created_at DESC",
            $uuid
        ), ARRAY_A) ?: [];
    }

    // ── Offline items ───────────────────────────────────────────────────────

    public static function sync_offline(string $uuid, array $items): void {
        global $wpdb;
        $table = $wpdb->prefix . 'ta_user_offline_items';

        // Remove all current offline items for this device, then re-insert.
        $wpdb->delete($table, ['device_uuid' => $uuid]);

        foreach ($items as $item) {
            $type = sanitize_text_field($item['content_type'] ?? '');
            $id   = (int) ($item['content_id'] ?? 0);
            if (!$type || !$id) continue;
            $wpdb->insert($table, [
                'device_uuid'  => $uuid,
                'content_type' => $type,
                'content_id'   => $id,
            ]);
        }
    }

    public static function get_offline_counts(string $uuid): array {
        global $wpdb;
        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT content_type, COUNT(*) AS cnt FROM {$wpdb->prefix}ta_user_offline_items WHERE device_uuid=%s GROUP BY content_type",
            $uuid
        ), ARRAY_A) ?: [];

        $counts = ['audio_guide' => 0, 'story' => 0, 'total' => 0];
        foreach ($rows as $row) {
            $t = $row['content_type'];
            $n = (int) $row['cnt'];
            if (isset($counts[$t])) {
                $counts[$t] = $n;
            }
            $counts['total'] += $n;
        }
        return $counts;
    }

    // ── Resume items (favorites with incomplete progress) ───────────────────

    public static function get_resume_items(string $uuid, string $lang, int $limit = 5): array {
        global $wpdb;

        // Favorited stories and audio_guides where latest completion_pct < 100
        $favs = $wpdb->get_results($wpdb->prepare(
            "SELECT content_type, content_id, created_at AS saved_at
             FROM {$wpdb->prefix}ta_user_favorites
             WHERE device_uuid=%s AND content_type IN ('ta_story','audio_guide')
             ORDER BY created_at DESC",
            $uuid
        ), ARRAY_A) ?: [];

        $items = [];
        foreach ($favs as $fav) {
            $type = $fav['content_type'];
            $id   = (int) $fav['content_id'];

            // Latest completion_pct from engagement events
            $row = $wpdb->get_row($wpdb->prepare(
                "SELECT completion_pct, created_at AS last_event_at
                 FROM {$wpdb->prefix}ta_content_events
                 WHERE device_uuid=%s AND content_type=%s AND content_id=%d
                   AND event_type IN ('audio_play','article_read')
                 ORDER BY created_at DESC LIMIT 1",
                $uuid, $type, $id
            ), ARRAY_A);

            $completion = $row ? (int) $row['completion_pct'] : 0;
            if ($completion >= 100) continue;

            $post = get_post($id);
            if (!$post || $post->post_status !== 'publish') continue;

            $name  = TA_Localize::get_field_localized($id, $type === 'ta_story' ? 'story_name' : 'audio_guide_name', $lang);
            $image = TA_Localize::format_image(get_field($type === 'ta_story' ? 'story_feature_image' : 'audio_guide_image', $id));

            $items[] = [
                'content_type'  => $type,
                'content_id'    => $id,
                'title'         => $name,
                'feature_image' => $image,
                'completion_pct' => $completion,
                'last_event_at' => $row['last_event_at'] ?? null,
                'saved_at'      => $fav['saved_at'],
            ];

            if (count($items) >= $limit) break;
        }

        return $items;
    }

    // ── Recent activity (aggregated from multiple tables) ───────────────────

    public static function get_recent_activity(string $uuid, string $lang, int $limit = 10): array {
        global $wpdb;
        $events = [];

        // Check-ins (place visits)
        $checkins = $wpdb->get_results($wpdb->prepare(
            "SELECT place_id, created_at FROM {$wpdb->prefix}ta_checkins WHERE device_uuid=%s ORDER BY created_at DESC LIMIT %d",
            $uuid, $limit
        ), ARRAY_A) ?: [];
        foreach ($checkins as $c) {
            $name = TA_Localize::get_field_localized((int)$c['place_id'], 'place_name', $lang);
            $events[] = [
                'type'         => 'checkin',
                'content_type' => 'place',
                'content_id'   => (int) $c['place_id'],
                'title'        => $name,
                'created_at'   => $c['created_at'],
            ];
        }

        // Unlocked content
        $unlocks = $wpdb->get_results($wpdb->prepare(
            "SELECT content_type, content_id, created_at FROM {$wpdb->prefix}ta_unlocked_content WHERE device_uuid=%s ORDER BY created_at DESC LIMIT %d",
            $uuid, $limit
        ), ARRAY_A) ?: [];
        foreach ($unlocks as $u) {
            $id   = (int) $u['content_id'];
            $type = $u['content_type'];
            $name = '';
            if ($type === 'ta_story') {
                $name = TA_Localize::get_field_localized($id, 'story_name', $lang);
            }
            $events[] = [
                'type'         => 'unlock',
                'content_type' => $type,
                'content_id'   => $id,
                'title'        => $name,
                'created_at'   => $u['created_at'],
            ];
        }

        // Audio download events
        $audio_events = $wpdb->get_results($wpdb->prepare(
            "SELECT content_id, created_at FROM {$wpdb->prefix}ta_content_events
             WHERE device_uuid=%s AND content_type='ta_story' AND event_type='audio_play'
             GROUP BY content_id ORDER BY MAX(created_at) DESC LIMIT %d",
            $uuid, $limit
        ), ARRAY_A) ?: [];
        foreach ($audio_events as $e) {
            $id   = (int) $e['content_id'];
            $name = TA_Localize::get_field_localized($id, 'story_name', $lang);
            $events[] = [
                'type'         => 'audio_play',
                'content_type' => 'ta_story',
                'content_id'   => $id,
                'title'        => $name,
                'created_at'   => $e['created_at'],
            ];
        }

        // Sort all events by created_at desc, take top N
        usort($events, fn($a, $b) => strcmp($b['created_at'], $a['created_at']));
        return array_slice($events, 0, $limit);
    }
}
