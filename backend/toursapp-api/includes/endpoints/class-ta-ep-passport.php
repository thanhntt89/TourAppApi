<?php
defined('ABSPATH') || exit;

class TA_EP_Passport {

    public static function register_routes() {
        register_rest_route(TA_API_NAMESPACE, '/user/passport/(?P<journey_id>\d+)', [
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => [self::class, 'get_passport'],
            'permission_callback' => [TA_Auth::class, 'permission_check_device'],
            'args'                => [
                'journey_id' => [
                    'required' => true,
                    'type'     => 'integer',
                ],
                'lang' => [
                    'type'    => 'string',
                    'default' => TA_DEFAULT_LANG,
                ],
            ],
        ]);
    }

    // ──────────────────────────────────────────────
    // GET /user/passport/{journey_id}
    // ──────────────────────────────────────────────
    public static function get_passport(WP_REST_Request $request): WP_REST_Response {
        $uuid       = TA_Auth::get_device_uuid($request);
        $journey_id = (int) $request->get_param('journey_id');
        $lang       = TA_Localize::get_lang($request);

        $journey = get_post($journey_id);
        if (!$journey || $journey->post_type !== 'journey' || $journey->post_status !== 'publish') {
            return TA_API::error('journey_not_found', 'Journey not found.', 404);
        }

        $place_ids   = self::get_journey_place_ids($journey_id);
        $place_order = array_flip($place_ids);

        if (empty($place_ids)) {
            return TA_API::success(self::build_response($journey_id, $lang, [], []));
        }

        // Batch queries
        $checkins         = self::get_checkins_batch($uuid, $place_ids);
        $content_progress = self::get_content_progress_batch($uuid, $place_ids);
        $planned_ids      = self::get_planned_place_ids($uuid, $journey_id);

        // Build per-place data
        $places       = [];
        $filters      = ['all' => 0, 'discovered' => 0, 'explored' => 0, 'planned' => 0, 'unexplored' => 0];
        $next_actions = [];
        $visited_count    = 0;
        $discovered_count = 0;

        foreach ($place_ids as $pid) {
            $is_visited = isset($checkins[$pid]);
            $is_planned = in_array($pid, $planned_ids, true);

            $has_article = self::place_has_content($pid, 'article', $lang);
            $has_audio   = self::place_has_content($pid, 'audio', $lang);

            $story_pct = $has_article ? (int) ($content_progress[$pid]['article_read'] ?? 0) : 100;
            $audio_pct = $has_audio   ? (int) ($content_progress[$pid]['audio'] ?? 0)        : 100;

            $flower_earned = $is_visited && $story_pct >= 100 && $audio_pct >= 100;

            if ($is_visited && $flower_earned) {
                $status = 'discovered';
            } elseif ($is_visited) {
                $status = 'explored';
            } elseif ($is_planned) {
                $status = 'planned';
            } else {
                $status = 'unexplored';
            }

            if ($is_visited) $visited_count++;
            if ($flower_earned) $discovered_count++;

            $filters['all']++;
            $filters[$status]++;

            $place_name = TA_Localize::get_field_localized($pid, 'place_name', $lang);

            if ($is_visited && !$flower_earned) {
                if ($has_article && $story_pct < 100) {
                    $next_actions[] = [
                        'place_id' => $pid,
                        'type'     => 'story',
                        'label'    => "Complete $place_name Story",
                    ];
                }
                if ($has_audio && $audio_pct < 100) {
                    $next_actions[] = [
                        'place_id' => $pid,
                        'type'     => 'audio',
                        'label'    => "Complete $place_name Audio Guide",
                    ];
                }
            }

            $places[] = [
                'place_id'          => $pid,
                'name'              => $place_name,
                'feature_image'     => TA_Localize::format_image(get_field('place_feature_image', $pid)),
                'stop_order'        => $place_order[$pid] ?? 0,
                'is_visited'        => $is_visited,
                'checked_in_at'     => $checkins[$pid]['created_at'] ?? null,
                'story_progress_pct' => $has_article ? $story_pct : null,
                'audio_progress_pct' => $has_audio ? $audio_pct : null,
                'status'            => $status,
                'flower_earned'     => $flower_earned,
            ];
        }

        $total    = $filters['all'];
        $stamp_pct = $total > 0 ? (int) round(($discovered_count / $total) * 100) : 0;

        return TA_API::success([
            'journey' => [
                'id'            => $journey_id,
                'name'          => TA_Localize::get_field_localized($journey_id, 'journey_name', $lang),
                'passport_name' => get_field('journey_passport_name', $journey_id) ?: '',
                'feature_image' => TA_Localize::format_image(get_field('journey_feature_image', $journey_id)),
                'stamp_image'   => TA_Localize::format_image(get_field('journey_stamp_image', $journey_id)),
            ],
            'stamp' => [
                'progress_pct'    => $stamp_pct,
                'is_locked'       => $discovered_count < $total,
                'total_required'  => $total,
                'total_completed' => $discovered_count,
            ],
            'summary' => [
                'total_places'      => $total,
                'places_visited'    => $visited_count,
                'places_discovered' => $discovered_count,
                'filters'           => $filters,
            ],
            'next_actions' => $next_actions,
            'places'       => $places,
        ]);
    }

