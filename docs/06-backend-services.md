[< 05 — Mobile App Architecture](05-mobile-app-architecture.md) | [07 — Maps & Location >](07-maps-and-location.md)

---

# 06 — Backend Services (WordPress Plugin)

> **Stack:** WordPress + PHP 7.4+ · ACF Free · MySQL  
> **Plugin:** `toursapp-api` v1.2.7  
> **Live:** `hagiang.caremycars.com/wp-json/toursapp/v1`

---

## Plugin Architecture

```
toursapp-api (WordPress Plugin)
│
├── Main file: toursapp-api.php
│   ├── Defines constants (TA_VERSION, TA_API_NAMESPACE, TA_LANGUAGES)
│   ├── Registers 8 Custom Post Types
│   ├── Hooks: init, rest_api_init, acf/init, admin_menu
│   └── Loads all includes on plugins_loaded
│
├── Activation: TA_Activator
│   └── Creates 14 custom DB tables via dbDelta()
│
├── Deactivation: flush_rewrite_rules() only (data preserved)
│
└── Deletion: uninstall.php
    ├── DROP TABLE IF EXISTS (all 14 tables)
    ├── delete_option('ta_acf_fields_version')
    └── Delete ACF field groups from DB
```

---

## Core Classes

### TA_API — Route Registry & Filters
- Registers all 17 endpoint classes
- `init_filters()` hooks `rest_endpoints` filter (priority 5, before dispatch)
- **Strict Mode filter:** when OFF, sets `required=false` on all params in our namespace
- **Endpoint disable filter:** replaces callback with 503 response for disabled endpoints

### TA_Auth — Device Authentication
```php
// Check device UUID in header
$uuid = TA_Auth::get_device_uuid($request);  // returns string

// Permission callback for protected routes
'permission_callback' => ['TA_Auth', 'permission_check_device']
// Returns WP_Error 401 if UUID not in wp_ta_devices
```

### TA_Localize — i18n Helpers
```php
// Get localized text field with fallback chain
TA_Localize::get_field_localized($post_id, 'place_name', 'ko');
// → place_name_ko → place_name_en → place_name_vi → ''

// Format image attachment
TA_Localize::format_image($attachment_id_or_array);
// → {url, width, height, alt}

// Format gallery
TA_Localize::format_gallery("101,102,103");
// → [{url, width, height, alt, caption}, ...]

// Get localized audio URL with fallback
TA_Localize::get_audio_localized($post_id, 'place_audio', 'ko');
// → {url, size}
```

### TA_Geo — Geofencing Math
```php
TA_Geo::distance_meters($lat1, $lng1, $lat2, $lng2);  // Haversine
TA_Geo::distance_km($lat1, $lng1, $lat2, $lng2);
TA_Geo::is_within_radius($user_lat, $user_lng, $place_lat, $place_lng, $radius_m);
```

### TA_API_Logger — Async Request Logging
Hooks into WordPress REST API lifecycle:
```
rest_pre_dispatch  → record start time (microtime)
rest_post_dispatch → capture route/method/status/response_ms
shutdown           → INSERT into wp_ta_api_logs
```
Zero impact on response time. Only logs requests in `toursapp/v1` namespace.

---

## ACF Field Groups

8 field groups imported into WP database via `acf_import_field_group()` on plugin activation (or version bump). Visible and editable in **ACF → Field Groups** admin UI.

Re-import triggered by: `get_option('ta_acf_fields_version') !== TA_VERSION`

### Tab Structure (all CPTs)
```
[ General ] [ VI – Tiếng Việt ] [ EN – English ] [ KO – 한국어 ] [ ZH – 中文 ] [ FR – Français ]
```

- **General:** images, GPS, settings, parent relationships, paywall toggles, tracking toggles
- **Language tabs:** name (text), description/content (WYSIWYG), audio URL (text + Browse button)

### Custom Meta Boxes (not ACF)
| Meta Box | CPTs | Description |
|----------|------|-------------|
| Gallery | province, place, sub_item, ta_story | Multi-image picker with drag-reorder |
| Journey Stops | journey | Table UI with single/multi-province mode toggle (see below) |

**Journey Stops — Province Modes:**

- **Single province (default):** checkbox unchecked, Province column hidden, Place dropdown auto-filtered to `journey_province` ACF field value. Stored in `journey_is_multi_province = 0`.
- **Multi-province:** checkbox "🗺 Multi-province journey" checked, Province column visible per row, each stop can choose any province → Place dropdown re-filters. Stored in `journey_is_multi_province = 1`.

Each stop serialized to JSON in `journey_stops` post meta:
```json
[{
  "journey_stop_place": 123,
  "journey_stop_province": 1,
  "journey_stop_order": 1,
  "journey_stop_day": 1,
  "journey_stop_duration": 30,
  "journey_stop_note_vi": "...",
  "journey_stop_note_en": "..."
}]
```

