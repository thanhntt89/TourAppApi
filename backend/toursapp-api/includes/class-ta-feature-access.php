<?php
defined('ABSPATH') || exit;

/**
 * Feature gate system.
 * Each feature can be: disabled | free | paid (flowers) | achievement (checkin count)
 *
 * Settings stored in wp_options:
 *   ta_feature_{name}_enabled    (0/1)
 *   ta_feature_{name}_mode       (free|paid|achievement)
 *   ta_feature_{name}_cost       (int, flowers — paid mode)
 *   ta_feature_{name}_achievement (int, check-in count — achievement mode)
 */
class TA_Feature_Access {

    // Feature registry: slug => label
    const FEATURES = [
        'cross_province'     => 'Cross-Province Journeys',
        'unlimited_journeys' => 'Unlimited Custom Journeys',
    ];

    // Internal IDs used in wp_ta_unlocked_content (content_type='feature')
    const FEATURE_IDS = [
        'cross_province'     => 1,
        'unlimited_journeys' => 2,
    ];

    // ── Public API ────────────────────────────────────────────────────────

    public static function is_enabled(string $feature): bool {
        return (bool) get_option('ta_feature_' . $feature . '_enabled', 0);
    }

    public static function get_mode(string $feature): string {
        $mode = get_option('ta_feature_' . $feature . '_mode', 'free');
        return in_array($mode, ['free', 'paid', 'achievement'], true) ? $mode : 'free';
    }

    public static function get_cost(string $feature): int {
        return (int) get_option('ta_feature_' . $feature . '_cost', 10);
    }

    public static function get_achievement_required(string $feature): int {
        return max(1, (int) get_option('ta_feature_' . $feature . '_achievement', 10));
    }

    /**
     * Check if a device has access to a feature.
     * Returns true only if feature is enabled AND access conditions are met.
     */
    public static function user_has_access(string $uuid, string $feature): bool {
        if (!self::is_enabled($feature)) return false;

        $mode = self::get_mode($feature);

        if ($mode === 'free') return true;

        if ($mode === 'paid') {
            $fid = self::FEATURE_IDS[$feature] ?? 0;
            return TA_Checkin_Model::is_content_unlocked($uuid, 'feature', $fid);
        }

        if ($mode === 'achievement') {
            $required = self::get_achievement_required($feature);
            return self::count_checkins($uuid) >= $required;
        }

        return false;
    }

    /**
     * Unlock a paid feature by spending flowers.
     * Returns new balance (int) or WP_Error.
     */
    public static function unlock_paid(string $uuid, string $feature) {
        if (!self::is_enabled($feature)) {
            return new WP_Error('feature_disabled', 'This feature is not available.', ['status' => 403]);
        }
        if (self::get_mode($feature) !== 'paid') {
            return new WP_Error('not_paid_feature', 'This feature does not require payment.', ['status' => 400]);
        }

        $fid = self::FEATURE_IDS[$feature] ?? 0;
        if (TA_Checkin_Model::is_content_unlocked($uuid, 'feature', $fid)) {
            return new WP_Error('already_unlocked', 'Feature already unlocked.', ['status' => 409]);
        }

        $cost   = self::get_cost($feature);
        $result = TA_Wallet_Model::spend($uuid, $cost, 'feature', $fid, 'Unlock feature: ' . $feature);
        if (is_wp_error($result)) return $result;

        TA_Checkin_Model::unlock_content($uuid, 'feature', $fid, $cost);
        return $result;
    }

    /**
     * Full status object for a feature + device combination.
     */
    public static function get_status(string $uuid, string $feature): array {
        $enabled    = self::is_enabled($feature);
        $mode       = self::get_mode($feature);
        $has_access = $enabled ? self::user_has_access($uuid, $feature) : false;

        $status = [
            'feature'    => $feature,
            'label'      => self::FEATURES[$feature] ?? $feature,
            'enabled'    => $enabled,
            'mode'       => $mode,
            'has_access' => $has_access,
        ];

        if ($mode === 'paid') {
            $fid = self::FEATURE_IDS[$feature] ?? 0;
            $status['cost']    = self::get_cost($feature);
            $status['unlocked'] = TA_Checkin_Model::is_content_unlocked($uuid, 'feature', $fid);
        }

        if ($mode === 'achievement') {
            $required = self::get_achievement_required($feature);
            $current  = self::count_checkins($uuid);
            $status['achievement'] = [
                'required' => $required,
                'current'  => $current,
                'progress' => min(100, (int) round($current / $required * 100)),
            ];
        }

        return $status;
    }

    // ── Internal helpers ──────────────────────────────────────────────────

    public static function count_checkins(string $uuid): int {
        global $wpdb;
        return (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$wpdb->prefix}ta_checkins WHERE device_uuid = %s",
            $uuid
        ));
    }
}
