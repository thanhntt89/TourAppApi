<?php
defined('ABSPATH') || exit;

class TA_Gallery_Meta {

    // Map: post_type => [ meta_key => label ]
    private static $galleries = [
        'province'  => ['province_banner_images' => 'Banner Images'],
        'place'     => ['place_gallery'           => 'Gallery'],
        'sub_item'  => ['sub_item_gallery'        => 'Gallery'],
        'ta_story'  => ['story_gallery'           => 'Gallery'],
    ];

    public static function register() {
        add_action('add_meta_boxes', [self::class, 'add_meta_boxes']);
        add_action('save_post',      [self::class, 'save'],       10, 2);
        add_action('admin_enqueue_scripts', [self::class, 'enqueue']);
    }

    public static function add_meta_boxes() {
        foreach (self::$galleries as $post_type => $fields) {
            foreach ($fields as $meta_key => $label) {
                add_meta_box(
                    'ta_gallery_' . $meta_key,
                    $label,
                    function($post) use ($meta_key) {
                        self::render($post, $meta_key);
                    },
                    $post_type,
                    'normal',
                    'default'
                );
            }
        }
    }

    public static function enqueue($hook) {
        if (!in_array($hook, ['post.php', 'post-new.php'], true)) {
            return;
        }
        $screen = get_current_screen();
        if (!$screen) return;

        $our_post_types = array_merge(
            array_keys(self::$galleries),
            ['journey', 'news_alert', 'ta_story', 'place', 'sub_place', 'sub_item']
        );
        if (!in_array($screen->post_type, $our_post_types, true)) return;

        wp_enqueue_media();
        wp_enqueue_style('ta-gallery-meta', TA_PLUGIN_URL . 'assets/gallery-meta.css', [], TA_VERSION);

        if (array_key_exists($screen->post_type, self::$galleries)) {
            wp_enqueue_script('ta-gallery-meta', TA_PLUGIN_URL . 'assets/gallery-meta.js', ['jquery', 'media-upload', 'media-views'], TA_VERSION, true);
        }

        // Audio URL browse button — CPTs that have audio fields
        $audio_types = ['place', 'sub_place', 'sub_item', 'ta_story'];
        if (in_array($screen->post_type, $audio_types, true)) {
            wp_enqueue_script('ta-audio-url', TA_PLUGIN_URL . 'assets/audio-url.js', ['jquery', 'media-upload', 'media-views'], TA_VERSION, true);
        }

        // News & Alerts: auto-fill icon when type changes
        if ($screen->post_type === 'news_alert') {
            wp_enqueue_script('ta-news-icon', TA_PLUGIN_URL . 'assets/news-icon.js', ['jquery', 'acf-input'], TA_VERSION, true);
        }
    }

    public static function render($post, string $meta_key) {
        $ids  = get_post_meta($post->ID, $meta_key, true) ?: '';
        $nonce = wp_create_nonce('ta_gallery_' . $meta_key);
        ?>
        <input type="hidden" name="ta_gallery_nonce_<?php echo esc_attr($meta_key); ?>" value="<?php echo esc_attr($nonce); ?>">
        <input type="hidden" id="<?php echo esc_attr($meta_key); ?>" name="<?php echo esc_attr($meta_key); ?>" value="<?php echo esc_attr($ids); ?>">

        <div class="ta-gallery-wrap" data-field="<?php echo esc_attr($meta_key); ?>">
            <div class="ta-gallery-thumbs">
                <?php
                if ($ids) {
                    foreach (array_filter(array_map('intval', explode(',', $ids))) as $att_id) {
                        $thumb = wp_get_attachment_image_src($att_id, 'thumbnail');
                        if ($thumb) {
                            echo '<div class="ta-thumb" data-id="' . esc_attr($att_id) . '">'
                               . '<img src="' . esc_url($thumb[0]) . '">'
                               . '<span class="ta-remove">×</span>'
                               . '</div>';
                        }
                    }
                }
                ?>
            </div>
            <button type="button" class="button ta-gallery-add">+ Add Images</button>
            <p class="description">Drag thumbnails to reorder. Click × to remove.</p>
        </div>
        <?php
    }

    public static function save(int $post_id, WP_Post $post) {
        if (wp_is_post_autosave($post_id) || wp_is_post_revision($post_id)) {
            return;
        }
        if (!array_key_exists($post->post_type, self::$galleries)) {
            return;
        }
        foreach (self::$galleries[$post->post_type] as $meta_key => $label) {
            $nonce_key = 'ta_gallery_nonce_' . $meta_key;
            if (empty($_POST[$nonce_key]) || !wp_verify_nonce($_POST[$nonce_key], 'ta_gallery_' . $meta_key)) {
                continue;
            }
            if (!current_user_can('edit_post', $post_id)) {
                continue;
            }
            $raw = isset($_POST[$meta_key]) ? sanitize_text_field($_POST[$meta_key]) : '';
            // Sanitize: keep only comma-separated integers.
            $ids = implode(',', array_filter(array_map('intval', explode(',', $raw))));
            update_post_meta($post_id, $meta_key, $ids);
        }
    }
}
