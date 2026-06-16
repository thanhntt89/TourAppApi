<?php
defined('ABSPATH') || exit;

class TA_API_Docs {

    private static function categorize(string $path): string {
        if (preg_match('#^/provinces/\{[^}]+\}/locations#', $path)) return 'Locations';
        if (strpos($path, '/user/journeys') === 0) return 'User Journeys';
        if (strpos($path, '/user/features') === 0) return 'Features';
        if (strpos($path, '/user/downloads') === 0) return 'Downloads';
        if (strpos($path, '/user/library') === 0) return 'Library';
        if (strpos($path, '/user/favorites') === 0) return 'Library';
        if (strpos($path, '/user/offline') === 0) return 'Library';
        if (strpos($path, '/user/upload') === 0) return 'User Actions';
        if (strpos($path, '/user/track') === 0) return 'Engagement';
        if (preg_match('#^/user/(checkin|unlock|history|wallet|share|referral)#', $path)) return 'User Actions';
        if (strpos($path, '/device') === 0) return 'Device';
        if (strpos($path, '/provinces') === 0) return 'Provinces';
        if (strpos($path, '/locations') === 0) return 'Locations';
        if (strpos($path, '/places') === 0) return 'Places';
        if (strpos($path, '/sub-places') === 0) return 'Sub-Places';
        if (strpos($path, '/sub-items') === 0) return 'Sub-Items';
        if (strpos($path, '/journeys') === 0) return 'Journeys';
        if (strpos($path, '/stories') === 0) return 'Stories';
        if (strpos($path, '/news') === 0) return 'News';
        if (strpos($path, '/content') === 0 && strpos($path, '/rating') !== false) return 'Ratings';
        if (strpos($path, '/content') === 0) return 'Comments';
        if (strpos($path, '/analytics') === 0) return 'Analytics';
        if (strpos($path, '/sync') === 0) return 'Sync';
        return 'Other';
    }

    private static function group_routes(array $routes): array {
        $order = [
            'Device', 'Provinces', 'Locations', 'Places',
            'Sub-Places', 'Sub-Items', 'Journeys', 'Stories', 'News',
            'User Actions', 'User Journeys', 'Features', 'Library',
            'Comments', 'Ratings', 'Engagement', 'Analytics',
            'Downloads', 'Sync',
        ];

        $grouped = [];
        foreach ($routes as $route) {
            $group = self::categorize($route['path']);
            $grouped[$group][] = $route;
        }

        $sorted = [];
        foreach ($order as $g) {
            if (!empty($grouped[$g])) $sorted[$g] = $grouped[$g];
        }
        foreach ($grouped as $g => $r) {
            if (!isset($sorted[$g])) $sorted[$g] = $r;
        }
        return $sorted;
    }

    private static function anchor(string $method, string $path): string {
        return strtolower($method) . '-' . preg_replace('/[^a-z0-9]+/', '-', strtolower(trim($path, '/')));
    }

    private static function param_hint(array $p): string {
        $hints = [
            'lang' => 'Language code (vi, en, ko, zh, fr)',
            'lat' => 'Latitude', 'lng' => 'Longitude',
            'page' => 'Page number', 'per_page' => 'Items per page',
            'device_uuid' => 'Unique device identifier',
            'province_id' => 'Province ID', 'location_id' => 'Location ID',
            'place_id' => 'Place ID', 'sub_place_id' => 'Sub-place ID',
            'search' => 'Search keyword', 'featured' => 'Filter featured only',
            'include' => 'Comma-separated includes (e.g. places,news)',
            'sort' => 'Sort field', 'radius' => 'Search radius in km',
            'since' => 'ISO date for incremental sync',
            'content_type' => 'Content type (place, story, etc.)',
            'content_id' => 'Content ID', 'event_type' => 'Event type',
            'method' => 'Check-in method (gps or qr)',
            'rating' => 'Rating score (1-5)',
            'comment_text' => 'Comment body text',
            'referral_code' => 'Referral/invitation code',
            'share_type' => 'Share type (social, referral)',
            'platform' => 'Platform or social network',
            'name' => 'Display name', 'description' => 'Description text',
            'status' => 'Status value', 'stops' => 'Array of journey stops',
            'type' => 'Type filter',
        ];
        $parts = [];
        if (isset($hints[$p['name']])) $parts[] = $hints[$p['name']];
        if (!empty($p['enum'])) $parts[] = 'Values: <code>' . implode('</code>, <code>', array_map('esc_html', $p['enum'])) . '</code>';
        if ($p['default'] !== '') $parts[] = 'Default: <code>' . esc_html($p['default']) . '</code>';
        return implode('. ', $parts);
    }

