<?php
defined('ABSPATH') || exit;

class TA_API_Logger {

    private static $start_time  = null;
    private static $request_ref = null;

    public static function init() {
        add_filter('rest_pre_dispatch',  [self::class, 'start_timer'],  10, 3);
        add_filter('rest_post_dispatch', [self::class, 'log_request'],  10, 3);
    }

    public static function start_timer($result, $server, $request) {
        if (self::is_our_namespace($request)) {
            self::$start_time  = microtime(true);
            self::$request_ref = $request;
        }
        return $result;
    }

    public static function log_request($response, $server, $request) {
        if (!self::is_our_namespace($request) || self::$start_time === null) {
            return $response;
        }

        $status     = $response->get_status();
        $elapsed_ms = (int) ((microtime(true) - self::$start_time) * 1000);
        $uuid       = $request->get_header('X-Device-UUID') ?: null;
        $route      = $request->get_route();
        $method     = $request->get_method();
        $ip         = $_SERVER['REMOTE_ADDR'] ?? '';

        $log_data = [
            'device_uuid' => $uuid,
            'endpoint'    => $route,
            'method'      => $method,
            'status_code' => $status,
            'response_ms' => $elapsed_ms,
            'ip_address'  => $ip,
        ];

        // For error responses, capture full details in error_logs
        $is_error = $status >= 400;
        if ($is_error) {
            $response_data = $response->get_data();
            $error_body    = is_array($response_data) ? wp_json_encode($response_data) : (string) $response_data;
            $error_code    = '';
            $error_message = '';

            if (isset($response_data['error'])) {
                $error_code    = $response_data['error']['code']    ?? '';
                $error_message = $response_data['error']['message'] ?? '';
            } elseif (is_wp_error($response_data)) {
                $error_code    = $response_data->get_error_code();
                $error_message = $response_data->get_error_message();
            }

            // Capture request params (sanitize — exclude passwords/tokens)
            $params = $request->get_params();
            $sensitive = ['password', 'token', 'secret', 'push_token', 'nonce'];
            foreach ($sensitive as $key) {
                if (isset($params[$key])) $params[$key] = '[REDACTED]';
            }
            $request_params = wp_json_encode($params);

            $error_log_data = [
                'device_uuid'    => $uuid,
                'endpoint'       => $route,
                'method'         => $method,
                'status_code'    => $status,
                'error_code'     => substr($error_code, 0, 100),
                'error_message'  => $error_message,
                'request_params' => $request_params,
                'response_body'  => substr($error_body, 0, 5000),
                'ip_address'     => $ip,
                'user_agent'     => substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 500),
            ];
        }

        self::$start_time  = null;
        self::$request_ref = null;

        global $wpdb;
        $wpdb->insert($wpdb->prefix . 'ta_api_logs', $log_data);

        if ($is_error) {
            $error_log_data['log_id'] = $wpdb->insert_id;
            $wpdb->insert($wpdb->prefix . 'ta_error_logs', $error_log_data);
        }

        return $response;
    }

    private static function is_our_namespace($request): bool {
        return strpos($request->get_route(), '/' . TA_API_NAMESPACE) === 0;
    }
}
