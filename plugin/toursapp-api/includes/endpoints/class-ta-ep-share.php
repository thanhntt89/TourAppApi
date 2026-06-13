<?php
defined('ABSPATH') || exit;

class TA_EP_Share {

    private const SOCIAL_REWARD  = 2;
    private const INVITER_REWARD = 5;
    private const INVITEE_REWARD = 3;

    private const VALID_SHARE_TYPES = [
        'app_referral',
        'social_facebook',
        'social_zalo',
        'social_instagram',
        'social_other',
    ];

    public static function register_routes() {
        // Share to earn flowers
        register_rest_route(TA_API_NAMESPACE, '/user/share', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [__CLASS__, 'share'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'share_type' => [
                    'required'          => true,
                    'type'              => 'string',
                    'enum'              => self::VALID_SHARE_TYPES,
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);

        // Redeem referral code
        register_rest_route(TA_API_NAMESPACE, '/user/referral/redeem', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [__CLASS__, 'redeem_referral'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'referral_code' => [
                    'required'          => true,
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ]);
    }

    /**
     * POST /user/share
     */
    public static function share(WP_REST_Request $request): WP_REST_Response {
        global $wpdb;

        $uuid       = TA_Auth::get_device_uuid($request);
        $share_type = $request->get_param('share_type');
        $table      = $wpdb->prefix . 'ta_shares';

        // Social share types: check daily limit
        if (str_starts_with($share_type, 'social_')) {
            $already_shared = (int) $wpdb->get_var($wpdb->prepare(
                "SELECT COUNT(*) FROM $table
                 WHERE device_uuid = %s AND share_type = %s AND DATE(created_at) = CURDATE()",
                $uuid, $share_type
            ));

            if ($already_shared) {
                return TA_API::error(
                    'SHARE_LIMIT_REACHED',
                    'You have already shared to this platform today.',
                    429
                );
            }

            $reward = self::SOCIAL_REWARD;
        } else {
            $reward = 0;
        }

        // Insert share record
        $wpdb->insert($table, [
            'device_uuid' => $uuid,
            'share_type'  => $share_type,
        ]);

        // Earn flowers for social shares
        $new_balance = 0;
        if ($reward > 0) {
            $platform    = str_replace('social_', '', $share_type);
            $new_balance = TA_Wallet_Model::earn(
                $uuid,
                $reward,
                'earn_share_social',
                '',
                0,
                "Share to $platform"
            );
        }

        return TA_API::created([
            'share_type' => $share_type,
            'reward'     => [
                'amount'      => $reward,
                'new_balance' => $new_balance,
            ],
            'message'    => $reward > 0
                ? "You earned $reward Buckwheat Flowers!"
                : 'Share recorded.',
        ]);
    }

    /**
     * POST /user/referral/redeem
     */
    public static function redeem_referral(WP_REST_Request $request): WP_REST_Response {
        global $wpdb;

        $uuid          = TA_Auth::get_device_uuid($request);
        $referral_code = $request->get_param('referral_code');
        $table         = $wpdb->prefix . 'ta_shares';

        // Find inviter by referral code
        $inviter = TA_Device_Model::find_by_referral_code($referral_code);
        if (!$inviter) {
            return TA_API::error('INVALID_PARAMS', 'Invalid referral code.', 400);
        }

        // Cannot use own code
        if ($inviter['device_uuid'] === $uuid) {
            return TA_API::error('INVALID_PARAMS', 'You cannot use your own referral code.', 400);
        }

        // Check if invitee already redeemed a referral code
        $already_redeemed = (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM $table WHERE device_uuid = %s AND share_type = 'app_referral'",
            $uuid
        ));

        if ($already_redeemed) {
            return TA_API::error('ALREADY_REDEEMED', 'You have already redeemed a referral code.', 409);
        }

        // Reward inviter
        TA_Wallet_Model::earn(
            $inviter['device_uuid'],
            self::INVITER_REWARD,
            'earn_share_app',
            'referral',
            0,
            'Referral reward'
        );

        // Reward invitee
        $new_balance = TA_Wallet_Model::earn(
            $uuid,
            self::INVITEE_REWARD,
            'earn_share_app',
            'referral',
            0,
            'Welcome bonus'
        );

        // Record the referral share for the invitee
        $wpdb->insert($table, [
            'device_uuid'  => $uuid,
            'share_type'   => 'app_referral',
            'referrer_uuid' => $inviter['device_uuid'],
        ]);

        return TA_API::created([
            'reward' => [
                'inviter_reward' => self::INVITER_REWARD,
                'invitee_reward' => self::INVITEE_REWARD,
                'new_balance'    => $new_balance,
            ],
        ]);
    }
}
