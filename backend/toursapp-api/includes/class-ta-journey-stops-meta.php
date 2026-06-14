<?php
defined('ABSPATH') || exit;

class TA_Journey_Stops_Meta {

    public static function register() {
        add_action('add_meta_boxes', [self::class, 'add_meta_box']);
        add_action('save_post',      [self::class, 'save'], 10, 2);
        add_action('admin_enqueue_scripts', [self::class, 'enqueue']);
    }

    public static function add_meta_box() {
        add_meta_box(
            'ta_journey_stops',
            'Journey Stops',
            [self::class, 'render'],
            'journey',
            'normal',
            'high'
        );
    }

    public static function enqueue($hook) {
        if (!in_array($hook, ['post.php', 'post-new.php'], true)) return;
        $screen = get_current_screen();
        if (!$screen || $screen->post_type !== 'journey') return;

        wp_enqueue_style('ta-journey-stops', TA_PLUGIN_URL . 'assets/journey-stops.css', [], TA_VERSION);
        wp_enqueue_script('ta-journey-stops', TA_PLUGIN_URL . 'assets/journey-stops.js', ['jquery'], TA_VERSION, true);

        // Build province list.
        $provinces     = get_posts(['post_type' => 'province', 'post_status' => 'publish', 'posts_per_page' => -1, 'orderby' => 'title', 'order' => 'ASC']);
        $province_list = [];
        foreach ($provinces as $prov) {
            $province_list[] = ['id' => $prov->ID, 'label' => $prov->post_title];
        }

        // Build places grouped by province_id.
        $all_places  = get_posts(['post_type' => 'place', 'post_status' => 'publish', 'posts_per_page' => -1, 'orderby' => 'title', 'order' => 'ASC']);
        $place_by_province = [];
        foreach ($all_places as $p) {
            $loc_id      = get_field('place_location', $p->ID);
            $province_id = 0;
            if ($loc_id) {
                $province_id = (int) get_field('location_province', $loc_id);
            }
            $loc_name = $loc_id ? get_the_title($loc_id) : '';
            if (!isset($place_by_province[$province_id])) {
                $place_by_province[$province_id] = [];
            }
            $place_by_province[$province_id][] = [
                'id'    => $p->ID,
                'label' => ($loc_name ? "[$loc_name] " : '') . $p->post_title,
            ];
        }

        // Get journey's main province for default filtering
        $main_province_id = 0;
        if (isset($_GET['post'])) {
            $main_province_id = (int) get_field('journey_province', (int) $_GET['post']);
        }

        wp_localize_script('ta-journey-stops', 'taJourneyStops', [
            'provinces'       => $province_list,
            'placeByProvince' => $place_by_province,
            'mainProvinceId'  => $main_province_id,
            'nonce'           => wp_create_nonce('ta_journey_stops'),
        ]);
    }

