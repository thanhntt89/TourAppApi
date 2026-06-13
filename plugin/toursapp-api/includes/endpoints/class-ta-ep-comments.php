<?php
defined('ABSPATH') || exit;

class TA_EP_Comments {

    private static $allowed_types = ['place', 'story', 'sub_place', 'sub_item'];
    private static $type_regex    = 'place|story|sub_place|sub_item';

    public static function register_routes() {
        $type_re = self::$type_regex;

        // Comments CRUD
        register_rest_route(TA_API_NAMESPACE, "/content/(?P<type>{$type_re})/(?P<id>\\d+)/comments", [
            ['methods' => WP_REST_Server::READABLE,  'callback' => [self::class, 'list_comments'],   'permission_callback' => '__return_true'],
            ['methods' => WP_REST_Server::CREATABLE, 'callback' => [self::class, 'create_comment'],  'permission_callback' => ['TA_Auth', 'permission_check_device'],
             'args' => [
                 'comment_text' => ['required' => true, 'type' => 'string', 'maxLength' => 1000],
                 'photo_id'     => ['type' => 'integer', 'minimum' => 0],
             ]],
        ]);

        register_rest_route(TA_API_NAMESPACE, "/content/(?P<type>{$type_re})/(?P<id>\\d+)/comments/(?P<cid>\\d+)", [
            ['methods' => 'PUT',                      'callback' => [self::class, 'update_comment'],  'permission_callback' => ['TA_Auth', 'permission_check_device'],
             'args' => ['comment_text' => ['required' => true, 'type' => 'string', 'maxLength' => 1000]]],
            ['methods' => WP_REST_Server::DELETABLE,  'callback' => [self::class, 'delete_comment'],  'permission_callback' => ['TA_Auth', 'permission_check_device']],
        ]);

        // Ratings
        register_rest_route(TA_API_NAMESPACE, "/content/(?P<type>{$type_re})/(?P<id>\\d+)/rating", [
            ['methods' => WP_REST_Server::READABLE,  'callback' => [self::class, 'get_rating'],    'permission_callback' => '__return_true'],
            ['methods' => WP_REST_Server::CREATABLE, 'callback' => [self::class, 'submit_rating'], 'permission_callback' => ['TA_Auth', 'permission_check_device'],
             'args' => ['rating' => ['required' => true, 'type' => 'integer', 'minimum' => 1, 'maximum' => 5]]],
        ]);

        // Photo upload
        register_rest_route(TA_API_NAMESPACE, '/user/upload-photo', [
            'methods'             => WP_REST_Server::CREATABLE,
            'callback'            => [self::class, 'upload_photo'],
            'permission_callback' => ['TA_Auth', 'permission_check_device'],
        ]);
    }

    // ──────────────────────────────────────────────
    // Comments
    // ──────────────────────────────────────────────

    public static function list_comments(WP_REST_Request $request): WP_REST_Response {
        $type = $request->get_param('type');
        $id   = (int) $request->get_param('id');

        if (!TA_Comment_Model::are_comments_allowed($type, $id)) {
            return TA_API::error('comments_disabled', 'Comments are disabled for this content.', 403);
        }

        $comments = TA_Comment_Model::get_comments($type, $id, [
            'page'     => $request->get_param('page') ?? 1,
            'per_page' => $request->get_param('per_page') ?? 20,
            'sort'     => $request->get_param('sort') ?? 'newest',
        ]);
        $total = TA_Comment_Model::count($type, $id);

        return TA_API::success($comments, ['total' => $total]);
    }

    public static function create_comment(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);
        $type = $request->get_param('type');
        $id   = (int) $request->get_param('id');

        if (!TA_Comment_Model::are_comments_allowed($type, $id)) {
            return TA_API::error('comments_disabled', 'Comments are disabled for this content.', 403);
        }

        if (TA_Comment_Model::count_today($uuid) >= 10) {
            return TA_API::error('rate_limit', 'Comment limit reached for today.', 429);
        }

        $text     = sanitize_textarea_field($request->get_param('comment_text'));
        $photo_id = (int) ($request->get_param('photo_id') ?? 0);

