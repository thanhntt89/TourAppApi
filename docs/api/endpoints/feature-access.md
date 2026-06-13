# Feature Access

> **Auth:** All require `X-Device-UUID` header 🔒

Toggleable premium features with three unlock modes: **free** / **paid** (flowers) / **achievement** (check-in count). Configured in **WP Admin → ToursApp API → Feature Access**.

---

## Available Features

| Feature | Slug | Description |
|---------|------|-------------|
| Cross-Province Journeys | `cross_province` | Allow user journeys spanning multiple provinces |
| Unlimited Custom Journeys | `unlimited_journeys` | Remove the 5-journey free plan limit |

---

## GET /user/features

List all features with current access status for this device.

### Response

```json
{
  "success": true,
  "data": [
    {
      "feature": "cross_province",
      "label": "Cross-Province Journeys",
      "enabled": true,
      "mode": "achievement",
      "has_access": false,
      "achievement": {
        "required": 10,
        "current": 6,
        "progress": 60
      }
    },
    {
      "feature": "unlimited_journeys",
      "label": "Unlimited Custom Journeys",
      "enabled": true,
      "mode": "paid",
      "has_access": false,
      "cost": 50
    }
  ]
}
```

---

## GET /user/features/{feature}

Single feature status with progress detail.

### Response

Same object as one item from the list above.

---

## POST /user/features/{feature}/unlock

Unlock a paid feature OR verify achievement progress.

### Behavior by mode

| Mode | Behavior |
|------|----------|
| `free` | Always returns `has_access: true` immediately |
| `paid` | Deducts `cost` flowers. Returns `403` if insufficient balance |
| `achievement` | Checks current check-in count. Grants access if threshold met. Returns progress if not |

### Errors

| Code | HTTP | Description |
|------|------|-------------|
| `feature_not_found` | 404 | Unknown feature slug |
| `feature_disabled` | 503 | Feature disabled in admin |
| `insufficient_balance` | 403 | Not enough flowers (paid mode) |
| `achievement_not_met` | 403 | Check-in count below required (achievement mode) |
| `already_unlocked` | 409 | Feature already active for this device |

---

## Unlock Modes

- **`free`** — all users have access automatically
- **`paid`** — costs X flowers (one-time unlock, stored in `wp_ta_unlocked_content` with `content_type='feature'`)
- **`achievement`** — automatically granted when user has checked in at N distinct places
