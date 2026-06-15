<?php
/**
 * Plugin Name: ToursApp API
 * Description: REST API backend for ToursApp mobile — tour guide application for Vietnamese provinces.
 * Version: 1.0.0
 * Author: ToursApp Team
 * Text Domain: toursapp
 * Requires PHP: 7.4
 * Requires at least: 5.9
 */

defined('ABSPATH') || exit;

define('TA_VERSION', '1.5.1');
define('TA_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('TA_PLUGIN_URL', plugin_dir_url(__FILE__));
define('TA_API_NAMESPACE', 'toursapp/v1');
define('TA_LANGUAGES', ['vi', 'en', 'ko', 'zh', 'fr']);
define('TA_DEFAULT_LANG', 'vi');

final class ToursApp {

    private static $instance = null;

    public static function instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function __construct() {
        $this->load_includes();
        add_action('init', [$this, 'register_post_types']);
        add_action('rest_api_init', [$this, 'register_api']);
        add_action('acf/init', ['TA_Fields', 'register']);
        add_action('rest_api_init', ['TA_API_Logger', 'init']);
        add_action('init', ['TA_Activator', 'upgrade']);
        add_action('rest_api_init', ['TA_Signature', 'init'], 3);
        add_action('rest_api_init', ['TA_API', 'init_filters'], 5);
        add_action('rest_api_init', ['TA_Output_Fields', 'init'], 20);
        add_action('save_post_place',       [self::class, 'clear_place_coords_cache']);
        add_action('save_post_ta_location', [self::class, 'clear_place_coords_cache']);
        add_filter('cron_schedules',        ['TA_Monitor', 'add_cron_interval']);
        add_action(TA_Monitor::CRON_HOOK, ['TA_Monitor', 'run']);
        add_filter('cron_schedules',           ['TA_Data_Archiver', 'add_cron_interval']);
        add_action(TA_Data_Archiver::CRON_HOOK, ['TA_Data_Archiver', 'run']);
        // AJAX for archive page
        add_action('wp_ajax_ta_archive_now',     ['TA_Archive_Page', 'ajax_archive_now']);
        add_action('wp_ajax_ta_archive_dry_run', ['TA_Archive_Page', 'ajax_dry_run']);
        add_action('wp_ajax_ta_archive_delete',  ['TA_Archive_Page', 'ajax_delete_file']);
        // admin_post_* and wp_ajax_* must be registered here — admin-post.php/admin-ajax.php skip admin_menu
        add_action('wp_ajax_ta_plugin_update',      ['TA_Admin',      'ajax_plugin_update']);
        add_action('admin_post_ta_logs_clear',      ['TA_Log_Viewer', 'handle_clear']);
        add_action('admin_post_ta_logs_delete_row', ['TA_Log_Viewer', 'handle_delete_row']);

        if (is_admin()) {
            TA_Admin_Font::register();
            add_action('load-post.php',     ['TA_Gallery_Meta', 'register']);
            add_action('load-post-new.php', ['TA_Gallery_Meta', 'register']);
            add_action('load-post.php',     ['TA_Journey_Stops_Meta', 'register']);
            add_action('load-post-new.php', ['TA_Journey_Stops_Meta', 'register']);
            add_action('admin_menu',        ['TA_Admin', 'register_menu']);
            add_action('admin_menu',        ['TA_Devices_Page', 'register_menu']);
            add_action('admin_menu',        ['TA_Analytics_Page', 'register_menu']);
            add_action('admin_menu',        ['TA_Log_Viewer', 'register_menu']);
            add_action('admin_menu',        ['TA_Monitor_Page', 'register_menu']);
            add_action('wp_ajax_ta_monitor_test', ['TA_Monitor_Page', 'handle_test_ajax']);
            add_action('admin_menu',        ['TA_Archive_Page', 'register_menu']);
            add_action('admin_menu',        ['TA_API_Docs', 'register_menu']);
            add_action('admin_menu',        ['TA_Output_Fields_Page', 'register_menu']);
        }
    }

    private function load_includes() {
        require_once TA_PLUGIN_DIR . 'includes/class-ta-activator.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-auth.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-signature.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-localize.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-geo.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-fields.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-gallery-meta.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-admin-font.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-journey-stops-meta.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-api-logger.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-feature-access.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-analytics.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-analytics-page.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-log-viewer.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-monitor.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-monitor-page.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-data-archiver.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-archive-page.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-admin.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-api-docs.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-output-fields.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-output-fields-page.php';
        require_once TA_PLUGIN_DIR . 'includes/class-ta-devices-page.php';

        require_once TA_PLUGIN_DIR . 'includes/models/class-ta-device-model.php';
        require_once TA_PLUGIN_DIR . 'includes/models/class-ta-wallet-model.php';
        require_once TA_PLUGIN_DIR . 'includes/models/class-ta-checkin-model.php';
        require_once TA_PLUGIN_DIR . 'includes/models/class-ta-journey-model.php';
        require_once TA_PLUGIN_DIR . 'includes/models/class-ta-engagement-model.php';
        require_once TA_PLUGIN_DIR . 'includes/models/class-ta-comment-model.php';
        require_once TA_PLUGIN_DIR . 'includes/models/class-ta-rating-model.php';
        require_once TA_PLUGIN_DIR . 'includes/models/class-ta-download-model.php';

        require_once TA_PLUGIN_DIR . 'includes/class-ta-api.php';
    }

    public function register_post_types() {
        $types = [
            'province' => [
                'label'  => 'Provinces',
                'labels' => ['singular_name' => 'Province', 'menu_name' => 'Provinces'],
                'icon'   => 'dashicons-location-alt',
            ],
            'ta_location' => [
                'label'  => 'Locations',
                'labels' => ['singular_name' => 'Location', 'menu_name' => 'Locations'],
                'icon'   => 'dashicons-location',
            ],
            'place' => [
                'label'  => 'Places',
                'labels' => ['singular_name' => 'Place', 'menu_name' => 'Places'],
                'icon'   => 'dashicons-admin-site',
            ],
            'sub_place' => [
                'label'  => 'Sub-Places',
                'labels' => ['singular_name' => 'Sub-Place', 'menu_name' => 'Sub-Places'],
                'icon'   => 'dashicons-admin-page',
            ],
            'sub_item' => [
                'label'  => 'Sub-Items',
                'labels' => ['singular_name' => 'Sub-Item', 'menu_name' => 'Sub-Items'],
                'icon'   => 'dashicons-media-default',
            ],
            'journey' => [
                'label'  => 'Journeys',
                'labels' => ['singular_name' => 'Journey', 'menu_name' => 'Journeys'],
                'icon'   => 'dashicons-chart-line',
            ],
            'news_alert' => [
                'label'  => 'News & Alerts',
                'labels' => ['singular_name' => 'News/Alert', 'menu_name' => 'News & Alerts'],
                'icon'   => 'dashicons-megaphone',
            ],
            'ta_story' => [
                'label'  => 'Stories',
                'labels' => ['singular_name' => 'Story', 'menu_name' => 'Stories'],
                'icon'   => 'dashicons-book-alt',
            ],
        ];

        foreach ($types as $slug => $config) {
            register_post_type($slug, [
                'labels'       => array_merge(['name' => $config['label']], $config['labels']),
                'public'       => false,
                'show_ui'      => true,
                'show_in_menu' => true,
                'menu_icon'    => $config['icon'],
                'supports'     => ['title', 'custom-fields'],
                'has_archive'  => false,
                'hierarchical' => false,
                'show_in_rest' => false,
            ]);
        }
    }

    public function register_api() {
        TA_API::register();
    }

    public function clear_place_coords_cache(): void {
        $v = (int) get_option('ta_place_coord_v', 1);
        update_option('ta_place_coord_v', $v + 1, false);
    }
}

register_activation_hook(__FILE__, ['TA_Activator', 'activate']);
register_deactivation_hook(__FILE__, ['TA_Activator', 'deactivate']);

add_action('plugins_loaded', ['ToursApp', 'instance']);
