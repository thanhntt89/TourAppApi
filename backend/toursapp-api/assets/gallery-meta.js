jQuery(function ($) {
    'use strict';

    // ── Drag-to-reorder (native HTML5 drag) ──────────────────────────────────

    function enableDrag(wrap) {
        var thumbs = wrap.find('.ta-gallery-thumbs');
        var dragging = null;

        thumbs.on('dragstart', '.ta-thumb', function (e) {
            dragging = this;
            $(this).css('opacity', '0.5');
        });

        thumbs.on('dragend', '.ta-thumb', function () {
            $(this).css('opacity', '');
            dragging = null;
            syncIds(wrap);
        });

        thumbs.on('dragover', '.ta-thumb', function (e) {
            e.preventDefault();
            if (dragging && dragging !== this) {
                var allThumbs = thumbs.children('.ta-thumb').toArray();
                var fromIdx = allThumbs.indexOf(dragging);
                var toIdx   = allThumbs.indexOf(this);
                if (fromIdx < toIdx) {
                    $(this).after(dragging);
                } else {
                    $(this).before(dragging);
                }
            }
        });

        wrap.find('.ta-gallery-thumbs .ta-thumb').attr('draggable', 'true');
    }

    // ── Sync hidden input from current thumbs order ───────────────────────────

    function syncIds(wrap) {
        var fieldId = wrap.data('field');
        var ids = wrap.find('.ta-thumb').map(function () {
            return $(this).data('id');
        }).get().join(',');
        $('#' + fieldId).val(ids);
    }

    // ── Remove single thumb ───────────────────────────────────────────────────

    $(document).on('click', '.ta-remove', function () {
        var wrap = $(this).closest('.ta-gallery-wrap');
        $(this).closest('.ta-thumb').remove();
        syncIds(wrap);
    });

    // ── Media picker ─────────────────────────────────────────────────────────

    $(document).on('click', '.ta-gallery-add', function (e) {
        e.preventDefault();
        var wrap   = $(this).closest('.ta-gallery-wrap');
        var thumbs = wrap.find('.ta-gallery-thumbs');

        var frame = wp.media({
            title:    'Select Images',
            button:   { text: 'Add to Gallery' },
            multiple: true,
            library:  { type: 'image' }
        });

        frame.on('select', function () {
            var selection = frame.state().get('selection');

            selection.each(function (attachment) {
                var att  = attachment.toJSON();
                var id   = att.id;

                // Skip if already in gallery
                if (thumbs.find('[data-id="' + id + '"]').length) return;

                var src = att.sizes && att.sizes.thumbnail
                    ? att.sizes.thumbnail.url
                    : att.url;

                var thumb = $(
                    '<div class="ta-thumb" data-id="' + id + '" draggable="true">' +
                    '<img src="' + src + '">' +
                    '<span class="ta-remove">×</span>' +
                    '</div>'
                );
                thumbs.append(thumb);
            });

            syncIds(wrap);
        });

        frame.open();
    });

    // ── Init ─────────────────────────────────────────────────────────────────

    $('.ta-gallery-wrap').each(function () {
        enableDrag($(this));
    });
});
