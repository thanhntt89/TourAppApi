# Offline Sync

> **Auth:** All public

These endpoints provide the data bundle for offline (SQLite) mode. See [offline-sqlite.md](../guides/offline-sqlite.md) for the full implementation guide.

---

## GET /sync/check

Check whether offline data is stale and needs updating.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `province_id` | ✓ | integer | Province to check |
| `since` | ✓ | string | ISO 8601 timestamp of last successful sync |

### Response

```json
{
  "success": true,
  "data": {
    "has_updates": true,
    "last_modified": "2025-06-14T10:00:00Z",
    "changes": {
      "provinces":  { "updated": 0, "last_modified": null },
      "locations":  { "updated": 0, "last_modified": null },
      "places":     { "updated": 2, "last_modified": "2025-06-14T09:30:00Z" },
      "sub_places": { "updated": 1, "last_modified": "2025-06-14T08:00:00Z" },
      "sub_items":  { "updated": 0, "last_modified": null },
      "journeys":   { "updated": 0, "last_modified": null },
      "news":       { "updated": 3, "last_modified": "2025-06-14T10:00:00Z" }
    },
    "estimated_download_size_mb": 0.4
  }
}
```

---

## GET /sync/package/{province_id}

Full offline data bundle — text content and structure for all types.

### Params

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `lang` | string | `vi` | Content language |
| `since` | string | | ISO 8601 — omit for full sync, provide for incremental (returns only changed records) |
| `include_media_urls` | boolean | `true` | Include `media_manifest` array |

### Response structure

```json
{
  "success": true,
  "data": {
    "province": { "id": 1, "name": "Hà Giang", ... },
    "locations": [ { "id": 10, "location_number": 1, "name": "Đồng Văn", ... } ],
    "places": [
      {
        "id": 100, "place_order_number": 1, "name": "Cột cờ Lũng Cú",
        "information": "...", "article": "...",
        "feature_image": {...}, "gallery": [...],
        "audio": { "url": "...", "duration": 180.5 },
        "latitude": 23.37, "longitude": 105.33,
        "geofence_radius": 300, "qr_code": "LCF001",
        "checkin_reward": 10, "article_cost": 5,
        "show_article_free": true, "show_audio_free": false
      }
    ],
    "sub_places": [
      { "id": 200, "sub_place_index": "A", "name": "Tầng 1",
        "description": "...", "feature_image": {...},
        "audio": { "url": "..." },
        "latitude": 23.37, "longitude": 105.33,
        "place_id": 100 }
    ],
    "sub_items": [
      { "id": 300, "item_index": "A1", "name": "Bức phù điêu",
        "description": "...", "feature_image": {...},
        "gallery": [...], "audio": { "url": "..." },
        "sub_place_id": 200 }
    ],
    "journeys": [...],
    "news": [...],
    "media_manifest": [
      { "type": "image", "url": "https://...", "size_bytes": 102400, "checksum": "abc123" },
      { "type": "audio", "url": "https://...", "size_bytes": 2097152, "checksum": "def456" }
    ],
    "sync_version": 1718000000,
    "total_media_size_mb": 45.2
  }
}
```

### Field naming differences from online API

| Sync field | Online API field | Notes |
|------------|-----------------|-------|
| `location_number` | `number` | `GET /provinces/{id}/locations` |
| `information` | `info` | `GET /places/{id}` |
| `place_order_number` | `order_number` | |
| `place_id` on sub_places | nested in `place` object | Flat FK for SQLite |
| `sub_place_id` on sub_items | nested in `sub_place` object | Flat FK for SQLite |

---

## GET /sync/media/{province_id}

Media file manifest — URLs, sizes, and checksums for all images and audio in a province.

### Params

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `type` | string | `all` | `all` \| `images` \| `audio` |
| `lang` | string | `vi` | Determines which audio language files are listed |
| `since` | string | | ISO 8601 — only files added/changed after this date |

### Response

```json
{
  "success": true,
  "data": {
    "files": [
      { "type": "image", "url": "https://...", "size_bytes": 102400, "checksum": "abc123", "related_type": "place", "related_id": 100 },
      { "type": "audio", "url": "https://...", "size_bytes": 2097152, "checksum": "def456", "related_type": "place", "related_id": 100 }
    ],
    "total_files": 87,
    "total_size_mb": 45.2
  }
}
```
