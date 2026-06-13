# 04 — Database Design (WordPress MySQL)

> **Engine:** MySQL (WordPress `$wpdb`)  
> **Prefix:** `wp_ta_` for all custom tables  
> **Created by:** `TA_Activator::activate()` via `dbDelta()`  
> **Removed by:** `uninstall.php` via `DROP TABLE IF EXISTS`  
> **Total custom tables:** 15 (16 after archiving system)

---

## Table Overview

| # | Table | Purpose |
|---|-------|---------|
| 1 | `wp_ta_devices` | Device registrations & preferences |
| 2 | `wp_ta_wallet` | Flower currency balances |
| 3 | `wp_ta_wallet_txn` | Transaction ledger (earn/spend history) |
| 4 | `wp_ta_checkins` | Place check-in records |
| 5 | `wp_ta_visit_history` | Simple visit events (view/audio/article) |
| 6 | `wp_ta_user_journeys` | User-created custom journeys |
| 7 | `wp_ta_user_journey_stops` | Individual stops within user journeys |
| 8 | `wp_ta_unlocked_content` | Purchased article/audio access |
| 9 | `wp_ta_shares` | Social shares and referral redemptions |
| 10 | `wp_ta_content_events` | Rich engagement tracking (scroll, completion) |
| 11 | `wp_ta_comments` | User comments on content |
| 12 | `wp_ta_ratings` | User ratings (1–5 stars) |
| 13 | `wp_ta_api_logs` | API request logs (infra monitoring) |
| 14 | `wp_ta_downloads` | Offline package download tracking |

---

## Content stored in WordPress CPTs (Post Meta)

Content data (names, descriptions, audio URLs, images, GPS coords, etc.) is stored in **WordPress post meta** via ACF fields, not in custom tables. Custom tables are for **transactional/user-generated data** only.

### CPT ↔ Post Meta pattern
```
wp_posts (post_type='place', id=123)
  └── wp_postmeta
        ├── place_name_vi     = "Đồng Văn"
        ├── place_name_en     = "Dong Van"
        ├── place_lat         = "23.274"
        ├── place_lng         = "105.367"
        ├── place_gallery     = "101,102,103"  (comma-separated attachment IDs)
        ├── place_audio_vi    = "https://cdn.example.com/audio-vi.mp3"
        ├── place_show_article_free = "1"
        └── place_article_cost      = "5"
```

---

## Schema: Original 9 Tables

### wp_ta_devices
```sql
CREATE TABLE wp_ta_devices (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL UNIQUE,
    device_name     VARCHAR(255),
    platform        VARCHAR(10) NOT NULL DEFAULT 'android',
    app_version     VARCHAR(20),
    lang            VARCHAR(5) DEFAULT 'vi',
    push_token      VARCHAR(500),
    referral_code   VARCHAR(32) UNIQUE,
    last_province_id INT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_uuid (device_uuid)
);
```

Notes:
- `referral_code` auto-generated on registration: `HG-` + 6 hex chars from MD5
- `lang` = user's preferred language for content
- `last_province_id` = most recently detected province (for GPS auto-detect)

---

