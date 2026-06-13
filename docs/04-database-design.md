# 04 — Database Design (PostgreSQL + drift)

> Schema PostgreSQL (Supabase) + drift SQLite mirror. Full SQL cho Phase 1 MVP và Phase 3+ tables.

---

[<< 03 System Architecture](03-system-architecture.md) | **04 Database Design** | [05 Mobile App Architecture >>](05-mobile-app-architecture.md)

| # | Tài liệu | Link |
|---|----------|------|
| 00 | Tổng quan | [00-overview.md](00-overview.md) |
| 01 | Vấn đề & Giải pháp | [01-problem-and-solution.md](01-problem-and-solution.md) |
| 02 | Tech Stack | [02-tech-stack.md](02-tech-stack.md) |
| 03 | Kiến trúc hệ thống | [03-system-architecture.md](03-system-architecture.md) |
| 04 | **Database Design (đang xem)** | — |

---

## 1. Entity Relationship Overview

### 1.1 Phase 1 MVP — Entity Map

```
provinces ──────────────── 1:N ──── locations
                                       │
                                       ├── 1:N ──── audio_guides
                                       │
                                       └── N:M ──── routes
                                            │         (through route_stops)
                                            │
provider_categories ── 1:N ── service_providers
                                       │
                                       └── references locations (optional)

articles (standalone)
banners  (standalone)
sync_metadata (local tracking)
```

### 1.2 Phase 3+ — Extended Entity Map

```
profiles ─── 1:N ─── trips
                       │
                       ├── 1:N ──── trip_entries
                       │
                       └── 1:N ──── trip_exports

profiles ─── 1:N ─── favorites ──── references locations/routes/articles
profiles ─── 1:N ─── reviews ────── references locations/service_providers
profiles ─── 1:N ─── user_photos ── references locations

content_embeddings ──── references locations/articles (pgvector, Phase 5)
```

---

## 2. Multilingual Strategy / Chiến lược đa ngôn ngữ

### Approach: Separate Columns

```sql
-- Mỗi field cần dịch có 4 columns:
--   name_vi  (Tiếng Việt — NOT NULL, source language)
--   name_en  (English — nullable)
--   name_ko  (한국어 — nullable)
--   name_zh  (中文 — nullable)

-- Tại sao separate columns thay vì JSONB?
-- 1. Index riêng cho mỗi ngôn ngữ (text search)
-- 2. NOT NULL constraint cho ngôn ngữ gốc (vi)
-- 3. Query đơn giản: SELECT name_vi FROM locations
-- 4. drift code-gen map trực tiếp sang Dart fields
-- 5. Schema rõ ràng, dễ validate

-- App sẽ có helper function:
-- getLocalizedName(location, currentLocale) →
--   locale='ko' → location.nameKo ?? location.nameEn ?? location.nameVi
```

---

## 3. Phase 1 MVP — Full SQL Schema

### 3.1 Extensions (chạy 1 lần trên Supabase)

```sql
-- ============================================================
-- EXTENSIONS
-- ============================================================

-- Geo distance calculations (tìm điểm gần GPS position)
CREATE EXTENSION IF NOT EXISTS cube;
CREATE EXTENSION IF NOT EXISTS earthdistance;

-- Trigram text search (tìm kiếm tên location/service)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Vector embeddings (Phase 5 — cài sẵn, chưa dùng)
-- CREATE EXTENSION IF NOT EXISTS vector;
```

### 3.2 provinces — Tỉnh/Thành phố

```sql
-- ============================================================
-- PROVINCES — Danh sách tỉnh thành
-- Phase 1 MVP: Hà Giang (seed data). Mở rộng dần.
-- ============================================================

CREATE TABLE provinces (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Tên đa ngôn ngữ
  name_vi     TEXT NOT NULL,                -- "Hà Giang"
  name_en     TEXT,                         -- "Ha Giang"
  name_ko     TEXT,                         -- "하장"
  name_zh     TEXT,                         -- "河江"

  -- Mô tả
  description_vi  TEXT,
  description_en  TEXT,
  description_ko  TEXT,
  description_zh  TEXT,

  -- Metadata
  image_url       TEXT,                     -- Banner image
  latitude        DOUBLE PRECISION,         -- Center point
  longitude       DOUBLE PRECISION,
  is_published    BOOLEAN DEFAULT FALSE,
  sort_order      INTEGER DEFAULT 0,

  -- Timestamps
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_provinces_published ON provinces (is_published) WHERE is_published = TRUE;
```

### 3.3 locations — Điểm tham quan

