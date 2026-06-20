<?php
defined('ABSPATH') || exit;

class TA_Fields {

    private static $langs = [
        'vi' => 'VI – Tiếng Việt',
        'en' => 'EN – English',
        'ko' => 'KO – 한국어',
        'zh' => 'ZH – 中文',
        'fr' => 'FR – Français',
    ];

    public static function register() {
        if (!function_exists('acf_import_field_group')) {
            return;
        }
        if (get_option('ta_acf_fields_version') === TA_VERSION) {
            return;
        }
        self::import('group_ta_province',  'Province Settings',      'province',   self::province());
        self::import('group_ta_location',  'Location Settings',      'ta_location', self::location());
        self::import('group_ta_place',     'Place Settings',         'place',       self::place());
        self::import('group_ta_sub_place', 'Sub-Place Settings',     'sub_place',   self::sub_place());
        self::import('group_ta_sub_item',  'Sub-Item Settings',      'sub_item',    self::sub_item());
        self::import('group_ta_journey',   'Journey Settings',       'journey',     self::journey());
        self::import('group_ta_news',      'News / Alert Settings',  'news_alert',  self::news());
        self::import('group_ta_story',     'Story Settings',         'ta_story',    self::story());
        update_option('ta_acf_fields_version', TA_VERSION);
    }

    public static function reimport() {
        delete_option('ta_acf_fields_version');
        self::register();
    }

    // ── Core helpers ─────────────────────────────────

    private static function import($key, $title, $post_type, $fields) {
        acf_import_field_group([
            'key'      => $key,
            'title'    => $title,
            'fields'   => $fields,
            'location' => [[['param' => 'post_type', 'operator' => '==', 'value' => $post_type]]],
            'position' => 'normal',
            'style'    => 'default',
            'active'   => true,
        ]);
    }

    private static function k($n) {
        return 'field_ta_' . $n;
    }

    private static function tab($prefix, $label) {
        return [
            'key'   => self::k($prefix . '_tab_' . sanitize_title($label)),
            'label' => $label,
            'type'  => 'tab',
        ];
    }

    private static function lang_tab($prefix, $code) {
        return self::tab($prefix, self::$langs[$code]);
    }

    // Single-language field helpers
    private static function one_text($prefix, $label, $lang) {
        return [
            'key'   => self::k($prefix . '_' . $lang),
            'label' => $label,
            'name'  => $prefix . '_' . $lang,
            'type'  => 'text',
        ];
    }

    private static function one_wysiwyg($prefix, $label, $lang) {
        return [
            'key'          => self::k($prefix . '_' . $lang),
            'label'        => $label,
            'name'         => $prefix . '_' . $lang,
            'type'         => 'wysiwyg',
            'tabs'         => 'all',
            'toolbar'      => 'full',
            'media_upload' => 1,
        ];
    }

    private static function one_file($prefix, $label, $lang) {
        return [
            'key'          => self::k($prefix . '_' . $lang),
            'label'        => $label,
            'name'         => $prefix . '_' . $lang,
            'type'         => 'text',
            'instructions' => 'Paste URL or click Browse to select from server',
            'placeholder'  => 'https://',
            'wrapper'      => ['class' => 'ta-audio-url-field'],
        ];
    }

    // Append language tabs for a set of translatable field definitions.
    // $builders: array of ['prefix' => '...', 'label' => '...', 'type' => 'text|wysiwyg|file']
    private static function append_lang_tabs(string $prefix, array $builders): array {
        $f = [];
        foreach (self::$langs as $code => $lang_label) {
            $f[] = self::lang_tab($prefix, $code);
            foreach ($builders as $b) {
                switch ($b['type']) {
                    case 'wysiwyg':
                        $f[] = self::one_wysiwyg($b['prefix'], $b['label'], $code);
                        break;
                    case 'file':
                        $f[] = self::one_file($b['prefix'], $b['label'], $code);
                        break;
                    default:
                        $f[] = self::one_text($b['prefix'], $b['label'], $code);
                }
            }
        }
        return $f;
    }

    // ── Province ─────────────────────────────────────

