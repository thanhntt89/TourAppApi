<?php
defined('ABSPATH') || exit;

class TA_EP_Places {

    public static function register_routes() {
        // List places
        register_rest_route(TA_API_NAMESPACE, '/places', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_places'],
            'permission_callback' => '__return_true',
            'args'                => [
                'province_id' => ['type' => 'integer', 'sanitize_callback' => 'absint'],
                'location_id' => ['type' => 'integer', 'sanitize_callback' => 'absint'],
                'featured'    => ['type' => 'string', 'enum' => ['true', 'false']],
                'lang'        => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
                'sort'        => [
                    'type'    => 'string',
                    'default' => 'sort_order',
                    'enum'    => ['sort_order', 'name', 'distance', 'place_order_number'],
                ],
                'lat'      => ['type' => 'number'],
                'lng'      => ['type' => 'number'],
                'page'     => ['type' => 'integer', 'default' => 1, 'minimum' => 1],
                'per_page' => ['type' => 'integer', 'default' => 20, 'minimum' => 1, 'maximum' => 100],
                'search'   => ['type' => 'string', 'sanitize_callback' => 'sanitize_text_field'],
            ],
        ]);

        // Place detail
        register_rest_route(TA_API_NAMESPACE, '/places/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_place'],
            'permission_callback' => '__return_true',
            'args'                => [
                'id'      => ['type' => 'integer', 'required' => true],
                'lang'    => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
                'include' => ['type' => 'string', 'default' => ''],
            ],
        ]);

        // Nearby places (GPS auto-detect)
        register_rest_route(TA_API_NAMESPACE, '/places/nearby', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'nearby_places'],
            'permission_callback' => '__return_true',
            'args'                => [
                'lat'         => ['type' => 'number', 'required' => true, 'validate_callback' => [self::class, 'validate_lat']],
                'lng'         => ['type' => 'number', 'required' => true, 'validate_callback' => [self::class, 'validate_lng']],
                'radius'      => ['type' => 'integer', 'default' => 1000],
                'province_id' => ['type' => 'integer', 'sanitize_callback' => 'absint'],
                'limit'       => ['type' => 'integer', 'default' => 10, 'minimum' => 1, 'maximum' => 100],
                'lang'        => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
            ],
        ]);

        // QR code lookup
        register_rest_route(TA_API_NAMESPACE, '/places/qr/(?P<code>[\\w-]+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'qr_lookup'],
            'permission_callback' => '__return_true',
            'args'                => [
                'code' => ['type' => 'string', 'required' => true, 'sanitize_callback' => 'sanitize_text_field'],
                'lang' => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
            ],
        ]);

        // Search places by keyword
        register_rest_route(TA_API_NAMESPACE, '/places/search', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'search_places'],
            'permission_callback' => '__return_true',
            'args'                => [
                'q'           => ['type' => 'string', 'required' => true, 'sanitize_callback' => 'sanitize_text_field'],
                'province_id' => ['type' => 'integer', 'sanitize_callback' => 'absint'],
                'lang'        => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
                'page'        => ['type' => 'integer', 'default' => 1, 'minimum' => 1],
                'per_page'    => ['type' => 'integer', 'default' => 20, 'minimum' => 1, 'maximum' => 100],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /places
    // ──────────────────────────────────────────────
    public static function list_places(WP_REST_Request $request): WP_REST_Response {
        $province_id = $request->get_param('province_id');
        $location_id = $request->get_param('location_id');
        $featured    = $request->get_param('featured');
        $lang        = TA_Localize::get_lang($request);
        $sort        = $request->get_param('sort') ?: 'sort_order';
        $lat         = $request->get_param('lat');
        $lng         = $request->get_param('lng');
        $page        = max(1, (int) ($request->get_param('page') ?: 1));
        $per_page    = min(100, max(1, (int) ($request->get_param('per_page') ?: 20)));
        $search      = $request->get_param('search');

        // Build meta_query.
        $meta_query = ['relation' => 'AND'];

        // Filter by location(s).
        if ($location_id) {
            $meta_query[] = [
                'key'   => 'place_location',
                'value' => (int) $location_id,
            ];
        } elseif ($province_id) {
            // Get all location IDs for this province, then filter places by those locations.
            $location_ids = get_posts([
                'post_type'      => 'ta_location',
                'post_status'    => 'publish',
                'meta_key'       => 'location_province',
                'meta_value'     => (int) $province_id,
                'posts_per_page' => -1,
                'fields'         => 'ids',
            ]);

            if (empty($location_ids)) {
                return TA_API::success([], [
                    'total'    => 0,
                    'page'     => $page,
                    'per_page' => $per_page,
                    'pages'    => 0,
                ]);
            }

            $meta_query[] = [
                'key'     => 'place_location',
                'value'   => $location_ids,
                'compare' => 'IN',
            ];
        }

        // Filter featured.
        if ($featured === 'true') {
            $meta_query[] = [
                'key'   => 'place_is_featured',
                'value' => '1',
            ];
        }

        // Build query args.
        $query_args = [
            'post_type'      => 'place',
            'post_status'    => 'publish',
            'posts_per_page' => -1,  // Fetch all for count + manual pagination (needed for distance sort).
        ];

        if (count($meta_query) > 1) {
            $query_args['meta_query'] = $meta_query;
        }

        // Title search filter.
        if ($search) {
            $query_args['s'] = $search;
        }

        $posts = get_posts($query_args);

        $has_coords = is_numeric($lat) && is_numeric($lng);
        $lat_f      = $has_coords ? (float) $lat : 0;
        $lng_f      = $has_coords ? (float) $lng : 0;

        // Format all places.
        $places = array_map(function ($post) use ($lang, $has_coords, $lat_f, $lng_f) {
            return self::format_place_list($post, $lang, $has_coords, $lat_f, $lng_f);
        }, $posts);

        // Sort.
        switch ($sort) {
            case 'distance':
                if ($has_coords) {
                    usort($places, function ($a, $b) {
                        return ($a['distance_km'] ?? PHP_FLOAT_MAX) <=> ($b['distance_km'] ?? PHP_FLOAT_MAX);
                    });
                    break;
                }
                // Fall through to default if no coords.
            case 'name':
                usort($places, function ($a, $b) {
                    return strcmp($a['name'], $b['name']);
                });
                break;
            case 'place_order_number':
                usort($places, function ($a, $b) {
                    return $a['order_number'] <=> $b['order_number'];
                });
                break;
            default: // sort_order
                usort($places, function ($a, $b) {
                    return $a['sort_order'] <=> $b['sort_order'];
                });
                break;
        }

        // Pagination.
        $total = count($places);
        $pages = (int) ceil($total / $per_page);
        $offset = ($page - 1) * $per_page;
        $places = array_slice($places, $offset, $per_page);

        return TA_API::success($places, [
            'total'    => $total,
            'page'     => $page,
            'per_page' => $per_page,
            'pages'    => $pages,
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /places/{id}
    // ──────────────────────────────────────────────
    public static function get_place(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $lang = TA_Localize::get_lang($request);
        $post = get_post($id);

        if (!$post || $post->post_type !== 'place' || $post->post_status !== 'publish') {
            return TA_API::error('place_not_found', 'Place not found.', 404);
        }

        // Optional device UUID for user status (not required).
        $uuid = TA_Auth::get_device_uuid($request);

        // Resolve parent location for hierarchical index.
        $location_obj = get_field('place_location', $id);
        $location_id  = is_object($location_obj) ? $location_obj->ID : (int) $location_obj;

        $location_data   = null;
        $location_number = 0;
        if ($location_id) {
            $location_post = get_post($location_id);
            if ($location_post && $location_post->post_status === 'publish') {
                $location_number = (int) get_field('location_number', $location_id);
                $location_data = [
                    'id'     => $location_id,
                    'number' => $location_number,
                    'name'   => TA_Localize::get_field_localized($location_id, 'location_name', $lang),
                ];
            }
        }

        // Build hierarchical_index: location_number.place_order_number
        $order_number      = (int) get_field('place_order_number', $id);
        $hierarchical_index = $location_number . '.' . $order_number;

        // Audio
        $audio    = TA_Localize::get_audio_localized($id, 'place_audio', $lang);
        $duration = get_field('place_audio_duration', $id);

        // User status
        $user_status = null;
        if ($uuid) {
            $user_status = [
                'is_checked_in'       => TA_Checkin_Model::has_checked_in($uuid, $id),
                'is_article_unlocked' => TA_Checkin_Model::is_content_unlocked($uuid, 'article', $id),
                'is_audio_unlocked'   => TA_Checkin_Model::is_content_unlocked($uuid, 'audio', $id),
            ];
        }

        $data = [
            'id'                   => $id,
            'hierarchical_index'   => $hierarchical_index,
            'order_number'         => $order_number,
            'name'                 => TA_Localize::get_field_localized($id, 'place_name', $lang),
            'info'                 => TA_Localize::get_field_localized($id, 'place_info', $lang),
            'article'              => TA_Localize::get_field_localized($id, 'place_article', $lang),
            'feature_image'        => TA_Localize::format_image(get_field('place_feature_image', $id)),
            'gallery'              => TA_Localize::format_gallery(get_field('place_gallery', $id)),
            'audio'                => $audio ? [
                'url'      => $audio['url'],
                'size'     => $audio['size'] ?? null,
                'duration' => (float) ($duration ?: 0),
            ] : null,
            'latitude'             => (float) get_field('place_lat', $id),
            'longitude'            => (float) get_field('place_lng', $id),
            'geofence_radius'      => (int) (get_field('place_geofence_radius', $id) ?: 300),
            'qr_code'              => get_field('place_qr_code', $id) ?: null,
            'is_featured'          => (bool) get_field('place_is_featured', $id),
            'show_article_free'    => (bool) get_field('place_show_article_free', $id),
            'show_audio_free'      => (bool) get_field('place_show_audio_free', $id),
            'article_offline'      => (bool) get_field('place_article_offline', $id),
            'audio_offline'        => (bool) get_field('place_audio_offline', $id),
            'article_cost'         => (int) (get_field('place_article_cost', $id) ?: 5),
            'checkin_reward'       => (int) (get_field('place_checkin_reward', $id) ?: 10),
            'sort_order'           => (int) get_field('place_sort_order', $id),
            'location'             => $location_data,
            'user_status'          => $user_status,
        ];

        // Optional includes.
        $includes = array_filter(array_map('trim', explode(',', $request->get_param('include') ?: '')));

        if (in_array('sub_places', $includes, true)) {
            $data['sub_places'] = self::get_place_sub_places($id, $lang, false);
        }

        if (in_array('sub_items', $includes, true)) {
            // sub_items include implies sub_places with their sub_items embedded.
            $data['sub_places'] = self::get_place_sub_places($id, $lang, true);
        }

        return TA_API::success($data);
    }

    // ──────────────────────────────────────────────
    // GET /places/nearby
    // ──────────────────────────────────────────────
    public static function nearby_places(WP_REST_Request $request): WP_REST_Response {
        $lat         = (float) $request->get_param('lat');
        $lng         = (float) $request->get_param('lng');
        $radius      = (int) ($request->get_param('radius') ?: 1000);
        $province_id = $request->get_param('province_id');
        $limit       = min(100, max(1, (int) ($request->get_param('limit') ?: 10)));
        $lang        = TA_Localize::get_lang($request);

        // Build query.
        $query_args = [
            'post_type'      => 'place',
            'post_status'    => 'publish',
            'posts_per_page' => -1,
        ];

        // Filter by province if provided.
        if ($province_id) {
            $location_ids = get_posts([
                'post_type'      => 'ta_location',
                'post_status'    => 'publish',
                'meta_key'       => 'location_province',
                'meta_value'     => (int) $province_id,
                'posts_per_page' => -1,
                'fields'         => 'ids',
            ]);

            if (empty($location_ids)) {
                return TA_API::success([]);
            }

            $query_args['meta_query'] = [
                [
                    'key'     => 'place_location',
                    'value'   => $location_ids,
                    'compare' => 'IN',
                ],
            ];
        }

        $posts = get_posts($query_args);

        // Compute distance and filter by radius.
        $results = [];
        foreach ($posts as $post) {
            $p_lat = (float) get_field('place_lat', $post->ID);
            $p_lng = (float) get_field('place_lng', $post->ID);

            if (!$p_lat && !$p_lng) {
                continue;
            }

            $distance_m       = TA_Geo::distance_meters($lat, $lng, $p_lat, $p_lng);
            $geofence_radius  = (int) (get_field('place_geofence_radius', $post->ID) ?: 300);

            if ($distance_m > $radius) {
                continue;
            }

            $audio = TA_Localize::get_audio_localized($post->ID, 'place_audio', $lang);

            $results[] = [
                'id'                 => $post->ID,
                'name'               => TA_Localize::get_field_localized($post->ID, 'place_name', $lang),
                'feature_image'      => TA_Localize::format_image(get_field('place_feature_image', $post->ID)),
                'latitude'           => $p_lat,
                'longitude'          => $p_lng,
                'distance_meters'    => round($distance_m),
                'geofence_radius'    => $geofence_radius,
                'is_within_geofence' => $distance_m <= $geofence_radius,
                'has_audio'          => $audio !== null,
                'is_featured'        => (bool) get_field('place_is_featured', $post->ID),
                'sort_order'         => (int) get_field('place_sort_order', $post->ID),
            ];
        }

        // Sort by nearest first.
        usort($results, function ($a, $b) {
            return $a['distance_meters'] <=> $b['distance_meters'];
        });

        // Apply limit.
        $results = array_slice($results, 0, $limit);

        return TA_API::success($results, ['total' => count($results)]);
    }

    // ──────────────────────────────────────────────
    // GET /places/qr/{code}
    // ──────────────────────────────────────────────
    public static function qr_lookup(WP_REST_Request $request): WP_REST_Response {
        $code = $request->get_param('code');
        $lang = TA_Localize::get_lang($request);

        $posts = get_posts([
            'post_type'      => 'place',
            'post_status'    => 'publish',
            'meta_key'       => 'place_qr_code',
            'meta_value'     => $code,
            'posts_per_page' => 1,
        ]);

        if (empty($posts)) {
            return TA_API::error('QR_NOT_FOUND', 'No place found for this QR code.', 404);
        }

        $post = $posts[0];
        $id   = $post->ID;

        $data = [
            'id'            => $id,
            'name'          => TA_Localize::get_field_localized($id, 'place_name', $lang),
            'feature_image' => TA_Localize::format_image(get_field('place_feature_image', $id)),
            'latitude'      => (float) get_field('place_lat', $id),
            'longitude'     => (float) get_field('place_lng', $id),
            'is_featured'   => (bool) get_field('place_is_featured', $id),
            'sort_order'    => (int) get_field('place_sort_order', $id),
        ];

        return TA_API::success($data);
    }

    // ──────────────────────────────────────────────
    // GET /places/search
    // ──────────────────────────────────────────────
    public static function search_places(WP_REST_Request $request): WP_REST_Response {
        global $wpdb;

        $q           = $request->get_param('q');
        $province_id = $request->get_param('province_id');
        $lang        = TA_Localize::get_lang($request);
        $page        = max(1, (int) ($request->get_param('page') ?: 1));
        $per_page    = min(100, max(1, (int) ($request->get_param('per_page') ?: 20)));

        // Determine which location IDs to scope to, if province is given.
        $location_ids = null;
        if ($province_id) {
            $location_ids = get_posts([
                'post_type'      => 'ta_location',
                'post_status'    => 'publish',
                'meta_key'       => 'location_province',
                'meta_value'     => (int) $province_id,
                'posts_per_page' => -1,
                'fields'         => 'ids',
            ]);

            if (empty($location_ids)) {
                return TA_API::success([], [
                    'total'    => 0,
                    'page'     => $page,
                    'per_page' => $per_page,
                    'pages'    => 0,
                ]);
            }
        }

        // Search in title via WP_Query native search.
        $title_query_args = [
            'post_type'      => 'place',
            'post_status'    => 'publish',
            's'              => $q,
            'posts_per_page' => -1,
            'fields'         => 'ids',
        ];

        if ($location_ids !== null) {
            $title_query_args['meta_query'] = [
                [
                    'key'     => 'place_location',
                    'value'   => $location_ids,
                    'compare' => 'IN',
                ],
            ];
        }

        $title_match_ids = get_posts($title_query_args);

        // Search in place_name_{lang} meta field via SQL LIKE.
        $meta_key   = 'place_name_' . $lang;
        $like_value = '%' . $wpdb->esc_like($q) . '%';

        $meta_sql = $wpdb->prepare(
            "SELECT DISTINCT pm.post_id FROM {$wpdb->postmeta} pm
             INNER JOIN {$wpdb->posts} p ON p.ID = pm.post_id
             WHERE pm.meta_key = %s
               AND pm.meta_value LIKE %s
               AND p.post_type = 'place'
               AND p.post_status = 'publish'",
            $meta_key,
            $like_value
        );
        $meta_match_ids = array_map('intval', $wpdb->get_col($meta_sql));

        // Merge results (union, no duplicates).
        $all_ids = array_unique(array_merge($title_match_ids, $meta_match_ids));

        if (empty($all_ids)) {
            return TA_API::success([], [
                'total'    => 0,
                'page'     => $page,
                'per_page' => $per_page,
                'pages'    => 0,
            ]);
        }

        // Further filter by province locations if meta search results aren't scoped yet.
        if ($location_ids !== null) {
            $filtered = [];
            foreach ($all_ids as $pid) {
                $loc_obj = get_field('place_location', $pid);
                $loc_id  = is_object($loc_obj) ? $loc_obj->ID : (int) $loc_obj;
                if (in_array($loc_id, $location_ids, true)) {
                    $filtered[] = $pid;
                }
            }
            $all_ids = $filtered;
        }

        if (empty($all_ids)) {
            return TA_API::success([], [
                'total'    => 0,
                'page'     => $page,
                'per_page' => $per_page,
                'pages'    => 0,
            ]);
        }

        // Compute match_score: 2 = matched in both title and meta, 1 = matched in one.
        $results = [];
        foreach ($all_ids as $pid) {
            $in_title = in_array($pid, $title_match_ids, true);
            $in_meta  = in_array($pid, $meta_match_ids, true);

            $score = 0;
            if ($in_title) $score++;
            if ($in_meta) $score++;

            $results[] = [
                'post_id'     => $pid,
                'match_score' => $score,
            ];
        }

        // Sort by match_score descending.
        usort($results, function ($a, $b) {
            return $b['match_score'] <=> $a['match_score'];
        });

        // Pagination.
        $total  = count($results);
        $pages  = (int) ceil($total / $per_page);
        $offset = ($page - 1) * $per_page;
        $paged  = array_slice($results, $offset, $per_page);

        // Format results.
        $items = [];
        foreach ($paged as $entry) {
            $post = get_post($entry['post_id']);
            if (!$post) continue;

            $items[] = [
                'id'            => $post->ID,
                'name'          => TA_Localize::get_field_localized($post->ID, 'place_name', $lang),
                'info'          => TA_Localize::get_field_localized($post->ID, 'place_info', $lang),
                'feature_image' => TA_Localize::format_image(get_field('place_feature_image', $post->ID)),
                'latitude'      => (float) get_field('place_lat', $post->ID),
                'longitude'     => (float) get_field('place_lng', $post->ID),
                'is_featured'   => (bool) get_field('place_is_featured', $post->ID),
                'sort_order'    => (int) get_field('place_sort_order', $post->ID),
                'match_score'   => $entry['match_score'],
            ];
        }

        return TA_API::success($items, [
            'total'    => $total,
            'page'     => $page,
            'per_page' => $per_page,
            'pages'    => $pages,
        ]);
    }

    // ──────────────────────────────────────────────
    // Format helpers
    // ──────────────────────────────────────────────

    /**
     * Compact place for list endpoint.
     */
    private static function format_place_list(WP_Post $post, string $lang, bool $has_coords, float $lat, float $lng): array {
        $id    = $post->ID;
        $p_lat = (float) get_field('place_lat', $id);
        $p_lng = (float) get_field('place_lng', $id);

        $item = [
            'id'            => $id,
            'order_number'  => (int) get_field('place_order_number', $id),
            'name'          => TA_Localize::get_field_localized($id, 'place_name', $lang),
            'info'          => TA_Localize::get_field_localized($id, 'place_info', $lang),
            'feature_image' => TA_Localize::format_image(get_field('place_feature_image', $id)),
            'latitude'      => $p_lat,
            'longitude'     => $p_lng,
            'is_featured'   => (bool) get_field('place_is_featured', $id),
            'sort_order'    => (int) get_field('place_sort_order', $id),
            'sub_places_count' => self::count_sub_places($id),
        ];

        if ($has_coords && $p_lat && $p_lng) {
            $item['distance_km'] = round(TA_Geo::distance_km($lat, $lng, $p_lat, $p_lng), 2);
        }

        return $item;
    }

    /**
     * Sub-places belonging to a place, with optional sub_items.
     */
    private static function get_place_sub_places(int $place_id, string $lang, bool $include_sub_items): array {
        $posts = get_posts([
            'post_type'      => 'sub_place',
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
            'posts_per_page' => -1,
        ]);

        $items = [];
        foreach ($posts as $sp) {
            $sp_id = $sp->ID;
            $audio = TA_Localize::get_audio_localized($sp_id, 'sub_place_audio', $lang);
            $duration = get_field('sub_place_audio_duration', $sp_id);

            $entry = [
                'id'              => $sp_id,
                'sub_place_index' => get_field('sub_place_index', $sp_id) ?: '',
                'name'            => TA_Localize::get_field_localized($sp_id, 'sub_place_name', $lang),
                'description'     => TA_Localize::get_field_localized($sp_id, 'sub_place_desc', $lang),
                'feature_image'   => TA_Localize::format_image(get_field('sub_place_feature_image', $sp_id)),
                'audio'           => $audio ? [
                    'url'      => $audio['url'],
                    'duration' => (float) ($duration ?: 0),
                ] : null,
                'latitude'        => (float) (get_field('sub_place_lat', $sp_id) ?: 0),
                'longitude'       => (float) (get_field('sub_place_lng', $sp_id) ?: 0),
                'sort_order'      => (int) (get_field('sub_place_sort_order', $sp_id) ?: 0),
            ];

            if ($include_sub_items) {
                $entry['sub_items'] = self::get_sub_items($sp_id, $lang);
            }

            $items[] = $entry;
        }

        return $items;
    }

    /**
     * Sub-items belonging to a sub-place.
     */
    private static function get_sub_items(int $sub_place_id, string $lang): array {
        $posts = get_posts([
            'post_type'      => 'sub_item',
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
            'posts_per_page' => -1,
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

    /**
     * Count sub_place posts belonging to a place.
     */
    private static function count_sub_places(int $place_id): int {
        $query = new WP_Query([
            'post_type'      => 'sub_place',
            'post_status'    => 'publish',
            'meta_key'       => 'sub_place_place',
            'meta_value'     => $place_id,
            'posts_per_page' => -1,
            'fields'         => 'ids',
            'no_found_rows'  => true,
        ]);
        return $query->post_count;
    }

    // ──────────────────────────────────────────────
    // Validation
    // ──────────────────────────────────────────────

    public static function validate_lat($value): bool {
        return is_numeric($value) && (float) $value >= -90 && (float) $value <= 90;
    }

    public static function validate_lng($value): bool {
        return is_numeric($value) && (float) $value >= -180 && (float) $value <= 180;
    }
}