---

## Admin Panel

**WP Admin → ToursApp API**

| Feature | Description |
|---------|-------------|
| Strict Mode toggle | ON/OFF for required param validation |
| Endpoint enable/disable | Per-endpoint checkbox, Enable All / Disable All |
| Export CSV | Full API reference downloadable for mobile team |

Settings stored in `wp_options`:
- `ta_api_strict_mode` (0/1)
- `ta_api_disabled_endpoints` (serialized array of endpoint keys)

---

## Model Layer

Each model is a static class providing DB abstraction:

| Model | Key Methods |
|-------|-------------|
| `TA_Device_Model` | `register_or_update()`, `find_by_uuid()`, `find_by_referral_code()` |
| `TA_Wallet_Model` | `earn()`, `spend()`, `get_balance()`, `get_recent_transactions()` |
| `TA_Checkin_Model` | `create()`, `has_checked_in()`, `is_content_unlocked()`, `unlock_content()`, `get_stats()` |
| `TA_Journey_Model` | `get_user_journeys()`, `create()`, `update()`, `delete()`, `get_progress()` |
| `TA_Engagement_Model` | `record()`, `get_content_stats()`, `get_top_content()`, `is_tracking_enabled()` |
| `TA_Comment_Model` | `create()`, `update()`, `delete()`, `get_comments()`, `count_today()`, `are_comments_allowed()` |
| `TA_Rating_Model` | `upsert()`, `get_summary()`, `get_user_rating()`, `are_ratings_allowed()` |
| `TA_Download_Model` | `start()`, `complete()`, `get_user_downloads()` |

---

## Content Paywall System

Per-item paywall controlled by ACF toggles. Article and audio unlocked independently.

| Post Type | Article Free Field | Article Cost Field | Audio Free Field | Audio Cost Field |
|-----------|-------------------|-------------------|-----------------|-----------------|
| `place` | `place_show_article_free` | `place_article_cost` | `place_show_audio_free` | `place_audio_cost` |
| `sub_place` | — | — | `sub_place_show_audio_free` | `sub_place_audio_cost` |
| `ta_story` | `story_show_article_free` | `story_article_cost` | `story_show_audio_free` | `story_audio_cost` |

All cost fields default to **5 flowers**. All free toggles default to **ON** (free).

**Flow:**
```
Mobile receives: article.is_free = false, article.cost = 5
User taps "Unlock article for 5 flowers"
→ POST /user/unlock {content_type: "article", content_id: 123}
→ Wallet debited 5 flowers
→ wp_ta_unlocked_content row inserted (UNIQUE: device+type+id)
→ Content accessible
```

Unlock recorded in `wp_ta_unlocked_content` with UNIQUE constraint — can't buy twice.

---

## Engagement Tracking System

Two separate tracking systems for different purposes:

### 1. Content Quality Analytics (wp_ta_content_events)
- **Purpose:** improve audio/article content quality
- **Triggered by:** `POST /user/track` from mobile app
- **Data:** scroll_depth, audio completion_pct, read duration
- **Gated by:** `{type}_enable_tracking` ACF toggle per content item
- **Note:** grows fast — plan to archive rows > 90 days

### 2. API Infrastructure Logs (wp_ta_api_logs)
- **Purpose:** identify slow endpoints, optimize server
- **Triggered by:** every API request (automatic, no mobile action needed)
- **Data:** endpoint, response_ms, status_code
- **Async:** written on PHP shutdown, zero latency impact

---

## Offline Sync Architecture

```
Mobile checks:  GET /sync/check?province_id=1&since=2024-01-01T00:00:00
                → {has_updates: true, changes: {places: 3}}

Mobile downloads: GET /sync/package/1?lang=vi
                  → all CPT content serialized for local SQLite

Media download:  GET /sync/media/1?type=all
                 → [{url, checksum, size_bytes}, ...]
                 Mobile downloads each file to local cache

Tracking:        POST /user/downloads/start  → download_id
                 POST /user/downloads/complete → status=completed
```

---

## Analytics & Observability (v1.2.x)

### Analytics Dashboard (WP Admin → Analytics)

7-tab dashboard querying existing tables directly. No new API endpoints needed.

| Tab | Data Source | Key Metrics |
|-----|-------------|-------------|
| Overview | all tables | 12 KPIs + API volume chart 14 days |
| Content | ta_content_events + ta_ratings | Top content by views/read_time/completion, top/bottom rated |
| API | ta_api_logs | Most used endpoints, slowest, error breakdown |
| Users | ta_devices + ta_api_logs | Most active, new registrations by day, user profiles |
| Retention | ta_devices + ta_api_logs | 6 churn segments, weekly cohorts (Day1/7/30 retention), session frequency |
| Feedback | ta_comments + ta_ratings | Comment moderation (approve/reject/delete), rating distributions |
| Economy | ta_wallet + ta_wallet_txn | Transaction types, unlock stats, wallet per user |

