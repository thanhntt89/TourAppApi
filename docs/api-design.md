# ToursApp — API Design Document

> Backend: WordPress + PHP | ACF Pro + CPT UI | REST API cho Mobile
> Phase 1: Hà Giang | Multi-province architecture

---

## 1. Tổng quan kiến trúc

```
┌─────────────────────────┐
│      Mobile App         │
│   (Android / iOS)       │
└────────┬────────────────┘
         │  HTTPS REST
         ▼
┌─────────────────────────┐
│   WordPress Backend     │
│                         │
│  ┌───────────────────┐  │
│  │  Custom REST API  │  │
│  │  /wp-json/        │  │
│  │  toursapp/v1/     │  │
│  └────────┬──────────┘  │
│           │              │
│  ┌────────┴──────────┐  │
│  │  CPT UI + ACF Pro │  │
│  │  (Content Layer)  │  │
│  └────────┬──────────┘  │
│           │              │
│  ┌────────┴──────────┐  │
│  │  Custom Tables    │  │
│  │  (User Data)      │  │
│  └───────────────────┘  │
│                         │
│  wp_posts / wp_postmeta │
│  wp_ta_devices          │
│  wp_ta_checkins         │
│  wp_ta_wallet           │
│  wp_ta_wallet_txn       │
│  wp_ta_user_journeys    │
│  wp_ta_user_journey_stops│
│  wp_ta_visit_history    │
└─────────────────────────┘
```

### Quy ước chung

| Mục | Quy ước |
|-----|---------|
| API namespace | `toursapp/v1` |
| Base URL | `https://domain.com/wp-json/toursapp/v1/` |
| Auth Phase 1 | Header `X-Device-UUID: {uuid}` |
| Ngôn ngữ | Query param `lang=vi|en|ko|zh|fr` (default: `vi`) |
| Pagination | Query param `page=1&per_page=20` |
| Response format | JSON envelope (xem Section 5) |
| Date format | ISO 8601: `2026-06-13T10:30:00+07:00` |
| ID type | WordPress post ID (integer) |
| Coordinate format | Decimal degrees: `23.3530, 104.9843` |

---

## 2. Kiến trúc dữ liệu WordPress

### 2.1 Custom Post Types (CPT UI)

| # | Post Type Slug | Label (EN) | Label (VI) | Hierarchical | Mô tả |
|---|----------------|-----------|------------|:---:|--------|
| 1 | `province` | Province | Tỉnh thành | No | Hà Giang, Cao Bằng, Lào Cai... |
| 2 | `ta_location` | Location | Khu vực | No | Đồng Văn, Quản Bạ, Mèo Vạc... |
| 3 | `place` | Place | Địa điểm | No | Dinh Vua Mèo, Mã Pí Lèng... |
| 4 | `sub_place` | Sub-Place | Điểm thuyết minh | No | Vị trí thuyết minh 1, 2, 3... |
| 5 | `sub_item` | Sub-Item | Chi tiết hiện vật | No | Chi tiết 1 item trong thuyết minh |
| 6 | `journey` | Journey | Lộ trình | No | Lộ trình đề xuất (admin tạo) |
| 7 | `news_alert` | News & Alert | Tin tức & Cảnh báo | No | Thông báo, cảnh báo địa phương |

### 2.2 ACF Field Groups

#### 2.2.1 Province Fields

| Field Name | Field Key | Type | Required | Default | Mô tả |
|-----------|-----------|------|:---:|---------|--------|
| name_vi | province_name_vi | Text | ✅ | — | Tên tiếng Việt |
| name_en | province_name_en | Text | | — | Tên tiếng Anh |
| name_ko | province_name_ko | Text | | — | Tên tiếng Hàn |
| name_zh | province_name_zh | Text | | — | Tên tiếng Trung |
| name_fr | province_name_fr | Text | | — | Tên tiếng Pháp |
| description_vi | province_desc_vi | Textarea | | — | Mô tả tiếng Việt |
| description_en | province_desc_en | Textarea | | — | Mô tả tiếng Anh |
| description_ko | province_desc_ko | Textarea | | — | Mô tả tiếng Hàn |
| description_zh | province_desc_zh | Textarea | | — | Mô tả tiếng Trung |
| description_fr | province_desc_fr | Textarea | | — | Mô tả tiếng Pháp |
| feature_image | province_feature_image | Image | ✅ | — | Ảnh đặc trưng tỉnh |
| banner_images | province_banner_images | Gallery | | — | Ảnh banner slideshow |
| latitude | province_lat | Number | ✅ | — | Vĩ độ trung tâm |
| longitude | province_lng | Number | ✅ | — | Kinh độ trung tâm |
| detection_radius_km | province_detect_radius | Number | | 50 | Bán kính nhận diện GPS (km) |
| is_active | province_is_active | True/False | | false | Đang hoạt động? |
| sort_order | province_sort_order | Number | | 0 | Thứ tự hiển thị |

#### 2.2.2 Location Fields (Khu vực)

| Field Name | Field Key | Type | Required | Default | Mô tả |
|-----------|-----------|------|:---:|---------|--------|
| province | location_province | Post Object (province) | ✅ | — | Thuộc tỉnh nào |
| location_number | location_number | Number | ✅ | — | Số thứ tự khu vực (1=HG, 2=QB, 3=YM, 4=ĐV, 5=MV, 6=VX) |
| name_vi | location_name_vi | Text | ✅ | — | Tên khu vực (VD: Đồng Văn) |
| name_en | location_name_en | Text | | — | |
| name_ko | location_name_ko | Text | | — | |
| name_zh | location_name_zh | Text | | — | |
| name_fr | location_name_fr | Text | | — | |
| description_vi | location_desc_vi | Textarea | | — | Mô tả khu vực |
| description_en | location_desc_en | Textarea | | — | |
| description_ko | location_desc_ko | Textarea | | — | |
| description_zh | location_desc_zh | Textarea | | — | |
| description_fr | location_desc_fr | Textarea | | — | |
| feature_image | location_feature_image | Image | | — | Ảnh đặc trưng khu vực |
| latitude | location_lat | Number | ✅ | — | Vĩ độ |
| longitude | location_lng | Number | ✅ | — | Kinh độ |
| sort_order | location_sort_order | Number | | 0 | Thứ tự trên map |

#### 2.2.3 Place Fields (Địa điểm)

