<?php
defined('ABSPATH') || exit;

class TA_Devices_Page {

    public static function register_menu() {
        add_submenu_page('toursapp-api', 'Devices', 'Devices', 'manage_options', 'toursapp-devices', [self::class, 'render']);
    }

    private static function get_stats(): array {
        global $wpdb;
        $p = $wpdb->prefix;

        $total = (int) $wpdb->get_var("SELECT COUNT(*) FROM {$p}ta_devices");

        $online = (int) $wpdb->get_var(
            "SELECT COUNT(DISTINCT device_uuid) FROM {$p}ta_api_logs
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL 5 MINUTE)"
        );

        $offline_downloaded = (int) $wpdb->get_var(
            "SELECT COUNT(DISTINCT device_uuid) FROM {$p}ta_downloads
             WHERE status = 'completed'"
        );

        $by_platform = $wpdb->get_results(
            "SELECT platform, COUNT(*) AS cnt FROM {$p}ta_devices GROUP BY platform ORDER BY cnt DESC",
            ARRAY_A
        ) ?: [];

        $new_today = (int) $wpdb->get_var(
            "SELECT COUNT(*) FROM {$p}ta_devices WHERE DATE(created_at) = CURDATE()"
        );

        $new_7d = (int) $wpdb->get_var(
            "SELECT COUNT(*) FROM {$p}ta_devices WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)"
        );

