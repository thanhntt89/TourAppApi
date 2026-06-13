# ToursApp — Backend API Design Document

> **Stack:** WordPress REST API · PHP 7.4+ · ACF Free · MySQL  
> **Plugin:** `toursapp-api` v1.2.7  
> **Namespace:** `toursapp/v1`  
> **Base URL:** `https://{domain}/wp-json/toursapp/v1`  
> **Phase 1:** Hà Giang · Multi-province architecture ready

---

## 1. Architecture Overview

```
Mobile App (Flutter)
        │
        │  HTTPS REST API
        ▼
WordPress (PHP 7.4+)
├── Custom Post Types (8 CPTs)
├── ACF Free field groups (8 groups, General + 5 language tabs each)
├── MySQL custom tables (14)
└── REST API (toursapp/v1)
        ├── Public endpoints  → no auth required
        └── Device endpoints  → X-Device-UUID header required
```

---

## 2. Authentication

All protected endpoints require the header:

```
X-Device-UUID: <device-uuid>
```

- Device must be registered via `POST /device/register` first
- UUID stored in `wp_ta_devices` table
- Missing/unknown UUID → `401 DEVICE_NOT_REGISTERED`

---

## 3. Response Format

### Success
```json
{
  "success": true,
  "data": { ... },
  "meta": { "total": 10, "page": 1, "per_page": 20 }
}
```

