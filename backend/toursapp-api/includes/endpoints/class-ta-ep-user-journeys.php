<?php
defined('ABSPATH') || exit;

class TA_EP_UserJourneys {

    const FREE_JOURNEY_LIMIT = 5;

    public static function register_routes() {
        // GET /user/journeys
        register_rest_route(TA_API_NAMESPACE, '/user/journeys', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_journeys'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'province_id' => [
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'status' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);

        // POST /user/journeys
        register_rest_route(TA_API_NAMESPACE, '/user/journeys', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [self::class, 'create_journey'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'province_id' => [
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                    'default'           => 0,
                ],
                'name' => [
                    'required'          => true,
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'description' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_textarea_field',
                ],
                'source_journey_id' => [
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'stops' => [
                    'type' => 'array',
                ],
            ],
        ]);

        // PUT /user/journeys/{id}
        register_rest_route(TA_API_NAMESPACE, '/user/journeys/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::EDITABLE,
            'callback'            => [self::class, 'update_journey'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'id' => ['type' => 'integer', 'required' => true],
                'name' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'description' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_textarea_field',
                ],
                'status' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'stops' => [
                    'type' => 'array',
                ],
            ],
        ]);

        // DELETE /user/journeys/{id}
        register_rest_route(TA_API_NAMESPACE, '/user/journeys/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::DELETABLE,
            'callback'            => [self::class, 'delete_journey'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'id' => ['type' => 'integer', 'required' => true],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /user/journeys
    // ──────────────────────────────────────────────
    public static function list_journeys(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);

        $args = [];
        if ($request->get_param('province_id')) {
            $args['province_id'] = (int) $request->get_param('province_id');
        }
        if ($request->get_param('status')) {
            $args['status'] = $request->get_param('status');
        }

        $rows = TA_Journey_Model::get_user_journeys($uuid, $args);

        $journeys = array_map(function ($row) {
            return self::format_user_journey($row);
        }, $rows);

        return TA_API::success($journeys, ['total' => count($journeys)]);
    }

    // ──────────────────────────────────────────────
    // POST /user/journeys
    // ──────────────────────────────────────────────
    public static function create_journey(WP_REST_Request $request): WP_REST_Response {
        $uuid  = TA_Auth::get_device_uuid($request);
        $stops = $request->get_param('stops') ?: [];

        // Journey limit check (free: max 5, unlimited requires feature unlock)
        if (!TA_Feature_Access::user_has_access($uuid, 'unlimited_journeys')) {
            $count = TA_Journey_Model::count_for_device($uuid);
            if ($count >= self::FREE_JOURNEY_LIMIT) {
                return TA_API::error(
                    'journey_limit_reached',
                    'Free plan allows up to ' . self::FREE_JOURNEY_LIMIT . ' custom journeys.',
                    403,
                    [
                        'limit'           => self::FREE_JOURNEY_LIMIT,
                        'current'         => $count,
                        'feature'         => TA_Feature_Access::get_status($uuid, 'unlimited_journeys'),
                        'unlock_endpoint' => '/' . TA_API_NAMESPACE . '/user/features/unlimited_journeys/unlock',
                    ]
                );
            }
        }

        // Cross-province check
        $cross_check = self::check_cross_province_access($uuid, $stops, 0);
        if (is_wp_error($cross_check)) {
            $d = $cross_check->get_error_data();
            return TA_API::error($cross_check->get_error_code(), $cross_check->get_error_message(), $d['status'] ?? 403, $d);
        }

        $province_id = $cross_check['province_id'];

        $data = [
            'province_id'       => $province_id,
            'name'              => $request->get_param('name'),
            'description'       => $request->get_param('description') ?? '',
            'source_journey_id' => $request->get_param('source_journey_id'),
            'stops'             => $stops,
        ];

        $journey_id = TA_Journey_Model::create($uuid, $data);
        $journey    = TA_Journey_Model::get_by_id($journey_id, $uuid);

        if (!$journey) {
            return TA_API::error('journey_create_failed', 'Failed to create journey.', 500);
        }

        return TA_API::created(self::format_user_journey($journey));
    }

    // ──────────────────────────────────────────────
    // PUT /user/journeys/{id}
    // ──────────────────────────────────────────────
    public static function update_journey(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $uuid = TA_Auth::get_device_uuid($request);

        // Verify ownership.
        $journey = TA_Journey_Model::get_by_id($id, $uuid);
        if (!$journey) {
            return TA_API::error('journey_not_found', 'Journey not found or not owned by this device.', 404);
        }

        $data = [];
        if ($request->get_param('name') !== null) {
            $data['name'] = $request->get_param('name');
        }
        if ($request->get_param('description') !== null) {
            $data['description'] = $request->get_param('description');
        }
        if ($request->get_param('status') !== null) {
            $data['status'] = $request->get_param('status');
        }
        if ($request->get_param('stops') !== null) {
            $stops = $request->get_param('stops');

            // Cross-province check when stops are being updated
            $cross_check = self::check_cross_province_access($uuid, $stops, (int) $journey['province_id']);
            if (is_wp_error($cross_check)) {
                $d = $cross_check->get_error_data();
                return TA_API::error($cross_check->get_error_code(), $cross_check->get_error_message(), $d['status'] ?? 403, $d);
            }

            $data['stops']       = $stops;
            $data['province_id'] = $cross_check['province_id'];
        }

        TA_Journey_Model::update($id, $data);

        // Re-fetch updated journey.
        $updated = TA_Journey_Model::get_by_id($id, $uuid);

        return TA_API::success(self::format_user_journey($updated));
    }

    // ──────────────────────────────────────────────
    // DELETE /user/journeys/{id}
    // ──────────────────────────────────────────────
    public static function delete_journey(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $uuid = TA_Auth::get_device_uuid($request);

        // Verify ownership.
        $journey = TA_Journey_Model::get_by_id($id, $uuid);
        if (!$journey) {
            return TA_API::error('journey_not_found', 'Journey not found or not owned by this device.', 404);
        }

        TA_Journey_Model::delete($id);

        return TA_API::success(['deleted' => true]);
    }

    // ──────────────────────────────────────────────
    // Format helpers
    // ──────────────────────────────────────────────

    /**
     * Check if stops span multiple provinces and validate cross-province access.
     * Returns array ['province_id' => int] on success, WP_Error on failure.
     */
    private static function check_cross_province_access(string $uuid, array $stops, int $current_province_id) {
        if (empty($stops)) {
            return ['province_id' => $current_province_id];
        }

        $province_ids = self::detect_provinces($stops);
        $unique_count = count($province_ids);

        // Single province — always allowed
        if ($unique_count <= 1) {
            $province_id = !empty($province_ids) ? reset($province_ids) : $current_province_id;
            return ['province_id' => $province_id ?: $current_province_id];
        }

        // Multiple provinces — check feature access
        if (!TA_Feature_Access::user_has_access($uuid, 'cross_province')) {
            $status = TA_Feature_Access::get_status($uuid, 'cross_province');

            if (!$status['enabled']) {
                return new WP_Error('cross_province_disabled',
                    'Cross-province journeys are not available.', ['status' => 403]);
            }

            $details = ['feature' => $status];

            if ($status['mode'] === 'paid') {
                $details['message'] = 'Unlock cross-province journeys for ' . $status['cost'] . ' flowers.';
                $details['unlock_endpoint'] = '/' . TA_API_NAMESPACE . '/user/features/cross_province/unlock';
            } elseif ($status['mode'] === 'achievement') {
                $ach = $status['achievement'];
                $details['message'] = 'Check in at ' . $ach['required'] . ' places to unlock cross-province journeys. Currently: ' . $ach['current'] . '/' . $ach['required'];
            }

            return new WP_Error('cross_province_locked',
                'You need to unlock cross-province journeys first.', array_merge(['status' => 403], $details));
        }

        // Access granted — use 0 as province_id for cross-province journeys
        return ['province_id' => 0];
    }

    /**
     * Get unique province IDs from a stops array.
     * Each stop has place_id; we trace place → location → province.
     */
    private static function detect_provinces(array $stops): array {
        $province_ids = [];
        foreach ($stops as $stop) {
            $place_id = (int) ($stop['place_id'] ?? 0);
            if (!$place_id) continue;

            $loc_id = get_field('place_location', $place_id);
            if (!$loc_id) continue;

            $prov_id = (int) get_field('location_province', $loc_id);
            if ($prov_id) {
                $province_ids[$prov_id] = $prov_id;
            }
        }
        return $province_ids;
    }

    /**
     * Format a user journey row from the custom table,
     * enriching stops with place CPT data.
     */
    private static function format_user_journey(array $row): array {
        $id       = (int) $row['id'];
        $stops    = TA_Journey_Model::get_stops($id);
        $progress = TA_Journey_Model::get_progress($id);

        $enriched_stops = array_map(function ($stop) {
            return self::enrich_stop($stop);
        }, $stops);

        return [
            'id'               => $id,
            'type'             => 'user',
            'name'             => $row['name'] ?? '',
            'description'      => $row['description'] ?? '',
            'province_id'      => (int) ($row['province_id'] ?? 0),
            'source_journey_id' => !empty($row['source_journey_id']) ? (int) $row['source_journey_id'] : null,
            'status'           => $row['status'] ?? 'planning',
            'total_places'     => $progress['total_places'],
            'visited_count'    => $progress['visited_count'],
            'progress_percent' => $progress['progress_percent'],
            'stops'            => $enriched_stops,
            'created_at'       => $row['created_at'] ?? null,
            'updated_at'       => $row['updated_at'] ?? null,
        ];
    }

    /**
     * Enrich a stop row from ta_user_journey_stops with place CPT data.
     */
    private static function enrich_stop(array $stop): array {
        $place_id = (int) ($stop['place_id'] ?? 0);

        $place_name    = '';
        $feature_image = null;
        $lat           = 0.0;
        $lng           = 0.0;

        if ($place_id) {
            $place_post = get_post($place_id);
            if ($place_post && $place_post->post_type === 'place' && $place_post->post_status === 'publish') {
                // Use default lang (vi) for place name since user journeys
                // are device-scoped and lang is not passed per-stop.
                $place_name    = TA_Localize::get_field_localized($place_id, 'place_name', TA_DEFAULT_LANG);
                $feature_image = TA_Localize::format_image(get_field('place_feature_image', $place_id));
                $lat           = (float) get_field('place_lat', $place_id);
                $lng           = (float) get_field('place_lng', $place_id);
            }
        }

        return [
            'place_id'      => $place_id,
            'place_name'    => $place_name,
            'feature_image' => $feature_image,
            'lat'           => $lat,
            'lng'           => $lng,
            'stop_order'    => (int) ($stop['stop_order'] ?? 0),
            'day_number'    => (int) ($stop['day_number'] ?? 1),
            'note'          => $stop['note'] ?? '',
            'status'        => $stop['status'] ?? 'planned',
        ];
    }
}
