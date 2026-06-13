<?php
defined('ABSPATH') || exit;

class TA_EP_News {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/news', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'list_news'],
            'permission_callback' => '__return_true',
            'args'                => [
                'province_id' => ['type' => 'integer', 'required' => true],
                'type'        => [
                    'type' => 'string',
                    'enum' => ['news', 'alert', 'warning', 'event'],
                ],
                'lang'        => ['type' => 'string', 'default' => TA_DEFAULT_LANG],
                'page'        => ['type' => 'integer', 'default' => 1, 'minimum' => 1],
                'per_page'    => ['type' => 'integer', 'default' => 10, 'minimum' => 1, 'maximum' => 100],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /news
    // ──────────────────────────────────────────────
    public static function list_news(WP_REST_Request $request): WP_REST_Response {
        $province_id = $request->get_param('province_id');

        if (empty($province_id)) {
            return TA_API::error('INVALID_PARAMS', 'province_id is required.', 400);
        }

        $province_id = (int) $province_id;
        $lang        = TA_Localize::get_lang($request);
        $type        = $request->get_param('type');
        $page        = max(1, (int) $request->get_param('page'));
        $per_page    = max(1, min(100, (int) $request->get_param('per_page')));

        $today = date('Ymd'); // ACF Date Picker stores as Ymd.

        // Build meta_query.
        $meta_query = [
            'relation' => 'AND',
            [
                'key'     => 'news_province',
                'value'   => $province_id,
                'compare' => '=',
            ],
            // news_start_date <= today
            [
                'key'     => 'news_start_date',
                'value'   => $today,
                'compare' => '<=',
                'type'    => 'DATE',
            ],
            // news_end_date >= today OR news_end_date is empty
            [
                'relation' => 'OR',
                [
                    'key'     => 'news_end_date',
                    'value'   => $today,
                    'compare' => '>=',
                    'type'    => 'DATE',
                ],
                [
                    'key'     => 'news_end_date',
                    'value'   => '',
                    'compare' => '=',
                ],
                [
                    'key'     => 'news_end_date',
                    'compare' => 'NOT EXISTS',
                ],
            ],
        ];

        // Optional type filter.
        if (!empty($type)) {
            $meta_query[] = [
                'key'   => 'news_type',
                'value' => $type,
            ];
        }

        // First, query all matching posts to get total count and handle sorting.
        $all_posts = get_posts([
            'post_type'      => 'news_alert',
            'post_status'    => 'publish',
            'meta_query'     => $meta_query,
            'posts_per_page' => -1,
        ]);

        $total = count($all_posts);
        $total_pages = (int) ceil($total / $per_page);

        // Sort: pinned first, then by post_date DESC.
        usort($all_posts, function ($a, $b) {
            $a_pinned = (bool) get_field('news_is_pinned', $a->ID);
            $b_pinned = (bool) get_field('news_is_pinned', $b->ID);

            if ($a_pinned !== $b_pinned) {
                return $b_pinned <=> $a_pinned;
            }

            return strtotime($b->post_date) <=> strtotime($a->post_date);
        });

        // Paginate.
        $offset = ($page - 1) * $per_page;
        $paged_posts = array_slice($all_posts, $offset, $per_page);

        // Format items.
        $items = array_map(function ($post) use ($lang) {
            return self::format_news($post, $lang);
        }, $paged_posts);

        return TA_API::success($items, [
            'total'       => $total,
            'page'        => $page,
            'per_page'    => $per_page,
            'total_pages' => $total_pages,
        ]);
    }

    // ──────────────────────────────────────────────
    // Format helpers
    // ──────────────────────────────────────────────

    private static function format_news(WP_Post $post, string $lang): array {
        $id = $post->ID;

        return [
            'id'         => $id,
            'type'       => get_field('news_type', $id) ?: 'news',
            'title'      => TA_Localize::get_field_localized($id, 'news_title', $lang),
            'content'    => TA_Localize::get_field_localized($id, 'news_content', $lang),
            'icon'       => get_field('news_icon', $id) ?: 'info',
            'is_pinned'  => (bool) get_field('news_is_pinned', $id),
            'start_date' => get_field('news_start_date', $id) ?: null,
            'end_date'   => get_field('news_end_date', $id) ?: null,
            'created_at' => $post->post_date,
        ];
    }
}