### Error
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": { ... }
  }
}
```

### HTTP Status Codes
| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad request / validation error |
| 401 | Device not registered |
| 403 | Forbidden (feature disabled) |
| 404 | Not found |
| 409 | Conflict (already exists) |
| 429 | Rate limit exceeded |
| 503 | Endpoint disabled via admin |

---

## 4. Admin Settings

**WP Admin → ToursApp API** menu provides:

| Setting | Default | Description |
|---------|---------|-------------|
| **Strict Mode** | OFF | ON = missing required params → 400. OFF = all params optional (recommended during testing) |
| **Endpoint toggles** | All ON | Each of 40+ endpoints individually enable/disable. Disabled → 503 |
| **Export CSV** | — | Download full API reference as Excel-compatible CSV for mobile team |

---

## 5. Localization

### 5.1 Language Parameter

All content endpoints accept a `?lang=` query parameter:

| Code | Language |
|------|----------|
| `vi` | Vietnamese (default) |
| `en` | English |
| `ko` | Korean |
| `zh` | Chinese |
| `fr` | French |

If omitted or invalid, defaults to `vi`.

### 5.2 Fallback Chain

When a field has no content in the requested language, the API falls back automatically:

```
requested lang → en → vi → '' (empty string)
```

Example: request `?lang=ko`, content only exists in `vi` → returns `vi` value.

**Text fields** (`name`, `description`, `info`, `article`, etc.) and **audio fields** both follow this chain independently — a place may return Korean text but Vietnamese audio if Korean audio is not uploaded.

### 5.3 Which Fields Are Localized

Each localized field is stored in ACF with a language suffix (`_vi`, `_en`, `_ko`, `_zh`, `_fr`). The API resolves and returns a single value per field (the correct language or fallback). Fields NOT localized (always language-neutral): `id`, `latitude`, `longitude`, `sort_order`, `is_featured`, `feature_image`, `gallery`, numeric/boolean fields.

**Localized fields by content type:**

| CPT | Localized fields |
|-----|-----------------|
| Province | `name`, `description` |
| Location | `name`, `description` |
| Place | `name`, `info`, `article`, `audio` |
| Sub-Place | `name`, `description`, `audio` |
| Sub-Item | `name`, `description`, `audio` |
| Journey | `name`, `description`, stop `note` |
| News/Alert | `title`, `content` |
| Story | `name`, `summary`, `content`, `audio` |

### 5.4 How to Use in Flutter

Pass `lang` as a query parameter on every content request. Recommended: read from app's content language setting (separate from UI language).

```dart
// Example
final lang = ref.watch(contentLanguageProvider); // 'vi' | 'en' | 'ko' | 'zh' | 'fr'
dio.get('/places/$id', queryParameters: {'lang': lang});
```

The app should store the user's **content language** separately from the **UI language** — a Korean-speaking user may navigate the UI in Korean but prefer Vietnamese audio for authenticity.

---

## 6. Custom Post Types (8 CPTs)

| CPT | Slug | Description |
|-----|------|-------------|
| Province | `province` | Top-level geographic unit |
| Location | `ta_location` | Area within province |
| Place | `place` | Individual POI with GPS geofence |
| Sub-Place | `sub_place` | Section within a place |
| Sub-Item | `sub_item` | Item within a sub-place |
| Journey | `journey` | Preset multi-day itinerary |
| News & Alert | `news_alert` | News, alerts, warnings, events |
| Story | `ta_story` | Cultural/historical narrative (multi-place, multi-province) |

### ACF Field Layout

All 8 CPTs use the same tab structure:
- **General tab** — media, GPS, settings, relationships, paywall toggles, tracking toggles
- **VI – Tiếng Việt tab** — all text/content/audio fields in Vietnamese
- **EN – English tab** — English fields
- **KO – 한국어 tab** — Korean fields
- **ZH – 中文 tab** — Chinese fields
- **FR – Français tab** — French fields

### Gallery Fields
Custom WordPress media picker meta box (not ACF textarea). Allows selecting multiple images from media library with thumbnail preview and drag-to-reorder. Stored as comma-separated attachment IDs. API returns `[{url, width, height, alt, caption}]`.

### Audio Fields
URL text input with Browse button. Supports:
- WordPress media library (click Browse → select)
- Any external URL (S3, CDN, paste link)
- Preview audio player shown inline after selection
API returns `{url, size}`.

### Journey Stops
Custom table UI meta box replacing the raw JSON textarea.

**Default mode (single province):**
- No Province column shown
- Place dropdown auto-filtered to the journey's `journey_province` ACF field
- Suitable for most journeys within one province

**Multi-province mode:**
- Toggle checkbox: "🗺 Multi-province journey"
- Each stop row shows a Province dropdown → Place dropdown filters to that province
- Each stop can reference a different province → supports cross-province tours

Each stop row: Province (optional), Place (filtered dropdown), Day, Order, Duration (min), Note VI, Note EN. Drag ☰ to reorder.

Saved as JSON to `journey_stops` post meta. Each stop includes `journey_stop_province` field.

`journey_is_multi_province` stored in post meta (0/1).

### News & Alerts
When **Type** field changes, **Icon** field auto-fills:
`news→newspaper`, `alert→bell`, `warning→triangle-warning`, `event→calendar`

---

## 7. Content Toggle Matrix

Per-item toggles on each post edit screen:

| Toggle | Default | CPTs |
|--------|---------|------|
| Enable Tracking | ON | place, story, sub_place, sub_item |
| Allow Comments | ON | place, story, sub_place, sub_item |
| Allow Ratings | ON | place, story, sub_place, sub_item |
| Show Article Free | ON | place, story |
| Show Audio Free | ON | place, sub_place, story |
| Article Available Offline | OFF | place, story |
| Audio Available Offline | OFF | place, story |

---

## 8. Buckwheat Flowers Economy

In-app currency for gamification:

| Action | Flowers |
|--------|---------|
| Check-in at place (GPS/QR) | configurable (default: +10) |
| Social share per platform/day | +2 |
| Referral — inviter | +5 |
| Referral — invitee | +3 |
| Unlock article | −`place_article_cost` (default 5) |
| Unlock audio | −`place_audio_cost` (default 5) |
| Unlock story content | −`story_article_cost` / `story_audio_cost` |

---

## 9. API Endpoint Reference (40+ endpoints)

### 9.1 Device

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/device/register` | Public | Register or update device |

**POST /device/register params:**
`device_uuid`✓, `device_name`, `platform` (android/ios), `app_version`, `lang`, `push_token`, `referral_code`

**Response:** `{is_new, wallet_balance, referral_code}`

---

### 9.2 Provinces

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/provinces` | Public | List active provinces |
| GET | `/provinces/detect` | Public | Detect province by GPS coordinates |
| GET | `/provinces/{id}` | Public | Province detail with description and banners |

**Params:** `lang`

**GET /provinces/detect params:** `lat`✓, `lng`✓, `lang`

**GET /provinces/detect response:** `{ detected: bool, province: {..., distance_km} }` — if not detected, returns `available_provinces` array instead.

**GET /provinces/{id} optional includes:** `?include=locations,featured_places,news`

> **List vs Detail:** `GET /provinces` and `GET /provinces/detect` return compact fields only (no `description`). Full `description` and `banner_images` are only returned by `GET /provinces/{id}`.

---

### 9.3 Locations

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/provinces/{province_id}/locations` | Public | List locations in province |
| GET | `/locations/{id}` | Public | Location detail (`include=places`) |

