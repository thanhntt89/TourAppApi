<?php
defined('ABSPATH') || exit;

class TA_Admin {

    public static function register_menu() {
        add_menu_page(
            'ToursApp API',
            'ToursApp API',
            'manage_options',
            'toursapp-api',
            [self::class, 'render_page'],
            'dashicons-rest-api',
            80
        );
    }

    public static function render_page() {
        if (!current_user_can('manage_options')) return;

        if (isset($_GET['export']) && $_GET['export'] === 'csv') {
            self::export_csv();
            return;
        }

        $routes = self::get_routes();
        ?>
        <div class="wrap">
            <h1>ToursApp API — Endpoint Reference</h1>
            <p>
                <a href="<?php echo esc_url(add_query_arg('export', 'csv')); ?>" class="button button-primary">
                    ⬇ Export to CSV (Excel)
                </a>
                <span style="margin-left:12px;color:#666;">
                    Namespace: <code><?php echo esc_html(TA_API_NAMESPACE); ?></code>
                    &nbsp;|&nbsp; Version: <code><?php echo esc_html(TA_VERSION); ?></code>
                    &nbsp;|&nbsp; Total endpoints: <strong><?php echo count($routes); ?></strong>
                </span>
            </p>

            <style>
                #ta-api-table { border-collapse: collapse; width: 100%; font-size: 13px; }
                #ta-api-table th { background: #2271b1; color: #fff; padding: 8px 10px; text-align: left; }
                #ta-api-table td { padding: 7px 10px; border-bottom: 1px solid #ddd; vertical-align: top; }
                #ta-api-table tr:hover td { background: #f0f6fc; }
                .ta-method { display:inline-block; padding:2px 7px; border-radius:3px; font-weight:bold; font-size:11px; }
                .ta-GET    { background:#0a7a35; color:#fff; }
                .ta-POST   { background:#0073aa; color:#fff; }
                .ta-PUT    { background:#8b6914; color:#fff; }
                .ta-DELETE { background:#b32d2e; color:#fff; }
                .ta-auth-yes  { color: #b32d2e; font-weight: bold; }
                .ta-auth-no   { color: #555; }
                .ta-param code { background:#f0f0f0; padding:1px 4px; border-radius:2px; margin-right:4px; }
            </style>

            <table id="ta-api-table">
                <thead>
                    <tr>
                        <th style="width:70px">Method</th>
                        <th style="width:35%">Endpoint</th>
                        <th style="width:80px">Auth</th>
                        <th>Parameters</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                <?php foreach ($routes as $route): ?>
                    <tr>
                        <td><span class="ta-method ta-<?php echo esc_attr($route['method']); ?>"><?php echo esc_html($route['method']); ?></span></td>
                        <td><code>/<?php echo esc_html(TA_API_NAMESPACE . $route['path']); ?></code></td>
                        <td class="<?php echo $route['auth'] ? 'ta-auth-yes' : 'ta-auth-no'; ?>">
                            <?php echo $route['auth'] ? '🔒 Device UUID' : 'Public'; ?>
                        </td>
                        <td class="ta-param">
                            <?php foreach ($route['params'] as $param): ?>
                                <div>
                                    <code><?php echo esc_html($param['name']); ?></code>
                                    <em><?php echo esc_html($param['type']); ?></em>
                                    <?php if ($param['required']): ?><span style="color:#c00">*required</span><?php endif; ?>
                                    <?php if (!empty($param['default'])): ?><span style="color:#888">default:<?php echo esc_html($param['default']); ?></span><?php endif; ?>
                                </div>
                            <?php endforeach; ?>
                        </td>
                        <td><?php echo esc_html($route['description']); ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </div>
        <?php
    }

    private static function export_csv() {
        $routes = self::get_routes();
        $filename = 'toursapp-api-v' . TA_VERSION . '.csv';

        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Pragma: no-cache');

        $out = fopen('php://output', 'w');
        fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF)); // UTF-8 BOM for Excel

        fputcsv($out, ['Method', 'Endpoint', 'Auth Required', 'Parameters', 'Description']);

        foreach ($routes as $r) {
            $params = implode('; ', array_map(function ($p) {
                $s = $p['name'] . '(' . $p['type'] . ')';
                if ($p['required']) $s .= '*';
                if (!empty($p['default'])) $s .= '='. $p['default'];
                return $s;
            }, $r['params']));

            fputcsv($out, [
                $r['method'],
                '/' . TA_API_NAMESPACE . $r['path'],
                $r['auth'] ? 'X-Device-UUID required' : 'Public',
                $params,
                $r['description'],
            ]);
        }

        fclose($out);
        exit;
    }

    private static function get_routes(): array {
        return [
            // Device
            ['method' => 'POST',   'path' => '/device/register',    'auth' => false, 'description' => 'Register or update a device', 'params' => [
                ['name' => 'device_uuid',  'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'device_name',  'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'platform',     'type' => 'string',  'required' => false, 'default' => 'android'],
                ['name' => 'app_version',  'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'lang',         'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'push_token',   'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'referral_code','type' => 'string',  'required' => false, 'default' => ''],
            ]],
            // Provinces
            ['method' => 'GET', 'path' => '/provinces',            'auth' => false, 'description' => 'List all active provinces', 'params' => [
                ['name' => 'lang', 'type' => 'string', 'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/provinces/{id}',       'auth' => false, 'description' => 'Get province detail', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            // Locations
            ['method' => 'GET', 'path' => '/provinces/{province_id}/locations', 'auth' => false, 'description' => 'List locations in a province', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'sort',        'type' => 'string',  'required' => false, 'default' => 'location_number'],
                ['name' => 'lat',         'type' => 'number',  'required' => false, 'default' => ''],
                ['name' => 'lng',         'type' => 'number',  'required' => false, 'default' => ''],
            ]],
            ['method' => 'GET', 'path' => '/locations/{id}', 'auth' => false, 'description' => 'Get location detail (include=places)', 'params' => [
                ['name' => 'id',      'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',    'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'include', 'type' => 'string',  'required' => false, 'default' => ''],
            ]],
            // Places
            ['method' => 'GET', 'path' => '/places',             'auth' => false, 'description' => 'List places with filters', 'params' => [
                ['name' => 'province_id',  'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'location_id',  'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'lang',         'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'featured',     'type' => 'boolean', 'required' => false, 'default' => ''],
                ['name' => 'search',       'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'sort',         'type' => 'string',  'required' => false, 'default' => 'order'],
                ['name' => 'page',         'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page',     'type' => 'integer', 'required' => false, 'default' => '20'],
            ]],
            ['method' => 'GET', 'path' => '/places/{id}',        'auth' => false, 'description' => 'Get place detail', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/places/nearby',      'auth' => false, 'description' => 'Get nearby places by GPS', 'params' => [
                ['name' => 'lat',         'type' => 'number',  'required' => true,  'default' => ''],
                ['name' => 'lng',         'type' => 'number',  'required' => true,  'default' => ''],
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'radius',      'type' => 'number',  'required' => false, 'default' => '5'],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/places/qr/{code}',   'auth' => false, 'description' => 'Look up place by QR code', 'params' => [
                ['name' => 'code', 'type' => 'string', 'required' => true, 'default' => ''],
                ['name' => 'lang', 'type' => 'string', 'required' => false, 'default' => 'vi'],
            ]],
            // Sub-Places & Sub-Items
            ['method' => 'GET', 'path' => '/sub-places',         'auth' => false, 'description' => 'List sub-places for a place', 'params' => [
                ['name' => 'place_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',     'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/sub-places/{id}',    'auth' => false, 'description' => 'Get sub-place detail', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/sub-items',          'auth' => false, 'description' => 'List sub-items for a sub-place', 'params' => [
                ['name' => 'sub_place_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',         'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            // Journeys
            ['method' => 'GET', 'path' => '/journeys',           'auth' => false, 'description' => 'List preset journeys', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'featured',    'type' => 'boolean', 'required' => false, 'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/journeys/{id}',      'auth' => false, 'description' => 'Get preset journey detail with stops', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            // Stories
            ['method' => 'GET', 'path' => '/stories',            'auth' => false, 'description' => 'List stories (filter by province/place/type)', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'place_id',    'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'type',        'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'featured',    'type' => 'boolean', 'required' => false, 'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'page',        'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page',    'type' => 'integer', 'required' => false, 'default' => '20'],
            ]],
            ['method' => 'GET', 'path' => '/stories/{id}',       'auth' => false, 'description' => 'Get story detail with related places', 'params' => [
                ['name' => 'id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang', 'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            // News
            ['method' => 'GET', 'path' => '/news',               'auth' => false, 'description' => 'List news and alerts', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'type',        'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'page',        'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page',    'type' => 'integer', 'required' => false, 'default' => '20'],
            ]],
            // User — Auth required
            ['method' => 'POST', 'path' => '/user/checkin',      'auth' => true, 'description' => 'Check in at a place (GPS or QR)', 'params' => [
                ['name' => 'place_id',  'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'method',    'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'latitude',  'type' => 'number',  'required' => false, 'default' => ''],
                ['name' => 'longitude', 'type' => 'number',  'required' => false, 'default' => ''],
                ['name' => 'qr_code',   'type' => 'string',  'required' => false, 'default' => ''],
            ]],
            ['method' => 'POST', 'path' => '/user/unlock',       'auth' => true, 'description' => 'Unlock paid content with flowers', 'params' => [
                ['name' => 'content_type', 'type' => 'string',  'required' => true, 'default' => ''],
                ['name' => 'content_id',   'type' => 'integer', 'required' => true, 'default' => ''],
            ]],
            ['method' => 'GET',  'path' => '/user/history',      'auth' => true, 'description' => 'Get user checkin history', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'type',        'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'page',        'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page',    'type' => 'integer', 'required' => false, 'default' => '20'],
            ]],
            ['method' => 'GET',  'path' => '/user/wallet',       'auth' => true, 'description' => 'Get wallet balance and recent transactions', 'params' => []],
            ['method' => 'POST', 'path' => '/user/share',        'auth' => true, 'description' => 'Record a social share or referral', 'params' => [
                ['name' => 'share_type',    'type' => 'string', 'required' => true,  'default' => ''],
                ['name' => 'platform',      'type' => 'string', 'required' => false, 'default' => ''],
                ['name' => 'referral_code', 'type' => 'string', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'POST', 'path' => '/user/referral/redeem', 'auth' => true, 'description' => 'Redeem an invitation referral code', 'params' => [
                ['name' => 'referral_code', 'type' => 'string', 'required' => true, 'default' => ''],
            ]],
            // User Journeys
            ['method' => 'GET',    'path' => '/user/journeys',      'auth' => true, 'description' => 'List user custom journeys', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'POST',   'path' => '/user/journeys',      'auth' => true, 'description' => 'Create a custom journey', 'params' => [
                ['name' => 'province_id',       'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'name',              'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'source_journey_id', 'type' => 'integer', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'PUT',    'path' => '/user/journeys/{id}', 'auth' => true, 'description' => 'Update a custom journey', 'params' => [
                ['name' => 'name',        'type' => 'string', 'required' => false, 'default' => ''],
                ['name' => 'description', 'type' => 'string', 'required' => false, 'default' => ''],
                ['name' => 'status',      'type' => 'string', 'required' => false, 'default' => ''],
                ['name' => 'stops',       'type' => 'array',  'required' => false, 'default' => ''],
            ]],
            ['method' => 'DELETE', 'path' => '/user/journeys/{id}', 'auth' => true, 'description' => 'Delete a custom journey', 'params' => []],
            // Engagement
            ['method' => 'POST', 'path' => '/user/track',           'auth' => true, 'description' => 'Record content engagement event', 'params' => [
                ['name' => 'content_type',   'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'content_id',     'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'event_type',     'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'duration_sec',   'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'scroll_depth',   'type' => 'integer', 'required' => false, 'default' => ''],
                ['name' => 'completion_pct', 'type' => 'integer', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'GET', 'path' => '/analytics/content/{id}',  'auth' => false, 'description' => 'Get engagement stats for one content item', 'params' => [
                ['name' => 'content_type', 'type' => 'string', 'required' => true,  'default' => ''],
                ['name' => 'since',        'type' => 'string', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'GET', 'path' => '/analytics/top-content',   'auth' => false, 'description' => 'Get top content ranked by metric', 'params' => [
                ['name' => 'content_type', 'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'metric',       'type' => 'string',  'required' => false, 'default' => 'views'],
                ['name' => 'limit',        'type' => 'integer', 'required' => false, 'default' => '10'],
                ['name' => 'since',        'type' => 'string',  'required' => false, 'default' => ''],
            ]],
            // Comments & Ratings
            ['method' => 'GET',    'path' => '/content/{type}/{id}/comments',      'auth' => false, 'description' => 'List comments for a content item', 'params' => [
                ['name' => 'page',     'type' => 'integer', 'required' => false, 'default' => '1'],
                ['name' => 'per_page', 'type' => 'integer', 'required' => false, 'default' => '20'],
                ['name' => 'sort',     'type' => 'string',  'required' => false, 'default' => 'newest'],
            ]],
            ['method' => 'POST',   'path' => '/content/{type}/{id}/comments',      'auth' => true,  'description' => 'Post a comment (max 10/day)', 'params' => [
                ['name' => 'comment_text', 'type' => 'string',  'required' => true,  'default' => ''],
                ['name' => 'photo_id',     'type' => 'integer', 'required' => false, 'default' => ''],
            ]],
            ['method' => 'PUT',    'path' => '/content/{type}/{id}/comments/{cid}','auth' => true,  'description' => 'Edit own comment', 'params' => [
                ['name' => 'comment_text', 'type' => 'string', 'required' => true, 'default' => ''],
            ]],
            ['method' => 'DELETE', 'path' => '/content/{type}/{id}/comments/{cid}','auth' => true,  'description' => 'Delete own comment', 'params' => []],
            ['method' => 'GET',    'path' => '/content/{type}/{id}/rating',         'auth' => false, 'description' => 'Get rating summary (avg, count, distribution)', 'params' => []],
            ['method' => 'POST',   'path' => '/content/{type}/{id}/rating',         'auth' => true,  'description' => 'Submit or update rating (1-5 stars)', 'params' => [
                ['name' => 'rating', 'type' => 'integer', 'required' => true, 'default' => ''],
            ]],
            ['method' => 'POST',   'path' => '/user/upload-photo',                 'auth' => true,  'description' => 'Upload comment photo (max 2MB, jpg/png/webp)', 'params' => [
                ['name' => 'photo', 'type' => 'file', 'required' => true, 'default' => ''],
            ]],
            // Downloads
            ['method' => 'GET',  'path' => '/user/downloads',          'auth' => true, 'description' => 'List user offline download records', 'params' => []],
            ['method' => 'POST', 'path' => '/user/downloads/start',    'auth' => true, 'description' => 'Record start of offline package download', 'params' => [
                ['name' => 'province_id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'download_type', 'type' => 'string',  'required' => false, 'default' => 'full'],
                ['name' => 'lang',          'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'POST', 'path' => '/user/downloads/complete', 'auth' => true, 'description' => 'Record completion of offline package download', 'params' => [
                ['name' => 'download_id',   'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'file_count',    'type' => 'integer', 'required' => false, 'default' => '0'],
                ['name' => 'total_size_mb', 'type' => 'number',  'required' => false, 'default' => '0'],
                ['name' => 'status',        'type' => 'string',  'required' => false, 'default' => 'completed'],
            ]],
            // Sync
            ['method' => 'GET', 'path' => '/sync/check',                'auth' => false, 'description' => 'Check for content updates since timestamp', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'since',       'type' => 'string',  'required' => false, 'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
            ]],
            ['method' => 'GET', 'path' => '/sync/package/{province_id}','auth' => false, 'description' => 'Download full offline data package for a province', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'lang',        'type' => 'string',  'required' => false, 'default' => 'vi'],
                ['name' => 'since',       'type' => 'string',  'required' => false, 'default' => ''],
            ]],
            ['method' => 'GET', 'path' => '/sync/media/{province_id}',  'auth' => false, 'description' => 'Get media file list for offline download', 'params' => [
                ['name' => 'province_id', 'type' => 'integer', 'required' => true,  'default' => ''],
                ['name' => 'type',        'type' => 'string',  'required' => false, 'default' => 'all'],
            ]],
        ];
    }
}
