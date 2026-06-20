<?php
defined('ABSPATH') || exit;

class TA_Output_Fields_Page {

    private static $type_labels = [
        'province'    => 'Provinces',
        'ta_location' => 'Locations',
        'place'       => 'Places',
        'sub_place'   => 'Sub-Places',
        'sub_item'    => 'Sub-Items',
        'journey'     => 'Journeys',
        'news_alert'  => 'News & Alerts',
        'ta_story'    => 'Stories',
    ];

    public static function register_menu(): void {
        add_submenu_page(
            'toursapp-api',
            'Output Fields',
            'Output Fields',
            'manage_options',
            'toursapp-output-fields',
            [self::class, 'render_page']
        );
    }

    public static function render_page(): void {
        if (!current_user_can('manage_options')) return;

        self::handle_save();

        $registry = TA_Output_Fields::get_field_registry();
        $disabled = (array) get_option(TA_Output_Fields::OPTION_KEY, []);
        $active   = isset($_GET['tab']) ? sanitize_key($_GET['tab']) : 'province';

        if (!isset($registry[$active])) $active = 'province';
        ?>
        <div class="wrap">
            <h1>API Output Fields</h1>
            <p class="description">Select which fields appear in API responses for each content type. Unchecked fields will be stripped from all responses. The <code>id</code> field is always included.</p>

            <?php if (isset($_GET['saved'])): ?>
            <div class="notice notice-success is-dismissible"><p>Field settings saved.</p></div>
            <?php endif; ?>

            <form method="post">
                <?php wp_nonce_field('ta_output_fields_save', 'ta_output_fields_nonce'); ?>
                <input type="hidden" name="ta_active_tab" id="ta-active-tab" value="<?php echo esc_attr($active); ?>">

                <style>
                @media(max-width:768px){
                    .nav-tab-wrapper { overflow-x:auto; white-space:nowrap; flex-wrap:nowrap; }
                    .ta-tab-pane { overflow-x:auto; }
                    .ta-tab-pane .widefat { min-width:480px; }
                }
            </style>
            <nav class="nav-tab-wrapper" style="margin-bottom:0">
                    <?php foreach (self::$type_labels as $type => $label): ?>
                    <a class="nav-tab ta-field-tab <?php echo $type === $active ? 'nav-tab-active' : ''; ?>"
                       href="#"
                       data-tab="<?php echo esc_attr($type); ?>"><?php echo esc_html($label); ?><?php
                        $d = count($disabled[$type] ?? []);
                        if ($d): ?> <span style="background:#d63638;color:#fff;font-size:11px;padding:1px 6px;border-radius:10px;margin-left:4px"><?php echo $d; ?></span><?php endif;
                    ?></a>
                    <?php endforeach; ?>
                </nav>

                <?php foreach ($registry as $type => $fields):
                    $type_disabled = $disabled[$type] ?? [];
                ?>
                <div class="ta-tab-pane" data-tab="<?php echo esc_attr($type); ?>"
                     style="background:#fff;border:1px solid #ddd;border-top:0;padding:16px 20px;<?php echo $type !== $active ? 'display:none' : ''; ?>">

                    <div style="margin-bottom:12px;display:flex;align-items:center;gap:8px">
                        <button type="button" class="button ta-check-all">Enable All</button>
                        <button type="button" class="button ta-uncheck-all">Disable All</button>
                        <span style="margin-left:auto;color:#666;font-size:12px">
                            <?php echo count($fields); ?> fields &bull;
                            <?php echo count($fields) - count($type_disabled); ?> enabled
                        </span>
                    </div>

                    <table class="widefat striped" style="border:0">
                        <thead>
                            <tr>
                                <th style="width:50px;text-align:center">On</th>
                                <th style="width:200px">Field</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($fields as $key => $meta):
                                $locked  = !empty($meta['locked']);
                                $checked = $locked || !in_array($key, $type_disabled, true);
                            ?>
                            <tr>
                                <td style="text-align:center">
                                    <?php if ($locked): ?>
                                        <input type="checkbox" checked disabled>
                                        <input type="hidden" name="ta_enabled[<?php echo esc_attr($type); ?>][]" value="<?php echo esc_attr($key); ?>">
                                    <?php else: ?>
                                        <input type="checkbox"
                                               name="ta_enabled[<?php echo esc_attr($type); ?>][]"
                                               value="<?php echo esc_attr($key); ?>"
                                               class="ta-field-cb"
                                               <?php checked($checked); ?>>
                                    <?php endif; ?>
                                </td>
                                <td><code><?php echo esc_html($key); ?></code></td>
                                <td>
                                    <?php echo esc_html($meta['label']); ?>
                                    <?php if ($locked): ?>
                                        <span style="color:#999;font-style:italic"> — always included</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
                <?php endforeach; ?>

                <p style="margin-top:16px">
                    <input type="submit" name="ta_save_output_fields" class="button button-primary" value="Save Field Settings">
                </p>
            </form>
        </div>

        <script>
        (function(){
            var tabs = document.querySelectorAll('.ta-field-tab');
            var panes = document.querySelectorAll('.ta-tab-pane');
            var hidden = document.getElementById('ta-active-tab');

            tabs.forEach(function(tab){
                tab.addEventListener('click', function(e){
                    e.preventDefault();
                    var t = this.getAttribute('data-tab');
                    tabs.forEach(function(x){ x.classList.remove('nav-tab-active'); });
                    this.classList.add('nav-tab-active');
                    panes.forEach(function(p){ p.style.display = p.getAttribute('data-tab') === t ? '' : 'none'; });
                    hidden.value = t;
                });
            });

            document.querySelectorAll('.ta-check-all').forEach(function(btn){
                btn.addEventListener('click', function(){
                    this.closest('.ta-tab-pane').querySelectorAll('.ta-field-cb').forEach(function(cb){ cb.checked = true; });
                });
            });

            document.querySelectorAll('.ta-uncheck-all').forEach(function(btn){
                btn.addEventListener('click', function(){
                    this.closest('.ta-tab-pane').querySelectorAll('.ta-field-cb').forEach(function(cb){ cb.checked = false; });
                });
            });
        })();
        </script>
        <?php
    }

    private static function handle_save(): void {
        if (!isset($_POST['ta_save_output_fields'])) return;
        if (!check_admin_referer('ta_output_fields_save', 'ta_output_fields_nonce')) return;

        $registry = TA_Output_Fields::get_field_registry();
        $enabled  = isset($_POST['ta_enabled']) ? (array) $_POST['ta_enabled'] : [];
        $disabled = [];

        foreach ($registry as $type => $fields) {
            $type_enabled = isset($enabled[$type]) ? array_map('sanitize_key', (array) $enabled[$type]) : [];
            $type_disabled = [];

            foreach ($fields as $key => $meta) {
                if (!empty($meta['locked'])) continue;
                if (!in_array($key, $type_enabled, true)) {
                    $type_disabled[] = $key;
                }
            }

            if (!empty($type_disabled)) {
                $disabled[$type] = $type_disabled;
            }
        }

        update_option(TA_Output_Fields::OPTION_KEY, $disabled);

        $tab = isset($_POST['ta_active_tab']) ? sanitize_key($_POST['ta_active_tab']) : 'province';
        wp_safe_redirect(admin_url('admin.php?page=toursapp-output-fields&tab=' . $tab . '&saved=1'));
        exit;
    }
}