**Sort options:** `location_number`, `name`, `distance` (requires lat/lng)

> **List vs Detail:** `GET /provinces/{province_id}/locations` returns compact fields (no `description`). Full `description` and parent `province` object are only in `GET /locations/{id}`. The `include=places` embed also omits `description` per place — place detail is fetched via `GET /places/{id}`.

---

### 9.4 Places

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/places` | Public | List places with filters |
| GET | `/places/{id}` | Public | Place detail with article/audio/paywall/ratings |
| GET | `/places/nearby` | Public | Places within GPS radius |
| GET | `/places/qr/{code}` | Public | Look up by QR code |
| GET | `/places/search` | Public | Full-text keyword search |

**GET /places params:** `province_id`, `location_id`, `lang`, `featured`, `search`, `sort` (sort_order\|name\|distance\|place_order_number), `lat`, `lng`, `page`, `per_page`

**GET /places/nearby params:** `lat`✓, `lng`✓, `radius` (meters, default 1000), `province_id`, `limit` (default 10), `lang`

**GET /places/search params:** `q`✓, `province_id`, `lang`, `page`, `per_page`

**GET /places/{id} optional includes:** `?include=sub_places` — embeds sub-places (no sub_items). `?include=sub_items` — embeds sub-places with full sub_items.

**List response fields** (`GET /places`):
`id`, `order_number`, `name`, `info`, `feature_image`, `latitude`, `longitude`, `is_featured`, `sort_order`, `sub_places_count`, optional `distance_km` (when lat/lng provided)

**Detail response fields** (`GET /places/{id}`):
`id`, `hierarchical_index` (e.g. `"2.5"`), `order_number`, `name`, `info`, `article`, `feature_image`, `gallery`, `audio` (url, size, duration), `latitude`, `longitude`, `geofence_radius` (meters), `qr_code`, `is_featured`, `show_article_free`, `show_audio_free`, `article_offline`, `audio_offline`, `article_cost`, `checkin_reward`, `sort_order`, `location` (id, number, name), `user_status`

**GET /places/nearby response fields:**
`id`, `name`, `feature_image`, `latitude`, `longitude`, `distance_meters`, `geofence_radius`, `is_within_geofence`, `has_audio`, `is_featured`, `sort_order`

**GET /places/search response fields:**
`id`, `name`, `info`, `feature_image`, `latitude`, `longitude`, `is_featured`, `sort_order`, `match_score` (1 = one field match, 2 = title + name both match)

**Optional user context — `user_status`:**

`GET /places/{id}` is a public endpoint but accepts an optional `X-Device-UUID` header. When provided, the response includes:

```json
"user_status": {
  "is_checked_in": false,
  "is_article_unlocked": false,
  "is_audio_unlocked": false
}
```

When the header is absent, `"user_status": null`. The mobile app should always send `X-Device-UUID` so it can determine paywall state in a single call without a separate request.

> **List vs Detail:** `GET /places` returns compact fields (no article, audio, gallery, location). Full content fields and `user_status` are only in `GET /places/{id}`.

---

### 9.5 Sub-Places & Sub-Items

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/places/{place_id}/sub-places` | Public | List sub-places for a place (compact) |
| GET | `/sub-places/{id}` | Public | Sub-place detail with description, audio, full sub_items |
| GET | `/sub-items/{id}` | Public | Sub-item detail with full gallery and audio |

**Navigation flow:**
```
GET /places                           → returns place id (e.g. 4460)
  ↓
GET /places/4460/sub-places           → returns sub-place list with sub-place ids
  ↓
GET /sub-places/{sub_place_id}        → full detail when user opens a sub-place
```

**List response fields** (`GET /places/{place_id}/sub-places`):
`id`, `sub_place_index`, `name`, `feature_image`, `latitude`, `longitude`, `sort_order`, `sub_items` (compact: id, item_index, name, feature_image, sort_order)

**Detail response fields** (`GET /sub-places/{id}`):
All list fields + `description`, `audio` (url, duration), `place` (id, name), `sub_items` (full: + gallery, audio, description)