    private static function param_example(array $p): string {
        $examples = [
            'device_uuid'       => 'abc-uuid-123',
            'province_id'       => '1',
            'location_id'       => '1',
            'place_id'          => '5',
            'sub_place_id'      => '2',
            'id'                => '1',
            'lang'              => 'vi',
            'lat'               => '22.82',
            'lng'               => '104.98',
            'radius'            => '5',
            'page'              => '1',
            'per_page'          => '20',
            'name'              => 'My Journey',
            'description'       => 'A great trip',
            'status'            => 'planning',
            'rating'            => '5',
            'comment_text'      => 'Great place!',
            'referral_code'     => 'HG-A1B2',
            'share_type'        => 'social',
            'platform'          => 'facebook',
            'content_type'      => 'place',
            'content_id'        => '5',
            'event_type'        => 'page_view',
            'method'            => 'gps',
            'type'              => 'news',
            'feature'           => 'cross_province',
            'since'             => '2026-01-01T00:00:00Z',
            'app_version'       => '1.0.0',
            'download_type'     => 'full',
            'source_journey_id' => '1',
        ];
        if (isset($examples[$p['name']])) return $examples[$p['name']];
        switch ($p['type'] ?? 'string') {
            case 'integer': return '1';
            case 'boolean': return 'true';
            case 'array':   return '[]';
            default:        return 'value';
        }
    }

