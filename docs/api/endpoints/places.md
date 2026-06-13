# Places

> **Auth:** All public. `GET /places/{id}` optionally accepts `X-Device-UUID` for user context.

---

## GET /places

List places with filters and pagination.

### Params

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `province_id` | integer | | Filter by province |
| `location_id` | integer | | Filter by location |
| `lang` | string | `vi` | Content language |
| `featured` | boolean | | `true` = featured only |
| `search` | string | | Keyword filter on name/info |
| `sort` | string | `sort_order` | `sort_order` \| `name` \| `distance` \| `place_order_number` |
| `lat` | number | | Required when `sort=distance` |
| `lng` | number | | Required when `sort=distance` |
| `page` | integer | 1 | |
| `per_page` | integer | 20 | |

### Response fields (compact)

`id`, `order_number`, `name`, `info`, `feature_image`, `latitude`, `longitude`, `is_featured`, `sort_order`, `sub_places_count`

When `lat`/`lng` provided: also includes `distance_km`.

> `article`, `audio`, `gallery`, `location` are NOT included — use `GET /places/{id}`.

---

## GET /places/{id}

Full place detail with article, audio, paywall state, and optional user context.

### Params

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `lang` | string | `vi` | Content language |
| `include` | string | | `sub_places` — compact sub-places. `sub_items` — sub-places with full sub_items |

### Response fields

`id`, `hierarchical_index` (e.g. `"2.5"`), `order_number`, `name`, `info`, `article`, `feature_image`, `gallery`, `audio` (url, size, duration), `latitude`, `longitude`, `geofence_radius` (meters), `qr_code`, `is_featured`, `show_article_free`, `show_audio_free`, `article_offline`, `audio_offline`, `article_cost`, `checkin_reward`, `sort_order`, `location` (id, number, name), `user_status`

### user_status — optional user context

This is a public endpoint but reads the optional `X-Device-UUID` header. When the header is present:

```json
"user_status": {
  "is_checked_in": false,
  "is_article_unlocked": false,
  "is_audio_unlocked": false
}
```

When the header is absent: `"user_status": null`.

> Always send `X-Device-UUID` so the app can determine paywall state in a single call.

---

## GET /places/nearby

Find places within a GPS radius.

### Params

| Param | Required | Type | Default | Notes |
|-------|----------|------|---------|-------|
| `lat` | ✓ | number | | User latitude |
| `lng` | ✓ | number | | User longitude |
| `radius` | | integer | `1000` | Search radius in meters |
| `province_id` | | integer | | Narrow to a province |
| `limit` | | integer | `10` | Max results |
| `lang` | | string | `vi` | Content language |

### Response fields

`id`, `name`, `feature_image`, `latitude`, `longitude`, `distance_meters`, `geofence_radius`, `is_within_geofence`, `has_audio`, `is_featured`, `sort_order`

---

## GET /places/qr/{code}

Look up a place by its QR code string.

### Response

Returns full place detail (same as `GET /places/{id}` without optional includes).

### Errors

| Code | HTTP | Description |
|------|------|-------------|
| `place_not_found` | 404 | No published place with that QR code |

---

## GET /places/search

Full-text keyword search across place names and info text.

### Params

| Param | Required | Type | Default | Notes |
|-------|----------|------|---------|-------|
| `q` | ✓ | string | | Search keyword |
| `province_id` | | integer | | Narrow to a province |
| `lang` | | string | `vi` | Content language |
| `page` | | integer | 1 | |
| `per_page` | | integer | 20 | |

### Response fields

`id`, `name`, `info`, `feature_image`, `latitude`, `longitude`, `is_featured`, `sort_order`, `match_score`

`match_score`: `1` = matched one field, `2` = matched both name and info text.