```sql
-- ============================================================
-- LOCATIONS — Điểm tham quan, địa điểm nổi bật
-- Core table: mọi thứ revolve quanh locations.
-- ============================================================

CREATE TABLE locations (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  province_id UUID NOT NULL REFERENCES provinces(id) ON DELETE CASCADE,

  -- Tên đa ngôn ngữ
  name_vi     TEXT NOT NULL,                -- "Dinh thự vua Mèo"
  name_en     TEXT,                         -- "Hmong King Palace"
  name_ko     TEXT,                         -- "흐몽 왕궁"
  name_zh     TEXT,                         -- "苗王府"

  -- Mô tả đa ngôn ngữ
  description_vi  TEXT,
  description_en  TEXT,
  description_ko  TEXT,
  description_zh  TEXT,

  -- Vị trí GPS
  latitude        DOUBLE PRECISION NOT NULL,
  longitude       DOUBLE PRECISION NOT NULL,
  altitude        DOUBLE PRECISION,         -- Độ cao (meters)

  -- Phân loại
  category        TEXT NOT NULL DEFAULT 'attraction',
  -- Giá trị: 'attraction', 'viewpoint', 'village', 'market',
  --          'pass', 'cave', 'waterfall', 'historical', 'natural'
  priority        CHAR(1) DEFAULT 'B',      -- A (must-see), B (recommended), C (optional)

  -- Media
  image_url       TEXT,                     -- Primary image
  images          JSONB DEFAULT '[]',       -- Additional images: ["url1", "url2"]
  thumbnail_url   TEXT,                     -- Thumbnail for lists

  -- Thông tin bổ sung
  address         TEXT,
  opening_hours   TEXT,                     -- "08:00-17:00" hoặc "Cả ngày"
  admission_fee   TEXT,                     -- "20.000 VND" hoặc "Miễn phí"
  visit_duration  INTEGER,                  -- Thời gian tham quan dự kiến (phút)
  best_time       TEXT,                     -- "Sáng sớm" hoặc "Chiều hoàng hôn"
  tips_vi         TEXT,                     -- Tips cho du khách
  tips_en         TEXT,

  -- QR Code
  qr_code_id      TEXT UNIQUE,             -- Mã QR unique tại điểm: "LOC-001"

  -- Thông tin khẩn cấp (cho vùng đèo)
  emergency_info  JSONB DEFAULT '{}',
  -- Ví dụ: {
  --   "nearest_hospital": "Bệnh viện Đồng Văn - 15km",
  --   "police_phone": "02193.856.135",
  --   "signal_quality": "weak",
  --   "nearest_gas": "Cây xăng Sà Phìn - 5km"
  -- }

  -- Status
  has_audio       BOOLEAN DEFAULT FALSE,    -- Có audio guide?
  is_published    BOOLEAN DEFAULT FALSE,
  is_featured     BOOLEAN DEFAULT FALSE,

  -- Timestamps
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Geo index: tìm locations gần GPS position
CREATE INDEX idx_locations_geo
  ON locations USING gist (ll_to_earth(latitude, longitude));

-- Category + published filter
CREATE INDEX idx_locations_category
  ON locations (category, is_published)
  WHERE is_published = TRUE;

-- QR code lookup
CREATE INDEX idx_locations_qr ON locations (qr_code_id)
  WHERE qr_code_id IS NOT NULL;

-- Text search (tên location)
CREATE INDEX idx_locations_name_vi_trgm
  ON locations USING gin (name_vi gin_trgm_ops);
CREATE INDEX idx_locations_name_en_trgm
  ON locations USING gin (name_en gin_trgm_ops);

-- Province filter
CREATE INDEX idx_locations_province ON locations (province_id);

-- Featured locations
CREATE INDEX idx_locations_featured ON locations (is_featured)
  WHERE is_featured = TRUE AND is_published = TRUE;
```

### 3.4 audio_guides — Audio Guide

```sql
-- ============================================================
-- AUDIO_GUIDES — File audio cho mỗi location + ngôn ngữ
-- Mỗi location có thể có nhiều audio (vi, en, ko, zh).
-- ============================================================

CREATE TABLE audio_guides (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  location_id UUID NOT NULL REFERENCES locations(id) ON DELETE CASCADE,

  -- Ngôn ngữ của audio này
  language    CHAR(2) NOT NULL,             -- 'vi', 'en', 'ko', 'zh'

  -- Thông tin audio
  title       TEXT NOT NULL,                -- "Dinh thự vua Mèo — Lịch sử"
  audio_url   TEXT NOT NULL,                -- Supabase Storage URL
  duration    INTEGER NOT NULL,             -- Duration in seconds
  file_size   INTEGER,                      -- File size in bytes

  -- Transcript (text version)
  transcript  TEXT,                         -- Full transcript cho accessibility

  -- Narrator info
  narrator    TEXT,                         -- "Nguyễn Văn A" hoặc "AI-Generated"
  is_ai_generated BOOLEAN DEFAULT FALSE,   -- AI TTS (Phase 2)?

  -- Status
  sort_order  INTEGER DEFAULT 0,           -- Thứ tự phát nếu có nhiều audio
  is_published BOOLEAN DEFAULT FALSE,

  -- Timestamps
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW(),

  -- Unique: mỗi location chỉ có 1 audio chính per ngôn ngữ
  UNIQUE(location_id, language, sort_order)
);

CREATE INDEX idx_audio_location ON audio_guides (location_id);
CREATE INDEX idx_audio_language ON audio_guides (language);
CREATE INDEX idx_audio_published ON audio_guides (is_published)
  WHERE is_published = TRUE;
```

