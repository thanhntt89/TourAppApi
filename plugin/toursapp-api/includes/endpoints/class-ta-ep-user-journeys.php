<?php
defined('ABSPATH') || exit;

class TA_EP_UserJourneys {

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
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
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
        $uuid = TA_Auth::get_device_uuid($request);

        $data = [
            'province_id'      => (int) $request->get_param('province_id'),
            'name'             => $request->get_param('name'),
            'description'      => $request->get_param('description') ?? '',
            'source_journey_id' => $request->get_param('source_journey_id'),
            'stops'            => $request->get_param('stops') ?: [],
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
            $data['stops'] = $request->get_param('stops');
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
