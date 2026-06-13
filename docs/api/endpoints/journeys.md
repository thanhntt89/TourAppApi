# Journeys (Preset)

> **Auth:** All public

---

## GET /journeys

List preset journeys for a province.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `province_id` | ✓ | integer | Province post ID |
| `featured` | | boolean | `true` = featured only |
| `lang` | | string | Content language |

---

## GET /journeys/{id}

Journey detail (same fields as list).

### Params

| Param | Type | Notes |
|-------|------|-------|
| `lang` | string | Content language |

---

## Response fields (list and detail)

`id`, `type` (always `"preset"`), `name`, `description`, `feature_image`, `duration_days`, `total_places`, `difficulty`, `is_featured`, `sort_order`, `stops`

### Stop object

```json
{
  "stop_order": 1,
  "day": 1,
  "duration_min": 30,
  "place": { "id": 5, "name": "Cột cờ Lũng Cú", "lat": 23.37, "lng": 105.33 },
  "note": "..."
}
```

---

## Admin Notes

### Single-province stops

Default mode in admin. Place dropdown auto-filters to the journey's `journey_province` field. No Province column shown.

### Multi-province stops

Toggle **"🗺 Multi-province journey"** in admin. Each stop row shows a Province dropdown → Place dropdown filters to that province.

Stored as JSON to `journey_stops` post meta. `journey_is_multi_province` stored as 0/1.
