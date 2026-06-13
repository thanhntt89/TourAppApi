<?php
defined('ABSPATH') || exit;

class TA_Activator {

    public static function activate() {
        self::create_tables();
        self::upgrade();
        flush_rewrite_rules();
    }

    public static function upgrade() {
        global $wpdb;
        $installed = get_option('ta_db_version', '0');

        if (version_compare($installed, '1.2.1', '<')) {
            // Make province_id nullable to support cross-province user journeys
            $wpdb->query("ALTER TABLE {$wpdb->prefix}ta_user_journeys MODIFY province_id INT NULL DEFAULT NULL");
            update_option('ta_db_version', '1.2.1');
        }
        if (version_compare($installed, '1.5.1', '<')) {
            if (!get_option(TA_Signature::OPTION_SECRET)) {
                update_option(TA_Signature::OPTION_SECRET, TA_Signature::generate_secret());
            }
            update_option('ta_db_version', '1.5.1');
        }
        if (version_compare($installed, '1.5.2', '<')) {
            // Ensure all tables exist for installs that were updated by file copy instead of re-activation
            self::create_tables();
            update_option('ta_db_version', '1.5.2');
        }
    }

    public static function deactivate() {
        flush_rewrite_rules();
    }

    private static function create_tables() {
        global $wpdb;
        $charset = $wpdb->get_charset_collate();

        $sql = "
        CREATE TABLE {$wpdb->prefix}ta_devices (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL UNIQUE,
            device_name     VARCHAR(255),
            platform        VARCHAR(10) NOT NULL DEFAULT 'android',
            app_version     VARCHAR(20),
            lang            VARCHAR(5) DEFAULT 'vi',
            push_token      VARCHAR(500),
            referral_code   VARCHAR(32) UNIQUE,
            last_province_id INT,
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX idx_uuid (device_uuid)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_wallet (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL UNIQUE,
            balance         INT DEFAULT 0,
            total_earned    INT DEFAULT 0,
            total_spent     INT DEFAULT 0,
            updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_wallet_txn (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            type            VARCHAR(30) NOT NULL,
            amount          INT NOT NULL,
            balance_after   INT NOT NULL,
            reference_type  VARCHAR(50),
            reference_id    INT,
            note            VARCHAR(255),
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_device (device_uuid),
            INDEX idx_type (type)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_checkins (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            place_id        INT NOT NULL,
            method          VARCHAR(5) NOT NULL DEFAULT 'gps',
            latitude        DECIMAL(10,7),
            longitude       DECIMAL(10,7),
            reward_amount   INT DEFAULT 0,
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_checkin (device_uuid, place_id),
            INDEX idx_device (device_uuid),
            INDEX idx_place (place_id)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_visit_history (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            place_id        INT NOT NULL,
            visit_type      VARCHAR(20) NOT NULL DEFAULT 'view',
            duration_sec    INT,
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_device_place (device_uuid, place_id),
            INDEX idx_created (created_at)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_user_journeys (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            province_id     INT NOT NULL,
            name            VARCHAR(255) NOT NULL,
            description     TEXT,
            source_journey_id INT,
            status          VARCHAR(15) DEFAULT 'planning',
            started_at      DATETIME,
            completed_at    DATETIME,
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX idx_device (device_uuid),
            INDEX idx_province (province_id)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_user_journey_stops (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            journey_id      BIGINT NOT NULL,
            place_id        INT NOT NULL,
            stop_order      INT NOT NULL,
            day_number      INT DEFAULT 1,
            note            TEXT,
            status          VARCHAR(10) DEFAULT 'planned',
            visited_at      DATETIME,
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_journey (journey_id)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_unlocked_content (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            content_type    VARCHAR(10) NOT NULL,
            content_id      INT NOT NULL,
            cost            INT NOT NULL,
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_unlock (device_uuid, content_type, content_id)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_shares (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            share_type      VARCHAR(30) NOT NULL,
            platform        VARCHAR(50),
            referral_code   VARCHAR(32),
            reward_amount   INT DEFAULT 0,
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_device (device_uuid),
            INDEX idx_referral (referral_code)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_content_events (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            content_type    VARCHAR(20) NOT NULL,
            content_id      INT NOT NULL,
            event_type      VARCHAR(30) NOT NULL,
            duration_sec    INT DEFAULT 0,
            scroll_depth    TINYINT DEFAULT 0,
            completion_pct  TINYINT DEFAULT 0,
            extra           VARCHAR(500),
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_device (device_uuid),
            INDEX idx_content (content_type, content_id),
            INDEX idx_event_type (event_type),
            INDEX idx_created (created_at)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_comments (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            content_type    VARCHAR(20) NOT NULL,
            content_id      INT NOT NULL,
            comment_text    TEXT NOT NULL,
            photo_id        INT DEFAULT 0,
            status          VARCHAR(10) NOT NULL DEFAULT 'approved',
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX idx_content (content_type, content_id),
            INDEX idx_device (device_uuid),
            INDEX idx_status (status),
            INDEX idx_created (created_at)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_ratings (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            content_type    VARCHAR(20) NOT NULL,
            content_id      INT NOT NULL,
            rating          TINYINT NOT NULL,
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            UNIQUE KEY unique_rating (device_uuid, content_type, content_id),
            INDEX idx_content (content_type, content_id)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_api_logs (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64),
            endpoint        VARCHAR(200) NOT NULL,
            method          VARCHAR(10) NOT NULL,
            status_code     SMALLINT NOT NULL,
            response_ms     INT NOT NULL,
            ip_address      VARCHAR(45),
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_endpoint (endpoint),
            INDEX idx_created (created_at),
            INDEX idx_device (device_uuid)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_downloads (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            device_uuid     VARCHAR(64) NOT NULL,
            province_id     INT NOT NULL,
            download_type   VARCHAR(20) NOT NULL DEFAULT 'full',
            lang            VARCHAR(5) DEFAULT 'vi',
            file_count      INT DEFAULT 0,
            total_size_mb   DECIMAL(8,2) DEFAULT 0,
            status          VARCHAR(15) NOT NULL DEFAULT 'started',
            started_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            completed_at    DATETIME,
            INDEX idx_device (device_uuid),
            INDEX idx_province (province_id)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_error_logs (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            log_id          BIGINT,
            device_uuid     VARCHAR(64),
            endpoint        VARCHAR(200) NOT NULL,
            method          VARCHAR(10) NOT NULL,
            status_code     SMALLINT NOT NULL,
            error_code      VARCHAR(100),
            error_message   TEXT,
            request_params  TEXT,
            response_body   TEXT,
            ip_address      VARCHAR(45),
            user_agent      VARCHAR(500),
            created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_device (device_uuid),
            INDEX idx_status (status_code),
            INDEX idx_error_code (error_code),
            INDEX idx_created (created_at)
        ) $charset;

        CREATE TABLE {$wpdb->prefix}ta_content_stats_daily (
            id             BIGINT AUTO_INCREMENT PRIMARY KEY,
            date           DATE NOT NULL,
            content_type   VARCHAR(20) NOT NULL,
            content_id     INT NOT NULL,
            event_type     VARCHAR(30) NOT NULL,
            event_count    INT DEFAULT 0,
            unique_users   INT DEFAULT 0,
            avg_duration   DECIMAL(8,2) DEFAULT 0,
            avg_scroll     DECIMAL(5,2) DEFAULT 0,
            avg_completion DECIMAL(5,2) DEFAULT 0,
            UNIQUE KEY unique_daily (date, content_type, content_id, event_type),
            INDEX idx_date (date),
            INDEX idx_content (content_type, content_id)
        ) $charset;
        ";

        require_once ABSPATH . 'wp-admin/includes/upgrade.php';
        dbDelta($sql);
    }
}