### 3.5 routes — Tuyến đường

```sql
-- ============================================================
-- ROUTES — Tuyến đường du lịch
-- Ví dụ: "Vòng cung đông", "Vòng cung tây", "Hà Giang city tour"
-- ============================================================

CREATE TABLE routes (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  province_id UUID NOT NULL REFERENCES provinces(id) ON DELETE CASCADE,

  -- Tên đa ngôn ngữ
  name_vi     TEXT NOT NULL,                -- "Vòng cung đông"
  name_en     TEXT,                         -- "Eastern Loop"
  name_ko     TEXT,                         -- "동쪽 루프"
  name_zh     TEXT,                         -- "东环线"

  -- Mô tả
  description_vi  TEXT,
  description_en  TEXT,
  description_ko  TEXT,
  description_zh  TEXT,

  -- Thông tin route
  distance_km     DOUBLE PRECISION,         -- Tổng km
  duration_hours  DOUBLE PRECISION,         -- Thời gian dự kiến (giờ)
  difficulty      TEXT DEFAULT 'moderate',   -- 'easy', 'moderate', 'hard', 'extreme'
  elevation_gain  INTEGER,                  -- Tổng lên dốc (meters)

  -- Media
  image_url       TEXT,
  thumbnail_url   TEXT,
  route_polyline  JSONB,                    -- GeoJSON LineString cho route trên map

  -- Ghi chú
  equipment_notes JSONB DEFAULT '{}',
  -- Ví dụ: {
  --   "vi": "Cần xe máy ≥125cc, áo mưa, đồ ấm",
  --   "en": "Need motorbike ≥125cc, raincoat, warm clothes"
  -- }

  best_season     TEXT,                     -- "Tháng 9-11" (mùa lúa chín)
  warnings_vi     TEXT,                     -- "Đèo nguy hiểm, cẩn thận sương mù"
  warnings_en     TEXT,

  -- Status
  is_published    BOOLEAN DEFAULT FALSE,
  is_featured     BOOLEAN DEFAULT FALSE,
  sort_order      INTEGER DEFAULT 0,

  -- Timestamps
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_routes_province ON routes (province_id);
CREATE INDEX idx_routes_published ON routes (is_published)
  WHERE is_published = TRUE;
CREATE INDEX idx_routes_difficulty ON routes (difficulty);
```

### 3.6 route_stops — Điểm dừng trên tuyến

```sql
-- ============================================================
-- ROUTE_STOPS — Junction table: route ↔ location
-- Mỗi route có nhiều stops, mỗi stop là 1 location.
-- ============================================================

CREATE TABLE route_stops (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id    UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
  location_id UUID NOT NULL REFERENCES locations(id) ON DELETE CASCADE,

  -- Thứ tự trên tuyến
  stop_order  INTEGER NOT NULL,             -- 1, 2, 3...

  -- Thông tin điểm dừng
  distance_from_start DOUBLE PRECISION,     -- km từ điểm xuất phát
  estimated_arrival   TEXT,                 -- "~2 giờ từ Hà Giang"
  stay_duration       INTEGER,              -- Thời gian dừng dự kiến (phút)

  -- Ghi chú cho điểm dừng này trên route
  note_vi     TEXT,                         -- "Dừng ăn trưa ở đây"
  note_en     TEXT,

  -- Timestamps
  created_at  TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(route_id, stop_order),
  UNIQUE(route_id, location_id)
);

CREATE INDEX idx_route_stops_route ON route_stops (route_id);
CREATE INDEX idx_route_stops_location ON route_stops (location_id);
```

### 3.7 provider_categories — Danh mục dịch vụ

```sql
-- ============================================================
-- PROVIDER_CATEGORIES — Loại dịch vụ: Homestay, Ăn uống, Sửa xe...
-- ============================================================

CREATE TABLE provider_categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Tên đa ngôn ngữ
  name_vi     TEXT NOT NULL,                -- "Homestay"
  name_en     TEXT,                         -- "Homestay"
  name_ko     TEXT,                         -- "홈스테이"
  name_zh     TEXT,                         -- "民宿"

  -- UI
  icon        TEXT,                         -- Material icon name: "hotel"
  color       TEXT,                         -- Hex color: "#4CAF50"
  sort_order  INTEGER DEFAULT 0,

  is_published BOOLEAN DEFAULT TRUE,

  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### 3.8 service_providers — Nhà cung cấp dịch vụ

```sql
-- ============================================================
-- SERVICE_PROVIDERS — Homestay, quán ăn, tiệm sửa xe, y tế...
-- ============================================================

