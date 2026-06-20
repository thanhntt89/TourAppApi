<?php
defined('ABSPATH') || exit;

class TA_EP_SubPlaces {

    public static function register_routes() {
        // List sub-places of a place
        register_rest_route(TA_API_NAMESPACE, '/places/(?P<place_id>\d+)/sub-places', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [__CLASS__, 'list_by_place'],
            'permission_callback' => '__return_true',
            'args'                => [
                'place_id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'lang' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);

        // Sub-place detail
        register_rest_route(TA_API_NAMESPACE, '/sub-places/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [__CLASS__, 'get_detail'],
            'permission_callback' => '__return_true',
            'args'                => [
                'id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'lang' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);
    }

    /**
     * GET /places/{place_id}/sub-places
     */
    public static function list_by_place(WP_REST_Request $request): WP_REST_Response {
        $place_id = (int) $request->get_param('place_id');
        $lang     = TA_Localize::get_lang($request);

        // Verify parent place exists
        $place = get_post($place_id);
        if (!$place || $place->post_type !== 'place') {
            return TA_API::error('place_not_found', 'Place not found.', 404);
        }

        $sub_places = get_posts([
            'post_type'      => 'sub_place',
            'posts_per_page' => -1,
            'post_status'    => 'publish',
            'meta_query'     => [
                [
                    'key'     => 'sub_place_place',
                    'value'   => $place_id,
                    'compare' => '=',
                ],
            ],
            'meta_key'       => 'sub_place_sort_order',
            'orderby'        => 'meta_value_num',
            'order'          => 'ASC',
        ]);

        $items = [];
        foreach ($sub_places as $sp) {
            $items[] = self::format_list_item($sp, $lang);
        }

        return TA_API::success($items);
    }

    /**
     * GET /sub-places/{id}
     */
    public static function get_detail(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $lang = TA_Localize::get_lang($request);

        $post = get_post($id);
        if (!$post || $post->post_type !== 'sub_place' || $post->post_status !== 'publish') {
            return TA_API::error('sub_place_not_found', 'Sub-place not found.', 404);
        }

        // Parent place info
        $place_obj = get_field('sub_place_place', $id);
        $place_id  = is_object($place_obj) ? $place_obj->ID : (int) $place_obj;
        $place     = null;
        if ($place_id) {
            $place = [
                'id'   => $place_id,
                'name' => TA_Localize::get_field_localized($place_id, 'place_name', $lang),
            ];
        }

        // Sub-items with full details
        $sub_items = self::get_sub_items_full($id, $lang);

        $audio = TA_Localize::get_audio_localized($id, 'sub_place_audio', $lang);

        $data = [
            'id'              => $id,
            'sub_place_index' => get_field('sub_place_index', $id) ?: '',
            'name'            => TA_Localize::get_field_localized($id, 'sub_place_name', $lang),
            'description'     => TA_Localize::get_field_localized($id, 'sub_place_desc', $lang),
            'feature_image'   => TA_Localize::format_image(get_field('sub_place_feature_image', $id)),
            'audio'           => $audio ?: null,
            'latitude'        => (float) (get_field('sub_place_lat', $id) ?: 0),
            'longitude'       => (float) (get_field('sub_place_lng', $id) ?: 0),
            'sort_order'      => (int) (get_field('sub_place_sort_order', $id) ?: 0),
            'place'           => $place,
            'sub_items'       => $sub_items,
        ];

        return TA_API::success($data);
    }

    /* ------------------------------------------------------------------ */
    /*  Private helpers                                                    */
    /* ------------------------------------------------------------------ */

    /**
     * Format a sub-place for the list endpoint (compact).
     */
    private static function format_list_item(WP_Post $sp, string $lang): array {
        $id = $sp->ID;

        return [
            'id'              => $id,
            'sub_place_index' => get_field('sub_place_index', $id) ?: '',
            'name'            => TA_Localize::get_field_localized($id, 'sub_place_name', $lang),
            'feature_image'   => TA_Localize::format_image(get_field('sub_place_feature_image', $id)),
            'latitude'        => (float) (get_field('sub_place_lat', $id) ?: 0),
            'longitude'       => (float) (get_field('sub_place_lng', $id) ?: 0),
            'sort_order'      => (int) (get_field('sub_place_sort_order', $id) ?: 0),
            'sub_items'       => self::get_sub_items_compact($id, $lang),
        ];
    }

    /**
     * Compact sub-items for the list endpoint.
     */
    private static function get_sub_items_compact(int $sub_place_id, string $lang): array {
        $posts = get_posts([
            'post_type'      => 'sub_item',
            'posts_per_page' => -1,
            'post_status'    => 'publish',
            'meta_query'     => [
                [
                    'key'     => 'sub_item_sub_place',
                    'value'   => $sub_place_id,
                    'compare' => '=',
                ],
            ],
            'meta_key'       => 'sub_item_sort_order',
            'orderby'        => 'meta_value_num',
            'order'          => 'ASC',
        ]);

        $items = [];
        foreach ($posts as $p) {
            $items[] = [
                'id'            => $p->ID,
                'item_index'    => get_field('sub_item_index', $p->ID) ?: '',
                'name'          => TA_Localize::get_field_localized($p->ID, 'sub_item_name', $lang),
                'feature_image' => TA_Localize::format_image(get_field('sub_item_feature_image', $p->ID)),
                'sort_order'    => (int) (get_field('sub_item_sort_order', $p->ID) ?: 0),
            ];
        }

        return $items;
    }

    /**
     * Full sub-items for the detail endpoint (includes gallery, audio).
     */
    private static function get_sub_items_full(int $sub_place_id, string $lang): array {
        $posts = get_posts([
            'post_type'      => 'sub_item',
            'posts_per_page' => -1,
            'post_status'    => 'publish',
            'meta_query'     => [
                [
                    'key'     => 'sub_item_sub_place',
                    'value'   => $sub_place_id,
                    'compare' => '=',
                ],
            ],
            'meta_key'       => 'sub_item_sort_order',
            'orderby'        => 'meta_value_num',
            'order'          => 'ASC',
        ]);

        $items = [];
        foreach ($posts as $p) {
            $pid   = $p->ID;
            $audio = TA_Localize::get_audio_localized($pid, 'sub_item_audio', $lang);

            $items[] = [
                'id'            => $pid,
                'item_index'    => get_field('sub_item_index', $pid) ?: '',
                'name'          => TA_Localize::get_field_localized($pid, 'sub_item_name', $lang),
                'description'   => TA_Localize::get_field_localized($pid, 'sub_item_desc', $lang),
                'feature_image' => TA_Localize::format_image(get_field('sub_item_feature_image', $pid)),
                'gallery'       => TA_Localize::format_gallery(get_field('sub_item_gallery', $pid)),
                'audio'         => $audio,
                'sort_order'    => (int) (get_field('sub_item_sort_order', $pid) ?: 0),
            ];
        }

        return $items;
    }
}
