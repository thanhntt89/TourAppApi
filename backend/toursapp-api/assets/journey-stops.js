jQuery(function ($) {
    'use strict';

    if (typeof taJourneyStops === 'undefined') {
        console.error('ToursApp: taJourneyStops not defined — journey-stops.js loaded too early or wp_localize_script failed');
        return;
    }

    var data         = taJourneyStops;
    var provinces    = data.provinces       || [];
    var placeByProv  = data.placeByProvince || {};
    var mainProvId   = parseInt(data.mainProvinceId) || 0;

    var $table   = $('#ta-stops-table');
    var $body    = $('#ta-stops-body');
    var $json    = $('#ta-stops-json');
    var $multi   = $('#ta-multi-province');
    var rowIndex = $body.find('.ta-stop-row').length;

    // ── Helpers ───────────────────────────────────────────────────────────

    function isMulti() { return $multi.is(':checked'); }

    function placesForProvince(provId) {
        if (!provId) {
            // No province filter — return all places flat
            var all = [];
            Object.keys(placeByProv).forEach(function (k) {
                all = all.concat(placeByProv[k]);
            });
            // Sort by label
            all.sort(function (a, b) { return a.label.localeCompare(b.label); });
            return all;
        }
        return placeByProv[provId] || placeByProv[String(provId)] || [];
    }

    function buildProvinceOptions(selectedId) {
        var html = '<option value="">— Province —</option>';
        provinces.forEach(function (p) {
            html += '<option value="' + p.id + '"' + (parseInt(selectedId) === p.id ? ' selected' : '') + '>' + p.label + '</option>';
        });
        return html;
    }

    function buildPlaceOptions(provId, selectedPlaceId) {
        var places = provId ? placesForProvince(provId) : placesForProvince(mainProvId);
        var html   = '<option value="">— Select Place —</option>';
        places.forEach(function (p) {
            html += '<option value="' + p.id + '"' + (parseInt(selectedPlaceId) === p.id ? ' selected' : '') + '>' + p.label + '</option>';
        });
        return html;
    }

    // ── Toggle multi-province mode ────────────────────────────────────────

    function applyMultiMode() {
        var multi = isMulti();
        $table.find('.ta-col-province').toggle(multi);

        if (!multi) {
            // Reset all stop places to main province scope
            $body.find('.ta-stop-row').each(function () {
                var $row        = $(this);
                var currentPlace = $row.find('.ta-stop-place').val();
                $row.find('.ta-stop-province').val('');
                $row.find('.ta-stop-place').html(buildPlaceOptions(0, currentPlace));
            });
        }
    }

    $multi.on('change', applyMultiMode);

    // ── When province changes in a row, reload places ─────────────────────

    $body.on('change', '.ta-stop-province', function () {
        var $row   = $(this).closest('.ta-stop-row');
        var provId = parseInt($(this).val()) || 0;
        $row.find('.ta-stop-place').html(buildPlaceOptions(provId, 0));
    });

    // ── Add new stop row ──────────────────────────────────────────────────

    $('#ta-add-stop').on('click', function () {
        var idx    = rowIndex++;
        var next   = $body.find('.ta-stop-row').length + 1;
        var multi  = isMulti();
        var provStyle = multi ? '' : 'display:none';

        var row = $(
            '<tr class="ta-stop-row" data-index="' + idx + '" draggable="true">' +
            '<td class="ta-drag-handle">☰</td>' +
            '<td class="ta-col-province" style="' + provStyle + '"><select class="ta-stop-province">' + buildProvinceOptions(0) + '</select></td>' +
            '<td><select class="ta-stop-place">' + buildPlaceOptions(0, 0) + '</select></td>' +
            '<td><input type="number" class="ta-stop-day" value="1" min="1" style="width:45px"></td>' +
            '<td><input type="number" class="ta-stop-order" value="' + next + '" min="1" style="width:45px"></td>' +
            '<td><input type="number" class="ta-stop-duration" value="30" min="0" style="width:60px"></td>' +
            '<td><input type="text" class="ta-stop-note-vi" placeholder="Note VI"></td>' +
            '<td><input type="text" class="ta-stop-note-en" placeholder="Note EN"></td>' +
            '<td><button type="button" class="button ta-remove-stop" title="Remove">✕</button></td>' +
            '</tr>'
        );
        $body.append(row);
        row.find('select.ta-stop-province').focus();
    });

    // ── Remove row ────────────────────────────────────────────────────────

    $body.on('click', '.ta-remove-stop', function () {
        $(this).closest('.ta-stop-row').remove();
        syncJson();
    });

    // ── Drag-to-reorder ───────────────────────────────────────────────────

    var dragging = null;

    $body.on('dragstart', '.ta-stop-row', function (e) {
        dragging = this;
        $(this).addClass('ta-dragging');
        e.originalEvent.dataTransfer.effectAllowed = 'move';
    });

    $body.on('dragend', '.ta-stop-row', function () {
        $(this).removeClass('ta-dragging');
        $body.find('.ta-drag-over').removeClass('ta-drag-over');
        dragging = null;
        reNumber();
        syncJson();
    });

    $body.on('dragover', '.ta-stop-row', function (e) {
        e.preventDefault();
        $body.find('.ta-drag-over').removeClass('ta-drag-over');
        if (dragging && dragging !== this) {
            $(this).addClass('ta-drag-over');
            var all  = $body.children('.ta-stop-row').toArray();
            var from = all.indexOf(dragging);
            var to   = all.indexOf(this);
            if (from < to) $(this).after(dragging); else $(this).before(dragging);
        }
    });

    // ── Renumber order column after drag ─────────────────────────────────

    function reNumber() {
        $body.find('.ta-stop-row').each(function (i) {
            $(this).find('.ta-stop-order').val(i + 1);
        });
    }

    // ── Serialize to JSON ─────────────────────────────────────────────────

    function syncJson() {
        var stops = [];
        $body.find('.ta-stop-row').each(function (i) {
            var $row    = $(this);
            var placeId = parseInt($row.find('.ta-stop-place').val()) || 0;
            if (!placeId) return;
            stops.push({
                journey_stop_place:    placeId,
                journey_stop_province: parseInt($row.find('.ta-stop-province').val()) || 0,
                journey_stop_order:    parseInt($row.find('.ta-stop-order').val())   || (i + 1),
                journey_stop_day:      parseInt($row.find('.ta-stop-day').val())     || 1,
                journey_stop_duration: parseInt($row.find('.ta-stop-duration').val())|| 30,
                journey_stop_note_vi:  $row.find('.ta-stop-note-vi').val() || '',
                journey_stop_note_en:  $row.find('.ta-stop-note-en').val() || '',
            });
        });
        $json.val(JSON.stringify(stops));
    }

    $body.on('change input', 'select, input', syncJson);
    $('form#post').on('submit', syncJson);
    syncJson();
});