    private static function province() {
        $f = [];

        $f[] = self::tab('prov', 'General');
        $f[] = ['key' => self::k('province_feature_image'),   'label' => 'Feature Image',           'name' => 'province_feature_image',   'type' => 'image',      'return_format' => 'id', 'preview_size' => 'medium'];
$f[] = ['key' => self::k('province_lat'),             'label' => 'Latitude',                 'name' => 'province_lat',             'type' => 'number',     'step' => 'any'];
        $f[] = ['key' => self::k('province_lng'),             'label' => 'Longitude',                'name' => 'province_lng',             'type' => 'number',     'step' => 'any'];
        $f[] = ['key' => self::k('province_detect_radius'),   'label' => 'Detection Radius (km)',    'name' => 'province_detect_radius',   'type' => 'number',     'default_value' => 50];
        $f[] = ['key' => self::k('province_is_active'),       'label' => 'Active',                   'name' => 'province_is_active',       'type' => 'true_false', 'default_value' => 1, 'ui' => 1];
        $f[] = ['key' => self::k('province_sort_order'),      'label' => 'Sort Order',               'name' => 'province_sort_order',      'type' => 'number',     'default_value' => 0];

        $f = array_merge($f, self::append_lang_tabs('prov', [
            ['prefix' => 'province_name', 'label' => 'Province Name', 'type' => 'text'],
            ['prefix' => 'province_desc', 'label' => 'Description',   'type' => 'wysiwyg'],
        ]));

        return $f;
    }

    // ── Location ─────────────────────────────────────

    private static function location() {
        $f = [];

        $f[] = self::tab('loc', 'General');
        $f[] = ['key' => self::k('location_province'),      'label' => 'Province',          'name' => 'location_province',      'type' => 'post_object', 'post_type' => ['province'], 'return_format' => 'id', 'required' => 1];
        $f[] = ['key' => self::k('location_number'),        'label' => 'Location Number',   'name' => 'location_number',        'type' => 'number',      'required' => 1];
        $f[] = ['key' => self::k('location_feature_image'), 'label' => 'Feature Image',     'name' => 'location_feature_image', 'type' => 'image',       'return_format' => 'id', 'preview_size' => 'medium'];
        $f[] = ['key' => self::k('location_lat'),           'label' => 'Latitude',          'name' => 'location_lat',           'type' => 'number',      'step' => 'any'];
        $f[] = ['key' => self::k('location_lng'),           'label' => 'Longitude',         'name' => 'location_lng',           'type' => 'number',      'step' => 'any'];
        $f[] = ['key' => self::k('location_sort_order'),    'label' => 'Sort Order',        'name' => 'location_sort_order',    'type' => 'number',      'default_value' => 0];

        $f = array_merge($f, self::append_lang_tabs('loc', [
            ['prefix' => 'location_name', 'label' => 'Location Name', 'type' => 'text'],
            ['prefix' => 'location_desc', 'label' => 'Description',   'type' => 'wysiwyg'],
        ]));

        return $f;
    }

    // ── Place ─────────────────────────────────────────

