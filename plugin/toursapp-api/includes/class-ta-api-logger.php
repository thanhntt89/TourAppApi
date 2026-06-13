<?php
defined('ABSPATH') || exit;

class TA_API_Logger {

    private static $start_time = null;

    public static function init() {
        add_filter('rest_pre_dispatch',  [self::class, 'start_timer'],  10, 3);
        add_filter('rest_post_dispatch', [self::class, 'log_request'],  10, 3);
    }

    public static function start_timer($result, $server, $request) {
        if (self::is_our_namespace($request)) {
            self::$start_time = microtime(true);
        }
        return $result;
    }

    public static function log_request($response, $server, $request) {
        if (!self::is_our_namespace($request) || self::$start_time === null) {
            return $response;
        }

        $log = [
            'device_uuid' => $request->get_header('X-Device-UUID') ?: null,
            'endpoint'    => $request->get_route(),
            'method'      => $request->get_method(),
            'status_code' => $response->get_status(),
            'response_ms' => (int) ((microtime(true) - self::$start_time) * 1000),
            'ip_address'  => $_SERVER['REMOTE_ADDR'] ?? '',
        ];

        self::$start_time = null;

        // Write asynchronously on shutdown — zero impact on response time.
        add_action('shutdown', function () use ($log) {
            global $wpdb;
            $wpdb->insert($wpdb->prefix . 'ta_api_logs', $log);
        });

        return $response;
    }

    private static function is_our_namespace($request): bool {
        return strpos($request->get_route(), '/' . TA_API_NAMESPACE) === 0;
    }
}
