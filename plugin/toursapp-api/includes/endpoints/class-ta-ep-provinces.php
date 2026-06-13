<?php
defined('ABSPATH') || exit;

class TA_EP_Provinces {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/provinces', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_provinces'],
            'permission_callback' => '__return_true',
            'args'                => [
                'lang' => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
            ],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/provinces/detect', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'detect_province'],
            'permission_callback' => '__return_true',
            'args'                => [
                'lat'  => ['type' => 'number', 'required' => true, 'validate_callback' => [self::class, 'validate_coordinate']],
                'lng'  => ['type' => 'number', 'required' => true, 'validate_callback' => [self::class, 'validate_coordinate']],
                'lang' => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
            ],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/provinces/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_province'],
            'permission_callback' => '__return_true',
            'args'                => [
                'id'      => ['type' => 'integer', 'required' => true],
                'lang'    => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
                'include' => ['type' => 'string', 'default' => ''],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /provinces
    // ──────────────────────────────────────────────
    public static function list_provinces(WP_REST_Request $request): WP_REST_Response {
        $lang = TA_Localize::get_lang($request);

        $posts = get_posts([
            'post_type'      => 'province',
            'post_status'    => 'publish',
            'posts_per_page' => -1,
            'meta_key'       => 'province_sort_order',
            'orderby'        => 'meta_value_num',
            'order'          => 'ASC',
        ]);

        $provinces = array_map(function ($post) use ($lang) {
            return self::format_province($post, $lang);
        }, $posts);

        return TA_API::success($provinces, ['total' => count($provinces)]);
    }

    // ──────────────────────────────────────────────
    // GET /provinces/detect
    // ──────────────────────────────────────────────
    public static function detect_province(WP_REST_Request $request): WP_REST_Response {
        $lat  = (float) $request->get_param('lat');
        $lng  = (float) $request->get_param('lng');
        $lang = TA_Localize::get_lang($request);

        $posts = get_posts([
            'post_type'      => 'province',
            'post_status'    => 'publish',
            'posts_per_page' => -1,
            'meta_query'     => [
                [
                    'key'   => 'province_is_active',
                    'value' => '1',
                ],
            ],
        ]);

        $nearest          = null;
        $nearest_distance = PHP_FLOAT_MAX;

        foreach ($posts as $post) {
            $p_lat    = (float) get_field('province_lat', $post->ID);
            $p_lng    = (float) get_field('province_lng', $post->ID);
            $radius   = (float) get_field('province_detect_radius', $post->ID);

            if (!$p_lat && !$p_lng) {
                continue;
            }

            $distance = TA_Geo::distance_km($lat, $lng, $p_lat, $p_lng);

            if ($distance <= $radius && $distance < $nearest_distance) {
                $nearest          = $post;
                $nearest_distance = $distance;
            }
        }

        if ($nearest) {
            $province_data                = self::format_province($nearest, $lang);
            $province_data['distance_km'] = round($nearest_distance, 2);

            return TA_API::success([
                'detected' => true,
                'province' => $province_data,
            ]);
        }

        // Not detected — return all active provinces so the app can offer a picker.
        $available = array_map(function ($post) use ($lang) {
            return self::format_province($post, $lang);
        }, $posts);

        return TA_API::success([
            'detected'             => false,
            'province'             => null,
            'available_provinces'  => $available,
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /provinces/{id}
    // ──────────────────────────────────────────────
    public static function get_province(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $lang = TA_Localize::get_lang($request);
        $post = get_post($id);

        if (!$post || $post->post_type !== 'province' || $post->post_status !== 'publish') {
            return TA_API::error('province_not_found', 'Province not found.', 404);
        }

        $data = self::format_province($post, $lang);

        // Banner gallery.
        $data['banner_images'] = TA_Localize::format_gallery(get_field('province_banner_images', $id));

        // Optional includes.
        $includes = array_filter(array_map('trim', explode(',', $request->get_param('include') ?: '')));

        if (in_array('locations', $includes, true)) {
            $data['locations'] = self::get_province_locations($id, $lang);
        }

        if (in_array('featured_places', $includes, true)) {
            $data['featured_places'] = self::get_featured_places($id, $lang);
        }

        if (in_array('news', $includes, true)) {
            $data['news'] = self::get_province_news($id, $lang);
        }

        return TA_API::success($data);
    }

    // ──────────────────────────────────────────────
    // Format helpers
    // ──────────────────────────────────────────────

    private static function format_province(WP_Post $post, string $lang): array {
        $id = $post->ID;

        return [
            'id'                   => $id,
            'name'                 => TA_Localize::get_field_localized($id, 'province_name', $lang),
            'description'          => TA_Localize::get_field_localized($id, 'province_desc', $lang),
            'feature_image'        => TA_Localize::format_image(get_field('province_feature_image', $id)),
            'latitude'             => (float) get_field('province_lat', $id),
            'longitude'            => (float) get_field('province_lng', $id),
            'detection_radius_km'  => (float) get_field('province_detect_radius', $id),
            'is_active'            => (bool) get_field('province_is_active', $id),
            'total_locations'      => self::count_linked_posts('ta_location', 'location_province', $id),
            'total_places'         => self::count_province_places($id),
            'sort_order'           => (int) get_field('province_sort_order', $id),
        ];
    }

    /**
     * Count CPT posts linked via an ACF Post Object field (stored as post ID in postmeta).
     */
    private static function count_linked_posts(string $post_type, string $meta_key, int $meta_value): int {
        $query = new WP_Query([
            'post_type'      => $post_type,
            'post_status'    => 'publish',
            'meta_key'       => $meta_key,
            'meta_value'     => $meta_value,
            'posts_per_page' => -1,
            'fields'         => 'ids',
            'no_found_rows'  => true,
        ]);
        return $query->post_count;
    }

    /**
     * Count all places across all locations belonging to this province.
     */
    private static function count_province_places(int $province_id): int {
        $location_ids = get_posts([
            'post_type'      => 'ta_location',
            'post_status'    => 'publish',
            'meta_key'       => 'location_province',
            'meta_value'     => $province_id,
            'posts_per_page' => -1,
            'fields'         => 'ids',
        ]);

        if (empty($location_ids)) {
            return 0;
        }

        $query = new WP_Query([
            'post_type'      => 'place',
            'post_status'    => 'publish',
            'meta_query'     => [
                [
                    'key'     => 'place_location',
                    'value'   => $location_ids,
                    'compare' => 'IN',
                ],
            ],
            'posts_per_page' => -1,
            'fields'         => 'ids',
            'no_found_rows'  => true,
        ]);

        return $query->post_count;
    }

    /**
     * Locations belonging to province, ordered by location_sort_order.
     */
    private static function get_province_locations(int $province_id, string $lang): array {
        $posts = get_posts([
            'post_type'      => 'ta_location',
            'post_status'    => 'publish',
            'meta_key'       => 'location_province',
            'meta_value'     => $province_id,
            'posts_per_page' => -1,
        ]);

        $locations = array_map(function ($post) use ($lang) {
            return self::format_location_summary($post, $lang);
        }, $posts);

        // Sort by sort_order.
        usort($locations, function ($a, $b) {
            return $a['sort_order'] <=> $b['sort_order'];
        });

        return $locations;
    }

    /**
     * Featured places across all locations in this province.
     */
    private static function get_featured_places(int $province_id, string $lang): array {
        $location_ids = get_posts([
            'post_type'      => 'ta_location',
            'post_status'    => 'publish',
            'meta_key'       => 'location_province',
            'meta_value'     => $province_id,
            'posts_per_page' => -1,
            'fields'         => 'ids',
        ]);

        if (empty($location_ids)) {
            return [];
        }

        $places = get_posts([
            'post_type'      => 'place',
            'post_status'    => 'publish',
            'meta_query'     => [
                'relation' => 'AND',
                [
                    'key'     => 'place_location',
                    'value'   => $location_ids,
                    'compare' => 'IN',
                ],
                [
                    'key'   => 'place_is_featured',
                    'value' => '1',
                ],
            ],
            'posts_per_page' => -1,
        ]);

        return array_map(function ($post) use ($lang) {
            return self::format_place_summary($post, $lang);
        }, $places);
    }

    /**
     * News/alerts for this province, pinned first.
     */
    private static function get_province_news(int $province_id, string $lang): array {
        $posts = get_posts([
            'post_type'      => 'news_alert',
            'post_status'    => 'publish',
            'meta_key'       => 'news_province',
            'meta_value'     => $province_id,
            'posts_per_page' => -1,
        ]);

        $items = array_map(function ($post) use ($lang) {
            $id = $post->ID;
            return [
                'id'          => $id,
                'title'       => TA_Localize::get_field_localized($id, 'news_title', $lang),
                'summary'     => TA_Localize::get_field_localized($id, 'news_summary', $lang),
                'image'       => TA_Localize::format_image(get_field('news_image', $id)),
                'is_pinned'   => (bool) get_field('news_is_pinned', $id),
                'published_at' => $post->post_date,
            ];
        }, $posts);

        // Pinned first, then by date descending.
        usort($items, function ($a, $b) {
            if ($a['is_pinned'] !== $b['is_pinned']) {
                return $b['is_pinned'] <=> $a['is_pinned'];
            }
            return strtotime($b['published_at']) <=> strtotime($a['published_at']);
        });

        return $items;
    }

    /**
     * Compact location for province includes.
     */
    private static function format_location_summary(WP_Post $post, string $lang): array {
        $id = $post->ID;

        return [
            'id'             => $id,
            'number'         => (int) get_field('location_number', $id),
            'name'           => TA_Localize::get_field_localized($id, 'location_name', $lang),
            'feature_image'  => TA_Localize::format_image(get_field('location_feature_image', $id)),
            'latitude'       => (float) get_field('location_lat', $id),
            'longitude'      => (float) get_field('location_lng', $id),
            'total_places'   => self::count_linked_posts('place', 'place_location', $id),
            'sort_order'     => (int) get_field('location_sort_order', $id),
        ];
    }

    /**
     * Compact place for province includes.
     */
    private static function format_place_summary(WP_Post $post, string $lang): array {
        $id = $post->ID;

        return [
            'id'            => $id,
            'name'          => TA_Localize::get_field_localized($id, 'place_name', $lang),
            'feature_image' => TA_Localize::format_image(get_field('place_feature_image', $id)),
            'latitude'      => (float) get_field('place_lat', $id),
            'longitude'     => (float) get_field('place_lng', $id),
            'is_featured'   => true,
        ];
    }

    // ──────────────────────────────────────────────
    // Validation
    // ──────────────────────────────────────────────

    public static function validate_coordinate($value, WP_REST_Request $request, string $key): bool {
        if (!is_numeric($value)) {
            return false;
        }
        $val = (float) $value;
        if ($key === 'lat') {
            return $val >= -90 && $val <= 90;
        }
        return $val >= -180 && $val <= 180;
    }
}