**CSV Export:** every tab has "Export This Tab" + "Export All Data" button. Uses `admin_post` hook (not `admin_init`) to avoid header-already-sent issues. UTF-8 BOM for Excel compatibility.

### Churn Segments

| Segment | Threshold | Action |
|---------|-----------|--------|
| 🟢 Active | < 7 days inactive | — |
| 🟡 Dormant | 7–14 days | Monitor |
| 🟠 At Risk | 15–30 days | Re-engage |
| 🔴 Churned | 31–90 days | Recovery campaign |
| ⚫ Lost | > 90 days | Low priority |
| ⚪ Never Used | 0 API calls | Investigate |

Calculated from `MAX(created_at)` in `wp_ta_api_logs` per device — no schema changes needed.

---

## API Log Viewer (WP Admin → API Logs)

All requests logged to `wp_ta_api_logs`. Error responses (4xx/5xx) additionally logged to `wp_ta_error_logs` with:
- `error_code`, `error_message`
- `request_params` (JSON, sensitive fields redacted)
- `response_body` (first 5000 chars)
- `user_agent`

**Log Viewer features:**
- Filter: date range, device UUID, endpoint (partial match), method, status (2xx/4xx/5xx), errors-only
- Error rows: click 🔍 to expand full error details inline
- UUID links to user profile in Analytics
- Clear logs older than 7/30/90/365 days
- Pagination (50 per page)

---

## System Monitor (WP Admin → Monitor)

WP-Cron runs every 5 minutes. Checks last 5 minutes of `wp_ta_api_logs`.

### Alert Thresholds (all configurable)

| Metric | Warning | Critical | Default Values |
|--------|---------|----------|----------------|
| Error rate | configurable | configurable | 5% / 20% |
| Avg response time | configurable | configurable | 500ms / 2000ms |
| Request volume | configurable | configurable | 500 / 2000 per 5min |
| Server errors (5xx) | configurable | configurable | 1 / 5 per 5min |
| Silence duration | configurable | configurable | 30min / 60min |

### Alert Channels
- **Email** — `wp_mail()`, comma-separated recipients
- **Telegram** — Telegram Bot API (`sendMessage`), Bot Token + Chat ID
- **Cooldown** — same alert type suppressed for N minutes (default 30min) via `wp_options`
- **Test button** — send test notification to verify channels before going live

### Cron Schedule
- Hook: `ta_monitor_run`, interval: `every_5_minutes` (registered via `cron_schedules` filter)
- Auto-scheduled when any alert channel is enabled, unscheduled when all disabled

---

## Feature Gate System (v1.2.2)

Controlled via `wp_options` (`ta_feature_{name}_{setting}`):

```
ta_feature_cross_province_enabled    = 0/1
ta_feature_cross_province_mode       = free|paid|achievement
ta_feature_cross_province_cost       = 10  (flowers)
ta_feature_cross_province_achievement= 10  (check-in count)
```

Access check in `TA_Feature_Access::user_has_access($uuid, 'cross_province')`:
- `free` → always true
- `paid` → check `wp_ta_unlocked_content` (content_type='feature', content_id=1)
- `achievement` → count rows in `wp_ta_checkins` >= threshold

Cross-province journeys: if a user creates a journey with stops from multiple provinces, `TA_EP_UserJourneys::check_cross_province_access()` validates access before saving. Returns 403 with unlock instructions if not granted.

---

## Plugin Update System (v1.2.7)

**WP Admin → ToursApp API → Update Plugin** provides safe in-place plugin updates:

1. Admin uploads new zip via drag-drop UI
2. PHP validates MIME type (must be zip)
3. `WP_Filesystem()` + `Plugin_Upgrader::install($tmp, ['overwrite_package' => true])` replaces plugin files
4. Plugin auto-reactivates after update
5. All DB tables, wp_options settings, and ACF field groups preserved

No uninstall/reinstall needed. No data loss. Version bump triggers ACF field re-import and DB schema upgrades via `TA_Activator::upgrade()`.

---

## Data Lifecycle & Archiving System (planned)

### Problem
High-growth tables accumulate data indefinitely with no cleanup mechanism:

| Table | Growth Rate | Est. 1-year Size |
|-------|-------------|-----------------|
| `ta_content_events` | ~100–500 rows/day | 180K–1.8M rows |
| `ta_api_logs` | ~1K–10K rows/day | 365K–3.6M rows |
| `ta_error_logs` | ~100–1K rows/day | 36K–365K rows |

### Solution: 3-layer Data Lifecycle

