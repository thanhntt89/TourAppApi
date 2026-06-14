<?php
defined('ABSPATH') || exit;

/**
 * Load Vietnamese-compatible font for all WordPress admin inputs and TinyMCE editor.
 * Fixes diacritic separation issue with default system fonts.
 */
class TA_Admin_Font {

    public static function register() {
        // Admin pages: all inputs, textareas, ACF fields
        add_action('admin_enqueue_scripts', [self::class, 'enqueue_admin']);

        // TinyMCE editor (visual mode): inject CSS into the iframe
        add_filter('mce_css', [self::class, 'inject_editor_css']);

        // Gutenberg block editor: add font via editor styles
        add_action('after_setup_theme', [self::class, 'add_editor_style']);
    }

    public static function enqueue_admin() {
        // Load Be Vietnam Pro — a font designed specifically for Vietnamese
        wp_enqueue_style(
            'ta-admin-vn-font',
            TA_PLUGIN_URL . 'assets/admin-vn.css',
            [],
            TA_VERSION
        );
    }

    /**
     * Inject CSS into TinyMCE iframe — fixes Vietnamese diacritics in WYSIWYG editors.
     * mce_css filter expects a comma-separated list of CSS URLs.
     */
    public static function inject_editor_css(string $mce_css): string {
        $editor_css = TA_PLUGIN_URL . 'assets/editor-vn.css';
        return $mce_css ? $mce_css . ',' . $editor_css : $editor_css;
    }

    public static function add_editor_style() {
        // For Gutenberg, if theme supports editor styles
        if (function_exists('add_editor_style')) {
            add_editor_style('https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;600&display=swap');
        }
    }
}
