# Sub-Places & Sub-Items

> **Auth:** All public

---

## Navigation Flow

```
GET /places                           → returns place id (e.g. 4460)
  ↓
GET /places/4460/sub-places           → returns sub-place list with sub-place ids
  ↓
GET /sub-places/{sub_place_id}        → full detail when user opens a sub-place
```

---

## GET /places/{place_id}/sub-places

List all sub-places for a place, ordered by `sort_order`.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `place_id` | ✓ | integer | Parent place post ID |
| `lang` | | string | Content language |

### Response fields (compact)

`id`, `sub_place_index`, `name`, `feature_image`, `latitude`, `longitude`, `sort_order`

Also includes `sub_items` (compact per sub-place): `id`, `item_index`, `name`, `feature_image`, `sort_order`

> `description` and `audio` are NOT included — use `GET /sub-places/{id}`.

---

## GET /sub-places/{id}

Full sub-place detail with description, audio, and complete sub-items.

### Params

| Param | Type | Notes |
|-------|------|-------|
| `lang` | string | Content language |

### Response fields

All compact fields + `description`, `audio` (url, duration), `place` (id, name)

`sub_items` (full per sub-item): `id`, `item_index`, `name`, `description`, `feature_image`, `gallery`, `audio`, `sort_order`

---

## GET /sub-items/{id}

Full sub-item detail (standalone endpoint for deep linking).

### Params

| Param | Type | Notes |
|-------|------|-------|
| `lang` | string | Content language |

### Response fields

`id`, `item_index`, `name`, `description`, `feature_image`, `gallery`, `audio`, `sort_order`, `sub_place` (id, name), `place` (id, name)
