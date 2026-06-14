<?php
defined('ABSPATH') || exit;

class TA_EP_Device {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/device/register', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [__CLASS__, 'register_device'],
            'permission_callback' => '__return_true',
            'args'                => [
                'device_uuid' => [
                    'required'          => true,
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'device_name' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'platform' => [
                    'type'              => 'string',
                    'enum'              => ['android', 'ios'],
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'app_version' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'lang' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'push_token' => [
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);
    }

    public static function register_device(WP_REST_Request $request): WP_REST_Response {
        $result = TA_Device_Model::register_or_update([
            'device_uuid' => $request->get_param('device_uuid'),
            'device_name' => $request->get_param('device_name'),
            'platform'    => $request->get_param('platform'),
            'app_version' => $request->get_param('app_version'),
            'lang'        => $request->get_param('lang'),
            'push_token'  => $request->get_param('push_token'),
        ]);

        return TA_API::success($result);
    }
}
