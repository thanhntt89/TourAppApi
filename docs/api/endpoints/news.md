# News & Alerts

> **Auth:** Public

---

## GET /news

List news/alerts for a province.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `province_id` | ✓ | integer | Province post ID |
| `type` | | string | `news` \| `alert` \| `warning` \| `event` |
| `lang` | | string | Content language |
| `page` | | integer | Default 1 |
| `per_page` | | integer | Default 20 |

### Response fields

`id`, `type`, `title`, `content`, `icon`, `is_pinned`, `start_date`, `end_date`, `created_at`

### Sorting

Pinned items first, then by `created_at` descending.

### Date Filtering

Only items where `start_date ≤ today ≤ end_date` are returned. Items with no `end_date` are always included.

---

## Admin: Auto-fill icon

When the **Type** field changes in the admin editor, the **Icon** field auto-fills:

| Type | Icon |
|------|------|
| `news` | `newspaper` |
| `alert` | `bell` |
| `warning` | `triangle-warning` |
| `event` | `calendar` |
