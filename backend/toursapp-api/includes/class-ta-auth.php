<?php
defined('ABSPATH') || exit;

class TA_Auth {

    public static function get_device_uuid(WP_REST_Request $request): ?string {
        return $request->get_header('X-Device-UUID') ?: null;
    }

    public static function require_device(WP_REST_Request $request) {
        $uuid = self::get_device_uuid($request);
        if (!$uuid) {
            return new WP_Error('DEVICE_NOT_REGISTERED', 'Missing X-Device-UUID header', ['status' => 401]);
        }

        global $wpdb;
        $exists = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$wpdb->prefix}ta_devices WHERE device_uuid = %s",
            $uuid
        ));

        if (!$exists) {
            return new WP_Error('DEVICE_NOT_REGISTERED', 'Device not registered', ['status' => 401]);
        }

        return true;
    }

    public static function permission_check_device(WP_REST_Request $request) {
        $result = self::require_device($request);
        if (is_wp_error($result)) {
            return $result;
        }
        return true;
    }
}