    private static function place() {
        $f = [];

        $f[] = self::tab('place', 'General');
        $f[] = ['key' => self::k('place_location'),           'label' => 'Location',                   'name' => 'place_location',           'type' => 'post_object', 'post_type' => ['ta_location'], 'return_format' => 'id', 'required' => 1];
        $f[] = ['key' => self::k('place_order_number'),       'label' => 'Order Number',               'name' => 'place_order_number',       'type' => 'number'];
        $f[] = ['key' => self::k('place_feature_image'),      'label' => 'Feature Image',              'name' => 'place_feature_image',      'type' => 'image',       'return_format' => 'id', 'preview_size' => 'medium'];
$f[] = ['key' => self::k('place_lat'),                'label' => 'Latitude',                   'name' => 'place_lat',                'type' => 'number',      'step' => 'any'];
        $f[] = ['key' => self::k('place_lng'),                'label' => 'Longitude',                  'name' => 'place_lng',                'type' => 'number',      'step' => 'any'];
        $f[] = ['key' => self::k('place_geofence_radius'),    'label' => 'Geofence Radius (m)',        'name' => 'place_geofence_radius',    'type' => 'number',      'default_value' => 300];
        $f[] = ['key' => self::k('place_qr_code'),            'label' => 'QR Code',                    'name' => 'place_qr_code',            'type' => 'text'];
        $f[] = ['key' => self::k('place_audio_duration'),     'label' => 'Audio Duration (seconds)',   'name' => 'place_audio_duration',     'type' => 'number',      'step' => '0.1'];
        $f[] = ['key' => self::k('place_is_featured'),        'label' => 'Featured',                   'name' => 'place_is_featured',        'type' => 'true_false',  'ui' => 1];
        $f[] = ['key' => self::k('place_show_article_free'),  'label' => 'Show Article Free',          'name' => 'place_show_article_free',  'type' => 'true_false',  'ui' => 1];
        $f[] = ['key' => self::k('place_show_audio_free'),    'label' => 'Show Audio Free',            'name' => 'place_show_audio_free',    'type' => 'true_false',  'ui' => 1];
        $f[] = ['key' => self::k('place_article_offline'),    'label' => 'Article Available Offline',  'name' => 'place_article_offline',    'type' => 'true_false',  'ui' => 1];
        $f[] = ['key' => self::k('place_audio_offline'),      'label' => 'Audio Available Offline',    'name' => 'place_audio_offline',      'type' => 'true_false',  'ui' => 1];
        $f[] = ['key' => self::k('place_article_cost'),       'label' => 'Article Unlock Cost',        'name' => 'place_article_cost',       'type' => 'number',      'default_value' => 5];
        $f[] = ['key' => self::k('place_audio_cost'),         'label' => 'Audio Unlock Cost',          'name' => 'place_audio_cost',         'type' => 'number',      'default_value' => 5];
        $f[] = ['key' => self::k('place_checkin_reward'),     'label' => 'Check-in Reward (flowers)',  'name' => 'place_checkin_reward',     'type' => 'number',      'default_value' => 10];
        $f[] = ['key' => self::k('place_sort_order'),         'label' => 'Sort Order',                 'name' => 'place_sort_order',         'type' => 'number',      'default_value' => 0];
        $f[] = ['key' => self::k('place_enable_tracking'),    'label' => 'Enable Engagement Tracking', 'name' => 'place_enable_tracking',    'type' => 'true_false',  'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('place_allow_comments'),     'label' => 'Allow Comments',             'name' => 'place_allow_comments',     'type' => 'true_false',  'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('place_allow_ratings'),      'label' => 'Allow Ratings',              'name' => 'place_allow_ratings',      'type' => 'true_false',  'ui' => 1, 'default_value' => 1];

        $f = array_merge($f, self::append_lang_tabs('place', [
            ['prefix' => 'place_name',    'label' => 'Place Name',  'type' => 'text'],
            ['prefix' => 'place_info',    'label' => 'Short Info',  'type' => 'wysiwyg'],
            ['prefix' => 'place_article', 'label' => 'Article',     'type' => 'wysiwyg'],
            ['prefix' => 'place_audio',   'label' => 'Audio File',  'type' => 'file'],
        ]));

        return $f;
    }

    // ── Sub-Place ─────────────────────────────────────