CREATE TABLE service_providers (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID NOT NULL REFERENCES provider_categories(id),
  province_id UUID NOT NULL REFERENCES provinces(id),

  -- Tên đa ngôn ngữ
  name_vi     TEXT NOT NULL,                -- "Homestay Pả Vi"
  name_en     TEXT,
  name_ko     TEXT,
  name_zh     TEXT,

  -- Mô tả
  description_vi  TEXT,
  description_en  TEXT,
  description_ko  TEXT,
  description_zh  TEXT,

  -- Vị trí
  latitude    DOUBLE PRECISION NOT NULL,
  longitude   DOUBLE PRECISION NOT NULL,
  address     TEXT,

  -- Liên hệ
  phone       TEXT,
  email       TEXT,
  website     TEXT,
  facebook    TEXT,                         -- Facebook page URL

  -- Thông tin
  price_range TEXT,                         -- "$", "$$", "$$$"
  opening_hours TEXT,
  image_url   TEXT,
  images      JSONB DEFAULT '[]',

  -- Metadata bổ sung (linh hoạt)
  metadata    JSONB DEFAULT '{}',
  -- Ví dụ cho homestay: {
  --   "rooms": 5,
  --   "wifi": true,
  --   "hot_water": true,
  --   "parking": true,
  --   "english_spoken": false,
  --   "korean_spoken": false
  -- }
  -- Ví dụ cho sửa xe: {
  --   "services": ["tire_repair", "oil_change", "brake"],
  --   "brands": ["Honda", "Yamaha"]
  -- }

  -- Status
  is_verified     BOOLEAN DEFAULT FALSE,    -- Admin đã xác minh?
  is_published    BOOLEAN DEFAULT FALSE,

  -- Timestamps
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Geo index: tìm services gần
CREATE INDEX idx_services_geo
  ON service_providers USING gist (ll_to_earth(latitude, longitude));

-- Category filter
CREATE INDEX idx_services_category ON service_providers (category_id);

-- Province filter
CREATE INDEX idx_services_province ON service_providers (province_id);

-- Published filter
CREATE INDEX idx_services_published ON service_providers (is_published)
  WHERE is_published = TRUE;

-- Text search
CREATE INDEX idx_services_name_vi_trgm
  ON service_providers USING gin (name_vi gin_trgm_ops);
```

### 3.9 articles — Bài viết du lịch

```sql
-- ============================================================
-- ARTICLES — Bài viết, tips, guides
-- ============================================================

CREATE TABLE articles (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  province_id UUID REFERENCES provinces(id),     -- Nullable: bài viết chung

  -- Tên đa ngôn ngữ
  title_vi    TEXT NOT NULL,
  title_en    TEXT,
  title_ko    TEXT,
  title_zh    TEXT,

  -- Nội dung (Markdown)
  content_vi  TEXT NOT NULL,
  content_en  TEXT,
  content_ko  TEXT,
  content_zh  TEXT,

  -- Tóm tắt (hiển thị trong list)
  summary_vi  TEXT,
  summary_en  TEXT,

  -- Metadata
  category    TEXT DEFAULT 'guide',          -- 'guide', 'tips', 'story', 'news', 'safety'
  tags        TEXT[] DEFAULT '{}',           -- {'ha-giang', 'motorbike', 'food'}
  image_url   TEXT,                          -- Cover image
  author_name TEXT,
  read_time   INTEGER,                       -- Estimated reading time (minutes)

  -- Status
  is_published BOOLEAN DEFAULT FALSE,
  is_featured  BOOLEAN DEFAULT FALSE,
  published_at TIMESTAMPTZ,
  sort_order   INTEGER DEFAULT 0,

  -- Timestamps
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_articles_category ON articles (category);
CREATE INDEX idx_articles_published ON articles (is_published, published_at DESC)
  WHERE is_published = TRUE;
CREATE INDEX idx_articles_tags ON articles USING gin (tags);
CREATE INDEX idx_articles_province ON articles (province_id);
CREATE INDEX idx_articles_title_vi_trgm
  ON articles USING gin (title_vi gin_trgm_ops);
```

### 3.10 banners — Banner quảng cáo / thông báo

```sql
-- ============================================================
-- BANNERS — Banner trên home screen
-- ============================================================

CREATE TABLE banners (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  title_vi    TEXT NOT NULL,
  title_en    TEXT,

  image_url   TEXT NOT NULL,
  link_type   TEXT,                          -- 'location', 'route', 'article', 'url'
  link_id     UUID,                          -- Reference to target entity
  link_url    TEXT,                          -- External URL (if link_type = 'url')

  is_published BOOLEAN DEFAULT FALSE,
  sort_order   INTEGER DEFAULT 0,
  start_date   TIMESTAMPTZ,                 -- Hiển thị từ
  end_date     TIMESTAMPTZ,                 -- Hiển thị đến

  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_banners_active ON banners (is_published, sort_order)
  WHERE is_published = TRUE;
```

### 3.11 sync_metadata — Tracking đồng bộ (local only)

```sql
-- ============================================================
-- SYNC_METADATA — Local table (drift only, không có trên Supabase)
-- Theo dõi thời điểm sync cuối cho mỗi bảng.
-- ============================================================

-- Trên drift (SQLite):
CREATE TABLE sync_metadata (
  table_name   TEXT PRIMARY KEY,
  last_sync_at TEXT,                         -- ISO 8601: "2026-06-08T10:30:00Z"
  sync_version INTEGER DEFAULT 0,
  row_count    INTEGER DEFAULT 0,
  last_error   TEXT                          -- Error message nếu sync fail
);

-- Trên drift (SQLite) — Sync queue cho offline actions:
CREATE TABLE sync_queue (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  action      TEXT NOT NULL,                 -- 'favorite', 'note', 'photo_upload'
  table_name  TEXT NOT NULL,                 -- Target table on Supabase
  data        TEXT NOT NULL,                 -- JSON payload
  status      TEXT DEFAULT 'pending',        -- 'pending', 'syncing', 'synced', 'failed', 'error'
  retry_count INTEGER DEFAULT 0,
  created_at  TEXT DEFAULT (datetime('now')),
  synced_at   TEXT
);

CREATE INDEX idx_sync_queue_status ON sync_queue (status);
```

---

## 4. Phase 3+ Tables — Schema Ready

### 4.1 profiles — User Profile (Phase 3)

```sql
-- ============================================================
-- PROFILES — User profiles (Phase 3 — Auth required)
-- Linked to Supabase Auth via auth.users.id
-- ============================================================

CREATE TABLE profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  display_name    TEXT,
  avatar_url      TEXT,
  bio             TEXT,
  preferred_lang  CHAR(2) DEFAULT 'vi',     -- 'vi', 'en', 'ko', 'zh'

  -- Thống kê
  total_trips     INTEGER DEFAULT 0,
  total_distance  DOUBLE PRECISION DEFAULT 0, -- km
  locations_visited INTEGER DEFAULT 0,

  -- Settings
  notification_enabled BOOLEAN DEFAULT TRUE,
  gps_autoplay_enabled BOOLEAN DEFAULT TRUE,
  dark_mode           BOOLEAN DEFAULT FALSE,

  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### 4.2 trips — Hành trình (Phase 3)

```sql
-- ============================================================
-- TRIPS — Travel journal trips
-- ============================================================

CREATE TABLE trips (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  province_id UUID REFERENCES provinces(id),

  -- Thông tin trip
  title       TEXT NOT NULL,                -- "Hà Giang tháng 10"
  start_date  DATE NOT NULL,
  end_date    DATE,

  -- Tổng kết
  total_distance  DOUBLE PRECISION DEFAULT 0,
  total_locations INTEGER DEFAULT 0,
  total_photos    INTEGER DEFAULT 0,

  -- GPS track (GeoJSON LineString — toàn bộ route)
  gps_track   JSONB,

  -- Status
  status      TEXT DEFAULT 'active',        -- 'active', 'completed', 'archived'
  is_public   BOOLEAN DEFAULT FALSE,        -- Chia sẻ public?

  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trips_user ON trips (user_id);
CREATE INDEX idx_trips_status ON trips (user_id, status);
```

### 4.3 trip_entries — Entries trong hành trình (Phase 3)

```sql
-- ============================================================
-- TRIP_ENTRIES — Mỗi mục trong timeline hành trình
-- Types: checkin, photo, note, audio, rest, meal
-- ============================================================

CREATE TABLE trip_entries (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id     UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  location_id UUID REFERENCES locations(id),   -- Nullable: note không cần location

  -- Loại entry
  entry_type  TEXT NOT NULL,                 -- 'checkin', 'photo', 'note', 'audio', 'rest', 'meal'

  -- Vị trí
  latitude    DOUBLE PRECISION,
  longitude   DOUBLE PRECISION,

  -- Nội dung
  title       TEXT,
  note        TEXT,                          -- User ghi chú
  photo_url   TEXT,                          -- Photo (if type = 'photo')
  audio_guide_id UUID REFERENCES audio_guides(id), -- Audio played (if type = 'audio')

  -- Metadata
  metadata    JSONB DEFAULT '{}',
  -- Ví dụ photo: {"width": 1920, "height": 1080, "filter": "vivid"}
  -- Ví dụ meal: {"restaurant": "Quán Phở Lý", "cost": 50000, "currency": "VND"}

  -- Time
  recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trip_entries_trip ON trip_entries (trip_id, recorded_at);
CREATE INDEX idx_trip_entries_type ON trip_entries (entry_type);
CREATE INDEX idx_trip_entries_location ON trip_entries (location_id);
```

### 4.4 trip_exports — Xuất hành trình (Phase 3)

```sql
-- ============================================================
-- TRIP_EXPORTS — Exported travel books (PDF, image)
-- ============================================================

CREATE TABLE trip_exports (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id     UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES profiles(id),

  format      TEXT NOT NULL,                 -- 'pdf', 'image', 'json'
  file_url    TEXT NOT NULL,                 -- Supabase Storage URL
  file_size   INTEGER,
  page_count  INTEGER,

  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trip_exports_trip ON trip_exports (trip_id);
```

### 4.5 favorites — Yêu thích (Phase 3)

```sql
-- ============================================================
-- FAVORITES — User favorites (locations, routes, articles)
-- ============================================================

CREATE TABLE favorites (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  target_type TEXT NOT NULL,                 -- 'location', 'route', 'article'
  target_id   UUID NOT NULL,                -- ID of the target entity

  created_at  TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, target_type, target_id)
);

CREATE INDEX idx_favorites_user ON favorites (user_id);
CREATE INDEX idx_favorites_target ON favorites (target_type, target_id);
```

### 4.6 reviews — Đánh giá (Phase 3)

```sql
-- ============================================================
-- REVIEWS — User reviews for locations and services
-- ============================================================

CREATE TABLE reviews (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  target_type TEXT NOT NULL,                 -- 'location', 'service_provider'
  target_id   UUID NOT NULL,

  rating      SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment     TEXT,
  language    CHAR(2) DEFAULT 'vi',

  -- Moderation
  is_approved BOOLEAN DEFAULT FALSE,
  is_flagged  BOOLEAN DEFAULT FALSE,

  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, target_type, target_id)   -- 1 review per user per target
);

CREATE INDEX idx_reviews_target ON reviews (target_type, target_id);
CREATE INDEX idx_reviews_user ON reviews (user_id);
CREATE INDEX idx_reviews_approved ON reviews (is_approved)
  WHERE is_approved = TRUE;
```

### 4.7 user_photos — Ảnh người dùng (Phase 3)

```sql
-- ============================================================
-- USER_PHOTOS — Photos uploaded by users
-- ============================================================

CREATE TABLE user_photos (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  location_id UUID REFERENCES locations(id),
  trip_id     UUID REFERENCES trips(id),

  photo_url   TEXT NOT NULL,
  thumbnail_url TEXT,
  caption     TEXT,

  latitude    DOUBLE PRECISION,
  longitude   DOUBLE PRECISION,
  taken_at    TIMESTAMPTZ,

  is_public   BOOLEAN DEFAULT TRUE,

  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_user_photos_user ON user_photos (user_id);
CREATE INDEX idx_user_photos_location ON user_photos (location_id);
CREATE INDEX idx_user_photos_trip ON user_photos (trip_id);
```

### 4.8 content_embeddings — Vector Embeddings (Phase 5)

```sql
-- ============================================================
-- CONTENT_EMBEDDINGS — pgvector embeddings cho RAG chatbot
-- Phase 5: AI Chatbot sử dụng embeddings để tìm context
-- ============================================================

-- Cần enable extension trước:
-- CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE content_embeddings (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  source_type TEXT NOT NULL,                 -- 'location', 'article', 'audio_transcript'
  source_id   UUID NOT NULL,
  language    CHAR(2) NOT NULL,              -- 'vi', 'en', 'ko', 'zh'

  content     TEXT NOT NULL,                 -- Original text chunk
  embedding   vector(1536),                  -- OpenAI text-embedding-3-small

  metadata    JSONB DEFAULT '{}',

  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- HNSW index cho fast similarity search
CREATE INDEX idx_embeddings_vector
  ON content_embeddings USING hnsw (embedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

CREATE INDEX idx_embeddings_source
  ON content_embeddings (source_type, source_id);
CREATE INDEX idx_embeddings_language
  ON content_embeddings (language);
```

---

## 5. Row-Level Security (RLS) Policies

### 5.1 Phase 1 — Anonymous Read-Only

```sql
-- ============================================================
-- RLS POLICIES — Phase 1: anon can only read published content
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE provinces ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE audio_guides ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE route_stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE provider_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_providers ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;

-- === PROVINCES ===
CREATE POLICY "Public can read published provinces"
  ON provinces FOR SELECT
  TO anon
  USING (is_published = TRUE);

-- === LOCATIONS ===
CREATE POLICY "Public can read published locations"
  ON locations FOR SELECT
  TO anon
  USING (is_published = TRUE);

-- === AUDIO_GUIDES ===
CREATE POLICY "Public can read published audio guides"
  ON audio_guides FOR SELECT
  TO anon
  USING (is_published = TRUE);

-- === ROUTES ===
CREATE POLICY "Public can read published routes"
  ON routes FOR SELECT
  TO anon
  USING (is_published = TRUE);

-- === ROUTE_STOPS ===
CREATE POLICY "Public can read route stops of published routes"
  ON route_stops FOR SELECT
  TO anon
  USING (
    EXISTS (
      SELECT 1 FROM routes
      WHERE routes.id = route_stops.route_id
      AND routes.is_published = TRUE
    )
  );

-- === PROVIDER_CATEGORIES ===
CREATE POLICY "Public can read published categories"
  ON provider_categories FOR SELECT
  TO anon
  USING (is_published = TRUE);

-- === SERVICE_PROVIDERS ===
CREATE POLICY "Public can read published services"
  ON service_providers FOR SELECT
  TO anon
  USING (is_published = TRUE);

-- === ARTICLES ===
CREATE POLICY "Public can read published articles"
  ON articles FOR SELECT
  TO anon
  USING (is_published = TRUE);

-- === BANNERS ===
CREATE POLICY "Public can read active banners"
  ON banners FOR SELECT
  TO anon
  USING (
    is_published = TRUE
    AND (start_date IS NULL OR start_date <= NOW())
    AND (end_date IS NULL OR end_date >= NOW())
  );
```

### 5.2 Service Role (Admin Panel)

```sql
-- Service role bypasses RLS by default in Supabase.
-- Admin panel uses service_role key (server-side only).
-- No additional policies needed for admin CRUD.
```

---

## 6. Useful Database Functions

```sql
-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================

-- Tìm locations gần GPS position (Phase 1)
CREATE OR REPLACE FUNCTION nearby_locations(
  user_lat DOUBLE PRECISION,
  user_lng DOUBLE PRECISION,
  radius_meters DOUBLE PRECISION DEFAULT 5000,
  max_results INTEGER DEFAULT 20
)
RETURNS TABLE (
  id UUID,
  name_vi TEXT,
  name_en TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  category TEXT,
  priority CHAR(1),
  has_audio BOOLEAN,
  distance_meters DOUBLE PRECISION
)
LANGUAGE SQL STABLE
AS $$
  SELECT
    l.id, l.name_vi, l.name_en, l.latitude, l.longitude,
    l.category, l.priority, l.has_audio,
    earth_distance(
      ll_to_earth(user_lat, user_lng),
      ll_to_earth(l.latitude, l.longitude)
    ) AS distance_meters
  FROM locations l
  WHERE l.is_published = TRUE
    AND earth_distance(
      ll_to_earth(user_lat, user_lng),
      ll_to_earth(l.latitude, l.longitude)
    ) < radius_meters
  ORDER BY distance_meters
  LIMIT max_results;
$$;

-- Tìm service providers gần (Phase 1)
CREATE OR REPLACE FUNCTION nearby_services(
  user_lat DOUBLE PRECISION,
  user_lng DOUBLE PRECISION,
  radius_meters DOUBLE PRECISION DEFAULT 10000,
  category_filter UUID DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  name_vi TEXT,
  category_name TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  phone TEXT,
  distance_meters DOUBLE PRECISION
)
LANGUAGE SQL STABLE
AS $$
  SELECT
    sp.id, sp.name_vi, pc.name_vi AS category_name,
    sp.latitude, sp.longitude, sp.phone,
    earth_distance(
      ll_to_earth(user_lat, user_lng),
      ll_to_earth(sp.latitude, sp.longitude)
    ) AS distance_meters
  FROM service_providers sp
  JOIN provider_categories pc ON pc.id = sp.category_id
  WHERE sp.is_published = TRUE
    AND (category_filter IS NULL OR sp.category_id = category_filter)
    AND earth_distance(
      ll_to_earth(user_lat, user_lng),
      ll_to_earth(sp.latitude, sp.longitude)
    ) < radius_meters
  ORDER BY distance_meters;
$$;

-- Auto-update updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to all tables
CREATE TRIGGER trg_provinces_updated_at BEFORE UPDATE ON provinces
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_locations_updated_at BEFORE UPDATE ON locations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_audio_guides_updated_at BEFORE UPDATE ON audio_guides
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_routes_updated_at BEFORE UPDATE ON routes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_service_providers_updated_at BEFORE UPDATE ON service_providers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_articles_updated_at BEFORE UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

---

## 7. Seed Data Strategy — Hà Giang

### 7.1 Phase 1 Seed Data Plan

| Entity | Số lượng | Chi tiết |
|--------|:--------:|---------|
| **provinces** | 1 | Hà Giang |
| **locations** | 25-30 | Top attractions: Dinh Vua Mèo, Mã Pí Lèng, Sông Nho Quế, Lũng Cú Flag Tower, Chợ Đồng Văn, Phố Cổ Đồng Văn, Nhà Pao, Sủng Là, Phó Bảng, Lung Khuy Cave... |
| **audio_guides** | 50-60 | 25 locations x 2 languages (vi + en). Ko, zh = Phase 2 AI TTS |
| **routes** | 5-7 | Vòng cung đông (3 ngày), Vòng cung tây (2 ngày), Hà Giang city, Hoàng Su Phì, Du Già, Combo 4-5 ngày... |
| **route_stops** | 60-80 | ~10-12 stops per route |
| **provider_categories** | 7 | Homestay, Nhà hàng/Quán ăn, Sửa xe, Y tế/Bệnh viện, ATM/Ngân hàng, Xăng dầu, Tour/Easy Rider |
| **service_providers** | 50-70 | Focus Đồng Văn, Mèo Vạc, Hà Giang city, Yên Minh |
| **articles** | 10-15 | Tips đi Hà Giang, Chuẩn bị xe máy, Thời tiết, An toàn đèo, Ẩm thực... |
| **banners** | 3-5 | Featured routes, seasonal highlights |

### 7.2 Seed Data Format

```sql
-- Ví dụ seed data cho Hà Giang province
INSERT INTO provinces (id, name_vi, name_en, name_ko, name_zh,
  description_vi, latitude, longitude, is_published) VALUES
(
  '550e8400-e29b-41d4-a716-446655440001',
  'Hà Giang',
  'Ha Giang',
  '하장',
  '河江',
  'Hà Giang — vùng đất địa đầu Tổ Quốc với Cao nguyên đá Đồng Văn (UNESCO Global Geopark), những cung đèo hùng vĩ và văn hóa dân tộc đa dạng.',
  23.3530, 104.9843,
  TRUE
);

-- Ví dụ seed location
INSERT INTO locations (id, province_id, name_vi, name_en, name_ko, name_zh,
  description_vi, latitude, longitude, category, priority,
  qr_code_id, has_audio, is_published, emergency_info) VALUES
(
  '550e8400-e29b-41d4-a716-446655440101',
  '550e8400-e29b-41d4-a716-446655440001',
  'Dinh thự họ Vương (Vua Mèo)',
  'Hmong King Palace (Vuong Family Mansion)',
  '흐몽 왕궁 (브엉 가문 저택)',
  '苗王府（王氏庄园）',
  'Dinh thự của vua Mèo Vương Chính Đức, xây dựng năm 1919-1928. Kiến trúc độc đáo pha trộn Trung Hoa, Pháp và dân tộc H''Mông. Di tích lịch sử quốc gia.',
  23.1560, 105.3210,
  'historical', 'A',
  'LOC-001', TRUE, TRUE,
  '{"nearest_hospital": "Trạm y tế Sà Phìn - 2km", "police_phone": "02193.856.135", "signal_quality": "moderate"}'
);
```

---

## 8. Migration Strategy

### 8.1 Supabase Migrations

```
supabase/migrations/
├── 20260601000000_create_extensions.sql
├── 20260601000001_create_provinces.sql
├── 20260601000002_create_locations.sql
├── 20260601000003_create_audio_guides.sql
├── 20260601000004_create_routes.sql
├── 20260601000005_create_route_stops.sql
├── 20260601000006_create_provider_categories.sql
├── 20260601000007_create_service_providers.sql
├── 20260601000008_create_articles.sql
├── 20260601000009_create_banners.sql
├── 20260601000010_create_rls_policies.sql
├── 20260601000011_create_functions.sql
├── 20260601000012_create_triggers.sql
├── 20260601000013_seed_ha_giang.sql
│
├── (Phase 3)
├── 20260801000000_create_profiles.sql
├── 20260801000001_create_trips.sql
├── 20260801000002_create_trip_entries.sql
├── 20260801000003_create_trip_exports.sql
├── 20260801000004_create_favorites.sql
├── 20260801000005_create_reviews.sql
├── 20260801000006_create_user_photos.sql
├── 20260801000007_create_phase3_rls.sql
│
├── (Phase 5)
└── 20261001000000_create_content_embeddings.sql
```

### 8.2 drift (SQLite) Migrations

```dart
// lib/data/local/app_database.dart

@DriftDatabase(
  tables: [
    // Phase 1
    Provinces, Locations, AudioGuides, Routes, RouteStops,
    ProviderCategories, ServiceProviders, Articles, Banners,
    SyncMetadata, SyncQueue,
    // Phase 3 (added later via schemaVersion bump)
    // Trips, TripEntries, Favorites, ...
  ],
)
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 1;  // Bump khi thêm tables/columns

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Version 2: Add trips, trip_entries (Phase 3)
      if (from < 2) {
        await m.createTable(trips);
        await m.createTable(tripEntries);
        // ...
      }
    },
  );
}
```

---

## 9. JSONB Usage Patterns

### 9.1 Khi nào dùng JSONB vs columns riêng?

| Dùng JSONB | Dùng columns riêng |
|-----------|-------------------|
| Data linh hoạt theo category (metadata cho homestay != sửa xe) | Data cố định, mọi row đều có (name, latitude, longitude) |
| Không cần filter/sort trên field đó | Cần index, filter, sort |
| Schema thay đổi thường xuyên | Schema ổn định |
| Không cần i18n cho field đó | Cần i18n (4 ngôn ngữ) |

### 9.2 JSONB fields trong schema

| Table | Field | Ví dụ |
|-------|-------|-------|
| `locations` | `emergency_info` | `{"nearest_hospital": "...", "police_phone": "..."}` |
| `locations` | `images` | `["url1", "url2", "url3"]` |
| `routes` | `route_polyline` | GeoJSON LineString |
| `routes` | `equipment_notes` | `{"vi": "Cần xe ≥125cc", "en": "Need 125cc+"}` |
| `service_providers` | `metadata` | `{"rooms": 5, "wifi": true, "parking": true}` |
| `trip_entries` | `metadata` | `{"width": 1920, "cost": 50000}` |

---

*Cập nhật lần cuối: 2026-06-08*