    // ──────────────────────────────────────────────
    // Data helpers
    // ──────────────────────────────────────────────

    private static function get_journey_place_ids(int $journey_id): array {
        $rows = get_field('journey_stops', $journey_id);

        if (is_string($rows) && !empty($rows)) {
            $rows = json_decode($rows, true);
        }
        if (empty($rows) || !is_array($rows)) {
            return [];
        }

        $ids = [];
        foreach ($rows as $row) {
            $place = $row['journey_stop_place'] ?? null;
            $pid   = is_numeric($place) ? (int) $place : ($place instanceof WP_Post ? $place->ID : 0);
            if ($pid && get_post_status($pid) === 'publish') {
                $ids[] = $pid;
            }
        }

        return $ids;
    }

    private static function get_checkins_batch(string $uuid, array $place_ids): array {
        global $wpdb;
        $placeholders = implode(',', array_fill(0, count($place_ids), '%d'));

        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT place_id, created_at
             FROM {$wpdb->prefix}ta_checkins
             WHERE device_uuid = %s AND place_id IN ($placeholders)",
            array_merge([$uuid], $place_ids)
        ), ARRAY_A);

        $map = [];
        foreach ($rows as $row) {
            $map[(int) $row['place_id']] = $row;
        }
        return $map;
    }

    private static function get_content_progress_batch(string $uuid, array $place_ids): array {
        global $wpdb;
        $placeholders = implode(',', array_fill(0, count($place_ids), '%d'));

        $rows = $wpdb->get_results($wpdb->prepare(
            "SELECT content_id, event_type, MAX(completion_pct) AS max_pct
             FROM {$wpdb->prefix}ta_content_events
             WHERE device_uuid = %s
               AND content_type = 'place'
               AND content_id IN ($placeholders)
               AND event_type IN ('article_read', 'audio_play', 'audio_complete')
             GROUP BY content_id, event_type",
            array_merge([$uuid], $place_ids)
        ), ARRAY_A);

        $map = [];
        foreach ($rows as $row) {
            $pid  = (int) $row['content_id'];
            $pct  = (int) $row['max_pct'];
            $type = $row['event_type'];

            if (!isset($map[$pid])) {
                $map[$pid] = [];
            }

            if ($type === 'article_read') {
                $map[$pid]['article_read'] = max($map[$pid]['article_read'] ?? 0, $pct);
            } else {
                $map[$pid]['audio'] = max($map[$pid]['audio'] ?? 0, $pct);
            }
        }

        return $map;
    }

    private static function get_planned_place_ids(string $uuid, int $journey_id): array {
        global $wpdb;

        $user_journey_ids = $wpdb->get_col($wpdb->prepare(
            "SELECT id FROM {$wpdb->prefix}ta_user_journeys
             WHERE device_uuid = %s AND source_journey_id = %d",
            $uuid, $journey_id
        ));

        if (empty($user_journey_ids)) {
            return [];
        }

        $placeholders = implode(',', array_fill(0, count($user_journey_ids), '%d'));

        return array_map('intval', $wpdb->get_col($wpdb->prepare(
            "SELECT DISTINCT place_id
             FROM {$wpdb->prefix}ta_user_journey_stops
             WHERE journey_id IN ($placeholders) AND status = 'planned'",
            $user_journey_ids
        )));
    }

    private static function place_has_content(int $pid, string $type, string $lang): bool {
        if ($type === 'article') {
            $value = TA_Localize::get_field_localized($pid, 'place_article', $lang);
            return !empty(trim(strip_tags((string) $value)));
        }

        $audio = get_field('place_audio', $pid);
        return !empty($audio);
    }

    private static function build_response(int $journey_id, string $lang, array $places, array $next_actions): array {
        return [
            'journey' => [
                'id'            => $journey_id,
                'name'          => TA_Localize::get_field_localized($journey_id, 'journey_name', $lang),
                'passport_name' => get_field('journey_passport_name', $journey_id) ?: '',
                'feature_image' => TA_Localize::format_image(get_field('journey_feature_image', $journey_id)),
                'stamp_image'   => TA_Localize::format_image(get_field('journey_stamp_image', $journey_id)),
            ],
            'stamp' => [
                'progress_pct'    => 0,
                'is_locked'       => true,
                'total_required'  => 0,
                'total_completed' => 0,
            ],
            'summary' => [
                'total_places'      => 0,
                'places_visited'    => 0,
                'places_discovered' => 0,
                'filters' => ['all' => 0, 'discovered' => 0, 'explored' => 0, 'planned' => 0, 'unexplored' => 0],
            ],
            'next_actions' => $next_actions,
            'places'       => $places,
        ];
    }
}
