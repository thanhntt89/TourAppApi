# Offline Downloads

> **Auth:** All require `X-Device-UUID` header 🔒

These endpoints track download history. The actual data download uses [`GET /sync/package`](sync.md) and [`GET /sync/media`](sync.md) — these are logging/audit endpoints only.

---

## POST /user/downloads/start

Record the start of a province offline download.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `province_id` | ✓ | integer | Province being downloaded |
| `download_type` | | string | `full` \| `incremental` \| `media_only`. Default `full` |
| `lang` | | string | Content language downloaded |

### Response

```json
{
  "success": true,
  "data": {
    "download_id": 123
  }
}
```

Save `download_id` — pass it to `/user/downloads/complete` when done.

---

## POST /user/downloads/complete

Mark a download as finished.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `download_id` | ✓ | integer | From `/user/downloads/start` |
| `file_count` | | integer | Number of media files downloaded |
| `total_size_mb` | | number | Total size in MB |
| `status` | | string | `completed` \| `partial` \| `failed` |

---

## GET /user/downloads

List all download records for this device.

### Response

```json
{
  "success": true,
  "data": [
    {
      "download_id": 123,
      "province_id": 1,
      "province_name": "Hà Giang",
      "download_type": "full",
      "lang": "vi",
      "file_count": 87,
      "total_size_mb": 45.2,
      "status": "completed",
      "started_at": "2025-06-01T08:00:00Z",
      "completed_at": "2025-06-01T08:03:12Z"
    }
  ]
}
```