### wp_ta_wallet
```sql
CREATE TABLE wp_ta_wallet (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid  VARCHAR(64) NOT NULL UNIQUE,
    balance      INT DEFAULT 0,
    total_earned INT DEFAULT 0,
    total_spent  INT DEFAULT 0,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

One row per device. Created automatically on device registration.

---

### wp_ta_wallet_txn
```sql
CREATE TABLE wp_ta_wallet_txn (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid    VARCHAR(64) NOT NULL,
    type           VARCHAR(30) NOT NULL,
    amount         INT NOT NULL,
    balance_after  INT NOT NULL,
    reference_type VARCHAR(50),
    reference_id   INT,
    note           VARCHAR(255),
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_type (type)
);
```

`type` values: `earn_checkin`, `earn_share_social`, `earn_share_app`, `earn_referral_inviter`, `earn_referral_invitee`, `spend_unlock`

---

### wp_ta_checkins
```sql
CREATE TABLE wp_ta_checkins (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid   VARCHAR(64) NOT NULL,
    place_id      INT NOT NULL,
    method        VARCHAR(5) NOT NULL DEFAULT 'gps',
    latitude      DECIMAL(10,7),
    longitude     DECIMAL(10,7),
    reward_amount INT DEFAULT 0,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_checkin (device_uuid, place_id),
    INDEX idx_device (device_uuid),
    INDEX idx_place (place_id)
);
```

UNIQUE constraint prevents duplicate check-ins per device per place.

---

### wp_ta_visit_history
```sql
CREATE TABLE wp_ta_visit_history (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid VARCHAR(64) NOT NULL,
    place_id    INT NOT NULL,
    visit_type  VARCHAR(20) NOT NULL DEFAULT 'view',
    duration_sec INT,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device_place (device_uuid, place_id),
    INDEX idx_created (created_at)
);
```

`visit_type` values: `view`, `audio_play`, `article_read`

---

### wp_ta_user_journeys
```sql
CREATE TABLE wp_ta_user_journeys (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid      VARCHAR(64) NOT NULL,
    province_id      INT NOT NULL,
    name             VARCHAR(255) NOT NULL,
    description      TEXT,
    source_journey_id INT,
    status           VARCHAR(15) DEFAULT 'planning',
    started_at       DATETIME,
    completed_at     DATETIME,
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_province (province_id)
);
```

`status` values: `planning`, `active`, `completed`

---

### wp_ta_user_journey_stops
```sql
CREATE TABLE wp_ta_user_journey_stops (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    journey_id  BIGINT NOT NULL,
    place_id    INT NOT NULL,
    stop_order  INT NOT NULL,
    day_number  INT DEFAULT 1,
    note        TEXT,
    status      VARCHAR(10) DEFAULT 'planned',
    visited_at  DATETIME,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_journey (journey_id)
);
```

---

### wp_ta_unlocked_content
```sql
CREATE TABLE wp_ta_unlocked_content (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid  VARCHAR(64) NOT NULL,
    content_type VARCHAR(10) NOT NULL,
    content_id   INT NOT NULL,
    cost         INT NOT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_unlock (device_uuid, content_type, content_id)
);
```

`content_type` values: `article`, `audio`

UNIQUE constraint prevents double-purchasing same content.

---

### wp_ta_shares
```sql
CREATE TABLE wp_ta_shares (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid   VARCHAR(64) NOT NULL,
    share_type    VARCHAR(30) NOT NULL,
    platform      VARCHAR(50),
    referral_code VARCHAR(32),
    reward_amount INT DEFAULT 0,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_referral (referral_code)
);
```

`share_type` values: `app_referral`, `social_facebook`, `social_zalo`, `social_instagram`, `social_other`

---

## Schema: New 5 Tables (v1.2.0)

### wp_ta_content_events
Rich engagement tracking — separated from `wp_ta_visit_history` because it supports multiple content types and richer metrics.

```sql
CREATE TABLE wp_ta_content_events (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL,
    content_type    VARCHAR(20) NOT NULL,
    content_id      INT NOT NULL,
    event_type      VARCHAR(30) NOT NULL,
    duration_sec    INT DEFAULT 0,
    scroll_depth    TINYINT DEFAULT 0,
    completion_pct  TINYINT DEFAULT 0,
    extra           VARCHAR(500),
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_content (content_type, content_id),
    INDEX idx_event_type (event_type),
    INDEX idx_created (created_at)
);
```

| Field | Description |
|-------|-------------|
| content_type | `place`, `story`, `sub_place`, `sub_item` |
| event_type | `page_view`, `article_read`, `audio_play`, `audio_complete`, `share` |
| scroll_depth | 0–100 percentage of article scrolled |
| completion_pct | 0–100 percentage of audio listened |
| extra | JSON extra metadata (e.g. share platform) |

**Note:** This table grows fast. Plan to archive rows older than 90 days to a summary table (future WP-Cron job).

---

### wp_ta_comments
```sql
CREATE TABLE wp_ta_comments (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid  VARCHAR(64) NOT NULL,
    content_type VARCHAR(20) NOT NULL,
    content_id   INT NOT NULL,
    comment_text TEXT NOT NULL,
    photo_id     INT DEFAULT 0,
    status       VARCHAR(10) NOT NULL DEFAULT 'approved',
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_content (content_type, content_id),
    INDEX idx_device (device_uuid),
    INDEX idx_status (status),
    INDEX idx_created (created_at)
);
```

| Field | Description |
|-------|-------------|
| photo_id | WordPress attachment ID (0 = no photo) |
| status | `approved` (default), `pending`, `rejected` |

Rate limit: 10 comments per device per day (enforced in PHP via `COUNT WHERE DATE(created_at) = CURDATE()`).

---

### wp_ta_ratings
```sql
CREATE TABLE wp_ta_ratings (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid  VARCHAR(64) NOT NULL,
    content_type VARCHAR(20) NOT NULL,
    content_id   INT NOT NULL,
    rating       TINYINT NOT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_rating (device_uuid, content_type, content_id),
    INDEX idx_content (content_type, content_id)
);
```

UNIQUE constraint: one rating per device per content. Upsert on re-submit.

---

### wp_ta_api_logs
Infrastructure-level request logging. Written asynchronously on PHP `shutdown` hook.

```sql
CREATE TABLE wp_ta_api_logs (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid  VARCHAR(64),
    endpoint     VARCHAR(200) NOT NULL,
    method       VARCHAR(10) NOT NULL,
    status_code  SMALLINT NOT NULL,
    response_ms  INT NOT NULL,
    ip_address   VARCHAR(45),
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_endpoint (endpoint),
    INDEX idx_created (created_at),
    INDEX idx_device (device_uuid)
);
```

Use for: identifying slow endpoints, most-used routes, detecting abuse by IP or UUID.

**Note:** `ip_address` VARCHAR(45) supports IPv6.

---

### wp_ta_downloads
```sql
CREATE TABLE wp_ta_downloads (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid   VARCHAR(64) NOT NULL,
    province_id   INT NOT NULL,
    download_type VARCHAR(20) NOT NULL DEFAULT 'full',
    lang          VARCHAR(5) DEFAULT 'vi',
    file_count    INT DEFAULT 0,
    total_size_mb DECIMAL(8,2) DEFAULT 0,
    status        VARCHAR(15) NOT NULL DEFAULT 'started',
    started_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at  DATETIME,
    INDEX idx_device (device_uuid),
    INDEX idx_province (province_id)
);
```

| Field | Values |
|-------|--------|
| download_type | `full`, `incremental`, `media_only` |
| status | `started`, `completed`, `failed` |

---

## Entity Relationships

```
province (1) ─── (N) ta_location (1) ─── (N) place (1) ─── (N) sub_place (1) ─── (N) sub_item
    │                                         │
    └── (N) journey                           └── (N) ta_story (M:N via ACF post_object)
    └── (N) news_alert
    └── (N) ta_story (M:N via story_related_provinces)

