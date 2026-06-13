# Offline / SQLite Implementation Guide

Complete flow for Flutter dev to implement province offline mode with local SQLite storage.

See [sync.md](../endpoints/sync.md) for the sync API endpoint reference.

---

## Overview

| What | Endpoint | When |
|------|----------|------|
| **Text & structure** | `GET /sync/package/{province_id}` | First install + incremental update |
| **Media files** | `GET /sync/media/{province_id}` | Download images/audio to device storage |
| **Check if stale** | `GET /sync/check` | App foreground / periodic check |
| **Log download** | `POST /user/downloads/start` + `/complete` | Track history (optional) |

---

## SQLite Schema

```sql
-- Metadata: track what's been synced
CREATE TABLE sync_meta (
  province_id   INTEGER PRIMARY KEY,
  lang          TEXT    NOT NULL,
  synced_at     TEXT    NOT NULL,  -- ISO 8601, used as `since` on next sync
  sync_version  INTEGER NOT NULL
);

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

-- Track which media files are downloaded locally
CREATE TABLE media_cache (
  url           TEXT PRIMARY KEY,
  local_path    TEXT NOT NULL,
  type          TEXT NOT NULL,   -- 'image' | 'audio'
  related_type  TEXT,            -- 'place' | 'sub_place' | 'sub_item'
  related_id    INTEGER,
  size_bytes    INTEGER,
  checksum      TEXT,
  downloaded_at TEXT
);
```

---

## First Install Flow

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
   ├── Download each file from media_manifest[].url
   │     → save to local storage
   │     → INSERT INTO media_cache (url, local_path, type, ...)
   │
   └── POST /user/downloads/complete  { download_id: 123, file_count: 87, total_size_mb: 45.2, status: "completed" }
```

---

## Incremental Update Flow

```
App comes to foreground (or periodic check every N hours):
   │
   ├── GET /sync/check?province_id=1&since=<synced_at from sync_meta>
   │     Response: { has_updates: true, last_modified: "...", changes: {...} }
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

---

## Using Offline Data (Flutter)

### Resolve local media path

```dart
// When rendering a place image:
final url = place.featureImageUrl;
final cached = await db.query('media_cache', where: 'url = ?', whereArgs: [url]);
final path = cached.isNotEmpty ? cached.first['local_path'] : url; // fallback to network
```

### Online vs offline read strategy

```dart
// Content read order:
// 1. Try SQLite (instant, no network)
// 2. On miss or if not yet synced: call API
// User status (checkin/unlock) always from API — never cached
```

### What is NOT stored offline

| Data | Why |
|------|-----|
| `user_status` (is_checked_in, is_article_unlocked, is_audio_unlocked) | Per-device live state |
| Comments and ratings | Real-time community data |
| Wallet balance | Financial — must be authoritative |
