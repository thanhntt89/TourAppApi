<?php
defined('ABSPATH') || exit;

class TA_Output_Fields {

    const OPTION_KEY = 'ta_api_output_fields';

    const LOCKED_FIELDS = ['id'];

    const ROUTE_MAP = [
        'provinces'  => 'province',
        'locations'  => 'ta_location',
        'places'     => 'place',
        'sub-places' => 'sub_place',
        'sub-items'  => 'sub_item',
        'journeys'   => 'journey',
        'news'       => 'news_alert',
        'stories'    => 'ta_story',
    ];

    const SYNC_SECTION_MAP = [
        'province'   => 'province',
        'locations'  => 'ta_location',
        'places'     => 'place',
        'sub_places' => 'sub_place',
        'sub_items'  => 'sub_item',
        'journeys'   => 'journey',
        'news'       => 'news_alert',
    ];

    private static $config = null;

    public static function init(): void {
        self::$config = (array) get_option(self::OPTION_KEY, []);

        $has_disabled = false;
        foreach (self::$config as $fields) {
            if (!empty($fields)) { $has_disabled = true; break; }
        }

        if ($has_disabled) {
            add_filter('rest_post_dispatch', [self::class, 'filter_response'], 10, 3);
        }
    }

    public static function filter_response(WP_REST_Response $response, WP_REST_Server $server, WP_REST_Request $request): WP_REST_Response {
        if ($response->get_status() !== 200) return $response;

        $route = $request->get_route();
        if (strpos($route, '/' . TA_API_NAMESPACE) !== 0) return $response;

        $data = $response->get_data();
        if (empty($data['success']) || !isset($data['data'])) return $response;

        $path = substr($route, strlen('/' . TA_API_NAMESPACE));

        if (preg_match('#^/sync/package/#', $path)) {
            $changed = false;
            foreach (self::SYNC_SECTION_MAP as $section => $post_type) {
                if (!isset($data['data'][$section])) continue;
                if (empty(self::$config[$post_type])) continue;

                if ($section === 'province') {
                    $data['data'][$section] = self::strip_fields($data['data'][$section], $post_type);
                } else {
                    $data['data'][$section] = array_map(function ($item) use ($post_type) {
                        return self::strip_fields($item, $post_type);
                    }, $data['data'][$section]);
                }
                $changed = true;
            }
            if ($changed) $response->set_data($data);
            return $response;
        }

        $post_type = self::resolve_post_type($path);
        if (!$post_type || empty(self::$config[$post_type])) return $response;

        if (isset($data['data'][0]) && is_array($data['data'][0])) {
            $data['data'] = array_map(function ($item) use ($post_type) {
                return self::strip_fields($item, $post_type);
            }, $data['data']);
        } elseif (is_array($data['data']) && !empty($data['data'])) {
            $data['data'] = self::strip_fields($data['data'], $post_type);
        }

        $response->set_data($data);
        return $response;
    }

    private static function resolve_post_type(string $path): ?string {
        if (preg_match('#^/provinces/\d+/locations#', $path)) return 'ta_location';
        if (preg_match('#^/places/\d+/sub-places#', $path))  return 'sub_place';

        if (preg_match('#^/([a-z-]+)#', $path, $m)) {
            return self::ROUTE_MAP[$m[1]] ?? null;
        }

        return null;
    }

    private static function strip_fields(array $item, string $post_type): array {
        $disabled = self::$config[$post_type] ?? [];
        if (empty($disabled)) return $item;

        foreach ($disabled as $field) {
            if (in_array($field, self::LOCKED_FIELDS, true)) continue;
            unset($item[$field]);
        }

        return $item;
    }

