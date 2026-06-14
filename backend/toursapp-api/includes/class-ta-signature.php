<?php
defined('ABSPATH') || exit;

class TA_Signature {

    const TIMESTAMP_WINDOW = 300;
    const NONCE_TTL        = 300;
    const OPTION_ENABLED   = 'ta_api_signature_enabled';
    const OPTION_SECRET    = 'ta_api_app_secret';

    public static function init() {
        // Validation is now directly injected into endpoint permission_callbacks by TA_API::apply_settings
    }

    public static function is_enabled(): bool {
        return (bool) get_option(self::OPTION_ENABLED, 0);
    }

    public static function get_secret(): string {
        return (string) get_option(self::OPTION_SECRET, '');
    }

    /**
     * @param WP_REST_Request $request
     * @return true|WP_Error
     */
    public static function verify_request_callback($request) {
        if (!self::is_enabled()) {
            return true;
        }

        if (self::get_secret() === '') {
            return self::make_error('SIGNATURE_CONFIG', 'Signing is enabled but no secret is configured');
        }

        $signature = $request->get_header('X-Signature');
        $timestamp = $request->get_header('X-Timestamp');
        $nonce     = $request->get_header('X-Nonce');

        if (!$signature || !$timestamp || !$nonce) {
            return self::make_error('SIGNATURE_MISSING', 'Missing required headers: X-Signature, X-Timestamp, X-Nonce');
        }

        $ts  = (int) $timestamp;
        $now = time();
        if (abs($now - $ts) > self::TIMESTAMP_WINDOW) {
            return self::make_error('SIGNATURE_EXPIRED', 'Request timestamp is outside the allowed window');
        }

        if (!preg_match('/^[a-f0-9]{16,32}$/i', $nonce)) {
            return self::make_error('SIGNATURE_INVALID', 'Invalid nonce format');
        }

        $nonce_key = 'ta_nonce_' . $nonce;
        if (get_transient($nonce_key) !== false) {
            return self::make_error('NONCE_REUSED', 'This nonce has already been used');
        }

        $method    = strtoupper($request->get_method());
        $path      = $request->get_route();
        $body      = $request->get_body();
        $body_hash = hash('sha256', $body ?? '');

        $string_to_sign = implode("\n", [$method, $path, $timestamp, $nonce, $body_hash]);

        $secret   = self::get_secret();
        $expected = hash_hmac('sha256', $string_to_sign, $secret);

        if (!hash_equals($expected, strtolower($signature))) {
            return self::make_error('SIGNATURE_INVALID', 'Request signature does not match');
        }

        set_transient($nonce_key, 1, self::NONCE_TTL);

        // Return true = authentication passed
        return true;
    }

    public static function generate(string $method, string $path, string $timestamp, string $nonce, string $body = ''): string {
        $body_hash      = hash('sha256', $body);
        $string_to_sign = implode("\n", [strtoupper($method), $path, $timestamp, $nonce, $body_hash]);
        return hash_hmac('sha256', $string_to_sign, self::get_secret());
    }

    public static function generate_secret(): string {
        return bin2hex(random_bytes(32));
    }

    // ── Private helpers ──────────────────────────────────────

    private static function is_our_namespace(WP_REST_Request $request): bool {
        return strpos($request->get_route(), '/' . TA_API_NAMESPACE) === 0;
    }

    /**
     * permission_callback expects WP_Error to block a request.
     */
    private static function make_error(string $code, string $message): \WP_Error {
        return new \WP_Error($code, $message, ['status' => 401]);
    }
}