| Field Name | Field Key | Type | Required | Default | Mô tả |
|-----------|-----------|------|:---:|---------|--------|
| location | place_location | Post Object (ta_location) | ✅ | — | Thuộc khu vực nào |
| place_order_number | place_order_number | Number | ✅ | — | Thứ tự trong khu vực |
| name_vi | place_name_vi | Text | ✅ | — | Tên địa điểm |
| name_en | place_name_en | Text | | — | |
| name_ko | place_name_ko | Text | | — | |
| name_zh | place_name_zh | Text | | — | |
| name_fr | place_name_fr | Text | | — | |
| information_vi | place_info_vi | WYSIWYG | | — | Thông tin mô tả ngắn |
| information_en | place_info_en | WYSIWYG | | — | |
| information_ko | place_info_ko | WYSIWYG | | — | |
| information_zh | place_info_zh | WYSIWYG | | — | |
| information_fr | place_info_fr | WYSIWYG | | — | |
| article_vi | place_article_vi | WYSIWYG | | — | Bài viết chính (đọc chi tiết) |
| article_en | place_article_en | WYSIWYG | | — | |
| article_ko | place_article_ko | WYSIWYG | | — | |
| article_zh | place_article_zh | WYSIWYG | | — | |
| article_fr | place_article_fr | WYSIWYG | | — | |
| feature_image | place_feature_image | Image | ✅ | — | Ảnh đặc trưng |
| gallery | place_gallery | Gallery | | — | Bộ sưu tập ảnh |
| audio_file_vi | place_audio_vi | File | | — | Audio thuyết minh tiếng Việt |
| audio_file_en | place_audio_en | File | | — | Audio thuyết minh tiếng Anh |
| audio_file_ko | place_audio_ko | File | | — | Audio thuyết minh tiếng Hàn |
| audio_file_zh | place_audio_zh | File | | — | Audio thuyết minh tiếng Trung |
| audio_file_fr | place_audio_fr | File | | — | Audio thuyết minh tiếng Pháp |
| audio_duration | place_audio_duration | Number | | — | Thời lượng audio (giây) |
| latitude | place_lat | Number | ✅ | — | Vĩ độ |
| longitude | place_lng | Number | ✅ | — | Kinh độ |
| geofence_radius | place_geofence_radius | Number | | 300 | Bán kính nhận diện GPS (mét) |
| qr_code | place_qr_code | Text | | — | Mã QR unique (VD: PL-001) |
| is_featured | place_is_featured | True/False | | false | Hiển thị ở Home Screen? |
| show_article_free | place_show_article_free | True/False | | false | Cho đọc article không cần check-in? |
| show_audio_free | place_show_audio_free | True/False | | false | Cho nghe audio không cần check-in? |
| article_offline_mode | place_article_offline | True/False | | false | Cho tải article offline? |
| audio_offline_mode | place_audio_offline | True/False | | false | Cho tải audio offline? |
| article_cost | place_article_cost | Number | | 5 | Số Hoa Tam Giác Mạch để unlock article |
| checkin_reward | place_checkin_reward | Number | | 10 | Số Hoa nhận khi check-in |
| sort_order | place_sort_order | Number | | 0 | Thứ tự hiển thị trong danh sách |

#### 2.2.4 Sub-Place Fields (Điểm thuyết minh)

| Field Name | Field Key | Type | Required | Default | Mô tả |
|-----------|-----------|------|:---:|---------|--------|
| place | sub_place_place | Post Object (place) | ✅ | — | Thuộc địa điểm nào |
| sub_place_index | sub_place_index | Text | ✅ | — | Chỉ mục phân cấp (VD: 4.2.1) |
| name_vi | sub_place_name_vi | Text | ✅ | — | Tên điểm thuyết minh |
| name_en | sub_place_name_en | Text | | — | |
| name_ko | sub_place_name_ko | Text | | — | |
| name_zh | sub_place_name_zh | Text | | — | |
| name_fr | sub_place_name_fr | Text | | — | |
| description_vi | sub_place_desc_vi | WYSIWYG | | — | Nội dung thuyết minh |
| description_en | sub_place_desc_en | WYSIWYG | | — | |
| description_ko | sub_place_desc_ko | WYSIWYG | | — | |
| description_zh | sub_place_desc_zh | WYSIWYG | | — | |
| description_fr | sub_place_desc_fr | WYSIWYG | | — | |
| feature_image | sub_place_feature_image | Image | | — | Ảnh vị trí |
| audio_file_vi | sub_place_audio_vi | File | | — | Audio thuyết minh |
| audio_file_en | sub_place_audio_en | File | | — | |
| audio_file_ko | sub_place_audio_ko | File | | — | |
| audio_file_zh | sub_place_audio_zh | File | | — | |
| audio_file_fr | sub_place_audio_fr | File | | — | |
| audio_duration | sub_place_audio_duration | Number | | — | Thời lượng (giây) |
| latitude | sub_place_lat | Number | | — | Vĩ độ (nullable nếu cùng place) |
| longitude | sub_place_lng | Number | | — | Kinh độ |
| sort_order | sub_place_sort_order | Number | | 0 | Thứ tự |

#### 2.2.5 Sub-Item Fields (Chi tiết hiện vật)

| Field Name | Field Key | Type | Required | Default | Mô tả |
|-----------|-----------|------|:---:|---------|--------|
| sub_place | sub_item_sub_place | Post Object (sub_place) | ✅ | — | Thuộc điểm thuyết minh nào |
| item_index | sub_item_index | Text | ✅ | — | Chỉ mục (VD: 4.2.1.3) |
| name_vi | sub_item_name_vi | Text | ✅ | — | Tên hiện vật |
| name_en | sub_item_name_en | Text | | — | |
| name_ko | sub_item_name_ko | Text | | — | |
| name_zh | sub_item_name_zh | Text | | — | |
| name_fr | sub_item_name_fr | Text | | — | |
| description_vi | sub_item_desc_vi | WYSIWYG | | — | Nội dung chi tiết |
| description_en | sub_item_desc_en | WYSIWYG | | — | |
| description_ko | sub_item_desc_ko | WYSIWYG | | — | |
| description_zh | sub_item_desc_zh | WYSIWYG | | — | |
| description_fr | sub_item_desc_fr | WYSIWYG | | — | |
| feature_image | sub_item_feature_image | Image | | — | Ảnh hiện vật |
| gallery | sub_item_gallery | Gallery | | — | Bộ ảnh chi tiết |
| audio_file_vi | sub_item_audio_vi | File | | — | Audio chi tiết |
| audio_file_en | sub_item_audio_en | File | | — | |
| audio_file_ko | sub_item_audio_ko | File | | — | |
| audio_file_zh | sub_item_audio_zh | File | | — | |
| audio_file_fr | sub_item_audio_fr | File | | — | |
| sort_order | sub_item_sort_order | Number | | 0 | Thứ tự |

#### 2.2.6 Journey Fields (Lộ trình đề xuất)

| Field Name | Field Key | Type | Required | Default | Mô tả |
|-----------|-----------|------|:---:|---------|--------|
| province | journey_province | Post Object (province) | ✅ | — | Thuộc tỉnh nào |
| name_vi | journey_name_vi | Text | ✅ | — | Tên lộ trình |
| name_en | journey_name_en | Text | | — | |
| name_ko | journey_name_ko | Text | | — | |
| name_zh | journey_name_zh | Text | | — | |
| name_fr | journey_name_fr | Text | | — | |
| description_vi | journey_desc_vi | Textarea | | — | Mô tả |
| description_en | journey_desc_en | Textarea | | — | |
| description_ko | journey_desc_ko | Textarea | | — | |
| description_zh | journey_desc_zh | Textarea | | — | |
| description_fr | journey_desc_fr | Textarea | | — | |
| feature_image | journey_feature_image | Image | | — | Ảnh lộ trình |
| duration_days | journey_duration_days | Number | | 1 | Số ngày |
| total_places | journey_total_places | Number | | — | Tổng số điểm |
| difficulty | journey_difficulty | Select | | moderate | easy / moderate / hard |
| stops | journey_stops | Repeater | ✅ | — | Danh sách điểm dừng |
| → stop_place | journey_stop_place | Post Object (place) | ✅ | — | Địa điểm dừng |
| → stop_order | journey_stop_order | Number | ✅ | — | Thứ tự |
| → stop_day | journey_stop_day | Number | | 1 | Ngày thứ mấy |
| → stop_note_vi | journey_stop_note_vi | Text | | — | Ghi chú |
| → stop_note_en | journey_stop_note_en | Text | | — | |
| → stop_duration_min | journey_stop_duration | Number | | 60 | Thời gian dừng (phút) |
| is_featured | journey_is_featured | True/False | | false | Hiển thị nổi bật? |
| sort_order | journey_sort_order | Number | | 0 | Thứ tự |