**Detail response fields** (`GET /sub-items/{id}`):
`id`, `item_index`, `name`, `description`, `feature_image`, `gallery`, `audio`, `sort_order`, `sub_place` (id, name), `place` (id, name)

> `description` and `audio` are only returned by the detail endpoint to keep the list response lightweight.

---

### 9.6 Journeys (Preset)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/journeys` | Public | List preset journeys (`province_id`✓, `featured`) |
| GET | `/journeys/{id}` | Public | Journey detail |

**Response fields** (list and detail return the same structure):
`id`, `type` (always `"preset"`), `name`, `description`, `feature_image`, `duration_days`, `total_places`, `difficulty`, `is_featured`, `sort_order`, `stops`

**Stop object:**
```json
{
  "stop_order": 1,
  "day": 1,
  "duration_min": 30,
  "place": { "id": 5, "name": "...", "lat": 23.1, "lng": 105.2 },
  "note": "..."
}
```

---

### 9.7 Stories

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/stories` | Public | List stories with filters |
| GET | `/stories/{id}` | Public | Story detail with audio + related places |

**GET /stories params:** `province_id`, `place_id`, `type`, `featured`, `lang`, `page`, `per_page`

**Story types:** `legend`, `history`, `culture`, `folk`, `mystery`, `nature`, `other`

**List response fields** (`GET /stories`):
`id`, `type`, `name`, `summary`, `feature_image`, `is_featured`, `sort_order`, `article` (is_free, cost), `audio_info` (is_free, cost, duration), `allow_comments`, `allow_ratings`, `enable_tracking`

**Detail response fields** (`GET /stories/{id}`):
All list fields + `content`, `audio` (url, size), `related_places` (id, name, feature_image), `related_provinces` (id, name)

> **List vs Detail:** `GET /stories` returns compact fields (no `content`, no `audio`). Full content and relationships are only in `GET /stories/{id}`.

**Story paywall — article and audio controlled independently:**
| ACF Field | Default | Effect |
|-----------|---------|--------|
| `story_show_article_free` | ON | Article free to read |
| `story_article_cost` | 5 | Flowers to unlock article |
| `story_show_audio_free` | ON | Audio free to play |
| `story_audio_cost` | 5 | Flowers to unlock audio |
| `story_article_offline` | OFF | Article downloadable offline |
| `story_audio_offline` | OFF | Audio downloadable offline |

**Story audio** — URL text field per language (VI/EN/KO/ZH/FR) with Browse button. Supports any URL: WordPress media library, S3, CDN, or external host. API returns `{url, size}` using language fallback chain.
```

---

