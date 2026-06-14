<?php
defined('ABSPATH') || exit;

class TA_EP_Downloads {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/user/downloads', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_downloads'],
            'permission_callback' => ['TA_Auth', 'permission_check_device'],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/user/downloads/start', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [self::class, 'start_download'],
            'permission_callback' => ['TA_Auth', 'permission_check_device'],
            'args'                => [
                'province_id'   => ['required' => true, 'type' => 'integer', 'minimum' => 1],
                'download_type' => ['type' => 'string', 'default' => 'full', 'enum' => ['full', 'incremental', 'media_only']],
                'lang'          => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
            ],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/user/downloads/complete', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [self::class, 'complete_download'],
            'permission_callback' => ['TA_Auth', 'permission_check_device'],
            'args'                => [
                'download_id'   => ['required' => true, 'type' => 'integer', 'minimum' => 1],
                'file_count'    => ['type' => 'integer', 'minimum' => 0, 'default' => 0],
                'total_size_mb' => ['type' => 'number',  'minimum' => 0, 'default' => 0],
                'status'        => ['type' => 'string', 'default' => 'completed', 'enum' => ['completed', 'failed']],
            ],
        ]);
    }

    public static function list_downloads(WP_REST_Request $request): WP_REST_Response {
        $uuid      = TA_Auth::get_device_uuid($request);
        $downloads = TA_Download_Model::get_user_downloads($uuid);
        return TA_API::success($downloads, ['total' => count($downloads)]);
    }

    public static function start_download(WP_REST_Request $request): WP_REST_Response {
        $uuid        = TA_Auth::get_device_uuid($request);
        $province_id = (int) $request->get_param('province_id');
        $type        = $request->get_param('download_type');
        $lang        = TA_Localize::get_lang($request);

        $province = get_post($province_id);
        if (!$province || $province->post_type !== 'province' || $province->post_status !== 'publish') {
            return TA_API::error('province_not_found', 'Province not found.', 404);
        }

        $id = TA_Download_Model::start($uuid, $province_id, $type, $lang);
        return TA_API::created(['download_id' => $id]);
    }

    public static function complete_download(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);
        $id   = (int) $request->get_param('download_id');

        TA_Download_Model::complete($id, [
            'status'        => $request->get_param('status'),
            'file_count'    => $request->get_param('file_count'),
            'total_size_mb' => $request->get_param('total_size_mb'),
        ]);

        return TA_API::success(['updated' => true]);
    }
}
