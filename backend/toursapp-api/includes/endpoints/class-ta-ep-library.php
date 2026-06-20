<?php
defined('ABSPATH') || exit;

class TA_EP_Library {

    private static $allowed_types = ['place', 'ta_story'];

    public static function register_routes() {
        // GET /user/library
        register_rest_route(TA_API_NAMESPACE, '/user/library', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_library'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'lang' => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
            ],
        ]);

        // POST /user/favorites
        register_rest_route(TA_API_NAMESPACE, '/user/favorites', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [self::class, 'add_favorite'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'content_type' => [
                    'required'          => true,
                    'type'              => 'string',
                    'enum'              => self::$allowed_types,
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'content_id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'minimum'           => 1,
                    'sanitize_callback' => 'absint',
                ],
            ],
        ]);

        // DELETE /user/favorites/{type}/{id}
        register_rest_route(TA_API_NAMESPACE, '/user/favorites/(?P<type>[a-z_]+)/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::DELETABLE,
            'callback'            => [self::class, 'remove_favorite'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'type' => ['required' => true, 'type' => 'string'],
                'id'   => ['required' => true, 'type' => 'integer'],
            ],
        ]);

        // POST /user/offline/sync  (app reports its offline inventory)
        register_rest_route(TA_API_NAMESPACE, '/user/offline/sync', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [self::class, 'sync_offline'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'items' => [
                    'required' => true,
                    'type'     => 'array',
                ],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /user/library
    // ──────────────────────────────────────────────
    public static function get_library(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);
        $lang = TA_Localize::get_lang($request);

        $favs_place = TA_Library_Model::get_favorites($uuid, 'place');
        $favs_story = TA_Library_Model::get_favorites($uuid, 'ta_story');

        return TA_API::success([
            'resume_items'      => TA_Library_Model::get_resume_items($uuid, $lang, 5),
            'favourite_places'  => array_map(fn($f) => self::format_place_fav($f, $lang),  $favs_place),
            'favourite_stories' => array_map(fn($f) => self::format_story_fav($f, $uuid, $lang), $favs_story),
            'offline_counts'    => TA_Library_Model::get_offline_counts($uuid),
            'recent_activity'   => TA_Library_Model::get_recent_activity($uuid, $lang, 10),
        ]);
    }

    // ──────────────────────────────────────────────
    // POST /user/favorites
    // ──────────────────────────────────────────────
    public static function add_favorite(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);
        $type = $request->get_param('content_type');
        $id   = (int) $request->get_param('content_id');

        if (!in_array($type, self::$allowed_types, true)) {
            return TA_API::error('invalid_type', 'Invalid content type.', 400);
        }

        $post = get_post($id);
        if (!$post || $post->post_status !== 'publish') {
            return TA_API::error('not_found', 'Content not found.', 404);
        }

        if (TA_Library_Model::is_favorite($uuid, $type, $id)) {
            return TA_API::success(['favorited' => true, 'already_existed' => true]);
        }

        TA_Library_Model::add_favorite($uuid, $type, $id);
        return TA_API::created(['favorited' => true]);
    }

    // ──────────────────────────────────────────────
    // DELETE /user/favorites/{type}/{id}
    // ──────────────────────────────────────────────
    public static function remove_favorite(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);
        $type = sanitize_text_field($request->get_param('type'));
        $id   = (int) $request->get_param('id');

        if (!in_array($type, self::$allowed_types, true)) {
            return TA_API::error('invalid_type', 'Invalid content type.', 400);
        }

        TA_Library_Model::remove_favorite($uuid, $type, $id);
        return TA_API::success(['removed' => true]);
    }

    // ──────────────────────────────────────────────
    // POST /user/offline/sync
    // ──────────────────────────────────────────────
    public static function sync_offline(WP_REST_Request $request): WP_REST_Response {
        $uuid  = TA_Auth::get_device_uuid($request);
        $items = (array) $request->get_param('items');

        if (count($items) > 500) {
            return TA_API::error('too_many_items', 'Maximum 500 items per sync.', 400);
        }

        TA_Library_Model::sync_offline($uuid, $items);
        $counts = TA_Library_Model::get_offline_counts($uuid);

        return TA_API::success(['synced' => true, 'counts' => $counts]);
    }

    // ──────────────────────────────────────────────
    // Format helpers
    // ──────────────────────────────────────────────

    private static function format_place_fav(array $fav, string $lang): array {
        $id = (int) $fav['content_id'];
        return [
            'id'            => $id,
            'name'          => TA_Localize::get_field_localized($id, 'place_name', $lang),
            'feature_image' => TA_Localize::format_image(get_field('place_feature_image', $id)),
            'lat'           => (float) get_field('place_lat', $id),
            'lng'           => (float) get_field('place_lng', $id),
            'saved_at'      => $fav['created_at'],
        ];
    }

    private static function format_story_fav(array $fav, string $uuid, string $lang): array {
        global $wpdb;
        $id = (int) $fav['content_id'];

        // Latest completion + last opened
        $event = $wpdb->get_row($wpdb->prepare(
            "SELECT completion_pct, created_at FROM {$wpdb->prefix}ta_content_events
             WHERE device_uuid=%s AND content_type='ta_story' AND content_id=%d
               AND event_type IN ('audio_play','article_read')
             ORDER BY created_at DESC LIMIT 1",
            $uuid, $id
        ), ARRAY_A);

        // Offline status
        $is_offline = (bool) $wpdb->get_var($wpdb->prepare(
            "SELECT id FROM {$wpdb->prefix}ta_user_offline_items WHERE device_uuid=%s AND content_type='ta_story' AND content_id=%d",
            $uuid, $id
        ));

        $status = 'saved';
        if ($is_offline) {
            $status = 'downloaded';
        } elseif ($event) {
            $status = 'in_progress';
        }

        return [
            'id'             => $id,
            'name'           => TA_Localize::get_field_localized($id, 'story_name', $lang),
            'feature_image'  => TA_Localize::format_image(get_field('story_feature_image', $id)),
            'completion_pct' => $event ? (int) $event['completion_pct'] : 0,
            'is_offline'     => $is_offline,
            'status'         => $status,
            'last_opened_at' => $event['created_at'] ?? null,
            'saved_at'       => $fav['created_at'],
        ];
    }
}
