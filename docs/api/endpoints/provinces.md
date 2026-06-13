# Provinces

> **Auth:** All public

---

## GET /provinces

List all active provinces.

### Params

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `lang` | string | `vi` | Content language |

### Response fields (compact)

`id`, `name`, `feature_image`, `latitude`, `longitude`, `detection_radius_km`, `is_active`, `total_locations`, `total_places`, `sort_order`

> `description` and `banner_images` are NOT included — use `GET /provinces/{id}` for full detail.

---

## GET /provinces/detect

Detect which province the user is currently in based on GPS coordinates.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `lat` | ✓ | number | Latitude (-90 to 90) |
| `lng` | ✓ | number | Longitude (-180 to 180) |
| `lang` | | string | Content language |

### Response — detected

```json
{
  "detected": true,
  "province": {
    "id": 1,
    "name": "Hà Giang",
    "distance_km": 2.4,
    ...
  }
}
```

### Response — not detected

When the user is outside all province detection radii, returns all active provinces so the app can show a picker:

```json
{
  "detected": false,
  "province": null,
  "available_provinces": [ { ... }, { ... } ]
}
```

### Notes

- Detection uses `province_detect_radius` (km) + Haversine distance
- Only provinces with `province_is_active = 1` are checked
- If multiple provinces overlap, the nearest one wins

---

## GET /provinces/{id}

Full province detail with description and banner gallery.

### Params

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `lang` | string | `vi` | Content language |
| `include` | string | | Comma-separated: `locations`, `featured_places`, `news` |

### Response fields

All compact fields + `description`, `banner_images`

**With `?include=locations`** — adds:
```json
"locations": [
  { "id": 10, "number": 1, "name": "...", "feature_image": {...}, "latitude": ..., "longitude": ..., "total_places": 5, "sort_order": 1 }
]
```

**With `?include=featured_places`** — adds:
```json
"featured_places": [
  { "id": 100, "name": "...", "feature_image": {...}, "latitude": ..., "longitude": ..., "is_featured": true }
]
```

**With `?include=news`** — adds:
```json
"news": [
  { "id": 50, "title": "...", "summary": "...", "image": {...}, "is_pinned": true, "published_at": "2025-06-01 08:00:00" }
]
```
