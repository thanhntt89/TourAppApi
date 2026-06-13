<?php
defined('ABSPATH') || exit;

class TA_EP_Journeys {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/journeys', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_journeys'],
            'permission_callback' => '__return_true',
            'args'                => [
                'province_id' => [
                    'required'          => true,
                    'type'              => 'integer',
                    'sanitize_callback' => 'absint',
                ],
                'lang' => [
                    'type'    => 'string',
                    'default' => TA_DEFAULT_LANG,
                ],
                'featured' => [
                    'type' => 'boolean',
                ],
            ],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/journeys/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_journey'],
            'permission_callback' => '__return_true',
            'args'                => [
                'id'   => ['type' => 'integer', 'required' => true],
                'lang' => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /journeys
    // ──────────────────────────────────────────────
    public static function list_journeys(WP_REST_Request $request): WP_REST_Response {
        $province_id = (int) $request->get_param('province_id');
        $lang        = TA_Localize::get_lang($request);
        $featured    = $request->get_param('featured');

        $meta_query = [
            [
                'key'   => 'journey_province',
                'value' => $province_id,
            ],
        ];

        if ($featured !== null) {
            $meta_query[] = [
                'key'   => 'journey_is_featured',
                'value' => $featured ? '1' : '0',
            ];
            $meta_query['relation'] = 'AND';
        }

        $posts = get_posts([
            'post_type'      => 'journey',
            'post_status'    => 'publish',
            'posts_per_page' => -1,
            'meta_query'     => $meta_query,
            'meta_key'       => 'journey_sort_order',
            'orderby'        => 'meta_value_num',
            'order'          => 'ASC',
        ]);

        $journeys = array_map(function ($post) use ($lang) {
            return self::format_journey($post, $lang);
        }, $posts);

        return TA_API::success($journeys, ['total' => count($journeys)]);
    }

    // ──────────────────────────────────────────────
    // GET /journeys/{id}
    // ──────────────────────────────────────────────
    public static function get_journey(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $lang = TA_Localize::get_lang($request);
        $post = get_post($id);

        if (!$post || $post->post_type !== 'journey' || $post->post_status !== 'publish') {
            return TA_API::error('journey_not_found', 'Journey not found.', 404);
        }

        return TA_API::success(self::format_journey($post, $lang));
    }

    // ──────────────────────────────────────────────
    // Format helpers
    // ──────────────────────────────────────────────

    private static function format_journey(WP_Post $post, string $lang): array {
        $id = $post->ID;

        return [
            'id'            => $id,
            'type'          => 'preset',
            'name'          => TA_Localize::get_field_localized($id, 'journey_name', $lang),
            'description'   => TA_Localize::get_field_localized($id, 'journey_desc', $lang),
            'feature_image' => TA_Localize::format_image(get_field('journey_feature_image', $id)),
            'duration_days' => (int) get_field('journey_duration_days', $id),
            'total_places'  => (int) get_field('journey_total_places', $id),
            'difficulty'    => get_field('journey_difficulty', $id) ?: 'easy',
            'is_featured'   => (bool) get_field('journey_is_featured', $id),
            'sort_order'    => (int) get_field('journey_sort_order', $id),
            'stops'         => self::format_stops($id, $lang),
        ];
    }

    private static function format_stops(int $journey_id, string $lang): array {
        $rows = get_field('journey_stops', $journey_id);

        if (is_string($rows) && !empty($rows)) {
            $rows = json_decode($rows, true);
        }

        if (empty($rows) || !is_array($rows)) {
            return [];
        }

        $stops = [];

        foreach ($rows as $row) {
            $place_post = $row['journey_stop_place'] ?? null;

            // ACF Post Object can return a WP_Post or an ID.
            if (is_numeric($place_post)) {
                $place_post = get_post((int) $place_post);
            }

            $place_data = null;
            if ($place_post instanceof WP_Post) {
                $pid = $place_post->ID;
                $place_data = [
                    'id'            => $pid,
                    'name'          => TA_Localize::get_field_localized($pid, 'place_name', $lang),
                    'feature_image' => TA_Localize::format_image(get_field('place_feature_image', $pid)),
                    'lat'           => (float) get_field('place_lat', $pid),
                    'lng'           => (float) get_field('place_lng', $pid),
                ];
            }

            $stops[] = [
                'stop_order'   => (int) ($row['journey_stop_order'] ?? 0),
                'day'          => (int) ($row['journey_stop_day'] ?? 1),
                'place'        => $place_data,
                'duration_min' => (int) ($row['journey_stop_duration'] ?? 0),
                'note'         => self::get_stop_note($row, $lang),
            ];
        }

        // Ensure stops are ordered.
        usort($stops, function ($a, $b) {
            return $a['stop_order'] <=> $b['stop_order'];
        });

        return $stops;
    }

    /**
     * Resolve localized note from a repeater row.
     * Sub-fields: journey_stop_note_vi, journey_stop_note_en.
     * Falls back: requested lang -> en -> vi -> ''.
     */
    private static function get_stop_note(array $row, string $lang): string {
        $value = $row["journey_stop_note_{$lang}"] ?? '';
        if (!empty($value)) {
            return $value;
        }

        if ($lang !== 'en') {
            $value = $row['journey_stop_note_en'] ?? '';
            if (!empty($value)) {
                return $value;
            }
        }

        return $row['journey_stop_note_vi'] ?? '';
    }
}
