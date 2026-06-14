<?php
defined('ABSPATH') || exit;

class TA_EP_Sync {

    public static function register_routes() {
        // Check for data updates.
        register_rest_route(TA_API_NAMESPACE, '/sync/check', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'check_updates'],
            'permission_callback' => '__return_true',
            'args'                => [
                'province_id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'since' => [
                    'required'          => true,
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);

        // Download full offline package.
        register_rest_route(TA_API_NAMESPACE, '/sync/package/(?P<province_id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_package'],
            'permission_callback' => '__return_true',
            'args'                => [
                'province_id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'lang' => [
                    'type'    => 'string',
                    'default' => TA_DEFAULT_LANG,
                ],
                'since' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'include_media_urls' => [
                    'type'    => 'boolean',
                    'default' => true,
                ],
            ],
        ]);

        // Media manifest for offline download.
        register_rest_route(TA_API_NAMESPACE, '/sync/media/(?P<province_id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_media_manifest'],
            'permission_callback' => '__return_true',
            'args'                => [
                'province_id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'type' => [
                    'type'    => 'string',
                    'default' => 'all',
                    'enum'    => ['all', 'images', 'audio'],
                ],
                'lang' => [
                    'type'    => 'string',
                    'default' => TA_DEFAULT_LANG,
                ],
                'since' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /sync/check
    // ──────────────────────────────────────────────
    public static function check_updates(WP_REST_Request $request): WP_REST_Response {
        $province_id = (int) $request->get_param('province_id');
        $since       = $request->get_param('since');

        // Validate province exists.
        $province = get_post($province_id);
        if (!$province || $province->post_type !== 'province' || $province->post_status !== 'publish') {
            return TA_API::error('province_not_found', 'Province not found.', 404);
        }

        // Validate ISO 8601 timestamp.
        $since_time = strtotime($since);
        if ($since_time === false) {
            return TA_API::error('INVALID_TIMESTAMP', 'The "since" parameter must be a valid ISO 8601 timestamp.', 400);
        }

        // Get location IDs for this province.
        $location_ids = self::get_province_location_ids($province_id);

        // Get place IDs for these locations.
        $place_ids = self::get_place_ids_by_locations($location_ids);

        // Get sub_place IDs for these places.
        $sub_place_ids = self::get_sub_place_ids_by_places($place_ids);

        // Count modified posts for each content type.
        $date_query = [['after' => $since, 'column' => 'post_modified']];

        $changes = [
            'provinces'  => self::count_changes('province', $since, [['key' => 'province_is_active', 'value' => '1']], [$province_id]),
            'locations'  => self::count_changes_by_ids('ta_location', $since, $location_ids),
            'places'     => self::count_changes_by_ids('place', $since, $place_ids),
            'sub_places' => self::count_changes_by_ids('sub_place', $since, $sub_place_ids),
            'sub_items'  => self::count_changes_sub_items($since, $sub_place_ids),
            'journeys'   => self::count_changes('journey', $since, [['key' => 'journey_province', 'value' => $province_id]]),
            'news'       => self::count_changes('news_alert', $since, [['key' => 'news_province', 'value' => $province_id]]),
        ];

        // Determine overall last_modified and has_updates.
        $total_updated = 0;
        $last_modified = $since;

        foreach ($changes as $type => &$counts) {
            $total_updated += $counts['updated'];

            // Track last_modified per type.
            if (!empty($counts['last_modified']) && $counts['last_modified'] > $last_modified) {
                $last_modified = $counts['last_modified'];
            }
        }
        unset($counts);

        $has_updates = $total_updated > 0;

        // Estimate download size: ~2KB per text item.
        $estimated_bytes = $total_updated * 2048;
        $estimated_mb    = round($estimated_bytes / (1024 * 1024), 2);

        return TA_API::success([
            'has_updates'             => $has_updates,
            'last_modified'           => $last_modified,
            'changes'                 => $changes,
            'estimated_download_size_mb' => $estimated_mb,
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /sync/package/{province_id}
    // ──────────────────────────────────────────────
    public static function get_package(WP_REST_Request $request): WP_REST_Response {
        $province_id      = (int) $request->get_param('province_id');
        $lang             = TA_Localize::get_lang($request);
        $since            = $request->get_param('since');
        $include_media    = (bool) $request->get_param('include_media_urls');

        // Validate province exists.
        $province_post = get_post($province_id);
        if (!$province_post || $province_post->post_type !== 'province' || $province_post->post_status !== 'publish') {
            return TA_API::error('province_not_found', 'Province not found.', 404);
        }

        // Build date_query for incremental sync.
        $date_query = [];
        if (!empty($since)) {
            $since_time = strtotime($since);
            if ($since_time === false) {
                return TA_API::error('INVALID_TIMESTAMP', 'The "since" parameter must be a valid ISO 8601 timestamp.', 400);
            }
            $date_query = [['after' => $since, 'column' => 'post_modified']];
        }

        // Province data.
        $province_data = [
            'id'            => $province_id,
            'name'          => TA_Localize::get_field_localized($province_id, 'province_name', $lang),
            'feature_image' => TA_Localize::format_image(get_field('province_feature_image', $province_id)),
            'latitude'      => (float) get_field('province_lat', $province_id),
            'longitude'     => (float) get_field('province_lng', $province_id),
        ];

        // Get all location IDs for this province (always need full set for hierarchy).
        $all_location_ids = self::get_province_location_ids($province_id);

        // Locations.
        $locations = self::build_locations_data($all_location_ids, $lang, $date_query);

        // Get all place IDs (need full set for hierarchy).
        $all_place_ids = self::get_place_ids_by_locations($all_location_ids);

        // Places.
        $places = self::build_places_data($all_place_ids, $lang, $date_query);

        // Get all sub_place IDs (need full set for hierarchy).
        $all_sub_place_ids = self::get_sub_place_ids_by_places($all_place_ids);

        // Sub-places.
        $sub_places = self::build_sub_places_data($all_sub_place_ids, $lang, $date_query);

        // Sub-items.
        $sub_items = self::build_sub_items_data($all_sub_place_ids, $lang, $date_query);

        // Journeys.
        $journeys = self::build_journeys_data($province_id, $lang, $date_query);

        // News.
        $news = self::build_news_data($province_id, $lang, $date_query);

        // Build package.
        $package = [
            'province'   => $province_data,
            'locations'  => $locations,
            'places'     => $places,
            'sub_places' => $sub_places,
            'sub_items'  => $sub_items,
            'journeys'   => $journeys,
            'news'       => $news,
        ];

        // Media manifest.
        $total_media_size = 0;
        if ($include_media) {
            $media_manifest = self::collect_media_manifest($places, $sub_places, $sub_items);
            $package['media_manifest'] = $media_manifest;

            foreach ($media_manifest as $entry) {
                $total_media_size += $entry['size_bytes'];
            }
        }

        $package['sync_version']       = current_time('timestamp');
        $package['total_media_size_mb'] = round($total_media_size / (1024 * 1024), 2);

        // Require device UUID — reject anonymous requests.
        $uuid = TA_Auth::get_device_uuid($request);
        if (!$uuid) {
            return TA_API::error('DEVICE_REQUIRED', 'Missing X-Device-UUID header.', 401);
        }

        // Auto-track download.
        $file_count = count($locations) + count($places) + count($sub_places)
                    + count($sub_items) + count($journeys) + count($news);
        $size_mb    = round($total_media_size / (1024 * 1024), 2);

        $dl_id = TA_Download_Model::start($uuid, $province_id, empty($since) ? 'full' : 'incremental', $lang);
        TA_Download_Model::complete($dl_id, [
            'status'        => 'completed',
            'file_count'    => $file_count,
            'total_size_mb' => $size_mb,
        ]);

        return TA_API::success($package);
    }

    // ──────────────────────────────────────────────
    // GET /sync/media/{province_id}
    // ──────────────────────────────────────────────
    public static function get_media_manifest(WP_REST_Request $request): WP_REST_Response {
        $province_id = (int) $request->get_param('province_id');
        $type        = $request->get_param('type') ?: 'all';
        $lang        = TA_Localize::get_lang($request);
        $since       = $request->get_param('since');

        // Validate province exists.
        $province_post = get_post($province_id);
        if (!$province_post || $province_post->post_type !== 'province' || $province_post->post_status !== 'publish') {
            return TA_API::error('province_not_found', 'Province not found.', 404);
        }

        // Build date_query.
        $date_query = [];
        if (!empty($since)) {
            $since_time = strtotime($since);
            if ($since_time === false) {
                return TA_API::error('INVALID_TIMESTAMP', 'The "since" parameter must be a valid ISO 8601 timestamp.', 400);
            }
            $date_query = [['after' => $since, 'column' => 'post_modified']];
        }

        // Get hierarchy IDs.
        $location_ids  = self::get_province_location_ids($province_id);
        $place_ids     = self::get_place_ids_by_locations($location_ids);
        $sub_place_ids = self::get_sub_place_ids_by_places($place_ids);

        $files        = [];
        $total_images = 0;
        $total_audio  = 0;
        $total_size   = 0;

        // Collect from places.
        $place_posts = self::get_posts_by_ids('place', $place_ids, $date_query);
        foreach ($place_posts as $post) {
            $id = $post->ID;

            if ($type === 'all' || $type === 'images') {
                // Feature image.
                $img = get_field('place_feature_image', $id);
                $formatted = TA_Localize::format_image($img);
                if ($formatted && !empty($formatted['url'])) {
                    $size = self::get_image_size_bytes($img);
                    $files[] = [
                        'id'         => "img_{$id}_feature",
                        'type'       => 'image',
                        'url'        => $formatted['url'],
                        'size_bytes' => $size,
                        'checksum'   => md5($formatted['url']),
                        'related_to' => ['type' => 'place', 'id' => $id],
                    ];
                    $total_images++;
                    $total_size += $size;
                }

                // Gallery.
                $gallery = get_field('place_gallery', $id);
                if (!empty($gallery) && is_array($gallery)) {
                    foreach ($gallery as $gi => $gimg) {
                        $formatted = TA_Localize::format_image($gimg);
                        if ($formatted && !empty($formatted['url'])) {
                            $size = self::get_image_size_bytes($gimg);
                            $files[] = [
                                'id'         => "img_{$id}_gallery_{$gi}",
                                'type'       => 'image',
                                'url'        => $formatted['url'],
                                'size_bytes' => $size,
                                'checksum'   => md5($formatted['url']),
                                'related_to' => ['type' => 'place', 'id' => $id],
                            ];
                            $total_images++;
                            $total_size += $size;
                        }
                    }
                }
            }

            if ($type === 'all' || $type === 'audio') {
                $audio = TA_Localize::get_audio_localized($id, 'place_audio', $lang);
                if ($audio && !empty($audio['url'])) {
                    $size = $audio['size'] ?? 0;
                    $files[] = [
                        'id'         => "audio_{$id}",
                        'type'       => 'audio',
                        'url'        => $audio['url'],
                        'size_bytes' => (int) $size,
                        'checksum'   => md5($audio['url']),
                        'related_to' => ['type' => 'place', 'id' => $id],
                    ];
                    $total_audio++;
                    $total_size += (int) $size;
                }
            }
        }

        // Collect from sub_places.
        $sub_place_posts = self::get_posts_by_ids('sub_place', $sub_place_ids, $date_query);
        foreach ($sub_place_posts as $post) {
            $id = $post->ID;

            if ($type === 'all' || $type === 'images') {
                $img = get_field('sub_place_feature_image', $id);
                $formatted = TA_Localize::format_image($img);
                if ($formatted && !empty($formatted['url'])) {
                    $size = self::get_image_size_bytes($img);
                    $files[] = [
                        'id'         => "img_{$id}_feature",
                        'type'       => 'image',
                        'url'        => $formatted['url'],
                        'size_bytes' => $size,
                        'checksum'   => md5($formatted['url']),
                        'related_to' => ['type' => 'sub_place', 'id' => $id],
                    ];
                    $total_images++;
                    $total_size += $size;
                }
            }

            if ($type === 'all' || $type === 'audio') {
                $audio = TA_Localize::get_audio_localized($id, 'sub_place_audio', $lang);
                if ($audio && !empty($audio['url'])) {
                    $size = $audio['size'] ?? 0;
                    $files[] = [
                        'id'         => "audio_{$id}",
                        'type'       => 'audio',
                        'url'        => $audio['url'],
                        'size_bytes' => (int) $size,
                        'checksum'   => md5($audio['url']),
                        'related_to' => ['type' => 'sub_place', 'id' => $id],
                    ];
                    $total_audio++;
                    $total_size += (int) $size;
                }
            }
        }

        // Collect from sub_items.
        $sub_item_posts = self::get_posts_by_ids_via_meta('sub_item', 'sub_item_sub_place', $sub_place_ids, $date_query);
        foreach ($sub_item_posts as $post) {
            $id = $post->ID;

            if ($type === 'all' || $type === 'images') {
                // Feature image.
                $img = get_field('sub_item_feature_image', $id);
                $formatted = TA_Localize::format_image($img);
                if ($formatted && !empty($formatted['url'])) {
                    $size = self::get_image_size_bytes($img);
                    $files[] = [
                        'id'         => "img_{$id}_feature",
                        'type'       => 'image',
                        'url'        => $formatted['url'],
                        'size_bytes' => $size,
                        'checksum'   => md5($formatted['url']),
                        'related_to' => ['type' => 'sub_item', 'id' => $id],
                    ];
                    $total_images++;
                    $total_size += $size;
                }

                // Gallery.
                $gallery = get_field('sub_item_gallery', $id);
                if (!empty($gallery) && is_array($gallery)) {
                    foreach ($gallery as $gi => $gimg) {
                        $formatted = TA_Localize::format_image($gimg);
                        if ($formatted && !empty($formatted['url'])) {
                            $size = self::get_image_size_bytes($gimg);
                            $files[] = [
                                'id'         => "img_{$id}_gallery_{$gi}",
                                'type'       => 'image',
                                'url'        => $formatted['url'],
                                'size_bytes' => $size,
                                'checksum'   => md5($formatted['url']),
                                'related_to' => ['type' => 'sub_item', 'id' => $id],
                            ];
                            $total_images++;
                            $total_size += $size;
                        }
                    }
                }
            }

            if ($type === 'all' || $type === 'audio') {
                $audio = TA_Localize::get_audio_localized($id, 'sub_item_audio', $lang);
                if ($audio && !empty($audio['url'])) {
                    $size = $audio['size'] ?? 0;
                    $files[] = [
                        'id'         => "audio_{$id}",
                        'type'       => 'audio',
                        'url'        => $audio['url'],
                        'size_bytes' => (int) $size,
                        'checksum'   => md5($audio['url']),
                        'related_to' => ['type' => 'sub_item', 'id' => $id],
                    ];
                    $total_audio++;
                    $total_size += (int) $size;
                }
            }
        }

        $total_files = count($files);
        $size_mb     = round($total_size / (1024 * 1024), 2);

        // Require device UUID — reject anonymous requests.
        $uuid = TA_Auth::get_device_uuid($request);
        if (!$uuid) {
            return TA_API::error('DEVICE_REQUIRED', 'Missing X-Device-UUID header.', 401);
        }

        // Auto-track media download.
        $dl_id = TA_Download_Model::start($uuid, $province_id, 'media_only', $lang);
        TA_Download_Model::complete($dl_id, [
            'status'        => 'completed',
            'file_count'    => $total_files,
            'total_size_mb' => $size_mb,
        ]);

        return TA_API::success([
            'files'   => $files,
            'summary' => [
                'total_files'   => $total_files,
                'total_images'  => $total_images,
                'total_audio'   => $total_audio,
                'total_size_mb' => $size_mb,
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // Hierarchy helpers
    // ──────────────────────────────────────────────

    /**
     * Get all ta_location IDs belonging to a province.
     */
    private static function get_province_location_ids(int $province_id): array {
        return get_posts([
            'post_type'      => 'ta_location',
            'post_status'    => 'publish',
            'meta_key'       => 'location_province',
            'meta_value'     => $province_id,
            'posts_per_page' => -1,
            'fields'         => 'ids',
        ]);
    }

    /**
     * Get all place IDs belonging to a set of locations.
     */
    private static function get_place_ids_by_locations(array $location_ids): array {
        if (empty($location_ids)) {
            return [];
        }

        return get_posts([
            'post_type'      => 'place',
            'post_status'    => 'publish',
            'meta_query'     => [
                ['key' => 'place_location', 'value' => $location_ids, 'compare' => 'IN'],
            ],
            'posts_per_page' => -1,
            'fields'         => 'ids',
        ]);
    }

    /**
     * Get all sub_place IDs belonging to a set of places.
     */
    private static function get_sub_place_ids_by_places(array $place_ids): array {
        if (empty($place_ids)) {
            return [];
        }

        return get_posts([
            'post_type'      => 'sub_place',
            'post_status'    => 'publish',
            'meta_query'     => [
                ['key' => 'sub_place_place', 'value' => $place_ids, 'compare' => 'IN'],
            ],
            'posts_per_page' => -1,
            'fields'         => 'ids',
        ]);
    }

    // ──────────────────────────────────────────────
    // Change-counting helpers (for /sync/check)
    // ──────────────────────────────────────────────

    /**
     * Count posts of a type modified after $since, filtered by meta_query.
     * Optionally restrict to specific post IDs.
     */
    private static function count_changes(string $post_type, string $since, array $meta_query = [], array $post_ids = []): array {
        $args = [
            'post_type'      => $post_type,
            'post_status'    => 'publish',
            'posts_per_page' => -1,
            'date_query'     => [['after' => $since, 'column' => 'post_modified']],
            'fields'         => 'ids',
        ];

        if (!empty($meta_query)) {
            $args['meta_query'] = $meta_query;
        }

        if (!empty($post_ids)) {
            $args['post__in'] = $post_ids;
        }

        $posts = get_posts($args);
        $last_modified = '';

        if (!empty($posts)) {
            foreach ($posts as $pid) {
                $mod = get_post_field('post_modified', $pid);
                if ($mod > $last_modified) {
                    $last_modified = $mod;
                }
            }
        }

        return [
            'updated'       => count($posts),
            'last_modified' => $last_modified ?: null,
        ];
    }

    /**
     * Count changes for posts whose IDs are already known.
     */
    private static function count_changes_by_ids(string $post_type, string $since, array $ids): array {
        if (empty($ids)) {
            return ['updated' => 0, 'last_modified' => null];
        }

        return self::count_changes($post_type, $since, [], $ids);
    }

    /**
     * Count sub_item changes via their parent sub_place IDs.
     */
    private static function count_changes_sub_items(string $since, array $sub_place_ids): array {
        if (empty($sub_place_ids)) {
            return ['updated' => 0, 'last_modified' => null];
        }

        return self::count_changes('sub_item', $since, [
            ['key' => 'sub_item_sub_place', 'value' => $sub_place_ids, 'compare' => 'IN'],
        ]);
    }

    // ──────────────────────────────────────────────
    // Package data builders (for /sync/package)
    // ──────────────────────────────────────────────

    /**
     * Build locations data for the sync package.
     */
    private static function build_locations_data(array $location_ids, string $lang, array $date_query): array {
        $posts = self::get_posts_by_ids('ta_location', $location_ids, $date_query);
        $items = [];

        foreach ($posts as $post) {
            $id = $post->ID;
            $items[] = [
                'id'              => $id,
                'location_number' => (int) get_field('location_number', $id),
                'name'            => TA_Localize::get_field_localized($id, 'location_name', $lang),
                'description'     => TA_Localize::get_field_localized($id, 'location_desc', $lang),
                'feature_image'   => TA_Localize::format_image(get_field('location_feature_image', $id)),
                'latitude'        => (float) get_field('location_lat', $id),
                'longitude'       => (float) get_field('location_lng', $id),
            ];
        }

        return $items;
    }

    /**
     * Build places data for the sync package.
     */
    private static function build_places_data(array $place_ids, string $lang, array $date_query): array {
        $posts = self::get_posts_by_ids('place', $place_ids, $date_query);
        $items = [];

        foreach ($posts as $post) {
            $id    = $post->ID;
            $audio = TA_Localize::get_audio_localized($id, 'place_audio', $lang);
            $duration = get_field('place_audio_duration', $id);

            $items[] = [
                'id'                => $id,
                'place_order_number' => (int) get_field('place_order_number', $id),
                'name'              => TA_Localize::get_field_localized($id, 'place_name', $lang),
                'information'       => TA_Localize::get_field_localized($id, 'place_info', $lang),
                'article'           => TA_Localize::get_field_localized($id, 'place_article', $lang),
                'feature_image'     => TA_Localize::format_image(get_field('place_feature_image', $id)),
                'gallery'           => TA_Localize::format_gallery(get_field('place_gallery', $id)),
                'audio'             => $audio ? [
                    'url'      => $audio['url'],
                    'duration' => (float) ($duration ?: 0),
                ] : null,
                'latitude'          => (float) get_field('place_lat', $id),
                'longitude'         => (float) get_field('place_lng', $id),
                'geofence_radius'   => (int) (get_field('place_geofence_radius', $id) ?: 300),
                'qr_code'           => get_field('place_qr_code', $id) ?: null,
                'checkin_reward'    => (int) (get_field('place_checkin_reward', $id) ?: 10),
                'article_cost'      => (int) (get_field('place_article_cost', $id) ?: 5),
                'show_article_free' => (bool) get_field('place_show_article_free', $id),
                'show_audio_free'   => (bool) get_field('place_show_audio_free', $id),
            ];
        }

        return $items;
    }

    /**
     * Build sub_places data for the sync package.
     */
    private static function build_sub_places_data(array $sub_place_ids, string $lang, array $date_query): array {
        $posts = self::get_posts_by_ids('sub_place', $sub_place_ids, $date_query);
        $items = [];

        foreach ($posts as $post) {
            $id    = $post->ID;
            $audio = TA_Localize::get_audio_localized($id, 'sub_place_audio', $lang);

            // Resolve parent place ID.
            $place_obj = get_field('sub_place_place', $id);
            $place_id  = is_object($place_obj) ? $place_obj->ID : (int) $place_obj;

            $items[] = [
                'id'              => $id,
                'sub_place_index' => get_field('sub_place_index', $id) ?: '',
                'name'            => TA_Localize::get_field_localized($id, 'sub_place_name', $lang),
                'description'     => TA_Localize::get_field_localized($id, 'sub_place_desc', $lang),
                'feature_image'   => TA_Localize::format_image(get_field('sub_place_feature_image', $id)),
                'audio'           => $audio,
                'latitude'        => (float) (get_field('sub_place_lat', $id) ?: 0),
                'longitude'       => (float) (get_field('sub_place_lng', $id) ?: 0),
                'place_id'        => $place_id,
            ];
        }

        return $items;
    }

    /**
     * Build sub_items data for the sync package.
     */
    private static function build_sub_items_data(array $sub_place_ids, string $lang, array $date_query): array {
        if (empty($sub_place_ids)) {
            return [];
        }

        $args = [
            'post_type'      => 'sub_item',
            'post_status'    => 'publish',
            'meta_query'     => [
                ['key' => 'sub_item_sub_place', 'value' => $sub_place_ids, 'compare' => 'IN'],
            ],
            'posts_per_page' => -1,
        ];

        if (!empty($date_query)) {
            $args['date_query'] = $date_query;
        }

        $posts = get_posts($args);
        $items = [];

        foreach ($posts as $post) {
            $id    = $post->ID;
            $audio = TA_Localize::get_audio_localized($id, 'sub_item_audio', $lang);

            // Resolve parent sub_place ID.
            $sp_obj = get_field('sub_item_sub_place', $id);
            $sp_id  = is_object($sp_obj) ? $sp_obj->ID : (int) $sp_obj;

            $items[] = [
                'id'            => $id,
                'item_index'    => get_field('sub_item_index', $id) ?: '',
                'name'          => TA_Localize::get_field_localized($id, 'sub_item_name', $lang),
                'description'   => TA_Localize::get_field_localized($id, 'sub_item_desc', $lang),
                'feature_image' => TA_Localize::format_image(get_field('sub_item_feature_image', $id)),
                'gallery'       => TA_Localize::format_gallery(get_field('sub_item_gallery', $id)),
                'audio'         => $audio,
                'sub_place_id'  => $sp_id,
            ];
        }

        return $items;
    }

    /**
     * Build journeys data for the sync package.
     */
    private static function build_journeys_data(int $province_id, string $lang, array $date_query): array {
        $args = [
            'post_type'      => 'journey',
            'post_status'    => 'publish',
            'meta_query'     => [
                ['key' => 'journey_province', 'value' => $province_id],
            ],
            'posts_per_page' => -1,
        ];

        if (!empty($date_query)) {
            $args['date_query'] = $date_query;
        }

        $posts = get_posts($args);
        $items = [];

        foreach ($posts as $post) {
            $id = $post->ID;

            $items[] = [
                'id'            => $id,
                'name'          => TA_Localize::get_field_localized($id, 'journey_name', $lang),
                'description'   => TA_Localize::get_field_localized($id, 'journey_desc', $lang),
                'feature_image' => TA_Localize::format_image(get_field('journey_feature_image', $id)),
                'duration_days' => (int) get_field('journey_duration_days', $id),
                'difficulty'    => get_field('journey_difficulty', $id) ?: 'easy',
                'stops'         => self::format_journey_stops($id, $lang),
            ];
        }

        return $items;
    }

    /**
     * Build news data for the sync package.
     */
    private static function build_news_data(int $province_id, string $lang, array $date_query): array {
        $today = date('Ymd');

        $meta_query = [
            'relation' => 'AND',
            ['key' => 'news_province', 'value' => $province_id],
            ['key' => 'news_start_date', 'value' => $today, 'compare' => '<=', 'type' => 'DATE'],
            [
                'relation' => 'OR',
                ['key' => 'news_end_date', 'value' => $today, 'compare' => '>=', 'type' => 'DATE'],
                ['key' => 'news_end_date', 'value' => '', 'compare' => '='],
                ['key' => 'news_end_date', 'compare' => 'NOT EXISTS'],
            ],
        ];

        $args = [
            'post_type'      => 'news_alert',
            'post_status'    => 'publish',
            'meta_query'     => $meta_query,
            'posts_per_page' => -1,
        ];

        if (!empty($date_query)) {
            $args['date_query'] = $date_query;
        }

        $posts = get_posts($args);
        $items = [];

        foreach ($posts as $post) {
            $id = $post->ID;

            $items[] = [
                'id'         => $id,
                'type'       => get_field('news_type', $id) ?: 'news',
                'title'      => TA_Localize::get_field_localized($id, 'news_title', $lang),
                'content'    => TA_Localize::get_field_localized($id, 'news_content', $lang),
                'icon'       => get_field('news_icon', $id) ?: 'info',
                'is_pinned'  => (bool) get_field('news_is_pinned', $id),
                'start_date' => get_field('news_start_date', $id) ?: null,
                'end_date'   => get_field('news_end_date', $id) ?: null,
                'created_at' => $post->post_date,
            ];
        }

        return $items;
    }

    /**
     * Format journey stops from ACF repeater for sync package.
     */
    private static function format_journey_stops(int $journey_id, string $lang): array {
        $rows = get_field('journey_stops', $journey_id);

        if (empty($rows) || !is_array($rows)) {
            return [];
        }

        $stops = [];

        foreach ($rows as $row) {
            $place_post = $row['journey_stop_place'] ?? null;

            if (is_numeric($place_post)) {
                $place_post = get_post((int) $place_post);
            }

            $place_data = null;
            if ($place_post instanceof WP_Post) {
                $pid = $place_post->ID;
                $place_data = [
                    'id'   => $pid,
                    'name' => TA_Localize::get_field_localized($pid, 'place_name', $lang),
                    'lat'  => (float) get_field('place_lat', $pid),
                    'lng'  => (float) get_field('place_lng', $pid),
                ];
            }

            $stops[] = [
                'stop_order'   => (int) ($row['journey_stop_order'] ?? 0),
                'day'          => (int) ($row['journey_stop_day'] ?? 1),
                'place'        => $place_data,
                'duration_min' => (int) ($row['journey_stop_duration'] ?? 0),
            ];
        }

        usort($stops, function ($a, $b) {
            return $a['stop_order'] <=> $b['stop_order'];
        });

        return $stops;
    }

    // ──────────────────────────────────────────────
    // Post query helpers
    // ──────────────────────────────────────────────

    /**
     * Get posts by a list of IDs with optional date_query.
     */
    private static function get_posts_by_ids(string $post_type, array $ids, array $date_query = []): array {
        if (empty($ids)) {
            return [];
        }

        $args = [
            'post_type'      => $post_type,
            'post_status'    => 'publish',
            'post__in'       => $ids,
            'posts_per_page' => -1,
        ];

        if (!empty($date_query)) {
            $args['date_query'] = $date_query;
        }

        return get_posts($args);
    }

    /**
     * Get posts by meta relationship with optional date_query.
     */
    private static function get_posts_by_ids_via_meta(string $post_type, string $meta_key, array $meta_values, array $date_query = []): array {
        if (empty($meta_values)) {
            return [];
        }

        $args = [
            'post_type'      => $post_type,
            'post_status'    => 'publish',
            'meta_query'     => [
                ['key' => $meta_key, 'value' => $meta_values, 'compare' => 'IN'],
            ],
            'posts_per_page' => -1,
        ];

        if (!empty($date_query)) {
            $args['date_query'] = $date_query;
        }

        return get_posts($args);
    }

    // ──────────────────────────────────────────────
    // Media helpers
    // ──────────────────────────────────────────────

    /**
     * Collect media manifest from formatted package data arrays.
     */
    private static function collect_media_manifest(array $places, array $sub_places, array $sub_items): array {
        $manifest = [];

        // Places: feature_image, gallery, audio.
        foreach ($places as $place) {
            $id = $place['id'];

            if (!empty($place['feature_image']['url'])) {
                $manifest[] = [
                    'type'       => 'image',
                    'url'        => $place['feature_image']['url'],
                    'size_bytes' => 0,
                    'checksum'   => md5($place['feature_image']['url']),
                ];
            }

            if (!empty($place['gallery'])) {
                foreach ($place['gallery'] as $img) {
                    if (!empty($img['url'])) {
                        $manifest[] = [
                            'type'       => 'image',
                            'url'        => $img['url'],
                            'size_bytes' => 0,
                            'checksum'   => md5($img['url']),
                        ];
                    }
                }
            }

            if (!empty($place['audio']['url'])) {
                $manifest[] = [
                    'type'       => 'audio',
                    'url'        => $place['audio']['url'],
                    'size_bytes' => 0,
                    'checksum'   => md5($place['audio']['url']),
                ];
            }
        }

        // Sub-places: feature_image, audio.
        foreach ($sub_places as $sp) {
            if (!empty($sp['feature_image']['url'])) {
                $manifest[] = [
                    'type'       => 'image',
                    'url'        => $sp['feature_image']['url'],
                    'size_bytes' => 0,
                    'checksum'   => md5($sp['feature_image']['url']),
                ];
            }

            if (!empty($sp['audio']['url'])) {
                $manifest[] = [
                    'type'       => 'audio',
                    'url'        => $sp['audio']['url'],
                    'size_bytes' => 0,
                    'checksum'   => md5($sp['audio']['url']),
                ];
            }
        }

        // Sub-items: feature_image, gallery, audio.
        foreach ($sub_items as $si) {
            if (!empty($si['feature_image']['url'])) {
                $manifest[] = [
                    'type'       => 'image',
                    'url'        => $si['feature_image']['url'],
                    'size_bytes' => 0,
                    'checksum'   => md5($si['feature_image']['url']),
                ];
            }

            if (!empty($si['gallery'])) {
                foreach ($si['gallery'] as $img) {
                    if (!empty($img['url'])) {
                        $manifest[] = [
                            'type'       => 'image',
                            'url'        => $img['url'],
                            'size_bytes' => 0,
                            'checksum'   => md5($img['url']),
                        ];
                    }
                }
            }

            if (!empty($si['audio']['url'])) {
                $manifest[] = [
                    'type'       => 'audio',
                    'url'        => $si['audio']['url'],
                    'size_bytes' => 0,
                    'checksum'   => md5($si['audio']['url']),
                ];
            }
        }

        return $manifest;
    }

    /**
     * Get image file size in bytes from an ACF image field value.
     */
    private static function get_image_size_bytes($image): int {
        if (is_array($image) && isset($image['filesize'])) {
            return (int) $image['filesize'];
        }

        if (is_array($image) && isset($image['ID'])) {
            $path = get_attached_file($image['ID']);
            if ($path && file_exists($path)) {
                return (int) filesize($path);
            }
        }

        if (is_numeric($image)) {
            $path = get_attached_file((int) $image);
            if ($path && file_exists($path)) {
                return (int) filesize($path);
            }
        }

        return 0;
    }
}
