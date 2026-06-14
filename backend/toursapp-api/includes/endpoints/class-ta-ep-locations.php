<?php
defined('ABSPATH') || exit;

class TA_EP_Locations {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/provinces/(?P<province_id>\d+)/locations', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_locations'],
            'permission_callback' => '__return_true',
            'args'                => [
                'province_id' => ['type' => 'integer', 'required' => true],
                'lang'        => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
                'sort'        => [
                    'type'    => 'string',
                    'default' => 'location_number',
                    'enum'    => ['location_number', 'name', 'distance'],
                ],
                'lat'         => ['type' => 'number'],
                'lng'         => ['type' => 'number'],
            ],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/locations/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_location'],
            'permission_callback' => '__return_true',
            'args'                => [
                'id'      => ['type' => 'integer', 'required' => true],
                'lang'    => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
                'include' => ['type' => 'string', 'default' => ''],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /provinces/{province_id}/locations
    // ──────────────────────────────────────────────
    public static function list_locations(WP_REST_Request $request): WP_REST_Response {
        $province_id = (int) $request->get_param('province_id');
        $lang        = TA_Localize::get_lang($request);
        $sort        = $request->get_param('sort') ?: 'location_number';
        $lat         = $request->get_param('lat');
        $lng         = $request->get_param('lng');

        // Verify province exists.
        $province = get_post($province_id);
        if (!$province || $province->post_type !== 'province' || $province->post_status !== 'publish') {
            return TA_API::error('province_not_found', 'Province not found.', 404);
        }

        $posts = get_posts([
            'post_type'      => 'ta_location',
            'post_status'    => 'publish',
            'meta_key'       => 'location_province',
            'meta_value'     => $province_id,
            'posts_per_page' => -1,
        ]);

        $has_coords = is_numeric($lat) && is_numeric($lng);
        $lat_f      = $has_coords ? (float) $lat : 0;
        $lng_f      = $has_coords ? (float) $lng : 0;

        $locations = array_map(function ($post) use ($lang, $has_coords, $lat_f, $lng_f) {
            return self::format_location($post, $lang, $has_coords, $lat_f, $lng_f);
        }, $posts);

        // Sort.
        switch ($sort) {
            case 'distance':
                if ($has_coords) {
                    usort($locations, function ($a, $b) {
                        return ($a['distance_km'] ?? PHP_FLOAT_MAX) <=> ($b['distance_km'] ?? PHP_FLOAT_MAX);
                    });
                    break;
                }
                // Fall through to default if no coords.
            case 'name':
                usort($locations, function ($a, $b) {
                    return strcmp($a['name'], $b['name']);
                });
                break;
            default: // location_number
                usort($locations, function ($a, $b) {
                    return $a['number'] <=> $b['number'];
                });
                break;
        }

        return TA_API::success($locations, ['total' => count($locations)]);
    }

    // ──────────────────────────────────────────────
    // GET /locations/{id}
    // ──────────────────────────────────────────────
    public static function get_location(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $lang = TA_Localize::get_lang($request);
        $post = get_post($id);

        if (!$post || $post->post_type !== 'ta_location' || $post->post_status !== 'publish') {
            return TA_API::error('location_not_found', 'Location not found.', 404);
        }

        $data = self::format_location_detail($post, $lang);

        // Optional includes.
        $includes = array_filter(array_map('trim', explode(',', $request->get_param('include') ?: '')));

        if (in_array('places', $includes, true)) {
            $data['places'] = self::get_location_places($id, $lang);
        }

        return TA_API::success($data);
    }

    // ──────────────────────────────────────────────
    // Format helpers
    // ──────────────────────────────────────────────

    /**
     * Compact location for list endpoint.
     */
    private static function format_location(WP_Post $post, string $lang, bool $has_coords, float $lat, float $lng): array {
        $id    = $post->ID;
        $l_lat = (float) get_field('location_lat', $id);
        $l_lng = (float) get_field('location_lng', $id);

        $item = [
            'id'            => $id,
            'number'        => (int) get_field('location_number', $id),
            'name'          => TA_Localize::get_field_localized($id, 'location_name', $lang),
            'feature_image' => TA_Localize::format_image(get_field('location_feature_image', $id)),
            'latitude'      => $l_lat,
            'longitude'     => $l_lng,
            'total_places'  => self::count_places($id),
            'sort_order'    => (int) get_field('location_sort_order', $id),
        ];

        if ($has_coords && $l_lat && $l_lng) {
            $item['distance_km'] = round(TA_Geo::distance_km($lat, $lng, $l_lat, $l_lng), 2);
        }

        return $item;
    }

    /**
     * Full location detail.
     */
    private static function format_location_detail(WP_Post $post, string $lang): array {
        $id = $post->ID;

        // Resolve parent province.
        $province_id   = (int) get_field('location_province', $id);
        $province_data = null;

        if ($province_id) {
            $province_post = get_post($province_id);
            if ($province_post && $province_post->post_status === 'publish') {
                $province_data = [
                    'id'   => $province_id,
                    'name' => TA_Localize::get_field_localized($province_id, 'province_name', $lang),
                ];
            }
        }

        return [
            'id'            => $id,
            'number'        => (int) get_field('location_number', $id),
            'name'          => TA_Localize::get_field_localized($id, 'location_name', $lang),
            'description'   => TA_Localize::get_field_localized($id, 'location_desc', $lang),
            'feature_image' => TA_Localize::format_image(get_field('location_feature_image', $id)),
            'latitude'      => (float) get_field('location_lat', $id),
            'longitude'     => (float) get_field('location_lng', $id),
            'total_places'  => self::count_places($id),
            'sort_order'    => (int) get_field('location_sort_order', $id),
            'province'      => $province_data,
        ];
    }

    /**
     * Place posts belonging to a location, ordered by place_sort_order.
     */
    private static function get_location_places(int $location_id, string $lang): array {
        $posts = get_posts([
            'post_type'      => 'place',
            'post_status'    => 'publish',
            'meta_key'       => 'place_location',
            'meta_value'     => $location_id,
            'posts_per_page' => -1,
        ]);

        $places = array_map(function ($post) use ($lang) {
            $id = $post->ID;
            return [
                'id'            => $id,
                'name'          => TA_Localize::get_field_localized($id, 'place_name', $lang),
                'feature_image' => TA_Localize::format_image(get_field('place_feature_image', $id)),
                'latitude'      => (float) get_field('place_lat', $id),
                'longitude'     => (float) get_field('place_lng', $id),
                'is_featured'   => (bool) get_field('place_is_featured', $id),
                'sort_order'    => (int) get_field('place_sort_order', $id),
            ];
        }, $posts);

        usort($places, function ($a, $b) {
            return $a['sort_order'] <=> $b['sort_order'];
        });

        return $places;
    }

    /**
     * Count place posts linked to a location.
     */
    private static function count_places(int $location_id): int {
        $query = new WP_Query([
            'post_type'      => 'place',
            'post_status'    => 'publish',
            'meta_key'       => 'place_location',
            'meta_value'     => $location_id,
            'posts_per_page' => -1,
            'fields'         => 'ids',
            'no_found_rows'  => true,
        ]);
        return $query->post_count;
    }
}
