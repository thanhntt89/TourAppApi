# Locations

> **Auth:** All public

---

## GET /provinces/{province_id}/locations

List all locations in a province.

### Params

| Param | Required | Type | Default | Notes |
|-------|----------|------|---------|-------|
| `province_id` | ✓ | integer | | Province post ID |
| `lang` | | string | `vi` | Content language |
| `sort` | | string | `location_number` | `location_number` \| `name` \| `distance` |
| `lat` | | number | | Required when `sort=distance` |
| `lng` | | number | | Required when `sort=distance` |

### Response fields (compact)

`id`, `number`, `name`, `feature_image`, `latitude`, `longitude`, `total_places`, `sort_order`

When `lat`/`lng` provided: also includes `distance_km`.

> `description` is NOT included in list — use `GET /locations/{id}` for full detail.

### Meta

```json
"meta": { "total": 4 }
```

---

## GET /locations/{id}

Location detail with optional embedded places.

### Params

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `lang` | string | `vi` | Content language |
| `include` | string | | `places` — embeds place list |

### Response fields

All compact fields + `description`, `province` (id, name)

**With `?include=places`** — adds:
```json
"places": [
  {
    "id": 100,
    "name": "Cột cờ Lũng Cú",
    "feature_image": { "url": "...", "width": 800, "height": 600, "alt": "", "caption": "" },
    "latitude": 23.37,
    "longitude": 105.33,
    "is_featured": true,
    "sort_order": 1
  }
]
```

> The embedded places do NOT include `description` — fetch `GET /places/{id}` for full place detail.
