<?php
defined('ABSPATH') || exit;

class TA_API {

    public static function init_filters() {
        add_filter('rest_endpoints',    [self::class, 'apply_settings'], 20);
        add_filter('rest_post_dispatch', [self::class, 'normalize_error_response'], 10, 3);
    }

    /**
     * Reformat WP-native 401/403 error responses (from permission_callback WP_Error)
     * into our standard { success: false, error: { code, message } } envelope.
     */
    public static function normalize_error_response($response, $server, $request) {
        if (!($response instanceof WP_REST_Response)) return $response;

        $status = $response->get_status();
        if (!in_array($status, [401, 403], true)) return $response;

        $data = $response->get_data();
        if (isset($data['success']) || !isset($data['code'])) return $response;

        $response->set_data([
            'success' => false,
            'error'   => [
                'code'    => $data['code'],
                'message' => $data['message'] ?? '',
            ],
        ]);
        return $response;
    }

    public static function apply_settings($endpoints) {
        $strict   = (int) get_option('ta_api_strict_mode', 0);
        $disabled = (array) get_option('ta_api_disabled_endpoints', []);

        foreach ($endpoints as $route => &$handlers) {
            if (strpos($route, '/' . TA_API_NAMESPACE) !== 0) continue;

            // Convert raw regex route → readable form (matches what admin saves)
            // e.g. /toursapp/v1/places/(?P<id>\d+) → /toursapp/v1/places/{id}
            $readable_route = preg_replace('/\(\?P<([^>]+)>[^)]+\)/', '{$1}', $route);

            foreach ($handlers as $idx => &$handler) {
                if (!is_array($handler) || !isset($handler['callback'])) continue;

                // Get individual methods from this handler
                $raw_methods = $handler['methods'] ?? [];
                $method_list = is_array($raw_methods)
                    ? array_keys(array_filter($raw_methods))
                    : array_map('trim', explode(',', (string) $raw_methods));

                // Check each method individually — admin saves one key per method
                $all_disabled = true;
                foreach ($method_list as $m) {
                    $key = $readable_route . ':' . strtoupper($m);
                    if (!in_array($key, $disabled, true)) {
                        $all_disabled = false;
                        break;
                    }
                }

                // Disable endpoint (replace callback + allow all)
                if ($all_disabled && !empty($method_list)) {
                    $handler['callback'] = function () {
                        return new WP_REST_Response(
                            ['success' => false, 'error' => ['code' => 'endpoint_disabled', 'message' => 'This endpoint is currently disabled.']],
                            503
                        );
                    };
                    $handler['permission_callback'] = '__return_true';
                    continue;
                }

                // Strict mode OFF → all required params become optional
                if (!$strict && isset($handler['args'])) {
                    foreach ($handler['args'] as &$arg) {
                        $arg['required'] = false;
                    }
                }

                // Inject HMAC Signature Validation directly into permission_callback
                $original_permission_callback = $handler['permission_callback'] ?? '__return_true';
                $handler['permission_callback'] = function($request) use ($original_permission_callback) {
                    // Check HMAC first
                    $hmac_check = TA_Signature::verify_request_callback($request);
                    if (is_wp_error($hmac_check)) {
                        return $hmac_check;
                    }

                    // Proceed to original permission check
                    if (is_callable($original_permission_callback)) {
                        return call_user_func($original_permission_callback, $request);
                    }
                    return true;
                };
            }
        }

        return $endpoints;
    }

    public static function register() {
        $endpoint_dir = TA_PLUGIN_DIR . 'includes/endpoints/';

        $files = [
            'class-ta-ep-device.php',
            'class-ta-ep-provinces.php',
            'class-ta-ep-locations.php',
            'class-ta-ep-places.php',
            'class-ta-ep-sub-places.php',
            'class-ta-ep-sub-items.php',
            'class-ta-ep-journeys.php',
            'class-ta-ep-user-journeys.php',
            'class-ta-ep-checkin.php',
            'class-ta-ep-wallet.php',
            'class-ta-ep-share.php',
            'class-ta-ep-news.php',
            'class-ta-ep-sync.php',
            'class-ta-ep-stories.php',
            'class-ta-ep-engagement.php',
            'class-ta-ep-comments.php',
            'class-ta-ep-downloads.php',
            'class-ta-ep-features.php',
            'class-ta-ep-passport.php',
            'class-ta-ep-library.php',
        ];

        foreach ($files as $file) {
            require_once $endpoint_dir . $file;
        }

        TA_EP_Device::register_routes();
        TA_EP_Provinces::register_routes();
        TA_EP_Locations::register_routes();
        TA_EP_Places::register_routes();
        TA_EP_SubPlaces::register_routes();
        TA_EP_SubItems::register_routes();
        TA_EP_Journeys::register_routes();
        TA_EP_UserJourneys::register_routes();
        TA_EP_Checkin::register_routes();
        TA_EP_Wallet::register_routes();
        TA_EP_Share::register_routes();
        TA_EP_News::register_routes();
        TA_EP_Sync::register_routes();
        TA_EP_Stories::register_routes();
        TA_EP_Engagement::register_routes();
        TA_EP_Comments::register_routes();
        TA_EP_Downloads::register_routes();
        TA_EP_Features::register_routes();
        TA_EP_Passport::register_routes();
        TA_EP_Library::register_routes();
    }

    public static function success($data, array $meta = []): WP_REST_Response {
        $response = ['success' => true, 'data' => $data];
        if (!empty($meta)) {
            $response['meta'] = $meta;
        }
        return new WP_REST_Response($response, 200);
    }

    public static function created($data): WP_REST_Response {
        return new WP_REST_Response(['success' => true, 'data' => $data], 201);
    }

    public static function error(string $code, string $message, int $status = 400, array $details = []): WP_REST_Response {
        $body = [
            'success' => false,
            'error'   => [
                'code'    => $code,
                'message' => $message,
            ],
        ];
        if (!empty($details)) {
            $body['error']['details'] = $details;
        }
        return new WP_REST_Response($body, $status);
    }
}