#### 2.2.7 News & Alert Fields

| Field Name | Field Key | Type | Required | Default | Mô tả |
|-----------|-----------|------|:---:|---------|--------|
| province | news_province | Post Object (province) | ✅ | — | Thuộc tỉnh nào |
| type | news_type | Select | ✅ | news | news / alert / warning / event |
| title_vi | news_title_vi | Text | ✅ | — | Tiêu đề |
| title_en | news_title_en | Text | | — | |
| title_ko | news_title_ko | Text | | — | |
| title_zh | news_title_zh | Text | | — | |
| title_fr | news_title_fr | Text | | — | |
| content_vi | news_content_vi | WYSIWYG | | — | Nội dung |
| content_en | news_content_en | WYSIWYG | | — | |
| content_ko | news_content_ko | WYSIWYG | | — | |
| content_zh | news_content_zh | WYSIWYG | | — | |
| content_fr | news_content_fr | WYSIWYG | | — | |
| icon | news_icon | Select | | info | info / warning / danger / event |
| start_date | news_start_date | Date Picker | | — | Hiển thị từ |
| end_date | news_end_date | Date Picker | | — | Hiển thị đến |
| is_pinned | news_is_pinned | True/False | | false | Ghim lên đầu? |

### 2.3 Custom Database Tables (User Data)

```sql
-- Thiết bị người dùng
CREATE TABLE wp_ta_devices (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL UNIQUE,
    device_name     VARCHAR(255),
    platform        ENUM('android', 'ios') NOT NULL,
    app_version     VARCHAR(20),
    lang            VARCHAR(5) DEFAULT 'vi',
    push_token      VARCHAR(500),
    last_province_id INT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_uuid (device_uuid)
);

-- Ví Hoa Tam Giác Mạch
CREATE TABLE wp_ta_wallet (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL UNIQUE,
    balance         INT DEFAULT 0,
    total_earned    INT DEFAULT 0,
    total_spent     INT DEFAULT 0,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (device_uuid) REFERENCES wp_ta_devices(device_uuid)
);

-- Lịch sử giao dịch Hoa
CREATE TABLE wp_ta_wallet_txn (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL,
    type            ENUM('earn_checkin', 'earn_share_app', 'earn_share_social', 'spend_unlock') NOT NULL,
    amount          INT NOT NULL,
    balance_after   INT NOT NULL,
    reference_type  VARCHAR(50),       -- 'place', 'sub_place', 'referral'
    reference_id    INT,               -- post ID hoặc NULL
    note            VARCHAR(255),
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_type (type),
    FOREIGN KEY (device_uuid) REFERENCES wp_ta_devices(device_uuid)
);

-- Check-in history
CREATE TABLE wp_ta_checkins (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL,
    place_id        INT NOT NULL,          -- WP post ID of place
    method          ENUM('gps', 'qr') NOT NULL,
    latitude        DECIMAL(10,7),
    longitude       DECIMAL(10,7),
    reward_amount   INT DEFAULT 0,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_place (place_id),
    UNIQUE KEY unique_checkin (device_uuid, place_id),  -- 1 check-in per place per device
    FOREIGN KEY (device_uuid) REFERENCES wp_ta_devices(device_uuid)
);

-- Lịch sử xem (visit history)
CREATE TABLE wp_ta_visit_history (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL,
    place_id        INT NOT NULL,
    visit_type      ENUM('view', 'audio_play', 'article_read') NOT NULL,
    duration_sec    INT,                   -- thời gian xem/nghe
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device_place (device_uuid, place_id),
    INDEX idx_created (created_at),
    FOREIGN KEY (device_uuid) REFERENCES wp_ta_devices(device_uuid)
);

-- User Journey (user tự tạo)
CREATE TABLE wp_ta_user_journeys (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL,
    province_id     INT NOT NULL,
    name            VARCHAR(255) NOT NULL,
    description     TEXT,
    source_journey_id INT,                 -- NULL = user tạo mới, INT = clone từ preset
    status          ENUM('planning', 'active', 'completed') DEFAULT 'planning',
    started_at      DATETIME,
    completed_at    DATETIME,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_province (province_id),
    FOREIGN KEY (device_uuid) REFERENCES wp_ta_devices(device_uuid)
);

-- Điểm dừng trong User Journey
CREATE TABLE wp_ta_user_journey_stops (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    journey_id      BIGINT NOT NULL,
    place_id        INT NOT NULL,
    stop_order      INT NOT NULL,
    day_number      INT DEFAULT 1,
    note            TEXT,
    status          ENUM('planned', 'visited', 'skipped') DEFAULT 'planned',
    visited_at      DATETIME,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_journey (journey_id),
    FOREIGN KEY (journey_id) REFERENCES wp_ta_user_journeys(id) ON DELETE CASCADE
);

-- Nội dung đã unlock
CREATE TABLE wp_ta_unlocked_content (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL,
    content_type    ENUM('article', 'audio') NOT NULL,
    content_id      INT NOT NULL,          -- place_id hoặc sub_place_id
    cost            INT NOT NULL,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_unlock (device_uuid, content_type, content_id),
    FOREIGN KEY (device_uuid) REFERENCES wp_ta_devices(device_uuid)
);

-- Share tracking (cho earn Hoa)
CREATE TABLE wp_ta_shares (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    device_uuid     VARCHAR(64) NOT NULL,
    share_type      ENUM('app_referral', 'social_facebook', 'social_zalo', 'social_instagram', 'social_other') NOT NULL,
    platform        VARCHAR(50),
    referral_code   VARCHAR(32),           -- mã giới thiệu unique cho app_referral
    reward_amount   INT DEFAULT 0,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device (device_uuid),
    INDEX idx_referral (referral_code),
    FOREIGN KEY (device_uuid) REFERENCES wp_ta_devices(device_uuid)
);
```

---

## 3. API Endpoints

### 3.1 Device / Authentication

#### 3.1.1 Register Device

```
POST /toursapp/v1/device/register
```

Đăng ký thiết bị lần đầu hoặc cập nhật thông tin. Gọi mỗi lần mở app.

**Request Body:**
```json
{
    "device_uuid": "550e8400-e29b-41d4-a716-446655440000",
    "device_name": "iPhone 15 Pro",
    "platform": "ios",
    "app_version": "1.0.0",
    "lang": "vi",
    "push_token": "fcm_token_here"
}
```

**Response (200):**
```json
{
    "success": true,
    "data": {
        "device_uuid": "550e8400-e29b-41d4-a716-446655440000",
        "is_new": true,
        "wallet_balance": 0,
        "referral_code": "HG-ABC123",
        "last_province_id": null
    }
}
```

---

### 3.2 Province APIs

#### 3.2.1 List Provinces

