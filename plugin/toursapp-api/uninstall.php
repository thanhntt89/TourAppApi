<?php
// Only run when WordPress calls this during plugin deletion.
if (!defined('WP_UNINSTALL_PLUGIN')) {
    exit;
}

global $wpdb;

$tables = [
    'ta_devices',
    'ta_wallet',
    'ta_wallet_txn',
    'ta_checkins',
    'ta_visit_history',
    'ta_user_journeys',
    'ta_user_journey_stops',
    'ta_unlocked_content',
    'ta_shares',
    'ta_content_events',
    'ta_comments',
    'ta_ratings',
    'ta_api_logs',
    'ta_downloads',
];

foreach ($tables as $table) {
    $wpdb->query("DROP TABLE IF EXISTS {$wpdb->prefix}{$table}");
}

// Remove plugin options.
delete_option('ta_acf_fields_version');

// Remove ACF field groups created by this plugin.
$group_keys = [
    'group_ta_province',
    'group_ta_location',
    'group_ta_place',
    'group_ta_sub_place',
    'group_ta_sub_item',
    'group_ta_journey',
    'group_ta_news',
    'group_ta_story',
];

foreach ($group_keys as $key) {
    $post = get_page_by_path($key, OBJECT, 'acf-field-group');
    if ($post) {
        wp_delete_post($post->ID, true);
    }
}
