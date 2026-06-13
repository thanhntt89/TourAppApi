<?php
defined('ABSPATH') || exit;

class TA_EP_Checkin {

    public static function register_routes() {
        // Check-in at a place
        register_rest_route(TA_API_NAMESPACE, '/user/checkin', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [__CLASS__, 'checkin'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'place_id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'method' => [
                    'required'          => true,
                    'type'              => 'string',
                    'enum'              => ['gps', 'qr'],
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'latitude' => [
                    'type'              => 'number',
                    'sanitize_callback' => 'floatval',
                ],
                'longitude' => [
                    'type'              => 'number',
                    'sanitize_callback' => 'floatval',
                ],
                'qr_code' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);

        // Unlock content with flowers
        register_rest_route(TA_API_NAMESPACE, '/user/unlock', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [__CLASS__, 'unlock_content'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'content_type' => [
                    'required'          => true,
                    'type'              => 'string',
                    'enum'              => ['article', 'audio'],
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'content_id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
            ],
        ]);

        // Visit history
        register_rest_route(TA_API_NAMESPACE, '/user/history', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [__CLASS__, 'history'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'province_id' => [
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'type' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'page' => [
                    'type'              => 'integer',
                    'default'           => 1,
                    'sanitize_callback' => 'absint',
                ],
                'per_page' => [
                    'type'              => 'integer',
                    'default'           => 20,
                    'sanitize_callback' => 'absint',
                ],
            ],
        ]);
    }

    /**
     * POST /user/checkin
     */
    public static function checkin(WP_REST_Request $request): WP_REST_Response {
        $uuid     = TA_Auth::get_device_uuid($request);
        $place_id = (int) $request->get_param('place_id');
        $method   = $request->get_param('method');

        // Validate place exists
        $place = get_post($place_id);
        if (!$place || $place->post_type !== 'place') {
            return TA_API::error('INVALID_PARAMS', 'Place not found.', 404);
        }

        // Check already checked in
        if (TA_Checkin_Model::has_checked_in($uuid, $place_id)) {
            $existing = TA_Checkin_Model::get_checkin($uuid, $place_id);
            return TA_API::error('ALREADY_CHECKED_IN', 'You have already checked in at this place.', 409, [
                'checked_in_at' => $existing['created_at'] ?? null,
            ]);
        }

        $lat = null;
        $lng = null;

        // Validate by method
        if ($method === 'gps') {
            $lat = (float) $request->get_param('latitude');
            $lng = (float) $request->get_param('longitude');

            if (!$lat || !$lng) {
                return TA_API::error('INVALID_PARAMS', 'Latitude and longitude are required for GPS check-in.', 400);
            }

            $place_lat = (float) get_field('place_lat', $place_id);
            $place_lng = (float) get_field('place_lng', $place_id);
            $geofence  = (int) get_field('place_geofence_radius', $place_id) ?: 300;

            if (!TA_Geo::is_within_radius($lat, $lng, $place_lat, $place_lng, $geofence)) {
                $distance = TA_Geo::distance_meters($lat, $lng, $place_lat, $place_lng);
                return TA_API::error('TOO_FAR', 'You are too far from this place.', 400, [
                    'distance_meters'  => round($distance, 1),
                    'required_meters'  => $geofence,
                ]);
            }
        } elseif ($method === 'qr') {
            $qr_code       = $request->get_param('qr_code');
            $expected_code  = get_field('place_qr_code', $place_id);

            if (!$qr_code || $qr_code !== $expected_code) {
                return TA_API::error('INVALID_PARAMS', 'Invalid QR code.', 400);
            }
        }

        // Reward
        $reward = (int) get_field('place_checkin_reward', $place_id) ?: 10;

        // Create checkin
        $checkin_id = TA_Checkin_Model::create($uuid, $place_id, $method, $lat, $lng, $reward);

        // Earn flowers
        $place_name  = get_the_title($place_id);
        $new_balance = TA_Wallet_Model::earn($uuid, $reward, 'earn_checkin', 'place', $place_id, "Check-in tại $place_name");

        return TA_API::created([
            'checkin_id'  => $checkin_id,
            'place_id'    => $place_id,
            'place_name'  => $place_name,
            'method'      => $method,
            'reward'      => [
                'amount'      => $reward,
                'currency'    => 'buckwheat_flower',
                'new_balance' => $new_balance,
            ],
            'unlocked'    => [
                'article' => true,
                'audio'   => true,
            ],
            'created_at'  => current_time('mysql', true),
        ]);
    }

    /**
     * POST /user/unlock
     */
    public static function unlock_content(WP_REST_Request $request): WP_REST_Response {
        $uuid         = TA_Auth::get_device_uuid($request);
        $content_type = $request->get_param('content_type');
        $content_id   = (int) $request->get_param('content_id');

        // Validate content exists
        $post = get_post($content_id);
        $allowed_post_types = ['place', 'sub_place', 'ta_story'];
        if (!$post || !in_array($post->post_type, $allowed_post_types, true)) {
            return TA_API::error('INVALID_PARAMS', 'Content not found.', 404);
        }

        // Check already unlocked
        if (TA_Checkin_Model::is_content_unlocked($uuid, $content_type, $content_id)) {
            return TA_API::error('ALREADY_UNLOCKED', 'This content is already unlocked.', 409);
        }

        // Determine cost based on post type and content_type
        $cost = self::get_unlock_cost($post->post_type, $content_type, $content_id);

        // Spend flowers
        $result = TA_Wallet_Model::spend($uuid, $cost, $content_type, $content_id, "Unlock $content_type");
        if (is_wp_error($result)) {
            $data = $result->get_error_data();
            return TA_API::error(
                $result->get_error_code(),
                $result->get_error_message(),
                $data['status'] ?? 400,
                [
                    'required'        => $data['required'] ?? $cost,
                    'current_balance' => $data['current_balance'] ?? 0,
                ]
            );
        }

        // Record unlock
        TA_Checkin_Model::unlock_content($uuid, $content_type, $content_id, $cost);

        return TA_API::success([
            'content_type' => $content_type,
            'content_id'   => $content_id,
            'cost'         => $cost,
            'new_balance'  => $result,
            'unlocked_at'  => current_time('mysql', true),
        ]);
    }

    private static function get_unlock_cost(string $post_type, string $content_type, int $content_id): int {
        if ($post_type === 'ta_story') {
            return (int) get_field('story_content_cost', $content_id) ?: 5;
        }
        if ($content_type === 'audio') {
            $field = $post_type === 'sub_place' ? 'sub_place_audio_cost' : 'place_audio_cost';
            return (int) get_field($field, $content_id) ?: 5;
        }
        // article
        return (int) get_field('place_article_cost', $content_id) ?: 5;
    }

    /**
     * GET /user/history
     */
    public static function history(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);

        $args = [
            'province_id' => $request->get_param('province_id'),
            'type'        => $request->get_param('type'),
            'page'        => $request->get_param('page') ?: 1,
            'per_page'    => $request->get_param('per_page') ?: 20,
        ];

        $result   = TA_Checkin_Model::get_history($uuid, $args);
        $checkins = [];

        foreach ($result['items'] as $row) {
            $pid   = (int) $row['place_id'];
            $place = get_post($pid);
            $image = get_field('place_feature_image', $pid);

            $checkins[] = [
                'id'         => (int) $row['id'],
                'place_id'   => $pid,
                'place_name' => $place ? get_the_title($place) : '',
                'place_image'=> $image ? (is_array($image) ? $image['url'] : wp_get_attachment_url($image)) : null,
                'method'     => $row['method'],
                'reward'     => (int) $row['reward_amount'],
                'created_at' => $row['created_at'],
            ];
        }

        $stats = TA_Checkin_Model::get_stats($uuid);

        return TA_API::success([
            'checkins' => $checkins,
            'stats'    => $stats,
        ], [
            'total'    => $result['total'],
            'page'     => $result['page'],
            'per_page' => $result['per_page'],
        ]);
    }
}