device_uuid ──────────────────────────────────────────────────────────┐
    ├── wp_ta_wallet (1:1)                                             │
    ├── wp_ta_wallet_txn (1:N)                                         │
    ├── wp_ta_checkins (1:N) ──── place_id → place CPT                │
    ├── wp_ta_visit_history (1:N)                                      │
    ├── wp_ta_user_journeys (1:N) ── wp_ta_user_journey_stops (1:N)   │
    ├── wp_ta_unlocked_content (1:N)                                   │
    ├── wp_ta_shares (1:N)                                             │
    ├── wp_ta_content_events (1:N) ── content_type + content_id       │
    ├── wp_ta_comments (1:N)                                           │
    ├── wp_ta_ratings (1:N, UNIQUE per content)                        │
    └── wp_ta_downloads (1:N)                                          │
                                                                       │
wp_ta_api_logs ────────────────── device_uuid (nullable) ─────────────┘
```

---

## Schema: New Table (v1.2.6)

### wp_ta_error_logs
Detailed error capture for 4xx/5xx API responses. Written asynchronously alongside `wp_ta_api_logs`. Only populated for error responses to keep storage lean.

```sql
CREATE TABLE wp_ta_error_logs (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    log_id          BIGINT,               -- FK → wp_ta_api_logs.id
    device_uuid     VARCHAR(64),
    endpoint        VARCHAR(200) NOT NULL,
    method          VARCHAR(10) NOT NULL,
    status_code     SMALLINT NOT NULL,
    error_code      VARCHAR(100),         -- e.g. "DEVICE_NOT_REGISTERED", "TOO_FAR"
    error_message   TEXT,
    request_params  TEXT,                 -- JSON, sensitive fields redacted
    response_body   TEXT,                 -- first 5000 chars of response
    ip_address      VARCHAR(45),
    user_agent      VARCHAR(500),
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_status (status_code),
    INDEX idx_error_code (error_code),
    INDEX idx_created (created_at)
);
```

**Sensitive field redaction in request_params:** `password`, `token`, `secret`, `push_token`, `nonce` → replaced with `[REDACTED]` before storage.

**Usage:** Viewable in WP Admin → API Logs → click 🔍 on any error row to expand full details.

---

## Schema Changes (v1.2.5)

`wp_ta_user_journeys.province_id` changed from `INT NOT NULL` → `INT NULL` to support cross-province journeys. Journey spanning multiple provinces stores `province_id = NULL`. Applied via `TA_Activator::upgrade()` at plugin activation.

---

## Schema: Planned Table (Data Archiving)

### wp_ta_content_stats_daily
Aggregated daily summary of content engagement events. Populated by `TA_Data_Archiver` before raw `ta_content_events` records are purged. Enables historical analytics even after raw data is deleted.

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

**Key properties:**
- UNIQUE constraint prevents duplicate aggregation on re-run
- `ON DUPLICATE KEY UPDATE` allows idempotent aggregation
- Approximately 100x smaller than equivalent raw `ta_content_events` data
- Queried by `TA_Analytics::top_content()` as fallback for historical periods

**Data lifecycle:**

```
ta_content_events (raw, 90 days)
    ↓ daily cron aggregates + exports