```
RAW DATA (DB)              AGGREGATED (DB)              ARCHIVE (File)
──────────────             ────────────────             ──────────────
ta_content_events   ──►   ta_content_stats_daily  ──►  ta-events-2026-06.csv.gz
ta_api_logs         ──►   (purged, no aggregate)  ──►  ta-api-2026-06.csv.gz
ta_error_logs       ──►   (purged, no aggregate)  ──►  ta-errors-2026-06.csv.gz

WP-Cron (daily, 2 AM) → Aggregate → Export CSV → Purge raw → Clean old archives
```

### New DB Table: `wp_ta_content_stats_daily`
Aggregated content event data — 100x smaller than raw, analytics still work after purge.

```sql
CREATE TABLE wp_ta_content_stats_daily (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    date           DATE NOT NULL,
    content_type   VARCHAR(20) NOT NULL,
    content_id     INT NOT NULL,
    event_type     VARCHAR(30) NOT NULL,
    event_count    INT DEFAULT 0,
    unique_users   INT DEFAULT 0,
    avg_duration   DECIMAL(8,2) DEFAULT 0,
    avg_scroll     DECIMAL(5,2) DEFAULT 0,
    avg_completion DECIMAL(5,2) DEFAULT 0,
    UNIQUE KEY unique_daily (date, content_type, content_id, event_type),
    INDEX idx_date (date),
    INDEX idx_content (content_type, content_id)
);
```

### Archiver Process (runs daily via WP-Cron)

**Step 1 — Aggregate** (before any deletion):
```sql
INSERT INTO ta_content_stats_daily (date, content_type, content_id, event_type,
    event_count, unique_users, avg_duration, avg_scroll, avg_completion)
SELECT DATE(created_at), content_type, content_id, event_type,
    COUNT(*), COUNT(DISTINCT device_uuid),
    AVG(duration_sec), AVG(scroll_depth), AVG(completion_pct)
FROM ta_content_events
WHERE created_at < DATE_SUB(NOW(), INTERVAL N DAY)
GROUP BY DATE(created_at), content_type, content_id, event_type
ON DUPLICATE KEY UPDATE event_count = event_count + VALUES(event_count), ...
```

**Step 2 — Export** (optional, if auto-export enabled):
- Export raw records to `wp-content/uploads/toursapp-archives/ta-{type}-{YYYY-MM}.csv`
- Compress with gzip if available
- Protected by `.htaccess` — only downloadable via admin AJAX handler

**Step 3 — Purge** raw records beyond retention period from DB.

**Step 4 — Cleanup** archive files older than keep-N-archives limit.

### Configurable Retention (stored in wp_options)

| Setting | Default | Description |
|---------|---------|-------------|
| `ta_archive_content_events_days` | 90 | Days to keep raw content events in DB |
| `ta_archive_api_logs_days` | 30 | Days to keep API request logs in DB |
| `ta_archive_error_logs_days` | 90 | Days to keep error logs in DB |
| `ta_archive_auto_export` | 1 | Export CSV before purging |
| `ta_archive_keep_files` | 12 | Number of monthly archive sets to keep |

### New Files

| File | Purpose |
|------|---------|
| `includes/class-ta-data-archiver.php` | Cron job: aggregate → export → purge → cleanup |
| `includes/class-ta-archive-page.php` | WP Admin page: settings + archive file list + manual trigger |

### Admin UI: WP Admin → Archive (submenu under ToursApp API)

- **Status panel**: rows per table, oldest record date, next scheduled run, total archive size
- **Settings form**: retention days per table, auto-export toggle, keep-N-archives
- **Archive files list**: filename, size, date, download/delete buttons
- **"Archive Now" button**: manual trigger (runs same logic as cron)
- **"Test Run" button**: dry-run showing what would be exported/deleted without actual changes

### Analytics Impact After Purge

Raw data in `ta_content_events` is replaced by aggregated `ta_content_stats_daily`:
- **Lost**: individual device events, scroll depth per-session
- **Preserved**: total counts, unique users, averages per day per content item
- Analytics tabs continue to work using the daily stats table
- `TA_Analytics::top_content()` must be updated to fallback to `ta_content_stats_daily` when raw data is outside retention window

---

## Security Notes

- **No WP authentication for API** — uses device UUID system instead
- **Nonces** on all admin forms (wp_nonce_field / wp_verify_nonce)
- **Input sanitization:** `sanitize_text_field()`, `absint()`, `sanitize_textarea_field()` throughout
- **Photo uploads:** MIME type validated server-side via `finfo` (not just extension), 2MB limit
- **Comment rate limiting:** 10/day per device via DB COUNT query
- **SQL:** all queries via `$wpdb->prepare()` — no raw SQL interpolation
- **Admin capability:** all admin actions check `current_user_can('manage_options')`
