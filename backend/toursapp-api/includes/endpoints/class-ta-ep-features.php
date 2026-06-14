<?php
defined('ABSPATH') || exit;

class TA_EP_Features {

    public static function register_routes() {
        // List all feature statuses for current device
        register_rest_route(TA_API_NAMESPACE, '/user/features', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_features'],
            'permission_callback' => ['TA_Auth', 'permission_check_device'],
        ]);

        // Single feature status
        register_rest_route(TA_API_NAMESPACE, '/user/features/(?P<feature>[a-z_]+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_feature'],
            'permission_callback' => ['TA_Auth', 'permission_check_device'],
            'args'                => [
                'feature' => ['required' => true, 'type' => 'string'],
            ],
        ]);

        // Unlock a paid feature
        register_rest_route(TA_API_NAMESPACE, '/user/features/(?P<feature>[a-z_]+)/unlock', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [self::class, 'unlock_feature'],
            'permission_callback' => ['TA_Auth', 'permission_check_device'],
            'args'                => [
                'feature' => ['required' => true, 'type' => 'string'],
            ],
        ]);
    }

    public static function list_features(WP_REST_Request $request): WP_REST_Response {
        $uuid     = TA_Auth::get_device_uuid($request);
        $statuses = [];
        foreach (array_keys(TA_Feature_Access::FEATURES) as $feature) {
            $statuses[] = TA_Feature_Access::get_status($uuid, $feature);
        }
        return TA_API::success($statuses);
    }

    public static function get_feature(WP_REST_Request $request): WP_REST_Response {
        $uuid    = TA_Auth::get_device_uuid($request);
        $feature = $request->get_param('feature');

        if (!array_key_exists($feature, TA_Feature_Access::FEATURES)) {
            return TA_API::error('feature_not_found', 'Unknown feature.', 404);
        }

        return TA_API::success(TA_Feature_Access::get_status($uuid, $feature));
    }

    public static function unlock_feature(WP_REST_Request $request): WP_REST_Response {
        $uuid    = TA_Auth::get_device_uuid($request);
        $feature = $request->get_param('feature');

        if (!array_key_exists($feature, TA_Feature_Access::FEATURES)) {
            return TA_API::error('feature_not_found', 'Unknown feature.', 404);
        }

        $mode = TA_Feature_Access::get_mode($feature);

        if ($mode === 'achievement') {
            // For achievement mode, just re-check progress
            $status = TA_Feature_Access::get_status($uuid, $feature);
            if ($status['has_access']) {
                return TA_API::success(['unlocked' => true, 'status' => $status]);
            }
            return TA_API::error('achievement_not_met', 'Achievement requirement not yet met.', 403, [
                'achievement' => $status['achievement'] ?? [],
            ]);
        }

        $result = TA_Feature_Access::unlock_paid($uuid, $feature);
        if (is_wp_error($result)) {
            $data = $result->get_error_data();
            return TA_API::error($result->get_error_code(), $result->get_error_message(), $data['status'] ?? 400);
        }

        return TA_API::success([
            'unlocked'    => true,
            'new_balance' => $result,
            'status'      => TA_Feature_Access::get_status($uuid, $feature),
        ]);
    }
}
