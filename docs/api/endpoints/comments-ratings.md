# Comments & Ratings

`{type}` in all paths = `place` | `story` | `sub_place` | `sub_item`

---

## Comments

### GET /content/{type}/{id}/comments

List approved comments for a content item. Public.

### POST /content/{type}/{id}/comments 🔒

Post a new comment. Max 10 comments per device per day.

#### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `comment_text` | ✓ | string | Max 1000 characters |
| `photo_id` | | integer | Attachment ID from `/user/upload-photo` |

### PUT /content/{type}/{id}/comments/{cid} 🔒

Edit own comment (only the owning device).

#### Params

Same as POST.

### DELETE /content/{type}/{id}/comments/{cid} 🔒

Delete own comment.

---

## Ratings

### GET /content/{type}/{id}/rating

Rating summary and distribution. Public.

#### Response

```json
{
  "success": true,
  "data": {
    "average": 4.3,
    "total": 28,
    "distribution": { "1": 0, "2": 1, "3": 3, "4": 10, "5": 14 },
    "your_rating": 5
  }
}
```

`your_rating` is `null` when `X-Device-UUID` header is absent or device hasn't rated yet.

### POST /content/{type}/{id}/rating 🔒

Submit or update a star rating (1–5). Calling again with a different value replaces the previous rating.

#### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `rating` | ✓ | integer | 1 to 5 |

---

## POST /user/upload-photo 🔒

Upload a photo to attach to a comment.

### Constraints

- Max file size: 2MB
- Accepted: `image/jpeg`, `image/png`, `image/webp`

### Response

```json
{
  "success": true,
  "data": {
    "photo_id": 99,
    "url": "https://..."
  }
}
```

Use `photo_id` in subsequent comment POST/PUT.