```
GET /toursapp/v1/provinces
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| lang | string | vi | Ngôn ngữ: vi, en, ko, zh, fr |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 10,
            "name": "Hà Giang",
            "description": "Vùng đất địa đầu Tổ Quốc...",
            "feature_image": {
                "url": "https://domain.com/wp-content/uploads/ha-giang.jpg",
                "width": 1200,
                "height": 800
            },
            "latitude": 23.3530,
            "longitude": 104.9843,
            "detection_radius_km": 50,
            "is_active": true,
            "total_locations": 6,
            "total_places": 45,
            "sort_order": 1
        }
    ]
}
```

#### 3.2.2 Detect Province by GPS

```
GET /toursapp/v1/provinces/detect?lat={lat}&lng={lng}
```

Tự động nhận diện tỉnh dựa trên tọa độ GPS. Tìm tỉnh gần nhất trong bán kính `detection_radius_km`.

**Query Params:**

| Param | Type | Required | Mô tả |
|-------|------|:---:|--------|
| lat | decimal | ✅ | Vĩ độ user |
| lng | decimal | ✅ | Kinh độ user |
| lang | string | | Ngôn ngữ |

**Response (200) — Tìm thấy:**
```json
{
    "success": true,
    "data": {
        "detected": true,
        "province": {
            "id": 10,
            "name": "Hà Giang",
            "feature_image": { "url": "...", "width": 1200, "height": 800 },
            "latitude": 23.3530,
            "longitude": 104.9843,
            "distance_km": 12.5
        }
    }
}
```

**Response (200) — Không tìm thấy:**
```json
{
    "success": true,
    "data": {
        "detected": false,
        "province": null,
        "available_provinces": [ ... ]
    }
}
```

#### 3.2.3 Province Detail (Home Screen Data)

```
GET /toursapp/v1/provinces/{id}
```

Trả về toàn bộ thông tin tỉnh + dữ liệu cho Home Screen.

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| lang | string | vi | Ngôn ngữ |
| include | string | — | Bao gồm thêm: `locations,featured_places,news` (comma-separated) |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "id": 10,
        "name": "Hà Giang",
        "description": "...",
        "feature_image": { "url": "...", "width": 1200, "height": 800 },
        "banner_images": [
            { "url": "...", "width": 1200, "height": 600 }
        ],
        "latitude": 23.3530,
        "longitude": 104.9843,
        "locations": [
            {
                "id": 20,
                "location_number": 1,
                "name": "Hà Giang City",
                "feature_image": { "url": "..." },
                "latitude": 22.823,
                "longitude": 104.983,
                "place_count": 5
            }
        ],
        "featured_places": [
            {
                "id": 101,
                "name": "Mã Pí Lèng",
                "feature_image": { "url": "...", "width": 800, "height": 600 },
                "location_name": "Mèo Vạc",
                "latitude": 23.2156,
                "longitude": 105.4023,
                "has_audio": true,
                "distance_km": null
            }
        ],
        "news": [
            {
                "id": 501,
                "type": "warning",
                "title": "Sạt lở kinh hoàng tại KM67 trên tuyến đường...",
                "icon": "warning",
                "is_pinned": true,
                "created_at": "2026-06-13T08:00:00+07:00"
            }
        ]
    }
}
```

---

### 3.3 Location APIs (Khu vực)

#### 3.3.1 List Locations in Province

```
GET /toursapp/v1/provinces/{province_id}/locations
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| lang | string | vi | Ngôn ngữ |
| sort | string | location_number | Sắp xếp: `location_number`, `name`, `distance` |
| lat | decimal | — | Vĩ độ user (cần cho sort=distance) |
| lng | decimal | — | Kinh độ user (cần cho sort=distance) |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 20,
            "location_number": 1,
            "name": "Hà Giang City",
            "description": "Cửa ngõ vào vòng cung...",
            "feature_image": { "url": "..." },
            "latitude": 22.823,
            "longitude": 104.983,
            "place_count": 5,
            "distance_km": 2.3
        },
        {
            "id": 21,
            "location_number": 2,
            "name": "Quản Bạ",
            "description": "...",
            "feature_image": { "url": "..." },
            "latitude": 23.073,
            "longitude": 105.009,
            "place_count": 8,
            "distance_km": 45.2
        }
    ]
}
```

#### 3.3.2 Location Detail

```
GET /toursapp/v1/locations/{id}
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| lang | string | vi | Ngôn ngữ |
| include | string | — | `places` — kèm danh sách places |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "id": 24,
        "location_number": 4,
        "name": "Đồng Văn",
        "description": "Cao nguyên đá...",
        "feature_image": { "url": "..." },
        "latitude": 23.278,
        "longitude": 105.362,
        "province": { "id": 10, "name": "Hà Giang" },
        "places": [
            {
                "id": 101,
                "place_order_number": 1,
                "name": "Phố cổ Đồng Văn",
                "feature_image": { "url": "..." },
                "latitude": 23.279,
                "longitude": 105.363,
                "has_audio": true,
                "is_featured": false,
                "checkin_reward": 10
            },
            {
                "id": 102,
                "place_order_number": 2,
                "name": "Dinh thự Vua Mèo",
                "feature_image": { "url": "..." },
                "latitude": 23.156,
                "longitude": 105.321,
                "has_audio": true,
                "is_featured": true,
                "checkin_reward": 10
            }
        ]
    }
}
```

---

### 3.4 Place APIs (Địa điểm)

#### 3.4.1 List Places

```
GET /toursapp/v1/places
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| province_id | int | — | Filter theo tỉnh (required nếu không có location_id) |
| location_id | int | — | Filter theo khu vực |
| featured | bool | — | Chỉ lấy featured places |
| lang | string | vi | Ngôn ngữ |
| sort | string | sort_order | `sort_order`, `name`, `distance`, `place_order_number` |
| lat | decimal | — | Vĩ độ user |
| lng | decimal | — | Kinh độ user |
| page | int | 1 | Trang |
| per_page | int | 20 | Số lượng mỗi trang (max: 100) |
| search | string | — | Tìm kiếm theo tên |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 102,
            "place_order_number": 2,
            "name": "Dinh thự Vua Mèo",
            "information": "Di tích lịch sử quốc gia...",
            "feature_image": { "url": "...", "width": 800, "height": 600 },
            "location": { "id": 24, "name": "Đồng Văn", "location_number": 4 },
            "latitude": 23.156,
            "longitude": 105.321,
            "has_audio": true,
            "audio_duration": 420,
            "is_featured": true,
            "show_article_free": false,
            "show_audio_free": false,
            "article_cost": 5,
            "checkin_reward": 10,
            "distance_km": 0.8,
            "sub_place_count": 7
        }
    ],
    "meta": {
        "total": 45,
        "page": 1,
        "per_page": 20,
        "total_pages": 3
    }
}
```

#### 3.4.2 Place Detail

```
GET /toursapp/v1/places/{id}
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| lang | string | vi | Ngôn ngữ |
| include | string | — | `sub_places,sub_items` (comma-separated) |

**Headers:**
```
X-Device-UUID: {uuid}
```

