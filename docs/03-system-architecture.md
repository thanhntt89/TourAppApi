# 03 — Kiến trúc hệ thống / System Architecture

> Kiến trúc tổng thể, data flow patterns, offline strategy, battery optimization, và sync architecture.

---

## High-Level Architecture

```
┌─────────────────────────────┐
│       Flutter Mobile App     │
│  ┌─────────────────────────┐ │
│  │  UI (Screens/Widgets)   │ │
│  ├─────────────────────────┤ │
│  │  Riverpod Providers     │ │
│  ├─────────────────────────┤ │
│  │  Repositories           │ │
│  │  (offline-first logic)  │ │
│  ├─────────────────────────┤ │
│  │  Services               │ │
│  │  - API (REST)           │ │
│  │  - Local SQLite (drift) │ │
│  │  - Audio Cache          │ │
│  │  - GPS / Connectivity   │ │
│  └─────────────────────────┘ │
└──────────────┬──────────────┘
               │ HTTPS REST API
               │ X-Device-UUID header
               ▼
┌─────────────────────────────────────────┐
│         WordPress (PHP 7.4+)             │
│                                         │
│  Plugin: toursapp-api v1.2.0            │
│  Namespace: toursapp/v1                 │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  REST API (40+ endpoints)       │   │
│  │  ├── Public (no auth)           │   │
│  │  └── Device UUID (protected)    │   │
│  ├─────────────────────────────────┤   │
│  │  8 Custom Post Types (CPTs)     │   │
│  │  ACF Free field groups          │   │
│  ├─────────────────────────────────┤   │
│  │  14 Custom MySQL Tables         │   │
│  │  (transactional data)           │   │
│  ├─────────────────────────────────┤   │
│  │  Admin Panel                    │   │
│  │  (endpoint toggle, strict mode) │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

---

## Data Flow Patterns

### Pattern A — Online Content Browsing
```
User opens place →
  Repository checks local SQLite →
    [cache hit] return local data immediately
    [cache miss] → GET /places/{id}?lang=vi →
      WordPress queries ACF post meta →
      returns JSON response →
      Repository upserts to local SQLite →
      UI updates
```

### Pattern B — Offline Mode
```
No internet →
  Repository detects via ConnectivityService →
  Reads from local SQLite (drift) →
  Plays locally cached audio file →
  Queues any user actions to sync_queue →
  When back online: flush sync_queue to API
```

### Pattern C (PRIMARY) — GPS Auto-Detect + Audio
```
App launches →
  GET /provinces → detect province by GPS proximity →
  Store last_province_id →
  
User walks near a place →
  GPS geofence check (Haversine, device-side) →
  [within radius] → auto-play place audio (foreground service) →
  POST /user/track (event_type=audio_play) →
  Optional: prompt for check-in
```

### Pattern C2 — QR Code Backup
```
User scans QR →
  GET /places/qr/{code} →
  Load place detail →
  Play audio
  POST /user/checkin (method=qr, qr_code=xxx) →
  Earn flowers
```

### Pattern D — Content Unlock Flow
```
User views paid article/audio →
  API returns {is_free: false, cost: 5} →
  App shows "Unlock for 5 flowers" prompt →
  [confirm] → POST /user/unlock (content_type=article, content_id=123) →
    [success] → wallet debited, content shown →
  [cancel] → return to browse
```

### Pattern E — Engagement Tracking
```
User reads article →
  App tracks scroll position + read time →
  On exit: POST /user/track
    {content_type: "place", content_id: 5,
     event_type: "article_read",
     duration_sec: 180, scroll_depth: 85}

User plays audio →
  App tracks playback position →
  POST /user/track
    {event_type: "audio_play", completion_pct: 68}
```

### Pattern F — Offline Download
```
User requests offline mode for province →
  POST /user/downloads/start {province_id: 1} → download_id
  GET /sync/package/1?lang=vi → all content JSON → store to SQLite
  GET /sync/media/1?type=all → media manifest
  For each media file: download → cache locally
  POST /user/downloads/complete {download_id, file_count, total_size_mb}
```

---

## Content Hierarchy

```
Province
└── Location (numbered areas, e.g. "Khu vực 1 - Đồng Văn")
    └── Place (individual POI with GPS geofence)
        ├── Sub-Place (section within place, e.g. "Khu A")
        │   └── Sub-Item (item within section)
        │
        ├── Article (multi-lang WYSIWYG content)
        ├── Audio Guide (multi-lang URL, any CDN)
        └── Gallery (multi-image)

