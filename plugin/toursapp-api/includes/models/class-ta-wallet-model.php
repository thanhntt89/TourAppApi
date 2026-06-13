<?php
defined('ABSPATH') || exit;

class TA_Wallet_Model {

    public static function create_wallet(string $uuid): void {
        global $wpdb;
        $wpdb->insert($wpdb->prefix . 'ta_wallet', [
            'device_uuid' => $uuid,
            'balance'      => 0,
            'total_earned'  => 0,
            'total_spent'   => 0,
        ]);
    }

    public static function get_balance(string $uuid): int {
        global $wpdb;
        $balance = $wpdb->get_var($wpdb->prepare(
            "SELECT balance FROM {$wpdb->prefix}ta_wallet WHERE device_uuid = %s",
            $uuid
        ));
        return (int)($balance ?? 0);
    }

    public static function get_wallet(string $uuid): array {
        global $wpdb;
        $wallet = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}ta_wallet WHERE device_uuid = %s",
            $uuid
        ), ARRAY_A);

        if (!$wallet) {
            return ['balance' => 0, 'total_earned' => 0, 'total_spent' => 0];
        }

        return [
            'balance'      => (int)$wallet['balance'],
            'total_earned' => (int)$wallet['total_earned'],
            'total_spent'  => (int)$wallet['total_spent'],
        ];
    }

    public static function earn(string $uuid, int $amount, string $type, string $ref_type = '', int $ref_id = 0, string $note = ''): int {
        global $wpdb;
        $table = $wpdb->prefix . 'ta_wallet';

        $wpdb->query($wpdb->prepare(
            "UPDATE $table SET balance = balance + %d, total_earned = total_earned + %d WHERE device_uuid = %s",
            $amount, $amount, $uuid
        ));

        $new_balance = self::get_balance($uuid);

        $wpdb->insert($wpdb->prefix . 'ta_wallet_txn', [
            'device_uuid'   => $uuid,
            'type'          => $type,
            'amount'        => $amount,
            'balance_after' => $new_balance,
            'reference_type' => $ref_type,
            'reference_id'   => $ref_id,
            'note'          => $note,
        ]);

        return $new_balance;
    }

    public static function spend(string $uuid, int $amount, string $ref_type, int $ref_id, string $note = '') {
        global $wpdb;
        $table = $wpdb->prefix . 'ta_wallet';

        // Atomic UPDATE: deduct only if balance is sufficient — prevents race condition
        $rows_affected = $wpdb->query($wpdb->prepare(
            "UPDATE $table SET balance = balance - %d, total_spent = total_spent + %d
             WHERE device_uuid = %s AND balance >= %d",
            $amount, $amount, $uuid, $amount
        ));

        if (!$rows_affected) {
            $current = self::get_balance($uuid);
            return new WP_Error('INSUFFICIENT_BALANCE', 'Not enough Buckwheat Flowers', [
                'status'          => 400,
                'required'        => $amount,
                'current_balance' => $current,
            ]);
        }

        $new_balance = self::get_balance($uuid);

        $wpdb->insert($wpdb->prefix . 'ta_wallet_txn', [
            'device_uuid'   => $uuid,
            'type'          => 'spend_unlock',
            'amount'        => -$amount,
            'balance_after' => $new_balance,
            'reference_type' => $ref_type,
            'reference_id'   => $ref_id,
            'note'          => $note,
        ]);

        return $new_balance;
    }

    public static function get_recent_transactions(string $uuid, int $limit = 10): array {
        global $wpdb;
        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM {$wpdb->prefix}ta_wallet_txn WHERE device_uuid = %s ORDER BY created_at DESC LIMIT %d",
            $uuid, $limit
        ), ARRAY_A);

        return array_map(function ($row) {
            return [
                'id'            => (int)$row['id'],
                'type'          => $row['type'],
                'amount'        => (int)$row['amount'],
                'balance_after' => (int)$row['balance_after'],
                'note'          => $row['note'],
                'created_at'    => $row['created_at'],
            ];
        }, $rows ?: []);
    }
}
