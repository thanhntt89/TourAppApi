<?php
defined('ABSPATH') || exit;

class TA_Device_Model {

    public static function register_or_update(array $data): array {
        global $wpdb;
        $table = $wpdb->prefix . 'ta_devices';
        $uuid  = sanitize_text_field($data['device_uuid']);

        $existing = $wpdb->get_row(
            $wpdb->prepare("SELECT * FROM $table WHERE device_uuid = %s", $uuid),
            ARRAY_A
        );

        if ($existing) {
            $wpdb->update($table, [
                'device_name' => sanitize_text_field($data['device_name'] ?? $existing['device_name']),
                'platform'    => sanitize_text_field($data['platform'] ?? $existing['platform']),
                'app_version' => sanitize_text_field($data['app_version'] ?? $existing['app_version']),
                'lang'        => sanitize_text_field($data['lang'] ?? $existing['lang']),
                'push_token'  => sanitize_text_field($data['push_token'] ?? $existing['push_token']),
            ], ['device_uuid' => $uuid]);

            $wallet = TA_Wallet_Model::get_balance($uuid);

            return [
                'device_uuid'    => $uuid,
                'is_new'         => false,
                'wallet_balance' => $wallet,
                'referral_code'  => $existing['referral_code'],
                'last_province_id' => (int)$existing['last_province_id'] ?: null,
            ];
        }

        $referral_code = self::generate_referral_code();

        $wpdb->insert($table, [
            'device_uuid'  => $uuid,
            'device_name'  => sanitize_text_field($data['device_name'] ?? ''),
            'platform'     => sanitize_text_field($data['platform'] ?? 'android'),
            'app_version'  => sanitize_text_field($data['app_version'] ?? ''),
            'lang'         => sanitize_text_field($data['lang'] ?? 'vi'),
            'push_token'   => sanitize_text_field($data['push_token'] ?? ''),
            'referral_code' => $referral_code,
        ]);

        TA_Wallet_Model::create_wallet($uuid);

        return [
            'device_uuid'    => $uuid,
            'is_new'         => true,
            'wallet_balance' => 0,
            'referral_code'  => $referral_code,
            'last_province_id' => null,
        ];
    }

    public static function find_by_uuid(string $uuid): ?array {
        global $wpdb;
        $row = $wpdb->get_row(
            $wpdb->prepare("SELECT * FROM {$wpdb->prefix}ta_devices WHERE device_uuid = %s", $uuid),
            ARRAY_A
        );
        return $row ?: null;
    }

    public static function find_by_referral_code(string $code): ?array {
        global $wpdb;
        $row = $wpdb->get_row(
            $wpdb->prepare("SELECT * FROM {$wpdb->prefix}ta_devices WHERE referral_code = %s", $code),
            ARRAY_A
        );
        return $row ?: null;
    }

    private static function generate_referral_code(): string {
        return 'HG-' . strtoupper(substr(md5(uniqid(mt_rand(), true)), 0, 6));
    }
}