    public static function render($post) {
        $raw          = get_post_meta($post->ID, 'journey_stops', true) ?: '[]';
        $stops        = json_decode($raw, true);
        if (!is_array($stops)) $stops = [];

        // Default province = journey's main province (ACF field)
        $main_province_id  = (int) get_field('journey_province', $post->ID);
        $is_multi_province = (bool) get_post_meta($post->ID, 'journey_is_multi_province', true);

        // Provinces list for province column
        $provinces = get_posts(['post_type' => 'province', 'post_status' => 'publish', 'posts_per_page' => -1, 'orderby' => 'title', 'order' => 'ASC']);

        // All places (needed for PHP render of existing stops)
        $all_places = get_posts(['post_type' => 'place', 'post_status' => 'publish', 'posts_per_page' => -1, 'orderby' => 'title', 'order' => 'ASC']);
        ?>
        <div id="ta-stops-wrap">

            <p style="margin-bottom:12px">
                <label style="font-size:13px;font-weight:600">
                    <input type="checkbox" id="ta-multi-province" name="ta_multi_province" value="1"
                        <?php checked($is_multi_province); ?>>
                    🗺 Multi-province journey
                </label>
                <span style="color:#888;margin-left:8px;font-size:12px">
                    Check this if the journey passes through multiple provinces.
                </span>
            </p>

            <table id="ta-stops-table" class="<?php echo $is_multi_province ? 'ta-multi' : ''; ?>">
                <thead>
                    <tr>
                        <th style="width:30px"></th>
                        <th class="ta-col-province" style="width:18%;<?php echo $is_multi_province ? '' : 'display:none'; ?>">Province</th>
                        <th style="width:32%">Place *</th>
                        <th style="width:50px">Day</th>
                        <th style="width:50px">Order</th>
                        <th style="width:70px">Duration (min)</th>
                        <th>Note (VI)</th>
                        <th>Note (EN)</th>
                        <th style="width:36px"></th>
                    </tr>
                </thead>
                <tbody id="ta-stops-body">
                <?php
                // Pre-compute province per stop for render
                foreach ($stops as $i => $stop):
                    $selected_place      = (int) ($stop['journey_stop_place'] ?? 0);
                    $selected_province   = (int) ($stop['journey_stop_province'] ?? 0);

                    // Auto-detect province from place if not saved yet
                    if (!$selected_province && $selected_place) {
                        $loc_id = get_field('place_location', $selected_place);
                        if ($loc_id) {
                            $selected_province = (int) get_field('location_province', $loc_id);
                        }
                    }

                    $prov_places = [];
                    if ($selected_province) {
                        foreach ($all_places as $p) {
                            $loc_id = get_field('place_location', $p->ID);
                            if (!$loc_id) continue;
                            $prov_id = (int) get_field('location_province', $loc_id);
                            if ($prov_id === $selected_province) {
                                $loc_name  = get_the_title($loc_id);
                                $prov_places[] = ['id' => $p->ID, 'title' => "[$loc_name] " . $p->post_title];
                            }
                        }
                    }
                ?>
                    <tr class="ta-stop-row" data-index="<?php echo $i; ?>">
                        <td class="ta-drag-handle">☰</td>
                        <td class="ta-col-province" style="<?php echo $is_multi_province ? '' : 'display:none'; ?>">
                            <select class="ta-stop-province">
                                <option value="">— Province —</option>
                                <?php foreach ($provinces as $prov): ?>
                                    <option value="<?php echo $prov->ID; ?>" <?php selected($selected_province, $prov->ID); ?>>
                                        <?php echo esc_html($prov->post_title); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </td>
                        <td>
                            <select class="ta-stop-place">
                                <option value="">— Select Place —</option>
                                <?php foreach ($prov_places as $pp): ?>
                                    <option value="<?php echo $pp['id']; ?>" <?php selected($selected_place, $pp['id']); ?>>
                                        <?php echo esc_html($pp['title']); ?>
                                    </option>
                                <?php endforeach; ?>
                                <?php if ($selected_place && empty($prov_places)):
                                    $p_title = get_the_title($selected_place);
                                    echo '<option value="' . $selected_place . '" selected>' . esc_html($p_title) . '</option>';
                                endif; ?>
                            </select>
                        </td>
                        <td><input type="number" class="ta-stop-day" value="<?php echo (int)($stop['journey_stop_day'] ?? 1); ?>" min="1" style="width:45px"></td>
                        <td><input type="number" class="ta-stop-order" value="<?php echo (int)($stop['journey_stop_order'] ?? ($i + 1)); ?>" min="1" style="width:45px"></td>
                        <td><input type="number" class="ta-stop-duration" value="<?php echo (int)($stop['journey_stop_duration'] ?? 30); ?>" min="0" style="width:60px"></td>
                        <td><input type="text" class="ta-stop-note-vi" value="<?php echo esc_attr($stop['journey_stop_note_vi'] ?? ''); ?>" placeholder="Note VI"></td>
                        <td><input type="text" class="ta-stop-note-en" value="<?php echo esc_attr($stop['journey_stop_note_en'] ?? ''); ?>" placeholder="Note EN"></td>
                        <td><button type="button" class="button ta-remove-stop" title="Remove">✕</button></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>

            <p>
                <button type="button" class="button" id="ta-add-stop">+ Add Stop</button>
                <span style="color:#888;margin-left:10px;font-size:12px">Drag ☰ to reorder rows.</span>
            </p>

            <input type="hidden" id="ta-stops-json" name="ta_stops_json" value="<?php echo esc_attr($raw); ?>">
            <?php wp_nonce_field('ta_journey_stops', 'ta_journey_stops_nonce'); ?>
        </div>
        <?php
    }

    public static function save(int $post_id, WP_Post $post) {
        if (wp_is_post_autosave($post_id) || wp_is_post_revision($post_id)) return;
        if ($post->post_type !== 'journey') return;
        if (empty($_POST['ta_journey_stops_nonce']) || !wp_verify_nonce($_POST['ta_journey_stops_nonce'], 'ta_journey_stops')) return;
        if (!current_user_can('edit_post', $post_id)) return;

        $raw = isset($_POST['ta_stops_json']) ? stripslashes($_POST['ta_stops_json']) : '[]';
        $stops = json_decode($raw, true);
        if (!is_array($stops)) $stops = [];

        // Sanitize each stop.
        $clean = [];
        foreach ($stops as $stop) {
            $place_id = (int) ($stop['journey_stop_place'] ?? 0);
            if (!$place_id) continue;
            $clean[] = [
                'journey_stop_place'    => $place_id,
                'journey_stop_order'    => (int)  ($stop['journey_stop_order']    ?? 0),
                'journey_stop_day'      => (int)  ($stop['journey_stop_day']      ?? 1),
                'journey_stop_duration' => (int)  ($stop['journey_stop_duration'] ?? 30),
                'journey_stop_note_vi'  => sanitize_text_field($stop['journey_stop_note_vi']  ?? ''),
                'journey_stop_note_en'  => sanitize_text_field($stop['journey_stop_note_en']  ?? ''),
            ];
        }

        update_post_meta($post_id, 'journey_stops', wp_json_encode($clean));
        update_post_meta($post_id, 'journey_is_multi_province', isset($_POST['ta_multi_province']) ? 1 : 0);
    }
}