### 9.8 News & Alerts

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/news` | Public | List news/alerts |

**Params:** `province_id`✓, `type` (news\|alert\|warning\|event), `lang`, `page`, `per_page`

**Response fields:**
`id`, `type`, `title`, `content`, `icon`, `is_pinned`, `start_date`, `end_date`, `created_at`

Sorted: pinned items first, then by `created_at` descending. Only items where `start_date ≤ today ≤ end_date` (or no `end_date`) are returned.

---

### 9.9 User Actions 🔒

| Method | Path | Description |
|--------|------|-------------|
| POST | `/user/checkin` | Check in at place (GPS or QR) |
| POST | `/user/unlock` | Unlock paid content with flowers |
| GET | `/user/history` | Checkin history + stats |
| GET | `/user/wallet` | Wallet balance + last 10 transactions |
| POST | `/user/share` | Record social share or referral |
| POST | `/user/referral/redeem` | Redeem invitation referral code |

**POST /user/checkin params:** `place_id`✓, `method` (gps\|qr)✓, `latitude`, `longitude`, `qr_code`

Business rules:
- GPS: validates within `place_geofence_radius` meters (default 300m) using Haversine formula
- One check-in per device per place (UNIQUE constraint)
- Earns `place_checkin_reward` flowers (default 10)

**POST /user/unlock params:** `content_type` (article\|audio)✓, `content_id`✓

Supported: `place`, `sub_place`, `ta_story`

---

### 9.10 User Journeys 🔒

| Method | Path | Description |
|--------|------|-------------|
| GET | `/user/journeys` | List custom journeys |
| POST | `/user/journeys` | Create journey (free plan: max 5) |
| PUT | `/user/journeys/{id}` | Update journey + stops |
| DELETE | `/user/journeys/{id}` | Delete journey |

**Free plan limit:** `POST /user/journeys` returns `403 journey_limit_reached` when device has 5 or more journeys and has not unlocked the `unlimited_journeys` feature. Response includes `limit`, `current`, and `feature` status to guide the Flutter app in showing the upgrade prompt.

---

### 9.11 Engagement Tracking 🔒

| Method | Path | Description |
|--------|------|-------------|
| POST | `/user/track` | Record content interaction event |
| GET | `/analytics/content/{id}` | Engagement stats for one item |
| GET | `/analytics/top-content` | Ranked content by metric |

**POST /user/track params:**
| Param | Type | Notes |
|-------|------|-------|
| content_type | string✓ | place\|story\|sub_place\|sub_item |
| content_id | integer✓ | Post ID |
| event_type | string✓ | page_view\|article_read\|audio_play\|audio_complete\|share |
| duration_sec | integer | Read/listen duration |
| scroll_depth | integer | 0–100% article scrolled |
| completion_pct | integer | 0–100% audio listened |

Only records if `{type}_enable_tracking` is ON for that content item.

**GET /analytics/top-content params:** `content_type`, `metric` (views\|unique\|read_time\|completion\|shares), `order`, `limit`, `since`

---

### 9.12 Comments & Ratings

`{type}` = `place` | `story` | `sub_place` | `sub_item`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/content/{type}/{id}/comments` | Public | List approved comments |
| POST | `/content/{type}/{id}/comments` | 🔒 | Post comment (max 10/day) |
| PUT | `/content/{type}/{id}/comments/{cid}` | 🔒 | Edit own comment |
| DELETE | `/content/{type}/{id}/comments/{cid}` | 🔒 | Delete own comment |
| GET | `/content/{type}/{id}/rating` | Public | Rating summary + distribution |
| POST | `/content/{type}/{id}/rating` | 🔒 | Submit/update rating (1–5 stars) |
| POST | `/user/upload-photo` | 🔒 | Upload comment photo (max 2MB) |

**Comment params:** `comment_text`✓ (max 1000 chars), `photo_id`

**Rating response:**
```json
{
  "average": 4.3,
  "total": 28,
  "distribution": { "1": 0, "2": 1, "3": 3, "4": 10, "5": 14 },
  "your_rating": 5
}
```

---

### 9.13 Offline Downloads 🔒

| Method | Path | Description |
|--------|------|-------------|
| POST | `/user/downloads/start` | Record download start |
| POST | `/user/downloads/complete` | Mark download finished |
| GET | `/user/downloads` | List device download history |

**Start params:** `province_id`✓, `download_type` (full\|incremental\|media_only), `lang`

---

### 9.14 Feature Access 🔒

Toggleable premium features with 3 unlock modes: **free** / **paid** (flowers) / **achievement** (check-in count).

| Method | Path | Description |
|--------|------|-------------|
| GET | `/user/features` | List all features + current user's access status |
| GET | `/user/features/{feature}` | Single feature status + progress if achievement mode |
| POST | `/user/features/{feature}/unlock` | Unlock paid feature OR verify achievement progress |

**Available features:**

| Feature | Slug | Description |
|---------|------|-------------|
| Cross-Province Journeys | `cross_province` | Allow user journeys spanning multiple provinces |
| Unlimited Custom Journeys | `unlimited_journeys` | Remove the 5-journey free plan limit |

**Feature status response:**
```json
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
}
```

**Modes:**
- `free` — all users have access automatically
- `paid` — costs X flowers (one-time unlock, stored in `wp_ta_unlocked_content content_type='feature'`)
- `achievement` — automatically granted when user has checked in at N places

Configured in **WP Admin → ToursApp API → Feature Access** section.

---

### 9.15 Offline Sync (Public)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/sync/check` | Check for updates since a timestamp |
| GET | `/sync/package/{province_id}` | Full offline data bundle (text + structure) |
| GET | `/sync/media/{province_id}` | Media file manifest (images + audio URLs) |

**Params:**

`GET /sync/check`: `province_id`✓, `since`✓ (ISO 8601, e.g. `2025-01-01T00:00:00Z`)

`GET /sync/package/{province_id}`: `lang`, `since` (ISO 8601 — omit for full sync), `include_media_urls` (bool, default true)

