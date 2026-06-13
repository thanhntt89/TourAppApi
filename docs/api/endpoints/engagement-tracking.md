# Engagement Tracking & Analytics

---

## POST /user/track 🔒

Record a content interaction event. Requires `X-Device-UUID`.

Only records if `{type}_enable_tracking` is ON for that content item.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `content_type` | ✓ | string | `place` \| `story` \| `sub_place` \| `sub_item` |
| `content_id` | ✓ | integer | Post ID |
| `event_type` | ✓ | string | `page_view` \| `article_read` \| `audio_play` \| `audio_complete` \| `share` |
| `duration_sec` | | integer | Read/listen duration |
| `scroll_depth` | | integer | 0–100 — percentage of article scrolled |
| `completion_pct` | | integer | 0–100 — percentage of audio listened |

---

## GET /analytics/content/{id}

Engagement stats for a single content item. Public endpoint.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `id` | ✓ | integer | Post ID |
| `content_type` | ✓ | string | `place` \| `story` \| `sub_place` \| `sub_item` |

### Response

```json
{
  "content_id": 100,
  "content_type": "place",
  "total_views": 1240,
  "unique_devices": 380,
  "avg_read_time_sec": 45,
  "avg_audio_completion_pct": 72,
  "total_shares": 18
}
```

---

## GET /analytics/top-content

Ranked content by engagement metric. Public endpoint.

### Params

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `content_type` | string | | Filter by type |
| `metric` | string | `views` | `views` \| `unique` \| `read_time` \| `completion` \| `shares` |
| `order` | string | `DESC` | `ASC` \| `DESC` |
| `limit` | integer | 10 | Max results |
| `since` | string | | ISO 8601 — only count events after this date |