**Response (200):**
```json
{
    "success": true,
    "data": {
        "id": 102,
        "place_order_number": 2,
        "hierarchical_index": "4.2",
        "name": "Dinh thự Vua Mèo",
        "information": "<p>Di tích lịch sử quốc gia xây dựng 1919-1928...</p>",
        "article": "<p>Bài viết chi tiết về Dinh thự...</p>",
        "feature_image": { "url": "...", "width": 1200, "height": 800 },
        "gallery": [
            { "url": "...", "width": 800, "height": 600, "caption": "Cổng chính" },
            { "url": "...", "width": 800, "height": 600, "caption": "Sân trước" }
        ],
        "audio": {
            "url": "https://domain.com/wp-content/uploads/audio/vua-meo-vi.mp3",
            "duration": 420,
            "offline_allowed": false
        },
        "location": {
            "id": 24,
            "name": "Đồng Văn",
            "location_number": 4
        },
        "province": { "id": 10, "name": "Hà Giang" },
        "latitude": 23.156,
        "longitude": 105.321,
        "geofence_radius": 300,
        "qr_code": "PL-102",
        "is_featured": true,
        "show_article_free": false,
        "show_audio_free": false,
        "article_offline_mode": false,
        "audio_offline_mode": false,
        "article_cost": 5,
        "checkin_reward": 10,
        "user_status": {
            "is_checked_in": false,
            "is_article_unlocked": false,
            "is_audio_unlocked": false
        },
        "sub_places": [
            {
                "id": 201,
                "sub_place_index": "4.2.1",
                "name": "Cổng tam quan",
                "feature_image": { "url": "..." },
                "has_audio": true,
                "audio_duration": 120,
                "sort_order": 1,
                "sub_item_count": 3
            },
            {
                "id": 202,
                "sub_place_index": "4.2.2",
                "name": "Sảnh chính",
                "feature_image": { "url": "..." },
                "has_audio": true,
                "audio_duration": 180,
                "sort_order": 2,
                "sub_item_count": 5
            }
        ]
    }
}
```

#### 3.4.3 Nearby Places (GPS Detection)

```
GET /toursapp/v1/places/nearby
```

Tìm places gần vị trí hiện tại. Dùng cho GPS auto-detect và Free Walk mode.

**Query Params:**

| Param | Type | Required | Default | Mô tả |
|-------|------|:---:|---------|--------|
| lat | decimal | ✅ | — | Vĩ độ user |
| lng | decimal | ✅ | — | Kinh độ user |
| radius | int | | 1000 | Bán kính tìm kiếm (mét) |
| province_id | int | | — | Filter theo tỉnh |
| limit | int | | 10 | Số kết quả tối đa |
| lang | string | | vi | Ngôn ngữ |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 102,
            "name": "Dinh thự Vua Mèo",
            "feature_image": { "url": "..." },
            "latitude": 23.156,
            "longitude": 105.321,
            "distance_meters": 245,
            "geofence_radius": 300,
            "is_within_geofence": true,
            "has_audio": true,
            "audio_duration": 420,
            "show_audio_free": false,
            "checkin_reward": 10,
            "location": { "id": 24, "name": "Đồng Văn" }
        }
    ]
}
```

#### 3.4.4 QR Code Lookup

```
GET /toursapp/v1/places/qr/{code}
```

**Path Params:**

| Param | Type | Mô tả |
|-------|------|--------|
| code | string | Mã QR (VD: PL-102) |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "type": "place",
        "place": {
            "id": 102,
            "name": "Dinh thự Vua Mèo",
            "feature_image": { "url": "..." },
            "latitude": 23.156,
            "longitude": 105.321,
            "has_audio": true,
            "location": { "id": 24, "name": "Đồng Văn" }
        }
    }
}
```

**Response (404):**
```json
{
    "success": false,
    "error": {
        "code": "QR_NOT_FOUND",
        "message": "Mã QR không hợp lệ"
    }
}
```

#### 3.4.5 Search Places

```
GET /toursapp/v1/places/search
```

**Query Params:**

| Param | Type | Required | Default | Mô tả |
|-------|------|:---:|---------|--------|
| q | string | ✅ | — | Từ khóa tìm kiếm |
| province_id | int | | — | Filter theo tỉnh |
| lang | string | | vi | Ngôn ngữ |
| page | int | | 1 | Trang |
| per_page | int | | 20 | Số lượng |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 102,
            "name": "Dinh thự Vua Mèo",
            "information": "Di tích lịch sử...",
            "feature_image": { "url": "..." },
            "location": { "id": 24, "name": "Đồng Văn" },
            "latitude": 23.156,
            "longitude": 105.321,
            "has_audio": true,
            "match_score": 0.95
        }
    ],
    "meta": {
        "total": 3,
        "query": "vua mèo"
    }
}
```

---

### 3.5 Sub-Place & Sub-Item APIs

#### 3.5.1 List Sub-Places of a Place

```
GET /toursapp/v1/places/{place_id}/sub-places
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| lang | string | vi | Ngôn ngữ |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 201,
            "sub_place_index": "4.2.1",
            "name": "Cổng tam quan",
            "description": "<p>Cổng chính của dinh thự...</p>",
            "feature_image": { "url": "..." },
            "audio": {
                "url": "https://domain.com/.../cong-tam-quan-vi.mp3",
                "duration": 120
            },
            "latitude": 23.1561,
            "longitude": 105.3211,
            "sort_order": 1,
            "sub_items": [
                {
                    "id": 301,
                    "item_index": "4.2.1.1",
                    "name": "Phù điêu trên cổng",
                    "feature_image": { "url": "..." },
                    "sort_order": 1
                },
                {
                    "id": 302,
                    "item_index": "4.2.1.2",
                    "name": "Hoành phi câu đối",
                    "feature_image": { "url": "..." },
                    "sort_order": 2
                }
            ]
        }
    ]
}
```

#### 3.5.2 Sub-Place Detail

```
GET /toursapp/v1/sub-places/{id}
```

**Response (200):**
```json
{
    "success": true,
    "data": {
        "id": 201,
        "sub_place_index": "4.2.1",
        "name": "Cổng tam quan",
        "description": "<p>Nội dung thuyết minh chi tiết...</p>",
        "feature_image": { "url": "...", "width": 1200, "height": 800 },
        "audio": {
            "url": "https://domain.com/.../cong-tam-quan-vi.mp3",
            "duration": 120
        },
        "latitude": 23.1561,
        "longitude": 105.3211,
        "place": { "id": 102, "name": "Dinh thự Vua Mèo" },
        "sub_items": [
            {
                "id": 301,
                "item_index": "4.2.1.1",
                "name": "Phù điêu trên cổng",
                "description": "<p>Chi tiết về phù điêu...</p>",
                "feature_image": { "url": "..." },
                "gallery": [
                    { "url": "...", "caption": "Phù điêu mặt trước" },
                    { "url": "...", "caption": "Phù điêu chi tiết" }
                ],
                "audio": {
                    "url": "https://domain.com/.../phu-dieu-vi.mp3",
                    "duration": 60
                },
                "sort_order": 1
            }
        ]
    }
}
```

#### 3.5.3 Sub-Item Detail

```
GET /toursapp/v1/sub-items/{id}
```

**Response (200):**
```json
{
    "success": true,
    "data": {
        "id": 301,
        "item_index": "4.2.1.1",
        "name": "Phù điêu trên cổng",
        "description": "<p>Nội dung chi tiết về hiện vật...</p>",
        "feature_image": { "url": "...", "width": 1200, "height": 800 },
        "gallery": [
            { "url": "...", "width": 800, "height": 600, "caption": "Mặt trước" }
        ],
        "audio": {
            "url": "https://domain.com/.../phu-dieu-vi.mp3",
            "duration": 60
        },
        "sub_place": { "id": 201, "name": "Cổng tam quan" },
        "place": { "id": 102, "name": "Dinh thự Vua Mèo" }
    }
}
```

---

### 3.6 Journey APIs (Lộ trình)

#### 3.6.1 List Preset Journeys

```
GET /toursapp/v1/journeys
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| province_id | int | — | Filter theo tỉnh (required) |
| lang | string | vi | Ngôn ngữ |
| featured | bool | — | Chỉ lấy featured |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 50,
            "type": "preset",
            "name": "Ha Giang Loop: Day 1",
            "description": "Vòng cung đông ngày 1...",
            "feature_image": { "url": "..." },
            "duration_days": 1,
            "total_places": 12,
            "difficulty": "moderate",
            "is_featured": true,
            "stops": [
                {
                    "stop_order": 1,
                    "day": 1,
                    "place": {
                        "id": 100,
                        "name": "KM0 Milestone",
                        "feature_image": { "url": "..." },
                        "latitude": 22.823,
                        "longitude": 104.983
                    },
                    "duration_min": 30,
                    "note": "Điểm xuất phát"
                },
                {
                    "stop_order": 2,
                    "day": 1,
                    "place": {
                        "id": 101,
                        "name": "Quan Ba Heaven Gate",
                        "feature_image": { "url": "..." },
                        "latitude": 23.073,
                        "longitude": 105.009
                    },
                    "duration_min": 45,
                    "note": "Cổng trời Quản Bạ"
                }
            ]
        }
    ]
}
```

#### 3.6.2 Journey Detail

```
GET /toursapp/v1/journeys/{id}
```

Response giống item trong list nhưng thêm thông tin stops đầy đủ.

#### 3.6.3 Create User Journey

```
POST /toursapp/v1/user/journeys
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Request Body:**
```json
{
    "province_id": 10,
    "name": "Chuyến đi Hà Giang của tôi",
    "description": "3 ngày 2 đêm",
    "source_journey_id": 50,
    "stops": [
        { "place_id": 100, "stop_order": 1, "day_number": 1, "note": "" },
        { "place_id": 101, "stop_order": 2, "day_number": 1, "note": "Ăn trưa ở đây" },
        { "place_id": 102, "stop_order": 3, "day_number": 2, "note": "" }
    ]
}
```