`GET /sync/media/{province_id}`: `type` (all\|images\|audio, default all), `lang`, `since` (ISO 8601)

---

## 10. Offline / SQLite Implementation Guide

This section documents the complete flow for Flutter dev to implement province offline mode with local SQLite storage.

### 10.1 Overview

The offline system has two parts:

| What | Endpoint | When |
|------|----------|------|
| **Text & structure** | `GET /sync/package/{province_id}` | First install + incremental update |
| **Media files** | `GET /sync/media/{province_id}` | Download images/audio to device storage |
| **Check if stale** | `GET /sync/check` | App foreground / periodic check |
| **Log download** | `POST /user/downloads/start` + `/complete` | Track history (optional) |

### 10.2 SQLite Schema

```sql
-- Metadata: track what's been synced
CREATE TABLE sync_meta (
  province_id   INTEGER PRIMARY KEY,
  lang          TEXT    NOT NULL,
  synced_at     TEXT    NOT NULL,  -- ISO 8601, used as `since` on next sync
  sync_version  INTEGER NOT NULL
);

-- Core content tables (mirror server structure)
CREATE TABLE provinces (
  id             INTEGER PRIMARY KEY,
  name           TEXT,
  feature_image  TEXT,  -- JSON: {url, width, height}
  latitude       REAL,
  longitude      REAL
);

CREATE TABLE locations (
  id               INTEGER PRIMARY KEY,
  location_number  INTEGER,
  name             TEXT,
  description      TEXT,
  feature_image    TEXT,  -- JSON
  latitude         REAL,
  longitude        REAL
);

CREATE TABLE places (
  id                 INTEGER PRIMARY KEY,
  place_order_number INTEGER,
  name               TEXT,
  information        TEXT,
  article            TEXT,
  feature_image      TEXT,  -- JSON
  gallery            TEXT,  -- JSON array
  audio_url          TEXT,
  audio_duration     REAL,
  latitude           REAL,
  longitude          REAL,
  geofence_radius    INTEGER,
  qr_code            TEXT,
  checkin_reward     INTEGER,
  article_cost       INTEGER,
  show_article_free  INTEGER,  -- 0/1
  show_audio_free    INTEGER   -- 0/1
);

CREATE TABLE sub_places (
  id               INTEGER PRIMARY KEY,
  sub_place_index  TEXT,
  name             TEXT,
  description      TEXT,
  feature_image    TEXT,  -- JSON
  audio_url        TEXT,
  audio_duration   REAL,
  latitude         REAL,
  longitude        REAL,
  place_id         INTEGER REFERENCES places(id)
);

CREATE TABLE sub_items (
  id            INTEGER PRIMARY KEY,
  item_index    TEXT,
  name          TEXT,
  description   TEXT,
  feature_image TEXT,   -- JSON
  gallery       TEXT,   -- JSON array
  audio_url     TEXT,
  sub_place_id  INTEGER REFERENCES sub_places(id)
);

CREATE TABLE journeys (
  id            INTEGER PRIMARY KEY,
  name          TEXT,
  description   TEXT,
  feature_image TEXT,  -- JSON
  duration_days INTEGER,
  difficulty    TEXT,
  stops         TEXT   -- JSON array of stop objects
);

CREATE TABLE news (
  id         INTEGER PRIMARY KEY,
  type       TEXT,
  title      TEXT,
  content    TEXT,
  icon       TEXT,
  is_pinned  INTEGER,
  start_date TEXT,
  end_date   TEXT,
  created_at TEXT
);

-- Media cache: track which files are downloaded locally
CREATE TABLE media_cache (
  url          TEXT PRIMARY KEY,
  local_path   TEXT NOT NULL,
  type         TEXT NOT NULL,   -- 'image' | 'audio'
  related_type TEXT,            -- 'place' | 'sub_place' | 'sub_item'
  related_id   INTEGER,
  size_bytes   INTEGER,
  checksum     TEXT,
  downloaded_at TEXT
);
```

> **Field naming note:** The sync package uses different field names than the online API in a few places:
> - `location_number` (sync) vs `number` (online `/locations` list)
> - `information` (sync) vs `info` (online `/places/{id}`)
> - `place_order_number` (sync) vs `order_number` (online)
> - Sub-places include `place_id` (parent); sub-items include `sub_place_id` (parent) — these are flat arrays, not nested.

### 10.3 First Install Flow

