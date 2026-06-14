<?php
defined('ABSPATH') || exit;

class TA_EP_Wallet {

    public static function register_routes() {
        // Wallet info
        register_rest_route(TA_API_NAMESPACE, '/user/wallet', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [__CLASS__, 'get_wallet'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
        ]);
    }

    /**
     * GET /user/wallet
     */
    public static function get_wallet(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);

        $wallet = TA_Wallet_Model::get_wallet($uuid);
        $device = TA_Device_Model::find_by_uuid($uuid);
        $recent = TA_Wallet_Model::get_recent_transactions($uuid, 10);

        return TA_API::success([
            'balance'             => $wallet['balance'],
            'total_earned'        => $wallet['total_earned'],
            'total_spent'         => $wallet['total_spent'],
            'referral_code'       => $device['referral_code'] ?? null,
            'transactions' => $recent,
        ]);
    }
}
