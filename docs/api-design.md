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

All content endpoints accept `?lang=` parameter:

```
lang = vi (default) | en | ko | zh | fr
```

**Fallback chain:** requested lang → en → vi → ''

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
| GET | `/provinces/{id}` | Public | Province detail |

**Params:** `lang`

---

### 9.3 Locations

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/provinces/{province_id}/locations` | Public | List locations in province |
| GET | `/locations/{id}` | Public | Location detail (`include=places`) |

**Sort options:** `location_number`, `name`, `distance` (requires lat/lng)

---

### 9.4 Places

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/places` | Public | List places with filters |
| GET | `/places/{id}` | Public | Place detail with article/audio/paywall/ratings |
| GET | `/places/nearby` | Public | Places within GPS radius |
| GET | `/places/qr/{code}` | Public | Look up by QR code |
| GET | `/places/search` | Public | Full-text keyword search |

**GET /places params:** `province_id`, `location_id`, `lang`, `featured`, `search`, `sort`, `lat`, `lng`, `page`, `per_page`

**GET /places/nearby params:** `lat`✓, `lng`✓, `province_id`, `radius` (km, default 5), `lang`

---

### 9.5 Sub-Places & Sub-Items

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/sub-places` | Public | List sub-places (`place_id`✓) |
| GET | `/sub-places/{id}` | Public | Sub-place detail with audio |
| GET | `/sub-items` | Public | List sub-items (`sub_place_id`✓) |

---

### 9.6 Journeys (Preset)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/journeys` | Public | List preset journeys (`province_id`✓) |
| GET | `/journeys/{id}` | Public | Journey detail with stops |

**Stop object:**
```json
{
  "stop_order": 1, "day": 1, "duration_min": 30,
  "place": { "id": 5, "name": "...", "lat": ..., "lng": ... },
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

**Story detail response includes:**
```json
{
  "content": "...",
  "audio": { "url": "https://cdn.example.com/story-vi.mp3", "size": 0 },
  "article": { "is_free": true, "cost": 5 },
  "audio_info": { "is_free": true, "cost": 5, "duration": 240.5 },
  "allow_comments": true,
  "allow_ratings": true,
  "enable_tracking": true,
  "related_places": [
    { "id": 5, "name": "Mã Pí Lèng", "feature_image": {...} }
  ],
  "related_provinces": [
    { "id": 1, "name": "Hà Giang" }
  ]
}
```

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

**Params:** `province_id`, `type`, `lang`, `page`, `per_page`

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
| GET | `/sync/check` | Check for updates since timestamp |
| GET | `/sync/package/{province_id}` | Full offline data bundle |
| GET | `/sync/media/{province_id}` | Media file manifest |

---

## 10. API Request Logging

Every request in namespace `toursapp/v1` is logged asynchronously to `wp_ta_api_logs` (PHP shutdown hook — zero response time impact).

**Logged:** endpoint, method, status_code, response_ms, device_uuid, ip_address, created_at

Use for: identifying slowest endpoints, most-used routes, traffic patterns, abuse detection.

---

## 11. Plugin File Structure

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

## 12. Future: User Account Support

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

## 13. Changing API Version

Edit one constant in `toursapp-api.php`:

```php
define('TA_API_NAMESPACE', 'toursapp/v1');  // → toursapp/v2
```

All 40+ endpoints update automatically.