```
1. App launches for first time in a province
   │
   ├── POST /device/register  →  get device_uuid, wallet_balance
   │
   ├── GET /sync/package/{province_id}?lang=vi
   │     Response: {
   │       province: {...},
   │       locations: [...],
   │       places: [...],             ← includes article, audio, gallery
   │       sub_places: [...],         ← flat list with place_id FK
   │       sub_items: [...],          ← flat list with sub_place_id FK
   │       journeys: [...],
   │       news: [...],
   │       media_manifest: [...],     ← list of all media URLs + sizes
   │       sync_version: 1718000000,
   │       total_media_size_mb: 45.2
   │     }
   │
   ├── INSERT all rows into SQLite tables
   │
   ├── INSERT INTO sync_meta (province_id, lang, synced_at, sync_version)
   │     VALUES (1, 'vi', '2025-06-14T08:00:00Z', 1718000000)
   │
   ├── (Optional) POST /user/downloads/start  →  { download_id: 123 }
   │
   ├── Download each file from media_manifest.files[].url
   │     → save to local storage
   │     → INSERT INTO media_cache (url, local_path, type, ...)
   │
   └── POST /user/downloads/complete  { download_id: 123, file_count: 87, total_size_mb: 45.2, status: "completed" }
```

### 10.4 Incremental Update Flow

```
App comes to foreground (or periodic check every N hours):
   │
   ├── GET /sync/check?province_id=1&since=<synced_at from sync_meta>
   │     Response: {
   │       has_updates: true,
   │       last_modified: "2025-06-14T10:00:00Z",
   │       changes: {
   │         provinces:  { updated: 0, last_modified: null },
   │         locations:  { updated: 0, last_modified: null },
   │         places:     { updated: 2, last_modified: "2025-06-14T09:30:00Z" },
   │         sub_places: { updated: 1, last_modified: "..." },
   │         sub_items:  { updated: 0, last_modified: null },
   │         journeys:   { updated: 0, last_modified: null },
   │         news:       { updated: 3, last_modified: "..." }
   │       },
   │       estimated_download_size_mb: 0.4
   │     }
   │
   ├── IF has_updates == false  →  done
   │
   ├── GET /sync/package/{province_id}?lang=vi&since=<synced_at>
   │     Server returns ONLY records modified after `since`
   │     (empty arrays for types with no changes)
   │
   ├── For each returned item: INSERT OR REPLACE INTO <table> ...
   │
   ├── UPDATE sync_meta SET synced_at = last_modified, sync_version = <new>
   │
   └── Download new/changed media files (checksum changed or not in media_cache)
```

### 10.5 `/sync/package` Response Structure

