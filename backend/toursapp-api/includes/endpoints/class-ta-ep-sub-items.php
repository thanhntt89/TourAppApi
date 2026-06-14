<?php
defined('ABSPATH') || exit;

class TA_EP_SubItems {

    public static function register_routes() {
        // Sub-item detail
        register_rest_route(TA_API_NAMESPACE, '/sub-items/(?P<id>\d+)', [
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
     * GET /sub-items/{id}
     */
    public static function get_detail(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $lang = TA_Localize::get_lang($request);

        $post = get_post($id);
        if (!$post || $post->post_type !== 'sub_item' || $post->post_status !== 'publish') {
            return TA_API::error('sub_item_not_found', 'Sub-item not found.', 404);
        }

        // Resolve parent chain: sub_item -> sub_place -> place
        $sub_place_obj = get_field('sub_item_sub_place', $id);
        $sub_place_id  = is_object($sub_place_obj) ? $sub_place_obj->ID : (int) $sub_place_obj;

        $sub_place = null;
        $place     = null;

        if ($sub_place_id) {
            $sub_place = [
                'id'   => $sub_place_id,
                'name' => TA_Localize::get_field_localized($sub_place_id, 'sub_place_name', $lang),
            ];

            // Get grandparent place
            $place_obj = get_field('sub_place_place', $sub_place_id);
            $place_id  = is_object($place_obj) ? $place_obj->ID : (int) $place_obj;

            if ($place_id) {
                $place = [
                    'id'   => $place_id,
                    'name' => TA_Localize::get_field_localized($place_id, 'place_name', $lang),
                ];
            }
        }

        $audio = TA_Localize::get_audio_localized($id, 'sub_item_audio', $lang);

        $data = [
            'id'            => $id,
            'item_index'    => get_field('sub_item_index', $id) ?: '',
            'name'          => TA_Localize::get_field_localized($id, 'sub_item_name', $lang),
            'description'   => TA_Localize::get_field_localized($id, 'sub_item_desc', $lang),
            'feature_image' => TA_Localize::format_image(get_field('sub_item_feature_image', $id)),
            'gallery'       => TA_Localize::format_gallery(get_field('sub_item_gallery', $id)),
            'audio'         => $audio,
            'sort_order'    => (int) (get_field('sub_item_sort_order', $id) ?: 0),
            'sub_place'     => $sub_place,
            'place'         => $place,
        ];

        return TA_API::success($data);
    }
}