        $active_24h = (int) $wpdb->get_var(
            "SELECT COUNT(DISTINCT device_uuid) FROM {$p}ta_api_logs
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)"
        );

        $recent_devices = $wpdb->get_results(
            "SELECT d.device_uuid, d.device_name, d.platform, d.app_version, d.lang, d.created_at,
                    (SELECT MAX(l.created_at) FROM {$p}ta_api_logs l WHERE l.device_uuid = d.device_uuid) AS last_seen,
                    (SELECT COUNT(*) FROM {$p}ta_downloads dl WHERE dl.device_uuid = d.device_uuid AND dl.status = 'completed') AS dl_count
             FROM {$p}ta_devices d
             ORDER BY d.created_at DESC
             LIMIT 20",
            ARRAY_A
        ) ?: [];

        $download_stats = $wpdb->get_row(
            "SELECT COUNT(*) AS total_downloads,
                    COUNT(DISTINCT device_uuid) AS unique_devices,
                    COALESCE(SUM(total_size_mb), 0) AS total_size_mb,
                    COALESCE(SUM(file_count), 0) AS total_files
             FROM {$p}ta_downloads WHERE status = 'completed'",
            ARRAY_A
        ) ?: ['total_downloads' => 0, 'unique_devices' => 0, 'total_size_mb' => 0, 'total_files' => 0];

        $downloads_by_province = $wpdb->get_results(
            "SELECT dl.province_id,
                    COALESCE(pm.meta_value, CONCAT('Province #', dl.province_id)) AS province_name,
                    COUNT(*) AS dl_count,
                    COUNT(DISTINCT dl.device_uuid) AS unique_devices,
                    COALESCE(SUM(dl.total_size_mb), 0) AS total_size_mb,
                    MAX(dl.completed_at) AS last_download
             FROM {$p}ta_downloads dl
             LEFT JOIN {$p}postmeta pm ON pm.post_id = dl.province_id AND pm.meta_key = 'province_name_vi'
             WHERE dl.status = 'completed'
             GROUP BY dl.province_id
             ORDER BY dl_count DESC",
            ARRAY_A
        ) ?: [];

        $downloads_by_type = $wpdb->get_results(
            "SELECT download_type, COUNT(*) AS cnt,
                    COUNT(DISTINCT device_uuid) AS unique_devices,
                    COALESCE(SUM(total_size_mb), 0) AS total_size_mb
             FROM {$p}ta_downloads WHERE status = 'completed'
             GROUP BY download_type ORDER BY cnt DESC",
            ARRAY_A
        ) ?: [];

        $recent_downloads = $wpdb->get_results(
            "SELECT dl.device_uuid, dl.province_id, dl.download_type, dl.lang,
                    dl.file_count, dl.total_size_mb, dl.started_at, dl.completed_at,
                    COALESCE(pm.meta_value, CONCAT('Province #', dl.province_id)) AS province_name,
                    d.device_name, d.platform
             FROM {$p}ta_downloads dl
             LEFT JOIN {$p}postmeta pm ON pm.post_id = dl.province_id AND pm.meta_key = 'province_name_vi'
             LEFT JOIN {$p}ta_devices d ON d.device_uuid = dl.device_uuid
             WHERE dl.status = 'completed'
             ORDER BY dl.completed_at DESC
             LIMIT 20",
            ARRAY_A
        ) ?: [];

        $downloads_daily = $wpdb->get_results(
            "SELECT DATE(completed_at) AS day, COUNT(*) AS cnt
             FROM {$p}ta_downloads
             WHERE status = 'completed' AND completed_at >= DATE_SUB(NOW(), INTERVAL 14 DAY)
             GROUP BY DATE(completed_at) ORDER BY day ASC",
            ARRAY_A
        ) ?: [];

        $daily_registrations = $wpdb->get_results(
            "SELECT DATE(created_at) AS day, COUNT(*) AS cnt
             FROM {$p}ta_devices
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL 14 DAY)
             GROUP BY DATE(created_at) ORDER BY day ASC",
            ARRAY_A
        ) ?: [];

        return compact(
            'total', 'online', 'offline_downloaded', 'by_platform',
            'new_today', 'new_7d', 'active_24h', 'recent_devices',
            'download_stats', 'daily_registrations',
            'downloads_by_province', 'downloads_by_type', 'recent_downloads', 'downloads_daily'
        );
    }

    public static function render() {
        if (!current_user_can('manage_options')) return;

        $s = self::get_stats();
        ?>
        <div class="wrap">
            <h1>Device Dashboard</h1>

            <style>
                .ta-dev-cards { display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:14px; margin-bottom:24px; }
                .ta-dev-card  { background:#fff; border:1px solid #ddd; border-radius:8px; padding:18px 20px; position:relative; overflow:hidden; }
                .ta-dev-card .num  { font-size:32px; font-weight:700; line-height:1.1; }
                .ta-dev-card .lbl  { font-size:12px; color:#666; margin-top:6px; display:block; }
                .ta-dev-card .icon { position:absolute; top:14px; right:16px; font-size:28px; opacity:0.15; }
                .ta-dev-card--blue   { border-left:4px solid #2271b1; }
                .ta-dev-card--green  { border-left:4px solid #00a32a; }
                .ta-dev-card--orange { border-left:4px solid #dba617; }
                .ta-dev-card--purple { border-left:4px solid #8c5fc7; }
                .ta-dev-section { background:#fff; border:1px solid #ddd; border-radius:8px; padding:18px 20px; margin-bottom:20px; }
                .ta-dev-section h2 { margin-top:0; font-size:15px; border-bottom:1px solid #eee; padding-bottom:10px; }
                .ta-dev-online  { display:inline-block; width:8px; height:8px; border-radius:50%; background:#00a32a; margin-right:4px; }
                .ta-dev-offline { display:inline-block; width:8px; height:8px; border-radius:50%; background:#ccc; margin-right:4px; }
                .ta-dev-bar { display:flex; height:8px; border-radius:4px; overflow:hidden; background:#eee; margin-top:8px; }
                .ta-dev-bar > div { height:100%; }
                .ta-mini-chart { display:flex; align-items:flex-end; gap:3px; height:40px; margin-top:8px; }
                .ta-mini-chart > div { flex:1; background:#2271b1; border-radius:2px 2px 0 0; min-width:1px; }
                /* Tables: horizontal scroll on small screens */
                .ta-table-wrap { overflow-x:auto; -webkit-overflow-scrolling:touch; margin-bottom:16px; }
                .ta-table-wrap table { min-width:500px; margin-bottom:0 !important; }
                @media (max-width: 782px) {
                    .ta-dev-section { padding:12px 14px; }
                    .ta-dev-cards { grid-template-columns:repeat(auto-fill,minmax(140px,1fr)); gap:8px; }
                    .ta-grid-2 { grid-template-columns:1fr !important; } /* Stack columns */
                    .ta-grid-4 { grid-template-columns:1fr 1fr !important; } /* Stack stats */
                }
            </style>

            <!-- Main Stat Cards -->
            <div class="ta-dev-cards">
                <div class="ta-dev-card ta-dev-card--blue">
                    <span class="icon">📱</span>
                    <div class="num"><?php echo number_format($s['total']); ?></div>
                    <span class="lbl">Total Registered Devices</span>
                    <?php if ($s['new_today']): ?>
                        <span style="font-size:11px;color:#2271b1;margin-top:4px;display:block">+<?php echo $s['new_today']; ?> today</span>
                    <?php endif; ?>
                </div>

                <div class="ta-dev-card ta-dev-card--green">
                    <span class="icon">🟢</span>
                    <div class="num"><?php echo number_format($s['online']); ?></div>
                    <span class="lbl">Online Now <span style="font-size:10px;color:#999">(5 min)</span></span>
                    <?php if ($s['total'] > 0): ?>
                        <div class="ta-dev-bar" style="margin-top:10px">
                            <div style="width:<?php echo round($s['online'] / $s['total'] * 100, 1); ?>%;background:#00a32a"></div>
                        </div>
                        <span style="font-size:10px;color:#888;margin-top:2px;display:block">
                            <?php echo round($s['online'] / $s['total'] * 100, 1); ?>% of total
                        </span>
                    <?php endif; ?>
                </div>

                <div class="ta-dev-card ta-dev-card--orange">
                    <span class="icon">📥</span>
                    <div class="num"><?php echo number_format($s['offline_downloaded']); ?></div>
                    <span class="lbl">Offline Data Downloaded</span>
                    <?php if ($s['total'] > 0): ?>
                        <span style="font-size:10px;color:#888;margin-top:4px;display:block">
                            <?php echo round($s['offline_downloaded'] / $s['total'] * 100, 1); ?>% of devices
                        </span>
                    <?php endif; ?>
                </div>

                <div class="ta-dev-card ta-dev-card--purple">
                    <span class="icon">📊</span>
                    <div class="num"><?php echo number_format($s['active_24h']); ?></div>
                    <span class="lbl">Active Last 24h</span>
                </div>
            </div>

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px" class="ta-grid-2">
                <!-- Platform Breakdown -->
                <div class="ta-dev-section">
                    <h2>Platform Breakdown</h2>
                    <?php if ($s['by_platform']): ?>
                        <table style="width:100%;font-size:13px;border-collapse:collapse">
                            <?php
                            $colors = ['android' => '#3ddc84', 'ios' => '#007aff', 'web' => '#ff9500'];
                            foreach ($s['by_platform'] as $plat):
                                $pct = $s['total'] > 0 ? round($plat['cnt'] / $s['total'] * 100, 1) : 0;
                                $color = $colors[$plat['platform']] ?? '#888';
                            ?>
                            <tr>
                                <td style="padding:6px 0;width:90px">
                                    <strong style="text-transform:capitalize"><?php echo esc_html($plat['platform']); ?></strong>
                                </td>
                                <td style="padding:6px 8px">
                                    <div style="background:#eee;border-radius:4px;height:18px;position:relative">
                                        <div style="background:<?php echo esc_attr($color); ?>;height:100%;border-radius:4px;width:<?php echo $pct; ?>%;min-width:2px"></div>
                                    </div>
                                </td>
                                <td style="padding:6px 0;width:100px;text-align:right;font-size:12px;color:#666">
                                    <?php echo number_format($plat['cnt']); ?> (<?php echo $pct; ?>%)
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </table>
                    <?php else: ?>
                        <p style="color:#888">No data yet.</p>
                    <?php endif; ?>
                </div>

                <!-- Registration Trend (14 days) -->
                <div class="ta-dev-section">
                    <h2>New Registrations <span style="font-size:12px;font-weight:normal;color:#888">(14 days)</span></h2>
                    <?php if ($s['daily_registrations']):
                        $max_reg = max(array_column($s['daily_registrations'], 'cnt'));
                    ?>
                        <div class="ta-mini-chart">
                            <?php foreach ($s['daily_registrations'] as $day):
                                $h = $max_reg > 0 ? round($day['cnt'] / $max_reg * 100) : 0;
                            ?>
                                <div style="height:<?php echo max($h, 3); ?>%" title="<?php echo esc_attr($day['day'] . ': ' . $day['cnt']); ?>"></div>
                            <?php endforeach; ?>
                        </div>
                        <div style="display:flex;justify-content:space-between;font-size:10px;color:#aaa;margin-top:4px">
                            <span><?php echo esc_html(substr($s['daily_registrations'][0]['day'], 5)); ?></span>
                            <span>+<?php echo $s['new_7d']; ?> last 7 days</span>
                            <span><?php echo esc_html(substr(end($s['daily_registrations'])['day'], 5)); ?></span>
                        </div>
                    <?php else: ?>
                        <p style="color:#888">No data yet.</p>
                    <?php endif; ?>
                </div>
            </div>

            <!-- Offline Download Stats -->
            <div class="ta-dev-section">
                <h2>Offline Downloads Summary</h2>
                <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:16px" class="ta-grid-4">
                    <div>
                        <div style="font-size:24px;font-weight:700"><?php echo number_format($s['download_stats']['total_downloads']); ?></div>
                        <div style="font-size:12px;color:#666">Total Downloads</div>
                    </div>
                    <div>
                        <div style="font-size:24px;font-weight:700"><?php echo number_format($s['download_stats']['unique_devices']); ?></div>
                        <div style="font-size:12px;color:#666">Unique Devices</div>
                    </div>
                    <div>
                        <div style="font-size:24px;font-weight:700"><?php echo number_format($s['download_stats']['total_files']); ?></div>
                        <div style="font-size:12px;color:#666">Files Delivered</div>
                    </div>
                    <div>
                        <div style="font-size:24px;font-weight:700"><?php echo round($s['download_stats']['total_size_mb'], 1); ?> MB</div>
                        <div style="font-size:12px;color:#666">Total Data Served</div>
                    </div>
                </div>
            </div>

            <!-- Download Detail: By Province -->
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px" class="ta-grid-2">
                <div class="ta-dev-section">
                    <h2>Downloads by Province <span style="font-size:12px;font-weight:normal;color:#888">(ranked)</span></h2>
                    <?php if ($s['downloads_by_province']): ?>
                        <?php $max_dl = max(array_column($s['downloads_by_province'], 'dl_count')); ?>
                        <div class="ta-table-wrap"><table style="width:100%;font-size:13px;border-collapse:collapse">
                            <?php foreach ($s['downloads_by_province'] as $i => $prov):
                                $pct = $max_dl > 0 ? round($prov['dl_count'] / $max_dl * 100) : 0;
                            ?>
                            <tr>
                                <td style="padding:8px 0;width:30px;color:#888;font-size:12px;text-align:center"><?php echo $i + 1; ?></td>
                                <td style="padding:8px 4px">
                                    <strong><?php echo esc_html($prov['province_name']); ?></strong>
                                    <div style="background:#eee;border-radius:4px;height:6px;margin-top:4px">
                                        <div style="background:#dba617;height:100%;border-radius:4px;width:<?php echo $pct; ?>%"></div>
                                    </div>
                                </td>
                                <td style="padding:8px 0;width:120px;text-align:right;font-size:12px">
                                    <strong><?php echo $prov['dl_count']; ?></strong> downloads<br>
                                    <span style="color:#888"><?php echo $prov['unique_devices']; ?> devices · <?php echo round($prov['total_size_mb'], 1); ?> MB</span>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </table></div>
                    <?php else: ?>
                        <p style="color:#888">No download data yet.</p>
                    <?php endif; ?>
                </div>

                <div>
                    <!-- Download by Type -->
                    <div class="ta-dev-section" style="margin-bottom:20px">
                        <h2>Downloads by Type</h2>
                        <?php if ($s['downloads_by_type']):
                            $type_total = array_sum(array_column($s['downloads_by_type'], 'cnt'));
                            $type_colors = ['full' => '#2271b1', 'incremental' => '#00a32a', 'media_only' => '#dba617'];
                            $type_labels = ['full' => 'Full Package', 'incremental' => 'Incremental', 'media_only' => 'Media Only'];
                        ?>
                            <div class="ta-dev-bar" style="height:24px;border-radius:6px;margin-bottom:12px">
                                <?php foreach ($s['downloads_by_type'] as $dt):
                                    $w = $type_total > 0 ? round($dt['cnt'] / $type_total * 100, 1) : 0;
                                    $color = $type_colors[$dt['download_type']] ?? '#888';
                                ?>
                                    <div style="width:<?php echo $w; ?>%;background:<?php echo $color; ?>" title="<?php echo esc_attr($dt['download_type'] . ': ' . $dt['cnt']); ?>"></div>
                                <?php endforeach; ?>
                            </div>
                            <?php foreach ($s['downloads_by_type'] as $dt):
                                $color = $type_colors[$dt['download_type']] ?? '#888';
                                $label = $type_labels[$dt['download_type']] ?? $dt['download_type'];
                            ?>
                                <div style="display:flex;align-items:center;justify-content:space-between;padding:4px 0;font-size:13px">
                                    <span>
                                        <span style="display:inline-block;width:10px;height:10px;border-radius:2px;background:<?php echo $color; ?>;margin-right:6px"></span>
                                        <?php echo esc_html($label); ?>
                                    </span>
                                    <span style="color:#666">
                                        <?php echo $dt['cnt']; ?> (<?php echo $dt['unique_devices']; ?> devices · <?php echo round($dt['total_size_mb'], 1); ?> MB)
                                    </span>
                                </div>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <p style="color:#888">No data yet.</p>
                        <?php endif; ?>
                    </div>

                    <!-- Download Trend -->
                    <div class="ta-dev-section">
                        <h2>Download Trend <span style="font-size:12px;font-weight:normal;color:#888">(14 days)</span></h2>
                        <?php if ($s['downloads_daily']):
                            $max_ddl = max(array_column($s['downloads_daily'], 'cnt'));
                        ?>
                            <div class="ta-mini-chart">
                                <?php foreach ($s['downloads_daily'] as $day):
                                    $h = $max_ddl > 0 ? round($day['cnt'] / $max_ddl * 100) : 0;
                                ?>
                                    <div style="height:<?php echo max($h, 3); ?>%;background:#dba617" title="<?php echo esc_attr($day['day'] . ': ' . $day['cnt']); ?>"></div>
                                <?php endforeach; ?>
                            </div>
                            <div style="display:flex;justify-content:space-between;font-size:10px;color:#aaa;margin-top:4px">
                                <span><?php echo esc_html(substr($s['downloads_daily'][0]['day'], 5)); ?></span>
                                <span><?php echo esc_html(substr(end($s['downloads_daily'])['day'], 5)); ?></span>
                            </div>
                        <?php else: ?>
                            <p style="color:#888">No data yet.</p>
                        <?php endif; ?>
                    </div>
                </div>
            </div>

            <!-- Recent Downloads Table -->
            <div class="ta-dev-section" style="margin-bottom:20px">
                <h2>Recent Downloads <span style="font-size:12px;font-weight:normal;color:#888">(last 20)</span></h2>
                <div class="ta-table-wrap"><table class="widefat striped" style="font-size:13px">
                    <thead>
                        <tr>
                            <th>Province</th>
                            <th>Device</th>
                            <th>Platform</th>
                            <th>Type</th>
                            <th>Lang</th>
                            <th>Files</th>
                            <th>Size</th>
                            <th>Downloaded At</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php if ($s['recent_downloads']): ?>
                        <?php foreach ($s['recent_downloads'] as $dl):
                            $type_badges = ['full' => '#2271b1', 'incremental' => '#00a32a', 'media_only' => '#dba617'];
                            $badge_color = $type_badges[$dl['download_type']] ?? '#888';
                        ?>
                        <tr>
                            <td><strong><?php echo esc_html($dl['province_name']); ?></strong></td>
                            <td>
                                <span style="font-size:11px"><?php echo esc_html($dl['device_name'] ?: substr($dl['device_uuid'], 0, 12) . '…'); ?></span>
                            </td>
                            <td style="text-transform:capitalize"><?php echo esc_html($dl['platform'] ?: '—'); ?></td>
                            <td>
                                <span style="background:<?php echo $badge_color; ?>;color:#fff;padding:2px 8px;border-radius:10px;font-size:11px">
                                    <?php echo esc_html($dl['download_type']); ?>
                                </span>
                            </td>
                            <td><?php echo esc_html($dl['lang']); ?></td>
                            <td style="text-align:center"><?php echo (int) $dl['file_count']; ?></td>
                            <td style="text-align:right"><?php echo round($dl['total_size_mb'], 1); ?> MB</td>
                            <td style="font-size:11px">
                                <?php echo $dl['completed_at'] ? esc_html(human_time_diff(strtotime($dl['completed_at']))) . ' ago' : '—'; ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr><td colspan="8" style="text-align:center;color:#888;padding:20px">No downloads yet.</td></tr>
                    <?php endif; ?>
                    </tbody>
                </table></div>
            </div>

            <!-- Recent Devices Table -->
            <div class="ta-dev-section">
                <h2>Recent Devices <span style="font-size:12px;font-weight:normal;color:#888">(last 20 registered)</span></h2>
                <div class="ta-table-wrap"><table class="widefat striped" style="font-size:13px">
                    <thead>
                        <tr>
                            <th>Status</th>
                            <th>Device UUID</th>
                            <th>Name</th>
                            <th>Platform</th>
                            <th>Version</th>
                            <th>Lang</th>
                            <th>Registered</th>
                            <th>Last Seen</th>
                            <th>Offline</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php if ($s['recent_devices']): ?>
                        <?php foreach ($s['recent_devices'] as $dev):
                            $is_online = $dev['last_seen'] && strtotime($dev['last_seen']) >= strtotime('-5 minutes');
                        ?>
                        <tr>
                            <td>
                                <span class="<?php echo $is_online ? 'ta-dev-online' : 'ta-dev-offline'; ?>"
                                      title="<?php echo $is_online ? 'Online' : 'Offline'; ?>"></span>
                            </td>
                            <td><code style="font-size:11px"><?php echo esc_html(substr($dev['device_uuid'], 0, 16)); ?>…</code></td>
                            <td><?php echo esc_html($dev['device_name'] ?: '—'); ?></td>
                            <td style="text-transform:capitalize"><?php echo esc_html($dev['platform']); ?></td>
                            <td><?php echo esc_html($dev['app_version'] ?: '—'); ?></td>
                            <td><?php echo esc_html($dev['lang']); ?></td>
                            <td style="font-size:11px"><?php echo esc_html(substr($dev['created_at'], 0, 16)); ?></td>
                            <td style="font-size:11px;<?php echo $is_online ? 'color:#00a32a;font-weight:600' : ''; ?>">
                                <?php echo $dev['last_seen'] ? esc_html(human_time_diff(strtotime($dev['last_seen']))) . ' ago' : '—'; ?>
                            </td>
                            <td style="text-align:center">
                                <?php echo $dev['dl_count'] > 0 ? '<span style="color:#00a32a" title="' . $dev['dl_count'] . ' download(s)">✓</span>' : '<span style="color:#ccc">—</span>'; ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr><td colspan="9" style="text-align:center;color:#888;padding:20px">No devices registered yet.</td></tr>
                    <?php endif; ?>
                    </tbody>
                </table></div>
            </div>

            <p style="font-size:11px;color:#aaa;margin-top:8px">
                "Online" = API activity within the last 5 minutes.
                "Offline" = device has completed at least one offline data download.
                Data refreshes on each page load.
            </p>
        </div>
        <?php
    }
}