```json
{
  "success": true,
  "data": {
    "province": {
      "id": 1, "name": "Hà Giang", "feature_image": {...}, "latitude": 22.8, "longitude": 104.9
    },
    "locations": [
      { "id": 10, "location_number": 1, "name": "Đồng Văn", "description": "...",
        "feature_image": {...}, "latitude": 23.27, "longitude": 105.36 }
    ],
    "places": [
      { "id": 100, "place_order_number": 1, "name": "Cột cờ Lũng Cú",
        "information": "...", "article": "...",
        "feature_image": {...}, "gallery": [...],
        "audio": { "url": "https://cdn.example.com/audio.mp3", "duration": 180.5 },
        "latitude": 23.37, "longitude": 105.33,
        "geofence_radius": 300, "qr_code": "LCF001",
        "checkin_reward": 10, "article_cost": 5,
        "show_article_free": true, "show_audio_free": false }
    ],
    "sub_places": [
      { "id": 200, "sub_place_index": "A", "name": "Tầng 1",
        "description": "...", "feature_image": {...},
        "audio": { "url": "...", "size": 0 },
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

### 10.6 `/sync/check` Response Structure

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

### 10.7 Using Offline Data (Flutter)

**Resolve local media path:**
```dart
// When rendering a place image:
final url = place.featureImageUrl;
final cached = await db.query('media_cache', where: 'url = ?', whereArgs: [url]);
final path = cached.isNotEmpty ? cached.first['local_path'] : url; // fallback to network
```

**Online vs offline read strategy:**
```dart
// Content endpoint order:
// 1. Try SQLite (instant, no network)
// 2. On miss or if not yet synced: call API
// User status (checkin/unlock) always from API — never cached
```

**What is NOT stored offline:**
- `user_status` (is_checked_in, is_article_unlocked, is_audio_unlocked) — always live from API
- Comments and ratings — always live
- Wallet balance — always live

---

## 11. API Request Logging

Every request in namespace `toursapp/v1` is logged asynchronously to `wp_ta_api_logs` (PHP shutdown hook — zero response time impact).

**Logged:** endpoint, method, status_code, response_ms, device_uuid, ip_address, created_at

Use for: identifying slowest endpoints, most-used routes, traffic patterns, abuse detection.

---

## 12. Plugin File Structure

```
toursapp-api/
├── toursapp-api.php                        Main plugin, CPT registration, hooks, cron
├── uninstall.php                           Full DB cleanup (15 tables) on WP Admin delete
├── assets/
│   ├── gallery-meta.css + .js             Media gallery picker (multi-image, drag-reorder)
│   ├── audio-url.js                       Audio URL input + Browse button + inline preview player
│   ├── news-icon.js                       Auto-fill icon when news type dropdown changes
│   └── journey-stops.css + .js           Journey stops table UI (single/multi-province mode)
└── includes/
    ├── class-ta-api.php                   Route registry + strict mode + endpoint on/off filters
    ├── class-ta-api-logger.php            Async API request logging + detailed error capture
    ├── class-ta-admin.php                 WP Admin: API settings, endpoint toggles, CSV export, plugin updater
    ├── class-ta-auth.php                  Device UUID authentication
    ├── class-ta-activator.php             DB table creation (dbDelta) + schema upgrade routine
    ├── class-ta-fields.php                ACF field group import (8 CPTs, language tabs)
    ├── class-ta-feature-access.php        Feature gate: free/paid/achievement unlock system
    ├── class-ta-gallery-meta.php          Gallery + audio meta boxes + asset enqueue routing
    ├── class-ta-journey-stops-meta.php    Journey stops table UI meta box (province filtering)
    ├── class-ta-geo.php                   Haversine distance / geofence math
    ├── class-ta-localize.php              i18n helpers (get_field_localized, format_image, format_gallery, get_audio_localized)
    ├── class-ta-analytics.php             All analytics query methods (content, API, users, retention, economy)
    ├── class-ta-analytics-page.php        Analytics dashboard: 7 tabs + CSV export via admin-post
    ├── class-ta-log-viewer.php            API Log Viewer: filter, search, error detail expand, clear old logs
    ├── class-ta-monitor.php               System health monitor: threshold checks + email/Telegram alerts + WP-Cron
    ├── class-ta-monitor-page.php          Monitor settings page: thresholds, alert channels, test button
    ├── models/                            (8 model classes — device, wallet, checkin, journey, engagement, comment, rating, download)
    └── endpoints/                         (18 endpoint classes — includes features endpoint)
```

### WP Admin Menu Structure
```
ToursApp API  (main menu)
├── ToursApp API      → API Settings (strict mode, endpoint toggles, export)
├── Analytics         → 7-tab dashboard: Overview / Content / API / Users / Retention / Feedback / Economy
├── API Logs          → Searchable log viewer with error detail expand
├── Monitor           → System health + alert thresholds + email/Telegram config
└── Update Plugin     → Safe plugin update via zip upload (no reinstall needed)
```

---

## 13. Future: User Account Support

Current identity: `device_uuid` (per-device, anonymous). All tables already use `device_uuid` as the primary identity key, making the upgrade path straightforward.

To add Gmail/Apple Sign-In later:

```sql
-- Link devices to accounts
ALTER TABLE wp_ta_devices ADD COLUMN user_id BIGINT NULL;

-- New user accounts table
CREATE TABLE wp_ta_users (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  email        VARCHAR(255) UNIQUE NOT NULL,
  provider     VARCHAR(10) NOT NULL,  -- google | apple
  provider_id  VARCHAR(255) NOT NULL,
  display_name VARCHAR(255),
  avatar_url   VARCHAR(500),
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

Multiple devices linking to one user → wallet, history, comments automatically merged via JOIN on `device_uuid → user_id`. No API changes required.

---

## 14. Changing API Version

Edit one constant in `toursapp-api.php`:

```php
define('TA_API_NAMESPACE', 'toursapp/v1');  // → toursapp/v2
```

All 40+ endpoints update automatically.