**Response (201):**
```json
{
    "success": true,
    "data": {
        "id": 1001,
        "type": "user",
        "name": "Chuyến đi Hà Giang của tôi",
        "status": "planning",
        "total_places": 3,
        "stops": [ ... ],
        "created_at": "2026-06-13T10:00:00+07:00"
    }
}
```

#### 3.6.4 Update User Journey

```
PUT /toursapp/v1/user/journeys/{id}
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Request Body:**
```json
{
    "name": "Hà Giang Trip - Updated",
    "status": "active",
    "stops": [
        { "place_id": 100, "stop_order": 1, "day_number": 1, "note": "Đã sửa", "status": "visited" },
        { "place_id": 101, "stop_order": 2, "day_number": 1, "note": "" },
        { "place_id": 103, "stop_order": 3, "day_number": 2, "note": "Thêm mới" }
    ]
}
```

**Response (200):**
```json
{
    "success": true,
    "data": { ... }
}
```

#### 3.6.5 Delete User Journey

```
DELETE /toursapp/v1/user/journeys/{id}
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Response (200):**
```json
{
    "success": true,
    "data": { "deleted": true }
}
```

#### 3.6.6 List User Journeys

```
GET /toursapp/v1/user/journeys
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| province_id | int | — | Filter theo tỉnh |
| status | string | — | planning / active / completed |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 1001,
            "type": "user",
            "name": "Chuyến đi Hà Giang của tôi",
            "status": "active",
            "total_places": 12,
            "visited_count": 5,
            "progress_percent": 41,
            "started_at": "2026-06-10T08:00:00+07:00",
            "stops": [ ... ]
        }
    ]
}
```

---

### 3.7 User Action APIs

#### 3.7.1 Check-in at Place

```
POST /toursapp/v1/user/checkin
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Request Body:**
```json
{
    "place_id": 102,
    "method": "gps",
    "latitude": 23.1558,
    "longitude": 105.3209
}
```

Hoặc check-in bằng QR:
```json
{
    "place_id": 102,
    "method": "qr",
    "qr_code": "PL-102"
}
```

**Validation rules:**
- GPS method: Server tính khoảng cách user ↔ place, phải ≤ `geofence_radius`
- QR method: `qr_code` phải khớp với `place_qr_code` trong ACF
- Mỗi device chỉ check-in 1 lần cho mỗi place

**Response (200) — Thành công:**
```json
{
    "success": true,
    "data": {
        "checkin_id": 5001,
        "place_id": 102,
        "place_name": "Dinh thự Vua Mèo",
        "method": "gps",
        "reward": {
            "amount": 10,
            "currency": "buckwheat_flower",
            "new_balance": 35
        },
        "unlocked": {
            "article": true,
            "audio": true
        },
        "created_at": "2026-06-13T14:30:00+07:00"
    }
}
```

**Response (400) — Quá xa:**
```json
{
    "success": false,
    "error": {
        "code": "TOO_FAR",
        "message": "Bạn cần đến gần địa điểm hơn để check-in",
        "details": {
            "distance_meters": 520,
            "required_meters": 300
        }
    }
}
```

**Response (409) — Đã check-in:**
```json
{
    "success": false,
    "error": {
        "code": "ALREADY_CHECKED_IN",
        "message": "Bạn đã check-in tại địa điểm này rồi",
        "details": {
            "checked_in_at": "2026-06-10T09:00:00+07:00"
        }
    }
}
```

#### 3.7.2 Unlock Content

```
POST /toursapp/v1/user/unlock
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Request Body:**
```json
{
    "content_type": "article",
    "content_id": 102
}
```

`content_type`: `article` hoặc `audio`
`content_id`: place_id hoặc sub_place_id

**Response (200):**
```json
{
    "success": true,
    "data": {
        "content_type": "article",
        "content_id": 102,
        "cost": 5,
        "new_balance": 30,
        "unlocked_at": "2026-06-13T15:00:00+07:00"
    }
}
```

**Response (400) — Không đủ Hoa:**
```json
{
    "success": false,
    "error": {
        "code": "INSUFFICIENT_BALANCE",
        "message": "Bạn không đủ Hoa Tam Giác Mạch",
        "details": {
            "required": 5,
            "current_balance": 3
        }
    }
}
```

#### 3.7.3 Wallet Info

```
GET /toursapp/v1/user/wallet
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Response (200):**
```json
{
    "success": true,
    "data": {
        "balance": 35,
        "total_earned": 50,
        "total_spent": 15,
        "referral_code": "HG-ABC123",
        "recent_transactions": [
            {
                "id": 8001,
                "type": "earn_checkin",
                "amount": 10,
                "balance_after": 35,
                "note": "Check-in tại Dinh thự Vua Mèo",
                "created_at": "2026-06-13T14:30:00+07:00"
            },
            {
                "id": 8000,
                "type": "spend_unlock",
                "amount": -5,
                "balance_after": 25,
                "note": "Unlock bài viết KM0 Milestone",
                "created_at": "2026-06-13T10:15:00+07:00"
            }
        ]
    }
}
```

#### 3.7.4 Share App / Social (Earn Flowers)

```
POST /toursapp/v1/user/share
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Request Body:**
```json
{
    "share_type": "social_facebook",
    "platform": "facebook"
}
```