Journey (preset itinerary, links to Places via stops)
Story (cultural narrative, many-to-many with Places + Provinces)
News & Alert (province-scoped, typed: news/alert/warning/event)
```

---

## Multilingual Architecture

5 languages: `vi` (default), `en`, `ko`, `zh`, `fr`

**Storage:** separate ACF fields per language suffix
```
place_name_vi, place_name_en, place_name_ko, place_name_zh, place_name_fr
place_audio_vi, place_audio_en, ...
```

**Retrieval fallback chain:**
```
requested lang → en → vi → ''
```

**Admin UI:** language tabs in ACF edit screen
```
[ General ] [ VI – Tiếng Việt ] [ EN – English ] [ KO – 한국어 ] [ ZH – 中文 ] [ FR – Français ]
```

---

## Offline Strategy (3-tier Cache)

| Tier | Trigger | Scope | Storage |
|------|---------|-------|---------|
| **Auto-cache** | User browses any content | Viewed content only | SQLite + file cache |
| **User download** | User taps "Save offline" | Full province package | SQLite + file cache |
| **Online-only** | No prior browse/download | — | API only |

**Offline package structure:**
```
{province_id}/
├── data.json          (all CPT content for this province)
├── manifest.json      (file list with checksums + sizes)
├── images/            (feature images, galleries)
└── audio/             (audio files per language)
```

---

## GPS & Geofencing

**Check-in validation (server-side):**
```php
TA_Geo::is_within_radius(
    $user_lat, $user_lng,
    $place_lat, $place_lng,
    $geofence_radius_meters   // default: 300m, configurable per place
)
```
Uses Haversine formula. If outside radius → `400 TOO_FAR` with distance info.

**Auto-detect province on launch (client-side):**
```
For each province: calculate distance to province center
If within province.detect_radius_km → use this province
```

---

## Reward Economy Flow

```
Check-in at place ─────────────────────── +10 flowers (configurable)
Share on social (1x per platform/day) ─── +2 flowers
Invite friend (referral code) ─────────── +5 flowers (inviter)
Friend redeems code ────────────────────── +3 flowers (invitee)
Unlock article ─────────────────────────── -5 flowers (configurable)
Unlock audio ───────────────────────────── -5 flowers (configurable)

All transactions logged in wp_ta_wallet_txn with balance_after
```

---

## Security Architecture

| Layer | Mechanism |
|-------|-----------|
| API Authentication | Device UUID in `X-Device-UUID` header |
| Admin Authentication | WordPress user roles (`manage_options`) |
| Input Sanitization | `$wpdb->prepare()`, `sanitize_*()` functions |
| File Upload | MIME sniff via `finfo`, max 2MB, type whitelist |
| Rate Limiting | Comment: 10/day per device (DB COUNT + CURDATE()) |
| Photo Security | `media_handle_upload()` via WP core |
| Nonces | All admin form actions (`wp_nonce_field` / `wp_verify_nonce`) |

**Phase 1:** No user registration. Anonymous via device UUID.  
**Future:** Gmail/Apple Sign-In adds `wp_ta_users` table + `user_id` FK on devices. No breaking API changes.

---

## Monitoring & Analytics

### Infrastructure (wp_ta_api_logs)
- Every API request logged async (shutdown hook)
- Useful for: slow endpoint detection, traffic patterns, abuse detection
- Fields: endpoint, method, status_code, response_ms, device_uuid, ip_address

### Content Quality (wp_ta_content_events)
- Mobile sends events: page_view, article_read, audio_play, audio_complete, share
- Useful for: which content gets read/listened to, avg completion rates, popular vs. ignored content
- Gated per content item via `{type}_enable_tracking` ACF toggle

### Admin Queries
```
GET /analytics/content/{id}?content_type=place   → stats for one place
GET /analytics/top-content?metric=completion      → best audio guides by completion rate
GET /analytics/top-content?metric=read_time       → most-read articles
```

---

## Phase Roadmap

| Phase | Status | Key Features |
|-------|--------|-------------|
| **Phase 1** | ✅ In progress | WordPress REST API, 8 CPTs, 40+ endpoints, gamification, offline sync |
| **Phase 2** | Planned | Smart autoplay (GPS auto-trigger audio), AI-assisted content quality suggestions |
| **Phase 3** | Planned | Trip recording & timeline, user photo uploads to journeys |
| **Phase 4** | Planned | Multi-province expansion (Hà Nội, Sa Pa, Huế, ...) |
| **Phase 5** | Planned | Gmail/Apple Sign-In, cross-device sync, AI content (TTS, RAG chatbot) |
