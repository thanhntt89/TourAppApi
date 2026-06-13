<?php
defined('ABSPATH') || exit;

class TA_Localize {

    public static function get_lang(WP_REST_Request $request): string {
        $lang = $request->get_param('lang') ?: TA_DEFAULT_LANG;
        return in_array($lang, TA_LANGUAGES, true) ? $lang : TA_DEFAULT_LANG;
    }

    public static function get_field_localized(int $post_id, string $field_prefix, string $lang): string {
        $value = get_field("{$field_prefix}_{$lang}", $post_id);
        if (!empty($value)) {
            return $value;
        }

        if ($lang !== 'en') {
            $value = get_field("{$field_prefix}_en", $post_id);
            if (!empty($value)) {
                return $value;
            }
        }

        return get_field("{$field_prefix}_vi", $post_id) ?: '';
    }

    public static function get_audio_localized(int $post_id, string $field_prefix, string $lang): ?array {
        $file = get_field("{$field_prefix}_{$lang}", $post_id);
        if (empty($file)) {
            $file = get_field("{$field_prefix}_en", $post_id);
        }
        if (empty($file)) {
            $file = get_field("{$field_prefix}_vi", $post_id);
        }

        if (empty($file)) {
            return null;
        }

        if (is_array($file)) {
            return [
                'url'  => $file['url'] ?? '',
                'size' => $file['filesize'] ?? 0,
            ];
        }

        return ['url' => (string)$file, 'size' => 0];
    }

    public static function format_image($image): ?array {
        if (empty($image)) {
            return null;
        }

        if (is_numeric($image)) {
            $url = wp_get_attachment_url((int) $image);
            if (!$url) {
                return null;
            }
            $meta = wp_get_attachment_metadata((int) $image);
            return [
                'url'    => $url,
                'width'  => $meta['width'] ?? 0,
                'height' => $meta['height'] ?? 0,
                'alt'    => get_post_meta((int) $image, '_wp_attachment_image_alt', true) ?: '',
            ];
        }

        if (!is_array($image)) {
            return null;
        }

        return [
            'url'    => $image['url'] ?? '',
            'width'  => $image['width'] ?? 0,
            'height' => $image['height'] ?? 0,
            'alt'    => $image['alt'] ?? '',
        ];
    }

    public static function format_gallery($gallery): array {
        if (empty($gallery)) {
            return [];
        }

        if (is_string($gallery)) {
            $ids = array_filter(array_map('intval', explode(',', $gallery)));
            $result = [];
            foreach ($ids as $att_id) {
                $formatted = self::format_image($att_id);
                if ($formatted) {
                    $formatted['caption'] = wp_get_attachment_caption($att_id) ?: '';
                    $result[] = $formatted;
                }
            }
            return $result;
        }

        if (!is_array($gallery)) {
            return [];
        }

        return array_values(array_filter(array_map(function ($img) {
            $formatted = self::format_image($img);
            if ($formatted) {
                $formatted['caption'] = is_array($img) ? ($img['caption'] ?? '') : '';
            }
            return $formatted;
        }, $gallery)));
    }
}