ta_content_stats_daily (aggregated, forever)
    ↓ optional manual purge only
(historical data preserved indefinitely)
```

---

## Total Tables: 15 (+ 1 planned)

| # | Table | Purpose | Version |
|---|-------|---------|---------|
| 1–9 | Original tables | Core transactional data | v1.0 |
| 10 | `ta_content_events` | Rich engagement tracking | v1.2.0 |
| 11 | `ta_comments` | User comments | v1.2.0 |
| 12 | `ta_ratings` | User ratings (1–5 stars) | v1.2.0 |
| 13 | `ta_api_logs` | API request infrastructure logs | v1.2.0 |
| 14 | `ta_downloads` | Offline download tracking | v1.2.0 |
| 15 | `ta_error_logs` | Detailed error logs (4xx/5xx only) | v1.2.6 |
| 16 | `ta_content_stats_daily` | Aggregated daily content stats (archiving) | planned |

---

## Future: User Account Tables

When adding Gmail/Apple Sign-In (no breaking changes to existing tables):

```sql
-- Link multiple devices to one account
ALTER TABLE wp_ta_devices ADD COLUMN user_id BIGINT NULL;

CREATE TABLE wp_ta_users (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    email        VARCHAR(255) UNIQUE NOT NULL,
    provider     VARCHAR(10) NOT NULL,   -- google | apple
    provider_id  VARCHAR(255) NOT NULL,
    display_name VARCHAR(255),
    avatar_url   VARCHAR(500),
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

All existing queries continue to work. Cross-device data merged by joining through `device_uuid → user_id`.