`share_type` values:
- `app_referral` — Chia sẻ link app cho bạn bè (dùng referral_code)
- `social_facebook` — Share lên Facebook
- `social_zalo` — Share lên Zalo
- `social_instagram` — Share lên Instagram
- `social_other` — Share lên MXH khác

**Business Rules:**
- `social_*`: Mỗi platform earn 1 lần/ngày, mỗi lần 2 Hoa
- `app_referral`: Earn 5 Hoa khi người được giới thiệu cài app và mở lần đầu

**Response (200):**
```json
{
    "success": true,
    "data": {
        "share_type": "social_facebook",
        "reward": {
            "amount": 2,
            "new_balance": 37
        },
        "message": "Cảm ơn bạn đã chia sẻ!"
    }
}
```

**Response (429) — Đã share hôm nay:**
```json
{
    "success": false,
    "error": {
        "code": "SHARE_LIMIT_REACHED",
        "message": "Bạn đã chia sẻ lên Facebook hôm nay rồi. Thử lại ngày mai nhé!"
    }
}
```

#### 3.7.5 Redeem Referral Code

```
POST /toursapp/v1/user/referral/redeem
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Request Body:**
```json
{
    "referral_code": "HG-XYZ789"
}
```

**Response (200):**
```json
{
    "success": true,
    "data": {
        "reward": {
            "inviter_reward": 5,
            "invitee_reward": 3,
            "new_balance": 3
        },
        "message": "Chào mừng! Bạn nhận được 3 Hoa Tam Giác Mạch"
    }
}
```

#### 3.7.6 Visit History

```
GET /toursapp/v1/user/history
```

**Headers:**
```
X-Device-UUID: {uuid}
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| province_id | int | — | Filter theo tỉnh |
| type | string | — | `checkin`, `view`, `audio_play`, `article_read` |
| page | int | 1 | Trang |
| per_page | int | 20 | Số lượng |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "checkins": [
            {
                "place_id": 102,
                "place_name": "Dinh thự Vua Mèo",
                "place_image": { "url": "..." },
                "method": "gps",
                "reward_amount": 10,
                "checked_in_at": "2026-06-13T14:30:00+07:00"
            },
            {
                "place_id": 100,
                "place_name": "KM0 Milestone",
                "place_image": { "url": "..." },
                "method": "qr",
                "reward_amount": 10,
                "checked_in_at": "2026-06-13T09:00:00+07:00"
            }
        ],
        "stats": {
            "total_checkins": 5,
            "total_places_visited": 5,
            "total_audio_played": 8,
            "total_articles_read": 3,
            "total_flowers_earned": 50
        }
    },
    "meta": { "total": 5, "page": 1, "per_page": 20 }
}
```

---

### 3.8 News & Alert APIs

#### 3.8.1 List News/Alerts

```
GET /toursapp/v1/news
```

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| province_id | int | — | Filter theo tỉnh (required) |
| type | string | — | `news`, `alert`, `warning`, `event` |
| lang | string | vi | Ngôn ngữ |
| page | int | 1 | Trang |
| per_page | int | 10 | Số lượng |

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 501,
            "type": "warning",
            "title": "Sạt lở kinh hoàng tại KM67 trên tuyến đường...",
            "content": "<p>Nội dung chi tiết...</p>",
            "icon": "warning",
            "is_pinned": true,
            "start_date": "2026-06-12",
            "end_date": "2026-06-20",
            "created_at": "2026-06-12T08:00:00+07:00"
        }
    ]
}
```

---

### 3.9 Offline Sync APIs

#### 3.9.1 Check for Updates

```
GET /toursapp/v1/sync/check
```

Kiểm tra có dữ liệu mới không kể từ lần sync cuối.

**Query Params:**

| Param | Type | Required | Mô tả |
|-------|------|:---:|--------|
| province_id | int | ✅ | ID tỉnh |
| since | string | ✅ | ISO 8601 timestamp lần sync cuối |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "has_updates": true,
        "last_modified": "2026-06-13T06:00:00+07:00",
        "changes": {
            "provinces": { "updated": 0, "added": 0, "deleted": 0 },
            "locations": { "updated": 1, "added": 0, "deleted": 0 },
            "places": { "updated": 3, "added": 1, "deleted": 0 },
            "sub_places": { "updated": 0, "added": 2, "deleted": 0 },
            "sub_items": { "updated": 0, "added": 0, "deleted": 0 },
            "journeys": { "updated": 0, "added": 1, "deleted": 0 },
            "news": { "updated": 1, "added": 2, "deleted": 1 }
        },
        "estimated_download_size_mb": 12.5
    }
}
```

#### 3.9.2 Download Offline Package

```
GET /toursapp/v1/sync/package/{province_id}
```

Trả toàn bộ dữ liệu của tỉnh dưới dạng JSON. Mobile app sẽ cache local.

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| lang | string | vi | Ngôn ngữ |
| since | string | — | Chỉ lấy data thay đổi từ thời điểm này (incremental sync) |
| include_media_urls | bool | true | Kèm URL media (images, audio) để download |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "province": {
            "id": 10,
            "name": "Hà Giang",
            "feature_image": { "url": "..." },
            "latitude": 23.3530,
            "longitude": 104.9843
        },
        "locations": [ ... ],
        "places": [ ... ],
        "sub_places": [ ... ],
        "sub_items": [ ... ],
        "journeys": [ ... ],
        "news": [ ... ],
        "media_manifest": [
            {
                "type": "image",
                "url": "https://domain.com/.../ha-giang.jpg",
                "size_bytes": 245000,
                "checksum": "abc123"
            },
            {
                "type": "audio",
                "url": "https://domain.com/.../vua-meo-vi.mp3",
                "size_bytes": 3200000,
                "checksum": "def456",
                "place_id": 102,
                "lang": "vi"
            }
        ],
        "sync_version": "2026-06-13T06:00:00+07:00",
        "total_media_size_mb": 156.3
    }
}
```

#### 3.9.3 Media Manifest (danh sách file cần tải)

```
GET /toursapp/v1/sync/media/{province_id}
```

Chỉ trả danh sách URL các file media (images + audio) để app download riêng, không kèm data.

**Query Params:**

