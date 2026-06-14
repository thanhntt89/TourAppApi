jQuery(function ($) {
    'use strict';

    var iconMap = {
        'news':    'newspaper',
        'alert':   'bell',
        'warning': 'triangle-warning',
        'event':   'calendar',
    };

    function syncIcon(val) {
        if (!val) return;
        var icon = iconMap[val];
        if (!icon) return;
        // Target the icon text input (ACF field key: field_ta_news_icon)
        var $iconInput = $('[data-key="field_ta_news_icon"] input[type="text"]');
        if ($iconInput.length) {
            $iconInput.val(icon).trigger('change');
        }
    }

    // On type dropdown change
    $(document).on('change', '[data-key="field_ta_news_type"] select', function () {
        syncIcon($(this).val());
    });

    // Also sync on page load if type already selected and icon is default/empty
    $(document).on('acf/setup_fields', function () {
        var $typeSelect = $('[data-key="field_ta_news_type"] select');
        var $iconInput  = $('[data-key="field_ta_news_icon"] input[type="text"]');
        if ($typeSelect.length && $iconInput.length) {
            var currentIcon = $iconInput.val();
            // Only auto-set if icon is still the default 'info' or empty
            if (currentIcon === 'info' || currentIcon === '') {
                syncIcon($typeSelect.val());
            }
        }
    });
});