    public static function get_field_registry(): array {
        return [
            'province' => [
                'id'                  => ['label' => 'ID',                'locked' => true],
                'name'                => ['label' => 'Name'],
                'description'         => ['label' => 'Description'],
                'feature_image'       => ['label' => 'Feature Image'],
                'latitude'            => ['label' => 'Latitude'],
                'longitude'           => ['label' => 'Longitude'],
                'detection_radius_km' => ['label' => 'Detection Radius (km)'],
                'is_active'           => ['label' => 'Is Active'],
                'total_locations'     => ['label' => 'Total Locations'],
                'total_places'        => ['label' => 'Total Places'],
                'sort_order'          => ['label' => 'Sort Order'],
            ],
            'ta_location' => [
                'id'            => ['label' => 'ID',            'locked' => true],
                'number'        => ['label' => 'Number'],
                'name'          => ['label' => 'Name'],
                'description'   => ['label' => 'Description'],
                'feature_image' => ['label' => 'Feature Image'],
                'latitude'      => ['label' => 'Latitude'],
                'longitude'     => ['label' => 'Longitude'],
                'total_places'  => ['label' => 'Total Places'],
                'sort_order'    => ['label' => 'Sort Order'],
                'distance_km'   => ['label' => 'Distance (km)'],
                'province'      => ['label' => 'Province (nested)'],
            ],
            'place' => [
                'id'                => ['label' => 'ID',                'locked' => true],
                'order_number'      => ['label' => 'Order Number'],
                'hierarchical_index'=> ['label' => 'Hierarchical Index'],
                'name'              => ['label' => 'Name'],
                'info'              => ['label' => 'Info'],
                'article'           => ['label' => 'Article'],
                'feature_image'     => ['label' => 'Feature Image'],
                'gallery'           => ['label' => 'Gallery'],
                'audio'             => ['label' => 'Audio'],
                'latitude'          => ['label' => 'Latitude'],
                'longitude'         => ['label' => 'Longitude'],
                'geofence_radius'   => ['label' => 'Geofence Radius'],
                'qr_code'           => ['label' => 'QR Code'],
                'is_featured'       => ['label' => 'Is Featured'],
                'show_article_free' => ['label' => 'Show Article Free'],
                'show_audio_free'   => ['label' => 'Show Audio Free'],
                'article_offline'   => ['label' => 'Article Offline'],
                'audio_offline'     => ['label' => 'Audio Offline'],
                'article_cost'      => ['label' => 'Article Cost'],
                'checkin_reward'    => ['label' => 'Check-in Reward'],
                'sort_order'        => ['label' => 'Sort Order'],
                'sub_places_count'  => ['label' => 'Sub-Places Count'],
                'distance_km'       => ['label' => 'Distance (km)'],
                'location'          => ['label' => 'Location (nested)'],
                'sub_places'        => ['label' => 'Sub-Places (nested)'],
                'user_status'       => ['label' => 'User Status (nested)'],
            ],
            'sub_place' => [
                'id'              => ['label' => 'ID',              'locked' => true],
                'sub_place_index' => ['label' => 'Sub-Place Index'],
                'name'            => ['label' => 'Name'],
                'description'     => ['label' => 'Description'],
                'feature_image'   => ['label' => 'Feature Image'],
                'audio'           => ['label' => 'Audio'],
                'latitude'        => ['label' => 'Latitude'],
                'longitude'       => ['label' => 'Longitude'],
                'sort_order'      => ['label' => 'Sort Order'],
                'sub_items'       => ['label' => 'Sub-Items (nested)'],
                'place'           => ['label' => 'Place (nested)'],
            ],
            'sub_item' => [
                'id'            => ['label' => 'ID',              'locked' => true],
                'item_index'    => ['label' => 'Item Index'],
                'name'          => ['label' => 'Name'],
                'description'   => ['label' => 'Description'],
                'feature_image' => ['label' => 'Feature Image'],
                'gallery'       => ['label' => 'Gallery'],
                'audio'         => ['label' => 'Audio'],
                'sort_order'    => ['label' => 'Sort Order'],
                'sub_place'     => ['label' => 'Sub-Place (nested)'],
                'place'         => ['label' => 'Place (nested)'],
            ],
            'journey' => [
                'id'            => ['label' => 'ID',             'locked' => true],
                'type'          => ['label' => 'Type'],
                'name'          => ['label' => 'Name'],
                'description'   => ['label' => 'Description'],
                'feature_image' => ['label' => 'Feature Image'],
                'duration_days' => ['label' => 'Duration (days)'],
                'difficulty'    => ['label' => 'Difficulty'],
                'total_places'  => ['label' => 'Total Places (computed)'],
                'is_featured'   => ['label' => 'Is Featured'],
                'sort_order'    => ['label' => 'Sort Order'],
                'stops'         => ['label' => 'Stops (nested)'],
            ],
            'news_alert' => [
                'id'         => ['label' => 'ID',         'locked' => true],
                'type'       => ['label' => 'Type'],
                'title'      => ['label' => 'Title'],
                'content'    => ['label' => 'Content'],
                'icon'       => ['label' => 'Icon'],
                'is_pinned'  => ['label' => 'Is Pinned'],
                'start_date' => ['label' => 'Start Date'],
                'end_date'   => ['label' => 'End Date'],
                'created_at' => ['label' => 'Created At'],
            ],
            'ta_story' => [
                'id'                => ['label' => 'ID',                'locked' => true],
                'type'              => ['label' => 'Type'],
                'name'              => ['label' => 'Name'],
                'summary'           => ['label' => 'Summary'],
                'feature_image'     => ['label' => 'Feature Image'],
                'is_featured'       => ['label' => 'Is Featured'],
                'sort_order'        => ['label' => 'Sort Order'],
                'content'           => ['label' => 'Content'],
                'audio'             => ['label' => 'Audio'],
                'audio_info'        => ['label' => 'Audio Info'],
                'allow_comments'    => ['label' => 'Allow Comments'],
                'allow_ratings'     => ['label' => 'Allow Ratings'],
                'enable_tracking'   => ['label' => 'Enable Tracking'],
                'related_places'    => ['label' => 'Related Places (nested)'],
                'related_provinces' => ['label' => 'Related Provinces (nested)'],
            ],
        ];
    }
}