    private static function generate_curl(array $r, string $base_url): string {
        $method = $r['method'];
        $url    = rtrim($base_url, '/') . $r['path'];

        // Replace path placeholders with example values
        $url = str_replace(['{province_id}', '{location_id}', '{place_id}', '{id}',
                            '{cid}', '{type}', '{feature}', '{code}'],
                           ['1', '1', '5', '1', '7', 'place', 'cross_province', 'MPL-001'],
                           $url);

        $params   = $r['params'] ?? [];
        $required = array_values(array_filter($params, function ($p) { return !empty($p['required']); }));

        $headers   = [];
        $body_json = '';

        if ($r['auth']) {
            $headers[] = '-H "X-Device-UUID: your-device-uuid"';
        }

        if (in_array($method, ['POST', 'PUT', 'PATCH'], true)) {
            if (!empty($required)) {
                $headers[] = '-H "Content-Type: application/json"';
                $body = [];
                foreach ($required as $p) {
                    $body[$p['name']] = self::param_example($p);
                }
                $body_json = json_encode($body, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            } else {
                $headers[] = '-H "Content-Type: application/json"';
            }
        } else {
            if (!empty($required)) {
                $qs = [];
                foreach ($required as $p) {
                    $qs[] = urlencode($p['name']) . '=' . urlencode(self::param_example($p));
                }
                $url .= '?' . implode('&', $qs);
            }
        }

        $cmd = 'curl -X ' . $method . " \\\n  \"" . $url . '"';
        foreach ($headers as $h) {
            $cmd .= " \\\n  " . $h;
        }
        if ($body_json !== '') {
            $cmd .= " \\\n  -d '" . $body_json . "'";
        }

        return $cmd;
    }

    public static function register_menu() {
        add_submenu_page('toursapp-api', 'API Documentation', 'API Docs', 'manage_options', 'toursapp-api-docs', [self::class, 'render_page']);
    }

    public static function render_page() {
        if (!current_user_can('manage_options')) return;

        $routes   = TA_Admin::get_live_routes();
        $grouped  = self::group_routes($routes);
        $base_url = rest_url(TA_API_NAMESPACE);
        $total    = count($routes);
        ?>
        <style>
        .ta-docs *{box-sizing:border-box}
        .ta-docs{display:flex;flex-direction:column;height:calc(100vh - 32px);margin:-1px -20px 0;overflow:hidden;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif}

        /* Header */
        .ta-docs-hdr{background:#0b0e11;color:#eaecef;padding:14px 24px;display:flex;align-items:center;justify-content:space-between;flex-shrink:0;gap:12px}
        .ta-docs-hdr h1{margin:0;font-size:17px;font-weight:600;color:#fff}
        .ta-docs-hdr .ta-base{font-size:11px;color:#848e9c;margin-top:3px}
        .ta-docs-hdr .ta-base code{background:#1e2329;padding:2px 7px;border-radius:4px;color:#f0b90b;font-size:11px}
        .ta-docs-hdr .ta-stats{font-size:12px;color:#848e9c;white-space:nowrap}
        .ta-docs-hdr .ta-stats strong{color:#eaecef}

        /* Layout — two independent scroll panes */
        .ta-docs-body{display:flex;flex:1;overflow:hidden;min-height:0}

        /* Sidebar */
        .ta-docs-side{width:280px;min-width:280px;flex-shrink:0;background:#1e2329;border-right:1px solid #2b3139;overflow-y:auto;scrollbar-width:thin;scrollbar-color:#3b4149 #1e2329}
        .ta-docs-side::-webkit-scrollbar{width:5px}
        .ta-docs-side::-webkit-scrollbar-track{background:#1e2329}
        .ta-docs-side::-webkit-scrollbar-thumb{background:#3b4149;border-radius:3px}
        .ta-side-search{padding:10px 14px;border-bottom:1px solid #2b3139;position:sticky;top:0;background:#1e2329;z-index:2}
        .ta-side-search input{width:100%;padding:7px 11px;background:#0b0e11;border:1px solid #2b3139;border-radius:4px;color:#eaecef;font-size:13px;outline:none}
        .ta-side-search input:focus{border-color:#f0b90b}
        .ta-side-search input::placeholder{color:#5e6673}
        .ta-nav-group{border-bottom:1px solid #2b3139}
        .ta-nav-title{padding:10px 14px;color:#f0b90b;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;cursor:pointer;display:flex;align-items:center;justify-content:space-between;user-select:none;transition:background .15s}
        .ta-nav-title:hover{background:#252a2f}
        .ta-nav-title.group-active{background:#1a2030;color:#ffd166;border-left:3px solid #f0b90b}
        .ta-nav-title .arrow{font-size:10px;transition:transform .2s;color:#5e6673;flex-shrink:0;margin-left:4px}
        .ta-nav-title.collapsed .arrow{transform:rotate(-90deg)}
        .ta-nav-items{overflow:hidden;transition:max-height .25s ease;max-height:2000px}
        .ta-nav-items.collapsed{max-height:0!important}
        .ta-nav-link{display:flex;align-items:center;padding:6px 14px 6px 18px;color:#848e9c;text-decoration:none;font-size:12px;border-left:3px solid transparent;transition:all .15s;cursor:pointer}
        .ta-nav-link:hover{color:#eaecef;background:#252a2f;border-left-color:#3b4149}
        .ta-nav-link.active{color:#eaecef;border-left-color:#f0b90b;background:#252a2f}
        .ta-nav-link .ta-m{font-size:9px;padding:1px 5px;border-radius:2px;font-weight:700;margin-right:6px;min-width:32px;text-align:center;flex-shrink:0}
        .ta-nav-link .ep-path{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}

        /* Method badges */
        .ta-m-GET{background:#0a7a35;color:#fff}
        .ta-m-POST{background:#0073aa;color:#fff}
        .ta-m-PUT{background:#8b6914;color:#fff}
        .ta-m-DELETE{background:#b32d2e;color:#fff}

        /* Main content — independent scroll */
        .ta-docs-main{flex:1;background:#fff;min-width:0;overflow-y:auto}

        /* Section */
        .ta-docs-sect{padding:24px 32px;border-bottom:2px solid #eaecef}
        .ta-docs-sect h2{margin:0 0 18px;font-size:20px;font-weight:600;color:#1e2329;padding-bottom:10px;border-bottom:1px solid #eaecef}

        /* Endpoint */
        .ta-docs-ep{margin-bottom:32px;padding-bottom:24px;border-bottom:1px solid #f0f0f0}
        .ta-docs-ep:last-child{border-bottom:none;margin-bottom:0;padding-bottom:0}
        .ta-ep-head{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
        .ta-ep-head .ta-m{font-size:12px;padding:3px 10px;border-radius:4px;font-weight:700}
        .ta-ep-head code{font-size:14px;font-weight:600;color:#1e2329;word-break:break-all}
        .ta-ep-auth{font-size:11px;padding:3px 10px;border-radius:12px;font-weight:600;white-space:nowrap}
        .ta-auth-pub{background:#d4edda;color:#155724}
        .ta-auth-prv{background:#fff3cd;color:#856404}
        .ta-ep-desc{color:#555;margin:10px 0 18px;font-size:14px;line-height:1.6}

        /* Params */
        .ta-params{width:100%;border-collapse:collapse;font-size:13px;margin:10px 0 18px}
        .ta-params th{text-align:left;padding:9px 12px;background:#f8f9fa;border:1px solid #e9ecef;font-weight:600;color:#495057;font-size:11px;text-transform:uppercase;letter-spacing:.3px}
        .ta-params td{padding:8px 12px;border:1px solid #e9ecef;vertical-align:top;color:#333}
        .ta-params tr:hover td{background:#f8f9fa}
        .ta-params td code{background:#e9ecef;padding:1px 5px;border-radius:3px;font-size:12px}
        .ta-params .req{color:#c0392b;font-weight:600;font-size:12px}
        .ta-params .opt{color:#999;font-size:12px}
        .ta-params .hint{color:#666;font-size:12px;margin-top:2px}
        .ta-docs-ep h4{font-size:13px;font-weight:600;color:#1e2329;margin:18px 0 8px}

        /* Code block */
        .ta-code-wrap{position:relative;margin:6px 0 0}
        .ta-code-wrap pre{background:#1e1e1e;color:#d4d4d4;padding:16px 18px;border-radius:6px;overflow-x:auto;font-size:12px;line-height:1.6;margin:0;max-height:360px}
        .ta-copy{position:absolute;top:8px;right:8px;background:#3b4149;color:#848e9c;border:none;padding:3px 10px;border-radius:4px;font-size:11px;cursor:pointer;z-index:2}
        .ta-copy:hover{background:#4b5159;color:#eaecef}
        .ta-copy.copied{background:#0a7a35;color:#fff}

        .j-key{color:#9cdcfe}.j-str{color:#ce9178}.j-num{color:#b5cea8}.j-bool{color:#569cd6}
        .ta-curl{color:#98c379;white-space:pre}

        /* Mobile toggle */
        .ta-mob-btn{display:none;align-items:center;gap:6px;background:#2b3139;color:#eaecef;border:none;padding:6px 12px;border-radius:4px;font-size:13px;cursor:pointer;white-space:nowrap}
        .ta-mob-btn:hover{background:#3b4149}

        /* ── Responsive ── */
        @media(max-width:1200px) and (min-width:769px){.ta-docs-side{width:240px;min-width:240px}}
        @media(max-width:768px){
            .ta-docs{height:auto;min-height:100vh}
            .ta-docs-body{flex-direction:column;overflow:visible}
            .ta-docs-side{width:100%;min-width:100%;max-height:0;overflow:hidden;transition:max-height .3s ease;flex-shrink:0}
            .ta-docs-side.ta-open{max-height:65vh;overflow-y:auto}
            .ta-docs-main{min-height:60vh;overflow-y:visible}
            .ta-mob-btn{display:flex}
            .ta-docs-sect{padding:16px 14px}
            .ta-ep-head code{font-size:12px}
            .ta-params{display:block;overflow-x:auto;-webkit-overflow-scrolling:touch}
        }
        </style>

        <div class="ta-docs">
            <div class="ta-docs-hdr">
                <div>
                    <h1>ToursApp API Documentation</h1>
                    <div class="ta-base">Base URL: <code><?php echo esc_html(untrailingslashit($base_url)); ?></code></div>
                </div>
                <div style="display:flex;align-items:center;gap:14px">
                    <div class="ta-stats">
                        <strong><?php echo $total; ?></strong> endpoints &middot;
                        <strong><?php echo count($grouped); ?></strong> groups &middot;
                        v<strong><?php echo esc_html(TA_VERSION); ?></strong>
                    </div>
                    <button class="ta-mob-btn" id="ta-sidebar-toggle">&#9776; APIs</button>
                </div>
            </div>

            <div class="ta-docs-body">
                <!-- Sidebar -->
                <nav class="ta-docs-side">
                    <div class="ta-side-search">
                        <input type="text" id="ta-doc-search" placeholder="Search endpoints...">
                    </div>
                    <?php foreach ($grouped as $group_name => $group_routes): ?>
                    <div class="ta-nav-group" data-group="<?php echo esc_attr(sanitize_title($group_name)); ?>">
                        <div class="ta-nav-title">
                            <?php echo esc_html($group_name); ?>
                            <span class="arrow">&#9660;</span>
                        </div>
                        <div class="ta-nav-items">
                            <?php foreach ($group_routes as $r):
                                $anchor = self::anchor($r['method'], $r['path']);
                            ?>
                            <a href="#<?php echo esc_attr($anchor); ?>" class="ta-nav-link" data-target="<?php echo esc_attr($anchor); ?>">
                                <span class="ta-m ta-m-<?php echo esc_attr($r['method']); ?>"><?php echo esc_html($r['method']); ?></span>
                                <span class="ep-path"><?php echo esc_html($r['path']); ?></span>
                            </a>
                            <?php endforeach; ?>
                        </div>
                    </div>
                    <?php endforeach; ?>
                </nav>

                <!-- Content -->
                <main class="ta-docs-main">
                    <?php foreach ($grouped as $group_name => $group_routes): ?>
                    <section class="ta-docs-sect" id="group-<?php echo esc_attr(sanitize_title($group_name)); ?>">
                        <h2><?php echo esc_html($group_name); ?></h2>

                        <?php foreach ($group_routes as $ri => $r):
                            $anchor   = self::anchor($r['method'], $r['path']);
                            $full_ep  = '/' . TA_API_NAMESPACE . $r['path'];
                            $has_params = !empty($r['params']);
                            $has_sample = !empty($r['sample_output']);
                        ?>
                        <article class="ta-docs-ep" id="<?php echo esc_attr($anchor); ?>">
                            <div class="ta-ep-head">
                                <span class="ta-m ta-m-<?php echo esc_attr($r['method']); ?>"><?php echo esc_html($r['method']); ?></span>
                                <code><?php echo esc_html($full_ep); ?></code>
                                <span class="ta-ep-auth <?php echo $r['auth'] ? 'ta-auth-prv' : 'ta-auth-pub'; ?>">
                                    <?php echo $r['auth'] ? 'X-Device-UUID Required' : 'Public'; ?>
                                </span>
                            </div>

                            <?php if ($r['description']): ?>
                            <p class="ta-ep-desc"><?php echo esc_html($r['description']); ?></p>
                            <?php endif; ?>

                            <?php if ($has_params): ?>
                            <h4>Request Parameters</h4>
                            <table class="ta-params">
                                <thead>
                                    <tr>
                                        <th style="width:22%">Name</th>
                                        <th style="width:12%">Type</th>
                                        <th style="width:12%">Mandatory</th>
                                        <th>Description</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($r['params'] as $p): ?>
                                    <tr>
                                        <td><code><?php echo esc_html($p['name']); ?></code></td>
                                        <td><?php echo esc_html(strtoupper($p['type'])); ?></td>
                                        <td class="<?php echo $p['required'] ? 'req' : 'opt'; ?>">
                                            <?php echo $p['required'] ? 'YES' : 'NO'; ?>
                                        </td>
                                        <td><div class="hint"><?php echo self::param_hint($p); ?></div></td>
                                    </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                            <?php endif; ?>

                            <h4>Request Example</h4>
                            <div class="ta-code-wrap">
                                <button class="ta-copy" onclick="taCopy(this)">Copy</button>
                                <pre class="ta-curl"><?php echo esc_html(self::generate_curl($r, $base_url)); ?></pre>
                            </div>

                            <?php if ($has_sample): ?>
                            <h4>Response Example</h4>
                            <div class="ta-code-wrap">
                                <button class="ta-copy" onclick="taCopy(this)">Copy</button>
                                <pre class="ta-json"><?php
                                    $decoded = json_decode($r['sample_output'], true);
                                    echo esc_html($decoded !== null
                                        ? json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)
                                        : $r['sample_output']
                                    );
                                ?></pre>
                            </div>
                            <?php endif; ?>
                        </article>
                        <?php endforeach; ?>
                    </section>
                    <?php endforeach; ?>
                </main>
            </div>
        </div>

        <script>
        (function(){
            var main      = document.querySelector('.ta-docs-main');
            var side      = document.querySelector('.ta-docs-side');
            var togBtn    = document.getElementById('ta-sidebar-toggle');
            var allSects  = document.querySelectorAll('.ta-docs-sect');
            var allLinks  = document.querySelectorAll('.ta-nav-link');
            var allTitles = document.querySelectorAll('.ta-nav-title');

            // ── Mobile sidebar toggle ────────────────────────────────────
            if (togBtn) {
                togBtn.addEventListener('click', function() {
                    side.classList.toggle('ta-open');
                });
            }

            // ── Panel display helpers ─────────────────────────────────────
            function clearActive() {
                allLinks.forEach(function(a) { a.classList.remove('active'); });
                allTitles.forEach(function(t) { t.classList.remove('group-active'); });
            }

            function showGroup(slug) {
                allSects.forEach(function(s) { s.style.display = 'none'; });
                var sec = document.getElementById('group-' + slug);
                if (!sec) return;
                sec.style.display = '';
                sec.querySelectorAll('.ta-docs-ep').forEach(function(a) { a.style.display = ''; });
                main.scrollTop = 0;
            }

            function showEndpoint(anchor) {
                allSects.forEach(function(s) { s.style.display = 'none'; });
                var ep = document.getElementById(anchor);
                if (!ep) return;
                var sec = ep.closest('.ta-docs-sect');
                if (!sec) return;
                sec.style.display = '';
                sec.querySelectorAll('.ta-docs-ep').forEach(function(a) { a.style.display = 'none'; });
                ep.style.display = '';
                main.scrollTop = 0;
            }

            function closeMobile() {
                if (window.innerWidth <= 768) side.classList.remove('ta-open');
            }

            // ── Init: hide all, show first group ─────────────────────────
            allSects.forEach(function(s) { s.style.display = 'none'; });
            if (allSects.length) {
                var first = allSects[0];
                first.style.display = '';
                first.querySelectorAll('.ta-docs-ep').forEach(function(a) { a.style.display = ''; });
                var firstSlug = first.id.replace('group-', '');
                var firstTitle = document.querySelector('.ta-nav-group[data-group="' + firstSlug + '"] .ta-nav-title');
                if (firstTitle) firstTitle.classList.add('group-active');
            }

            // ── Group title click: show group + toggle collapse ───────────
            allTitles.forEach(function(title) {
                title.addEventListener('click', function() {
                    var group = this.closest('.ta-nav-group');
                    var items = this.nextElementSibling;
                    var slug  = group ? group.getAttribute('data-group') : null;

                    // Toggle collapse
                    var isNowCollapsed = !items.classList.contains('collapsed');
                    this.classList.toggle('collapsed', isNowCollapsed);
                    items.classList.toggle('collapsed', isNowCollapsed);

                    // Show group in right panel (always, regardless of collapse state)
                    if (slug) {
                        clearActive();
                        this.classList.add('group-active');
                        showGroup(slug);
                    }
                    closeMobile();
                });
            });

            // ── Endpoint link click: show only that endpoint ──────────────
            allLinks.forEach(function(link) {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var anchor = this.getAttribute('data-target');
                    clearActive();
                    this.classList.add('active');
                    showEndpoint(anchor);
                    history.replaceState(null, null, '#' + anchor);
                    closeMobile();
                });
            });

            // ── URL hash on page load ─────────────────────────────────────
            if (location.hash) {
                var hashId = location.hash.substring(1);
                var ep = document.getElementById(hashId);
                if (ep) {
                    showEndpoint(hashId);
                    var link = document.querySelector('.ta-nav-link[data-target="' + hashId + '"]');
                    if (link) { clearActive(); link.classList.add('active'); }
                }
            }

            // ── Search ────────────────────────────────────────────────────
            var searchInput = document.getElementById('ta-doc-search');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    var q = this.value.toLowerCase();
                    document.querySelectorAll('.ta-nav-group').forEach(function(g) {
                        var links = g.querySelectorAll('.ta-nav-link');
                        var anyVisible = false;
                        links.forEach(function(a) {
                            var show = !q || a.textContent.toLowerCase().indexOf(q) !== -1;
                            a.style.display = show ? '' : 'none';
                            if (show) anyVisible = true;
                        });
                        g.style.display = anyVisible ? '' : 'none';
                        if (q && anyVisible) {
                            var items = g.querySelector('.ta-nav-items');
                            var titleEl = g.querySelector('.ta-nav-title');
                            if (items) items.classList.remove('collapsed');
                            if (titleEl) titleEl.classList.remove('collapsed');
                        }
                    });
                });
            }

            // ── JSON highlight ────────────────────────────────────────────
            document.querySelectorAll('.ta-json').forEach(function(el) {
                var t = el.textContent;
                var h = t.replace(/&/g,'&amp;').replace(/</g,'&lt;');
                h = h.replace(/"([^"]*)"(\s*:)/g,'<span class="j-key">"$1"</span>$2');
                h = h.replace(/:\s*"([^"]*)"/g,': <span class="j-str">"$1"</span>');
                h = h.replace(/:\s*(\d+\.?\d*)/g,': <span class="j-num">$1</span>');
                h = h.replace(/:\s*(true|false|null)/g,': <span class="j-bool">$1</span>');
                el.innerHTML = h;
            });

            // ── Copy button ───────────────────────────────────────────────
            window.taCopy = function(btn) {
                var pre = btn.parentElement.querySelector('pre');
                navigator.clipboard.writeText(pre.textContent).then(function() {
                    btn.textContent = 'Copied!';
                    btn.classList.add('copied');
                    setTimeout(function() { btn.textContent = 'Copy'; btn.classList.remove('copied'); }, 1500);
                });
            };
        })();
        </script>
        <?php
    }
}
