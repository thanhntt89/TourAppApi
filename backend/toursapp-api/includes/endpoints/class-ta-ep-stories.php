<?php
defined('ABSPATH') || exit;

class TA_EP_Stories {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/stories', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_stories'],
            'permission_callback' => '__return_true',
            'args'                => [
                'lang'        => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
                'province_id' => ['type' => 'integer'],
                'place_id'    => ['type' => 'integer'],
                'type'        => ['type' => 'string'],
                'featured'    => ['type' => 'boolean'],
                'page'        => ['type' => 'integer', 'default' => 1, 'minimum' => 1],
                'per_page'    => ['type' => 'integer', 'default' => 20, 'minimum' => 1, 'maximum' => 100],
            ],
        ]);

        register_rest_route(TA_API_NAMESPACE, '/stories/(?P<id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_story'],
            'permission_callback' => '__return_true',
            'args'                => [
                'id'   => ['type' => 'integer', 'required' => true],
                'lang' => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /stories
    // ──────────────────────────────────────────────
    public static function list_stories(WP_REST_Request $request): WP_REST_Response {
        $lang        = TA_Localize::get_lang($request);
        $province_id = $request->get_param('province_id') ? (int) $request->get_param('province_id') : null;
        $place_id    = $request->get_param('place_id')    ? (int) $request->get_param('place_id')    : null;
        $type        = $request->get_param('type');
        $featured    = $request->get_param('featured');
        $page        = (int) $request->get_param('page');
        $per_page    = (int) $request->get_param('per_page');

        $query_args = [
            'post_type'      => 'ta_story',
            'post_status'    => 'publish',
            'posts_per_page' => -1,
            'orderby'        => 'meta_value_num',
            'meta_key'       => 'story_sort_order',
            'order'          => 'ASC',
        ];

        if ($type) {
            $query_args['meta_query'][] = ['key' => 'story_type', 'value' => $type];
        }

        if ($featured !== null) {
            $query_args['meta_query'][] = ['key' => 'story_is_featured', 'value' => $featured ? '1' : '0'];
        }

        if (!empty($query_args['meta_query'])) {
            $query_args['meta_query']['relation'] = 'AND';
        }

        $posts = get_posts($query_args);

        // Filter by province or place (many-to-many via ACF post_object).
        $filtered = [];
        foreach ($posts as $post) {
            if ($province_id !== null) {
                $provinces = (array) get_field('story_related_provinces', $post->ID);
                if (!in_array($province_id, $provinces)) {
                    continue;
                }
            }
            if ($place_id !== null) {
                $places = (array) get_field('story_related_places', $post->ID);
                if (!in_array($place_id, $places)) {
                    continue;
                }
            }
            $filtered[] = $post;
        }

        $total = count($filtered);
        $offset = ($page - 1) * $per_page;
        $paged  = array_slice($filtered, $offset, $per_page);

        $stories = array_map(function ($post) use ($lang) {
            return self::format_story_compact($post, $lang);
        }, $paged);

        return TA_API::success($stories, [
            'total'       => $total,
            'page'        => $page,
            'per_page'    => $per_page,
            'total_pages' => (int) ceil($total / $per_page),
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /stories/{id}
    // ──────────────────────────────────────────────
    public static function get_story(WP_REST_Request $request): WP_REST_Response {
        $id   = (int) $request->get_param('id');
        $lang = TA_Localize::get_lang($request);
        $post = get_post($id);

        if (!$post || $post->post_type !== 'ta_story' || $post->post_status !== 'publish') {
            return TA_API::error('story_not_found', 'Story not found.', 404);
        }

        return TA_API::success(self::format_story_detail($post, $lang));
    }

    // ──────────────────────────────────────────────
    // Format helpers
    // ──────────────────────────────────────────────

    private static function format_story_compact(WP_Post $post, string $lang): array {
        $id = $post->ID;
        return [
            'id'            => $id,
            'type'          => get_field('story_type', $id) ?: 'legend',
            'name'          => TA_Localize::get_field_localized($id, 'story_name', $lang),
            'summary'       => TA_Localize::get_field_localized($id, 'story_summary', $lang),
            'feature_image' => TA_Localize::format_image(get_field('story_feature_image', $id)),
            'is_featured'   => (bool) get_field('story_is_featured', $id),
            'sort_order'    => (int) get_field('story_sort_order', $id),
            'article'       => [
                'is_free' => (bool) get_field('story_show_article_free', $id) !== false
                             ? (bool) get_field('story_show_article_free', $id) : true,
                'cost'    => (int) get_field('story_article_cost', $id) ?: 5,
            ],
            'audio_info'    => [
                'is_free'  => (bool) get_field('story_show_audio_free', $id) !== false
                              ? (bool) get_field('story_show_audio_free', $id) : true,
                'cost'     => (int) get_field('story_audio_cost', $id) ?: 5,
                'duration' => (float) get_field('story_audio_duration', $id) ?: 0,
            ],
            'allow_comments'   => (bool) get_field('story_allow_comments', $id) !== false
                                  ? (bool) get_field('story_allow_comments', $id) : true,
            'allow_ratings'    => (bool) get_field('story_allow_ratings', $id) !== false
                                  ? (bool) get_field('story_allow_ratings', $id) : true,
            'enable_tracking'  => (bool) get_field('story_enable_tracking', $id) !== false
                                  ? (bool) get_field('story_enable_tracking', $id) : true,
        ];
    }

    private static function format_story_detail(WP_Post $post, string $lang): array {
        $id   = $post->ID;
        $data = self::format_story_compact($post, $lang);

        $data['content'] = TA_Localize::get_field_localized($id, 'story_content', $lang);
        $data['audio']   = TA_Localize::get_audio_localized($id, 'story_audio', $lang);

        // Related places.
        $place_ids = (array) get_field('story_related_places', $id);
        $places    = [];
        foreach (array_filter($place_ids) as $pid) {
            $p = get_post((int) $pid);
            if ($p && $p->post_status === 'publish') {
                $places[] = [
                    'id'            => $p->ID,
                    'name'          => TA_Localize::get_field_localized($p->ID, 'place_name', $lang),
                    'feature_image' => TA_Localize::format_image(get_field('place_feature_image', $p->ID)),
                ];
            }
        }
        $data['related_places'] = $places;

        // Related provinces.
        $province_ids = (array) get_field('story_related_provinces', $id);
        $provinces    = [];
        foreach (array_filter($province_ids) as $pid) {
            $p = get_post((int) $pid);
            if ($p && $p->post_status === 'publish') {
                $provinces[] = [
                    'id'   => $p->ID,
                    'name' => TA_Localize::get_field_localized($p->ID, 'province_name', $lang),
                ];
            }
        }
        $data['related_provinces'] = $provinces;

        return $data;
    }
}