| Param | Type | Default | Mô tả |
|-------|------|---------|--------|
| type | string | all | `all`, `images`, `audio` |
| lang | string | vi | Ngôn ngữ (cho audio) |
| since | string | — | Chỉ file mới/cập nhật từ thời điểm này |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "files": [
            {
                "id": "img_102_feature",
                "type": "image",
                "url": "https://domain.com/.../vua-meo.jpg",
                "size_bytes": 245000,
                "checksum": "sha256:abc123...",
                "related_to": { "type": "place", "id": 102 }
            },
            {
                "id": "audio_102_vi",
                "type": "audio",
                "url": "https://domain.com/.../vua-meo-vi.mp3",
                "size_bytes": 3200000,
                "checksum": "sha256:def456...",
                "duration": 420,
                "related_to": { "type": "place", "id": 102 }
            }
        ],
        "summary": {
            "total_files": 156,
            "total_images": 120,
            "total_audio": 36,
            "total_size_mb": 156.3
        }
    }
}
```

---

## 4. Response Envelope Format

### 4.1 Success Response

```json
{
    "success": true,
    "data": { ... },
    "meta": {
        "total": 45,
        "page": 1,
        "per_page": 20,
        "total_pages": 3
    }
}
```

`meta` chỉ xuất hiện khi response là danh sách có phân trang.

### 4.2 Error Response

```json
{
    "success": false,
    "error": {
        "code": "ERROR_CODE",
        "message": "Human-readable message (theo lang)",
        "details": { ... }
    }
}
```

### 4.3 Error Codes

| HTTP Status | Code | Mô tả |
|:-----------:|------|--------|
| 400 | INVALID_PARAMS | Thiếu hoặc sai params |
| 400 | TOO_FAR | Check-in: quá xa địa điểm |
| 400 | INSUFFICIENT_BALANCE | Không đủ Hoa để unlock |
| 401 | DEVICE_NOT_REGISTERED | Chưa đăng ký device |
| 404 | NOT_FOUND | Không tìm thấy resource |
| 404 | QR_NOT_FOUND | Mã QR không hợp lệ |
| 409 | ALREADY_CHECKED_IN | Đã check-in rồi |
| 409 | ALREADY_UNLOCKED | Đã unlock rồi |
| 429 | SHARE_LIMIT_REACHED | Đã share hôm nay rồi |
| 429 | RATE_LIMITED | Quá nhiều request |
| 500 | SERVER_ERROR | Lỗi server |

---

## 5. Localization Strategy

### 5.1 Cách hoạt động

Mọi endpoint hỗ trợ param `lang=vi|en|ko|zh|fr`.

Server sẽ:
1. Lấy field theo ngôn ngữ yêu cầu (VD: `name_en`)
2. Nếu field đó rỗng → fallback sang `name_en` (English)
3. Nếu English cũng rỗng → fallback sang `name_vi` (Vietnamese, luôn có)

```
Ưu tiên: lang yêu cầu → en → vi
```

### 5.2 Response luôn trả field name chung

```json
// Request: GET /toursapp/v1/places/102?lang=ko
{
    "id": 102,
    "name": "흐몽 왕궁",           // name_ko
    "information": "...",           // info_ko hoặc fallback
    "article": "..."               // article_ko hoặc fallback
}
```

Mobile không cần biết suffix `_ko` — server đã xử lý.

---

## 6. Buckwheat Flowers — Tổng hợp cách kiếm & tiêu

### 6.1 Earn (Kiếm Hoa)

| Hành động | Số Hoa | Giới hạn | Ghi chú |
|-----------|:------:|----------|---------|
| Check-in tại Place (GPS/QR) | 10 (default, configurable per place) | 1 lần / place / device | Reward configurable qua ACF field `checkin_reward` |
| Share app (referral) | 5 | Mỗi người bạn cài app | Cả inviter + invitee đều nhận |
| Nhận referral code | 3 | 1 lần / device | Invitee nhận khi nhập code lần đầu |
| Share lên Facebook | 2 | 1 lần / ngày | Verify bằng callback hoặc trust client |
| Share lên Zalo | 2 | 1 lần / ngày | |
| Share lên Instagram | 2 | 1 lần / ngày | |
| Share lên MXH khác | 2 | 1 lần / ngày | |

### 6.2 Spend (Tiêu Hoa)

| Hành động | Số Hoa | Ghi chú |
|-----------|:------:|---------|
| Unlock article bị khóa | 5 (default, configurable) | Qua ACF field `article_cost` |
| Unlock audio bị khóa | 5 (default, configurable) | Cùng field `article_cost` |

### 6.3 Miễn phí (không cần Hoa)

- Place có `show_article_free = true` → Đọc article miễn phí
- Place có `show_audio_free = true` → Nghe audio miễn phí
- Đã check-in tại Place → Tự động unlock article + audio của Place đó

---

## 7. Hierarchical Index System

### 7.1 Cấu trúc chỉ mục

```
[Location Number].[Place Order].[Sub-place Order].[Sub-item Order]

Ví dụ:
4           = Đồng Văn (Location)
4.2         = Dinh thự Vua Mèo (Place, thứ 2 trong Đồng Văn)
4.2.1       = Cổng tam quan (Sub-place, thứ 1 trong Dinh Vua Mèo)
4.2.1.3     = Phù điêu thứ 3 (Sub-item, thứ 3 trong Cổng tam quan)
```

### 7.2 Áp dụng

| Cấp | Field | Ví dụ | Mô tả |
|-----|-------|-------|--------|
| Location | `location_number` | 4 | Số thứ tự khu vực trong tỉnh |
| Place | `place_order_number` | 2 | Số thứ tự địa điểm trong khu vực |
| Sub-place | `sub_place_index` | 4.2.1 | Chỉ mục đầy đủ |
| Sub-item | `sub_item_index` | 4.2.1.3 | Chỉ mục đầy đủ |

API response sẽ kèm field `hierarchical_index` cho mỗi entity.

---

## 8. Offline Strategy

### 8.1 Flow tải offline

```
Mobile App                                Server
    │                                        │
    ├── GET /sync/check?since=...  ────────► │
    │ ◄──────────────── has_updates, sizes   │
    │                                        │
    ├── GET /sync/package/{province_id} ───► │
    │ ◄──────── Full JSON data + media URLs  │
    │                                        │
    │  [Download từng file media]            │
    ├── GET /uploads/audio/vua-meo-vi.mp3 ─► │
    ├── GET /uploads/images/vua-meo.jpg ───► │
    │ ◄───────────────────── binary files     │
    │                                        │
    │  [Lưu local SQLite + file cache]       │
    │  [Ghi sync_version timestamp]          │
    │                                        │
    │  === OFFLINE MODE ===                  │
    │  Đọc từ local DB + local files         │
    │  Không cần internet                    │
    │                                        │
    │  === ONLINE AGAIN ===                  │
    ├── GET /sync/check?since=last_sync ───► │
    │ ◄──────── incremental changes only     │
    └────────────────────────────────────────┘
```

### 8.2 Lưu ý

- Offline package chỉ chứa data text + URL media. App tải media riêng.
- `checksum` dùng để verify file không bị corrupt khi tải.
- Incremental sync: chỉ tải data thay đổi từ `since` timestamp.
- User actions (check-in, unlock) khi offline → queue local, sync khi online.

---

## 9. WordPress Plugin Structure

```
wp-content/plugins/toursapp-api/
├── toursapp-api.php              # Plugin main file
├── includes/
│   ├── class-ta-activator.php    # Create custom tables on activate
│   ├── class-ta-api.php          # REST API registration
│   ├── class-ta-auth.php         # Device UUID authentication
│   ├── class-ta-localize.php     # Localization helper
│   ├── class-ta-geo.php          # GPS distance calculation
│   │
│   ├── endpoints/
│   │   ├── class-ta-provinces.php
│   │   ├── class-ta-locations.php
│   │   ├── class-ta-places.php
│   │   ├── class-ta-sub-places.php
│   │   ├── class-ta-sub-items.php
│   │   ├── class-ta-journeys.php
│   │   ├── class-ta-user-journeys.php
│   │   ├── class-ta-checkin.php
│   │   ├── class-ta-wallet.php
│   │   ├── class-ta-share.php
│   │   ├── class-ta-news.php
│   │   └── class-ta-sync.php
│   │
│   └── models/
│       ├── class-ta-device-model.php
│       ├── class-ta-wallet-model.php
│       ├── class-ta-checkin-model.php
│       └── class-ta-journey-model.php
│
└── assets/
    └── (nếu cần)
```

---

*Tài liệu này là bản thiết kế API v1.0 cho ToursApp.*
*Cập nhật: 2026-06-13*
