jQuery(function ($) {
    'use strict';

    // Add a Browse button next to every .ta-audio-url-field text input
    function initAudioBrowse() {
        $('.ta-audio-url-field').each(function () {
            var $wrap = $(this);
            if ($wrap.find('.ta-audio-browse').length) return; // already done

            var $input = $wrap.find('input[type="text"]');
            if (!$input.length) return;

            // Wrap input + button together
            $input.wrap('<div class="ta-audio-input-row"></div>');
            $input.after(
                '<button type="button" class="button ta-audio-browse">📁 Browse</button>' +
                '<span class="ta-audio-preview"></span>'
            );

            // Show preview if already has a value
            if ($input.val()) {
                $wrap.find('.ta-audio-preview').html(
                    '<audio controls style="height:32px;margin-left:8px;vertical-align:middle">' +
                    '<source src="' + $input.val() + '"></audio>'
                );
            }

            // Update preview on manual input
            $input.on('change blur', function () {
                var url = $(this).val();
                var $preview = $wrap.find('.ta-audio-preview');
                if (url) {
                    $preview.html('<audio controls style="height:32px;margin-left:8px;vertical-align:middle"><source src="' + url + '"></audio>');
                } else {
                    $preview.html('');
                }
            });
        });
    }

    // Media picker on Browse click
    $(document).on('click', '.ta-audio-browse', function (e) {
        e.preventDefault();
        var $btn   = $(this);
        var $input = $btn.closest('.ta-audio-input-row').find('input[type="text"]');
        var $preview = $btn.closest('.ta-audio-url-field').find('.ta-audio-preview');

        var frame = wp.media({
            title:    'Select Audio File',
            button:   { text: 'Use this audio' },
            multiple: false,
            library:  { type: 'audio' },
        });

        frame.on('select', function () {
            var att = frame.state().get('selection').first().toJSON();
            $input.val(att.url).trigger('change');
            $preview.html(
                '<audio controls style="height:32px;margin-left:8px;vertical-align:middle">' +
                '<source src="' + att.url + '"></audio>'
            );
        });

        frame.open();
    });

    // Init on page load + ACF dynamic field load
    initAudioBrowse();
    $(document).on('acf/setup_fields', initAudioBrowse);
});