        $cid = TA_Comment_Model::create($uuid, $type, $id, $text, $photo_id);
        return TA_API::created([
            'comment_id' => $cid,
            'status'     => 'pending',
            'message'    => 'Your comment has been submitted and is awaiting approval.',
        ]);
    }

    public static function update_comment(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);
        $cid  = (int) $request->get_param('cid');

        $comment = TA_Comment_Model::get_by_id($cid);
        if (!$comment) {
            return TA_API::error('not_found', 'Comment not found.', 404);
        }
        if ($comment['device_uuid'] !== $uuid) {
            return TA_API::error('forbidden', 'Cannot edit another user\'s comment.', 403);
        }

        $text = sanitize_textarea_field($request->get_param('comment_text'));
        TA_Comment_Model::update($cid, $text);
        return TA_API::success(['updated' => true]);
    }

    public static function delete_comment(WP_REST_Request $request): WP_REST_Response {
        $uuid = TA_Auth::get_device_uuid($request);
        $cid  = (int) $request->get_param('cid');

        $comment = TA_Comment_Model::get_by_id($cid);
        if (!$comment) {
            return TA_API::error('not_found', 'Comment not found.', 404);
        }
        if ($comment['device_uuid'] !== $uuid) {
            return TA_API::error('forbidden', 'Cannot delete another user\'s comment.', 403);
        }

        TA_Comment_Model::delete($cid);
        return TA_API::success(['deleted' => true]);
    }

    // ──────────────────────────────────────────────
    // Ratings
    // ──────────────────────────────────────────────

    public static function get_rating(WP_REST_Request $request): WP_REST_Response {
        $type    = $request->get_param('type');
        $id      = (int) $request->get_param('id');
        $summary = TA_Rating_Model::get_summary($type, $id);

        $uuid = $request->get_header('X-Device-UUID');
        if ($uuid) {
            $summary['your_rating'] = TA_Rating_Model::get_user_rating($uuid, $type, $id);
        }

        return TA_API::success($summary);
    }

    public static function submit_rating(WP_REST_Request $request): WP_REST_Response {
        $uuid   = TA_Auth::get_device_uuid($request);
        $type   = $request->get_param('type');
        $id     = (int) $request->get_param('id');
        $rating = (int) $request->get_param('rating');

        if (!TA_Rating_Model::are_ratings_allowed($type, $id)) {
            return TA_API::error('ratings_disabled', 'Ratings are disabled for this content.', 403);
        }

        TA_Rating_Model::upsert($uuid, $type, $id, $rating);
        return TA_API::success(['rating' => $rating, 'summary' => TA_Rating_Model::get_summary($type, $id)]);
    }

    // ──────────────────────────────────────────────
    // Photo upload
    // ──────────────────────────────────────────────

    public static function upload_photo(WP_REST_Request $request): WP_REST_Response {
        if (empty($_FILES['photo'])) {
            return TA_API::error('no_file', 'No photo file provided.', 400);
        }

        $file = $_FILES['photo'];

        // Validate extension first — blocks double-extension attacks (e.g. shell.php.jpg)
        $allowed_mime = ['image/jpeg', 'image/png', 'image/webp'];
        $allowed_ext  = ['jpg', 'jpeg', 'png', 'webp'];
        $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        if (!in_array($ext, $allowed_ext, true)) {
            return TA_API::error('invalid_extension', 'Invalid file extension. Only jpg, png, webp allowed.', 400);
        }
        // Validate MIME type via server-side sniffing — with fallback for servers without fileinfo
        if (class_exists('finfo')) {
            $finfo = new finfo(FILEINFO_MIME_TYPE);
            $mime  = $finfo->file($file['tmp_name']);
            if (!in_array($mime, $allowed_mime, true)) {
                return TA_API::error('invalid_type', 'Only jpg, png, webp images allowed.', 400);
            }
        } elseif (function_exists('mime_content_type')) {
            $mime = mime_content_type($file['tmp_name']);
            if (!in_array($mime, $allowed_mime, true)) {
                return TA_API::error('invalid_type', 'Only jpg, png, webp images allowed.', 400);
            }
        }

        // 2MB limit.
        if ($file['size'] > 2 * 1024 * 1024) {
            return TA_API::error('too_large', 'Photo must be under 2MB.', 400);
        }

        require_once ABSPATH . 'wp-admin/includes/file.php';
        require_once ABSPATH . 'wp-admin/includes/media.php';
        require_once ABSPATH . 'wp-admin/includes/image.php';

        $att_id = media_handle_upload('photo', 0);
        if (is_wp_error($att_id)) {
            return TA_API::error('upload_failed', $att_id->get_error_message(), 500);
        }

        return TA_API::created([
            'attachment_id' => $att_id,
            'url'           => wp_get_attachment_url($att_id),
        ]);
    }
}
