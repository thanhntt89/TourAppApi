<?php
defined('ABSPATH') || exit;

class TA_API {

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
