# Stories

> **Auth:** All public

---

## GET /stories

List stories with optional filters.

### Params

| Param | Type | Notes |
|-------|------|-------|
| `province_id` | integer | Filter by province |
| `place_id` | integer | Filter by related place |
| `type` | string | `legend` \| `history` \| `culture` \| `folk` \| `mystery` \| `nature` \| `other` |
| `featured` | boolean | `true` = featured only |
| `lang` | string | Content language |
| `page` | integer | Default 1 |
| `per_page` | integer | Default 20 |

### Response fields (compact)

`id`, `type`, `name`, `summary`, `feature_image`, `is_featured`, `sort_order`, `article` (is_free, cost), `audio_info` (is_free, cost, duration), `allow_comments`, `allow_ratings`, `enable_tracking`

> `content` and `audio` are NOT included — use `GET /stories/{id}`.

---

## GET /stories/{id}

Full story detail.

### Params

| Param | Type | Notes |
|-------|------|-------|
| `lang` | string | Content language |

### Response fields

All compact fields + `content`, `audio` (url, size), `related_places` (id, name, feature_image), `related_provinces` (id, name)

---

## Paywall

Article and audio are controlled independently:

| ACF Field | Default | Effect |
|-----------|---------|--------|
| `story_show_article_free` | ON | Article free to read |
| `story_article_cost` | 5 | Flowers to unlock article |
| `story_show_audio_free` | ON | Audio free to play |
| `story_audio_cost` | 5 | Flowers to unlock audio |
| `story_article_offline` | OFF | Article downloadable offline |
| `story_audio_offline` | OFF | Audio downloadable offline |

**Story audio** — URL text field per language (VI/EN/KO/ZH/FR) with Browse button. Supports any URL: WordPress media library, S3, CDN, or external host. API returns `{url, size}` using language fallback chain.
