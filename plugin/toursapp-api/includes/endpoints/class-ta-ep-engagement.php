<?php
defined('ABSPATH') || exit;

class TA_EP_Engagement {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/user/track', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [self::class, 'track'],
            'permission_callback' => ['TA_Auth', 'permission_check_device'],
            'args'                => [
                'content_type'   => ['required' => true, 'type' => 'string', 'enum' => TA_Engagement_Model::allowed_types()],
                'content_id'     => ['required' => true, 'type' => 'integer', 'minimum' => 1],
                'event_type'     => ['required' => true, 'type' => 'string', 'enum' => TA_Engagement_Model::allowed_events()],
                'duration_sec'   => ['type' => 'integer', 'minimum' => 0],
                'scroll_depth'   => ['type' => 'integer', 'minimum' => 0, 'maximum' => 100],
                'completion_pct' => ['type' => 'integer', 'minimum' => 0, 'maximum' => 100],
                'extra'          => ['type' => 'string'],
            ],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/analytics/content/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'content_stats'],
            'permission_callback' => '__return_true',
            'args'                => [
                'id'           => ['required' => true, 'type' => 'integer'],
                'content_type' => ['required' => true, 'type' => 'string', 'enum' => TA_Engagement_Model::allowed_types()],
                'since'        => ['type' => 'string'],
            ],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/analytics/top-content', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'top_content'],
            'permission_callback' => '__return_true',
            'args'                => [
                'content_type' => ['type' => 'string'],
                'event_type'   => ['type' => 'string'],
                'metric'       => ['type' => 'string', 'default' => 'views', 'enum' => ['views', 'unique', 'read_time', 'completion', 'shares']],
                'order'        => ['type' => 'string', 'default' => 'DESC', 'enum' => ['DESC', 'ASC']],
                'limit'        => ['type' => 'integer', 'default' => 10, 'minimum' => 1, 'maximum' => 100],
                'since'        => ['type' => 'string'],
            ],
        ]);
    }

    public static function track(WP_REST_Request $request): WP_REST_Response {
        $uuid         = TA_Auth::get_device_uuid($request);
        $content_type = $request->get_param('content_type');
        $content_id   = (int) $request->get_param('content_id');
        $event_type   = $request->get_param('event_type');

        if (!TA_Engagement_Model::is_tracking_enabled($content_type, $content_id)) {
            return TA_API::error('tracking_disabled', 'Tracking is disabled for this content.', 403);
        }

        $id = TA_Engagement_Model::record($uuid, $content_type, $content_id, $event_type, [
            'duration_sec'   => $request->get_param('duration_sec'),
            'scroll_depth'   => $request->get_param('scroll_depth'),
            'completion_pct' => $request->get_param('completion_pct'),
            'extra'          => $request->get_param('extra'),
        ]);

        return TA_API::created(['event_id' => $id]);
    }

    public static function content_stats(WP_REST_Request $request): WP_REST_Response {
        $id           = (int) $request->get_param('id');
        $content_type = $request->get_param('content_type');
        $since        = $request->get_param('since');

        $stats = TA_Engagement_Model::get_content_stats($content_type, $id, $since ?: null);
        return TA_API::success($stats);
    }

    public static function top_content(WP_REST_Request $request): WP_REST_Response {
        $results = TA_Engagement_Model::get_top_content([
            'content_type' => $request->get_param('content_type'),
            'event_type'   => $request->get_param('event_type'),
            'metric'       => $request->get_param('metric'),
            'order'        => $request->get_param('order'),
            'limit'        => $request->get_param('limit'),
            'since'        => $request->get_param('since'),
        ]);

        return TA_API::success($results, ['total' => count($results)]);
    }
}