    private static function sub_place() {
        $f = [];

        $f[] = self::tab('sp', 'General');
        $f[] = ['key' => self::k('sub_place_place'),         'label' => 'Parent Place',        'name' => 'sub_place_place',         'type' => 'post_object', 'post_type' => ['place'], 'return_format' => 'id', 'required' => 1];
        $f[] = ['key' => self::k('sub_place_index'),         'label' => 'Sub-Place Index',     'name' => 'sub_place_index',         'type' => 'text',        'instructions' => 'e.g. A, B, C or 1, 2, 3'];
        $f[] = ['key' => self::k('sub_place_feature_image'), 'label' => 'Feature Image',       'name' => 'sub_place_feature_image', 'type' => 'image',       'return_format' => 'id', 'preview_size' => 'medium'];
        $f[] = ['key' => self::k('sub_place_lat'),           'label' => 'Latitude',            'name' => 'sub_place_lat',           'type' => 'number',      'step' => 'any'];
        $f[] = ['key' => self::k('sub_place_lng'),           'label' => 'Longitude',           'name' => 'sub_place_lng',           'type' => 'number',      'step' => 'any'];
        $f[] = ['key' => self::k('sub_place_audio_duration'),'label' => 'Audio Duration (s)',  'name' => 'sub_place_audio_duration','type' => 'number',      'step' => '0.1'];
        $f[] = ['key' => self::k('sub_place_sort_order'),        'label' => 'Sort Order',                  'name' => 'sub_place_sort_order',        'type' => 'number',     'default_value' => 0];
        $f[] = ['key' => self::k('sub_place_show_audio_free'),    'label' => 'Show Audio Free',             'name' => 'sub_place_show_audio_free',   'type' => 'true_false', 'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('sub_place_audio_cost'),         'label' => 'Audio Unlock Cost',           'name' => 'sub_place_audio_cost',        'type' => 'number',     'default_value' => 5];
        $f[] = ['key' => self::k('sub_place_enable_tracking'),    'label' => 'Enable Engagement Tracking',  'name' => 'sub_place_enable_tracking',   'type' => 'true_false', 'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('sub_place_allow_comments'),     'label' => 'Allow Comments',              'name' => 'sub_place_allow_comments',    'type' => 'true_false', 'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('sub_place_allow_ratings'),      'label' => 'Allow Ratings',               'name' => 'sub_place_allow_ratings',     'type' => 'true_false', 'ui' => 1, 'default_value' => 1];

        $f = array_merge($f, self::append_lang_tabs('sp', [
            ['prefix' => 'sub_place_name',  'label' => 'Name',        'type' => 'text'],
            ['prefix' => 'sub_place_desc',  'label' => 'Description', 'type' => 'wysiwyg'],
            ['prefix' => 'sub_place_audio', 'label' => 'Audio File',  'type' => 'file'],
        ]));

        return $f;
    }

    // ── Sub-Item ──────────────────────────────────────

    private static function sub_item() {
        $f = [];

        $f[] = self::tab('si', 'General');
        $f[] = ['key' => self::k('sub_item_sub_place'),     'label' => 'Parent Sub-Place', 'name' => 'sub_item_sub_place',     'type' => 'post_object', 'post_type' => ['sub_place'], 'return_format' => 'id', 'required' => 1];
        $f[] = ['key' => self::k('sub_item_index'),         'label' => 'Item Index',       'name' => 'sub_item_index',         'type' => 'text'];
        $f[] = ['key' => self::k('sub_item_feature_image'), 'label' => 'Feature Image',    'name' => 'sub_item_feature_image', 'type' => 'image',       'return_format' => 'id', 'preview_size' => 'medium'];
        $f[] = ['key' => self::k('sub_item_sort_order'),        'label' => 'Sort Order',                 'name' => 'sub_item_sort_order',        'type' => 'number',     'default_value' => 0];
        $f[] = ['key' => self::k('sub_item_enable_tracking'),    'label' => 'Enable Engagement Tracking', 'name' => 'sub_item_enable_tracking',    'type' => 'true_false', 'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('sub_item_allow_comments'),     'label' => 'Allow Comments',             'name' => 'sub_item_allow_comments',     'type' => 'true_false', 'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('sub_item_allow_ratings'),      'label' => 'Allow Ratings',              'name' => 'sub_item_allow_ratings',      'type' => 'true_false', 'ui' => 1, 'default_value' => 1];

        $f = array_merge($f, self::append_lang_tabs('si', [
            ['prefix' => 'sub_item_name',  'label' => 'Name',        'type' => 'text'],
            ['prefix' => 'sub_item_desc',  'label' => 'Description', 'type' => 'wysiwyg'],
            ['prefix' => 'sub_item_audio', 'label' => 'Audio File',  'type' => 'file'],
        ]));

        return $f;
    }

    // ── Journey ───────────────────────────────────────

    private static function journey() {
        $f = [];

        $f[] = self::tab('jrn', 'General');
        $f[] = ['key' => self::k('journey_province'),       'label' => 'Province',           'name' => 'journey_province',       'type' => 'post_object', 'post_type' => ['province'], 'return_format' => 'id', 'required' => 1];
        $f[] = ['key' => self::k('journey_feature_image'),  'label' => 'Feature Image',      'name' => 'journey_feature_image',  'type' => 'image',       'return_format' => 'id', 'preview_size' => 'medium'];
        $f[] = ['key' => self::k('journey_duration_days'),  'label' => 'Duration (days)',    'name' => 'journey_duration_days',  'type' => 'number',      'default_value' => 1];
        $f[] = ['key' => self::k('journey_difficulty'),     'label' => 'Difficulty',         'name' => 'journey_difficulty',     'type' => 'select',      'choices' => ['easy' => 'Easy', 'medium' => 'Medium', 'hard' => 'Hard'], 'default_value' => 'easy'];
        $f[] = ['key' => self::k('journey_is_featured'),    'label' => 'Featured',           'name' => 'journey_is_featured',    'type' => 'true_false',  'ui' => 1];
        $f[] = ['key' => self::k('journey_sort_order'),     'label' => 'Sort Order',         'name' => 'journey_sort_order',     'type' => 'number',      'default_value' => 0];

        $f = array_merge($f, self::append_lang_tabs('jrn', [
            ['prefix' => 'journey_name', 'label' => 'Journey Name', 'type' => 'text'],
            ['prefix' => 'journey_desc', 'label' => 'Description',  'type' => 'wysiwyg'],
        ]));

        return $f;
    }

    // ── News & Alerts ─────────────────────────────────

    private static function news() {
        $f = [];

        $f[] = self::tab('news', 'General');
        $f[] = ['key' => self::k('news_province'),    'label' => 'Province',    'name' => 'news_province',    'type' => 'post_object',  'post_type' => ['province'], 'return_format' => 'id', 'required' => 1];
        $f[] = ['key' => self::k('news_type'),        'label' => 'Type',        'name' => 'news_type',        'type' => 'select',       'choices' => ['news' => 'News', 'alert' => 'Alert', 'warning' => 'Warning', 'event' => 'Event'], 'default_value' => 'news'];
        $f[] = ['key' => self::k('news_icon'),        'label' => 'Icon',        'name' => 'news_icon',        'type' => 'text',         'default_value' => 'info'];
        $f[] = ['key' => self::k('news_is_pinned'),   'label' => 'Pinned',      'name' => 'news_is_pinned',   'type' => 'true_false',   'ui' => 1];
        $f[] = ['key' => self::k('news_image'),       'label' => 'Image',       'name' => 'news_image',       'type' => 'image',        'return_format' => 'id', 'preview_size' => 'medium'];
        $f[] = ['key' => self::k('news_start_date'),  'label' => 'Start Date',  'name' => 'news_start_date',  'type' => 'date_picker',  'display_format' => 'd/m/Y', 'return_format' => 'Ymd'];
        $f[] = ['key' => self::k('news_end_date'),    'label' => 'End Date',    'name' => 'news_end_date',    'type' => 'date_picker',  'display_format' => 'd/m/Y', 'return_format' => 'Ymd', 'instructions' => 'Leave empty = no expiry'];

        $f = array_merge($f, self::append_lang_tabs('news', [
            ['prefix' => 'news_title',   'label' => 'Title',   'type' => 'text'],
            ['prefix' => 'news_summary', 'label' => 'Summary', 'type' => 'wysiwyg'],
            ['prefix' => 'news_content', 'label' => 'Content', 'type' => 'wysiwyg'],
        ]));

        return $f;
    }

    // ── Story ─────────────────────────────────────────

    private static function story() {
        $f = [];

        $f[] = self::tab('story', 'General');
        $f[] = ['key' => self::k('story_type'),               'label' => 'Story Type',          'name' => 'story_type',               'type' => 'select',     'choices' => ['legend' => 'Legend', 'history' => 'History', 'culture' => 'Culture', 'folk' => 'Folklore', 'mystery' => 'Mystery', 'nature' => 'Nature', 'other' => 'Other'], 'default_value' => 'legend'];
        $f[] = ['key' => self::k('story_is_featured'),        'label' => 'Featured',            'name' => 'story_is_featured',        'type' => 'true_false', 'ui' => 1];
        $f[] = ['key' => self::k('story_sort_order'),         'label' => 'Sort Order',          'name' => 'story_sort_order',         'type' => 'number',     'default_value' => 0];
        $f[] = ['key' => self::k('story_feature_image'),      'label' => 'Feature Image',       'name' => 'story_feature_image',      'type' => 'image',      'return_format' => 'id', 'preview_size' => 'medium'];
        $f[] = ['key' => self::k('story_related_provinces'),  'label' => 'Related Provinces',   'name' => 'story_related_provinces',  'type' => 'post_object','post_type' => ['province'], 'return_format' => 'id', 'multiple' => 1, 'ui' => 1];
        $f[] = ['key' => self::k('story_related_places'),     'label' => 'Related Places',      'name' => 'story_related_places',     'type' => 'post_object','post_type' => ['place'],    'return_format' => 'id', 'multiple' => 1, 'ui' => 1];

        $f[] = self::tab('story', 'Article Settings');
        $f[] = ['key' => self::k('story_show_article_free'),  'label' => 'Article Free',        'name' => 'story_show_article_free',  'type' => 'true_false', 'ui' => 1, 'default_value' => 1, 'instructions' => 'ON = free to read. OFF = requires flowers.'];
        $f[] = ['key' => self::k('story_article_cost'),       'label' => 'Article Unlock Cost', 'name' => 'story_article_cost',       'type' => 'number',     'default_value' => 5];
        $f[] = ['key' => self::k('story_article_offline'),    'label' => 'Article Offline',     'name' => 'story_article_offline',    'type' => 'true_false', 'ui' => 1];

        $f[] = self::tab('story', 'Audio Settings');
        $f[] = ['key' => self::k('story_show_audio_free'),    'label' => 'Audio Free',          'name' => 'story_show_audio_free',    'type' => 'true_false', 'ui' => 1, 'default_value' => 1, 'instructions' => 'ON = free to play. OFF = requires flowers.'];
        $f[] = ['key' => self::k('story_audio_cost'),         'label' => 'Audio Unlock Cost',   'name' => 'story_audio_cost',         'type' => 'number',     'default_value' => 5];
        $f[] = ['key' => self::k('story_audio_duration'),     'label' => 'Audio Duration (sec)','name' => 'story_audio_duration',     'type' => 'number',     'step' => '0.1'];
        $f[] = ['key' => self::k('story_audio_offline'),      'label' => 'Audio Offline',       'name' => 'story_audio_offline',      'type' => 'true_false', 'ui' => 1];

        $f[] = self::tab('story', 'Tracking & UGC');
        $f[] = ['key' => self::k('story_enable_tracking'),    'label' => 'Enable Tracking',     'name' => 'story_enable_tracking',    'type' => 'true_false', 'ui' => 1, 'default_value' => 1, 'instructions' => 'Collect page views, read time, audio completion data.'];
        $f[] = ['key' => self::k('story_allow_comments'),     'label' => 'Allow Comments',      'name' => 'story_allow_comments',     'type' => 'true_false', 'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('story_allow_ratings'),      'label' => 'Allow Ratings',       'name' => 'story_allow_ratings',      'type' => 'true_false', 'ui' => 1, 'default_value' => 1];
        $f[] = ['key' => self::k('story_available_offline'),  'label' => 'Available Offline',   'name' => 'story_available_offline',  'type' => 'true_false', 'ui' => 1];

        $f = array_merge($f, self::append_lang_tabs('story', [
            ['prefix' => 'story_name',    'label' => 'Story Title', 'type' => 'text'],
            ['prefix' => 'story_summary', 'label' => 'Summary',     'type' => 'wysiwyg'],
            ['prefix' => 'story_content', 'label' => 'Content',     'type' => 'wysiwyg'],
            ['prefix' => 'story_audio',   'label' => 'Audio File',  'type' => 'file'],
        ]));

        return $f;
    }
}
