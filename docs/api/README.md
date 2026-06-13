# ToursApp API — Design Reference

> **Stack:** WordPress REST API · PHP 7.4+ · ACF Free · MySQL  
> **Plugin:** `toursapp-api` v1.2.7  
> **Namespace:** `toursapp/v1`  
> **Base URL:** `https://{domain}/wp-json/toursapp/v1`  
> **Phase 1:** Hà Giang · Multi-province architecture ready

---

## Index

### [ENDPOINTS.md](ENDPOINTS.md) — Master endpoint reference (50 endpoints, source of truth)

### Detailed docs

| File | Coverage |
|------|----------|
| [endpoints/device.md](endpoints/device.md) | Device registration |
| [endpoints/provinces.md](endpoints/provinces.md) | Provinces + GPS detect |
| [endpoints/locations.md](endpoints/locations.md) | Locations |
| [endpoints/places.md](endpoints/places.md) | Places, search, nearby, QR |
| [endpoints/sub-places.md](endpoints/sub-places.md) | Sub-places, sub-items |
| [endpoints/journeys.md](endpoints/journeys.md) | Preset journeys |
| [endpoints/stories.md](endpoints/stories.md) | Stories + paywall |
| [endpoints/news.md](endpoints/news.md) | News & alerts |
| [endpoints/user-actions.md](endpoints/user-actions.md) | Checkin, unlock, wallet, share, referral |
| [endpoints/user-journeys.md](endpoints/user-journeys.md) | Custom user journeys |
| [endpoints/engagement-tracking.md](endpoints/engagement-tracking.md) | Tracking, analytics |
| [endpoints/comments-ratings.md](endpoints/comments-ratings.md) | Comments, ratings, photo upload |
| [endpoints/downloads.md](endpoints/downloads.md) | Offline download logging |
| [endpoints/feature-access.md](endpoints/feature-access.md) | Feature unlock system |
| [endpoints/sync.md](endpoints/sync.md) | Sync package, media manifest |

### Guides

| File | Contents |
|------|----------|
| [guides/offline-sqlite.md](guides/offline-sqlite.md) | SQLite schema, first-install flow, incremental update flow |
| [guides/plugin-structure.md](guides/plugin-structure.md) | File structure, WP Admin menu, API logging, versioning, future account support |

---

## Architecture

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

## Authentication

All protected endpoints require the header:

```
X-Device-UUID: <device-uuid>
```

- Device must be registered via `POST /device/register` first
- UUID stored in `wp_ta_devices` table
- Missing/unknown UUID → `401 DEVICE_NOT_REGISTERED`

---

## Response Format

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

## Admin Settings

**WP Admin → ToursApp API** menu provides:

| Setting | Default | Description |
|---------|---------|-------------|
| **Strict Mode** | OFF | ON = missing required params → 400. OFF = all params optional (recommended during testing) |
| **Endpoint toggles** | All ON | Each of 40+ endpoints individually enable/disable. Disabled → 503 |
| **Export CSV** | — | Download full API reference as Excel-compatible CSV for mobile team |

---

## Localization

### Language Parameter

All content endpoints accept a `?lang=` query parameter:

| Code | Language |
|------|----------|
| `vi` | Vietnamese (default) |
| `en` | English |
| `ko` | Korean |
| `zh` | Chinese |
| `fr` | French |

If omitted or invalid, defaults to `vi`.

### Fallback Chain

When a field has no content in the requested language, the API falls back automatically:

```
requested lang → en → vi → '' (empty string)
```

Example: request `?lang=ko`, content only exists in `vi` → returns `vi` value.

**Text fields** (`name`, `description`, `info`, `article`, etc.) and **audio fields** both follow this chain independently — a place may return Korean text but Vietnamese audio if Korean audio is not uploaded.

### Localized Fields by CPT

Each localized field is stored in ACF with a language suffix (`_vi`, `_en`, `_ko`, `_zh`, `_fr`). The API resolves and returns a single value per field. Fields NOT localized: `id`, `latitude`, `longitude`, `sort_order`, `is_featured`, `feature_image`, `gallery`, numeric/boolean fields.

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

### Flutter Usage

```dart
final lang = ref.watch(contentLanguageProvider); // 'vi' | 'en' | 'ko' | 'zh' | 'fr'
dio.get('/places/$id', queryParameters: {'lang': lang});
```

Store **content language** separately from **UI language** — a Korean-speaking user may navigate the UI in Korean but prefer Vietnamese audio for authenticity.

---

## Custom Post Types (8 CPTs)

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

---

## Content Toggle Matrix

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

## Buckwheat Flowers Economy

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
