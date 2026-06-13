# API Endpoints — Master Reference

> **Namespace:** `toursapp/v1`  
> **Base URL:** `https://{domain}/wp-json/toursapp/v1`  
> **Total:** 50 endpoints  
> **Auth header:** `X-Device-UUID: <uuid>` (🔒 = required, 🔓 = optional enrichment)

This file is the single source of truth. Every endpoint listed here must exist in PHP code, and every registered route must appear here.

---

## Quick Index

| # | Method | Path | Auth | PHP File |
|---|--------|------|------|----------|
| 1 | POST | `/device/register` | Public | class-ta-ep-device.php |
| 2 | GET | `/provinces` | Public | class-ta-ep-provinces.php |
| 3 | GET | `/provinces/detect` | Public | class-ta-ep-provinces.php |
| 4 | GET | `/provinces/{id}` | Public | class-ta-ep-provinces.php |
| 5 | GET | `/provinces/{province_id}/locations` | Public | class-ta-ep-locations.php |
| 6 | GET | `/locations/{id}` | Public | class-ta-ep-locations.php |
| 7 | GET | `/places` | Public | class-ta-ep-places.php |
| 8 | GET | `/places/{id}` | 🔓 optional UUID | class-ta-ep-places.php |
| 9 | GET | `/places/nearby` | Public | class-ta-ep-places.php |
| 10 | GET | `/places/qr/{code}` | Public | class-ta-ep-places.php |
| 11 | GET | `/places/search` | Public | class-ta-ep-places.php |
| 12 | GET | `/places/{place_id}/sub-places` | Public | class-ta-ep-sub-places.php |
| 13 | GET | `/sub-places/{id}` | Public | class-ta-ep-sub-places.php |
| 14 | GET | `/sub-items/{id}` | Public | class-ta-ep-sub-items.php |
| 15 | GET | `/journeys` | Public | class-ta-ep-journeys.php |
| 16 | GET | `/journeys/{id}` | Public | class-ta-ep-journeys.php |
| 17 | GET | `/stories` | Public | class-ta-ep-stories.php |
| 18 | GET | `/stories/{id}` | Public | class-ta-ep-stories.php |
| 19 | GET | `/news` | Public | class-ta-ep-news.php |
| 20 | GET | `/content/{type}/{id}/comments` | Public | class-ta-ep-comments.php |
| 21 | POST | `/content/{type}/{id}/comments` | 🔒 Device UUID | class-ta-ep-comments.php |
| 22 | PUT | `/content/{type}/{id}/comments/{cid}` | 🔒 Device UUID | class-ta-ep-comments.php |
| 23 | DELETE | `/content/{type}/{id}/comments/{cid}` | 🔒 Device UUID | class-ta-ep-comments.php |
| 24 | GET | `/content/{type}/{id}/rating` | Public | class-ta-ep-comments.php |
| 25 | POST | `/content/{type}/{id}/rating` | 🔒 Device UUID | class-ta-ep-comments.php |
| 26 | POST | `/user/upload-photo` | 🔒 Device UUID | class-ta-ep-comments.php |
| 27 | GET | `/analytics/content/{id}` | Public | class-ta-ep-engagement.php |
| 28 | GET | `/analytics/top-content` | Public | class-ta-ep-engagement.php |
| 29 | POST | `/user/track` | 🔒 Device UUID | class-ta-ep-engagement.php |
| 30 | POST | `/user/checkin` | 🔒 Device UUID | class-ta-ep-checkin.php |
| 31 | POST | `/user/unlock` | 🔒 Device UUID | class-ta-ep-checkin.php |
| 32 | GET | `/user/history` | 🔒 Device UUID | class-ta-ep-checkin.php |
| 33 | GET | `/user/wallet` | 🔒 Device UUID | class-ta-ep-wallet.php |
| 34 | POST | `/user/share` | 🔒 Device UUID | class-ta-ep-share.php |
| 35 | POST | `/user/referral/redeem` | 🔒 Device UUID | class-ta-ep-share.php |
| 36 | GET | `/user/journeys` | 🔒 Device UUID | class-ta-ep-user-journeys.php |
| 37 | POST | `/user/journeys` | 🔒 Device UUID | class-ta-ep-user-journeys.php |
| 38 | POST | `/user/journeys/{id}` | 🔒 Device UUID | class-ta-ep-user-journeys.php |
| 39 | PUT | `/user/journeys/{id}` | 🔒 Device UUID | class-ta-ep-user-journeys.php |
| 40 | PATCH | `/user/journeys/{id}` | 🔒 Device UUID | class-ta-ep-user-journeys.php |
| 41 | DELETE | `/user/journeys/{id}` | 🔒 Device UUID | class-ta-ep-user-journeys.php |
| 42 | GET | `/user/features` | 🔒 Device UUID | class-ta-ep-features.php |
| 43 | GET | `/user/features/{feature}` | 🔒 Device UUID | class-ta-ep-features.php |
| 44 | POST | `/user/features/{feature}/unlock` | 🔒 Device UUID | class-ta-ep-features.php |
| 45 | GET | `/user/downloads` | 🔒 Device UUID | class-ta-ep-downloads.php |
| 46 | POST | `/user/downloads/start` | 🔒 Device UUID | class-ta-ep-downloads.php |
| 47 | POST | `/user/downloads/complete` | 🔒 Device UUID | class-ta-ep-downloads.php |
| 48 | GET | `/sync/check` | Public | class-ta-ep-sync.php |
| 49 | GET | `/sync/package/{province_id}` | Public | class-ta-ep-sync.php |
| 50 | GET | `/sync/media/{province_id}` | Public | class-ta-ep-sync.php |

> **#38 POST `/user/journeys/{id}`** — từ `WP_REST_Server::EDITABLE` (= POST, PUT, PATCH). Dùng PUT trong thực tế, POST/PATCH là alias WordPress tự thêm.  
> **`{type}`** trong `/content/{type}/...` = `place` | `story` | `sub_place` | `sub_item`

---

## Endpoint Details

### 1 — POST /device/register

Register or update a device.

**Params:**

| Param | Req | Type | Notes |
|-------|-----|------|-------|
| `device_uuid` | ✓ | string | Persistent UUID generated on device |
| `device_name` | | string | e.g. "Samsung Galaxy S24" |
| `platform` | | string | `android` \| `ios` |
| `app_version` | | string | e.g. "1.2.0" |
| `lang` | | string | Preferred content language |
| `push_token` | | string | FCM / APNs token |
| `referral_code` | | string | Invitation code from another device |

**Response:** `{ is_new, wallet_balance, referral_code }`

---

### 2 — GET /provinces

List all active provinces.

**Params:** `lang`

**Response fields:** `id`, `name`, `feature_image`, `latitude`, `longitude`, `detection_radius_km`, `is_active`, `total_locations`, `total_places`, `sort_order`

---

### 3 — GET /provinces/detect

Detect province by GPS coordinates.

**Params:** `lat`✓, `lng`✓, `lang`

**Response:**
- Detected: `{ detected: true, province: { ...fields, distance_km } }`
- Not detected: `{ detected: false, province: null, available_provinces: [...] }`

---

### 4 — GET /provinces/{id}

Province detail with description and banners.

**Params:** `lang`, `include` (comma-separated: `locations`, `featured_places`, `news`)

**Response fields:** All list fields + `description`, `banner_images`

---

### 5 — GET /provinces/{province_id}/locations

List locations in a province.

**Params:** `lang`, `sort` (`location_number` \| `name` \| `distance`), `lat`, `lng`

**Response fields (compact):** `id`, `number`, `name`, `feature_image`, `latitude`, `longitude`, `total_places`, `sort_order` + optional `distance_km`

---

### 6 — GET /locations/{id}

Location detail.

**Params:** `lang`, `include` (`places`)

**Response fields:** All compact fields + `description`, `province` (id, name)

---

### 7 — GET /places

List places with filters.

**Params:** `province_id`, `location_id`, `lang`, `featured`, `search`, `sort` (`sort_order` \| `name` \| `distance` \| `place_order_number`), `lat`, `lng`, `page`, `per_page`

**Response fields (compact):** `id`, `order_number`, `name`, `info`, `feature_image`, `latitude`, `longitude`, `is_featured`, `sort_order`, `sub_places_count` + optional `distance_km`

---

### 8 — GET /places/{id}

Full place detail. Accepts optional `X-Device-UUID` for `user_status`.

**Params:** `lang`, `include` (`sub_places` \| `sub_items`)

**Response fields:** `id`, `hierarchical_index`, `order_number`, `name`, `info`, `article`, `feature_image`, `gallery`, `audio` (url, size, duration), `latitude`, `longitude`, `geofence_radius`, `qr_code`, `is_featured`, `show_article_free`, `show_audio_free`, `article_offline`, `audio_offline`, `article_cost`, `checkin_reward`, `sort_order`, `location` (id, number, name), `user_status`

`user_status`: `{ is_checked_in, is_article_unlocked, is_audio_unlocked }` — `null` when no UUID header.

---

### 9 — GET /places/nearby

Places within GPS radius.

**Params:** `lat`✓, `lng`✓, `radius` (meters, default 1000), `province_id`, `limit` (default 10), `lang`

**Response fields:** `id`, `name`, `feature_image`, `latitude`, `longitude`, `distance_meters`, `geofence_radius`, `is_within_geofence`, `has_audio`, `is_featured`, `sort_order`

---

### 10 — GET /places/qr/{code}

Look up place by QR code string.

**Response:** Full place detail (same as #8 without optional includes).

---

### 11 — GET /places/search

Full-text keyword search.

**Params:** `q`✓, `province_id`, `lang`, `page`, `per_page`

**Response fields:** `id`, `name`, `info`, `feature_image`, `latitude`, `longitude`, `is_featured`, `sort_order`, `match_score` (1 = one field, 2 = name + info both match)

---

### 12 — GET /places/{place_id}/sub-places

List sub-places for a place (compact).

**Params:** `lang`

**Response fields:** `id`, `sub_place_index`, `name`, `feature_image`, `latitude`, `longitude`, `sort_order`, `sub_items` (compact: id, item_index, name, feature_image, sort_order)

---

### 13 — GET /sub-places/{id}

Sub-place detail with description, audio, full sub-items.

**Params:** `lang`

**Response fields:** All compact fields + `description`, `audio` (url, duration), `place` (id, name), `sub_items` (full: + gallery, audio, description)

---

### 14 — GET /sub-items/{id}

Sub-item detail (standalone, for deep linking).

**Params:** `lang`

**Response fields:** `id`, `item_index`, `name`, `description`, `feature_image`, `gallery`, `audio`, `sort_order`, `sub_place` (id, name), `place` (id, name)

---

### 15 — GET /journeys

List preset journeys.

**Params:** `province_id`✓, `featured`, `lang`

---

### 16 — GET /journeys/{id}

Preset journey detail (same fields as list).

**Params:** `lang`

**Response fields:** `id`, `type` (`"preset"`), `name`, `description`, `feature_image`, `duration_days`, `total_places`, `difficulty`, `is_featured`, `sort_order`, `stops`

Stop object: `{ stop_order, day, duration_min, place: { id, name, lat, lng }, note }`

---

### 17 — GET /stories

List stories with filters.

**Params:** `province_id`, `place_id`, `type` (`legend` \| `history` \| `culture` \| `folk` \| `mystery` \| `nature` \| `other`), `featured`, `lang`, `page`, `per_page`

**Response fields (compact):** `id`, `type`, `name`, `summary`, `feature_image`, `is_featured`, `sort_order`, `article` (is_free, cost), `audio_info` (is_free, cost, duration), `allow_comments`, `allow_ratings`, `enable_tracking`

---

### 18 — GET /stories/{id}

Story detail.

**Params:** `lang`

**Response fields:** All compact fields + `content`, `audio` (url, size), `related_places`, `related_provinces`

---

### 19 — GET /news

List news/alerts.

**Params:** `province_id`✓, `type` (`news` \| `alert` \| `warning` \| `event`), `lang`, `page`, `per_page`

**Response fields:** `id`, `type`, `title`, `content`, `icon`, `is_pinned`, `start_date`, `end_date`, `created_at`

Sorted: pinned first, then `created_at` DESC. Only active items (`start_date ≤ today ≤ end_date`).

---

### 20 — GET /content/{type}/{id}/comments

List approved comments. `{type}` = `place` | `story` | `sub_place` | `sub_item`

---

### 21 — POST /content/{type}/{id}/comments 🔒

Post a comment. Max 10/device/day.

**Params:** `comment_text`✓ (max 1000 chars), `photo_id`

---

### 22 — PUT /content/{type}/{id}/comments/{cid} 🔒

Edit own comment.

**Params:** `comment_text`✓

---

### 23 — DELETE /content/{type}/{id}/comments/{cid} 🔒

Delete own comment.

---

### 24 — GET /content/{type}/{id}/rating

Rating summary and distribution.

**Response:** `{ average, total, distribution: { "1": N, ... "5": N }, your_rating }`

`your_rating` = `null` when no UUID header.

---

### 25 — POST /content/{type}/{id}/rating 🔒

Submit or update a rating (replaces previous).

**Params:** `rating`✓ (integer 1–5)

---

### 26 — POST /user/upload-photo 🔒

Upload photo for comment attachment. Max 2MB, accepts jpeg/png/webp.

**Response:** `{ photo_id, url }`

---

### 27 — GET /analytics/content/{id}

Engagement stats for one content item.

**Params:** `content_type`✓ (`place` \| `story` \| `sub_place` \| `sub_item`), `since`

**Response:** `{ total_views, unique_devices, avg_read_time_sec, avg_audio_completion_pct, total_shares }`

---

### 28 — GET /analytics/top-content

Ranked content by engagement metric.

**Params:** `content_type`, `event_type`, `metric` (`views` \| `unique` \| `read_time` \| `completion` \| `shares`, default `views`), `order` (default `DESC`), `limit` (default 10), `since`

---

### 29 — POST /user/track 🔒

Record a content interaction event. Only records if `{type}_enable_tracking` = ON.

**Params:** `content_type`✓, `content_id`✓, `event_type`✓ (`page_view` \| `article_read` \| `audio_play` \| `audio_complete` \| `share`), `duration_sec`, `scroll_depth` (0–100), `completion_pct` (0–100)

---

### 30 — POST /user/checkin 🔒

Check in at a place.

**Params:** `place_id`✓, `method`✓ (`gps` \| `qr`), `latitude`, `longitude`, `qr_code`

GPS validates within `place_geofence_radius` meters. One check-in per device per place.

**Response:** `{ checkin_id, flowers_earned, new_balance }`

---

### 31 — POST /user/unlock 🔒

Unlock paid content with Buckwheat Flowers.

**Params:** `content_type`✓ (`article` \| `audio`), `content_id`✓

Supported post types: `place`, `sub_place`, `ta_story`

**Response:** `{ content_type, content_id, flowers_spent, new_balance }`

---

### 32 — GET /user/history 🔒

Check-in history and stats for this device.

---

### 33 — GET /user/wallet 🔒

Wallet balance and last 10 transactions.

**Response:** `{ balance, transactions: [{ type, amount, balance_after, description, created_at }] }`

---

### 34 — POST /user/share 🔒

Record a social share (+2 flowers/platform/day).

**Params:** `platform`✓ (`facebook` \| `instagram` \| `tiktok` \| `zalo` \| `other`), `content_type`, `content_id`

---

### 35 — POST /user/referral/redeem 🔒

Redeem invitation referral code (one-time per device).

**Params:** `referral_code`✓

On success: invitee +3, inviter +5 flowers.

---

### 36 — GET /user/journeys 🔒

List custom journeys for this device.

**Params:** `province_id`, `status`

**Response fields:** `id`, `type` (`"user"`), `name`, `description`, `province_id`, `source_journey_id`, `status`, `total_places`, `visited_count`, `progress_percent`, `stops`, `created_at`, `updated_at`

---

### 37 — POST /user/journeys 🔒

Create a custom journey. Free plan: max 5 journeys.

**Params:** `name`✓, `province_id`, `description`, `source_journey_id`, `stops`

Returns `403 journey_limit_reached` with `{ limit, current, feature }` when at cap.

---

### 38-40 — POST / PUT / PATCH /user/journeys/{id} 🔒

Update a custom journey (`WP_REST_Server::EDITABLE` = POST + PUT + PATCH, all handled identically).

**Params:** `name`, `description`, `status`, `stops`

> Use **PUT** in practice. POST and PATCH are WordPress aliases from the EDITABLE constant.

---

### 41 — DELETE /user/journeys/{id} 🔒

Delete own journey.

---

### 42 — GET /user/features 🔒

List all premium features with current access status.

**Response:** `[{ feature, label, enabled, mode, has_access, cost?, achievement? }]`

---

### 43 — GET /user/features/{feature} 🔒

Single feature status with progress detail.

**Available slugs:** `cross_province`, `unlimited_journeys`

---

### 44 — POST /user/features/{feature}/unlock 🔒

Unlock paid feature or verify achievement progress.

Modes: `free` (auto), `paid` (deduct flowers), `achievement` (check check-in count).

---

### 45 — GET /user/downloads 🔒

List download history for this device.

---

### 46 — POST /user/downloads/start 🔒

Record start of province offline download.

**Params:** `province_id`✓, `download_type` (`full` \| `incremental` \| `media_only`), `lang`

**Response:** `{ download_id }`

---

### 47 — POST /user/downloads/complete 🔒

Mark download as finished.

**Params:** `download_id`✓, `file_count`, `total_size_mb`, `status` (`completed` \| `partial` \| `failed`)

---

### 48 — GET /sync/check

Check whether offline data is stale.

**Params:** `province_id`✓, `since`✓ (ISO 8601)

**Response:** `{ has_updates, last_modified, changes: { provinces, locations, places, sub_places, sub_items, journeys, news }, estimated_download_size_mb }`

---

### 49 — GET /sync/package/{province_id}

Full offline data bundle (text + structure).

**Params:** `lang`, `since` (ISO 8601 — omit for full sync), `include_media_urls` (bool, default true)

**Response sections:** `province`, `locations`, `places`, `sub_places`, `sub_items`, `journeys`, `news`, `media_manifest`, `sync_version`, `total_media_size_mb`

> Field naming differs from online API in sync package — see [offline-sqlite.md](guides/offline-sqlite.md) for mapping table.

---

### 50 — GET /sync/media/{province_id}

Media file manifest (images + audio URLs, sizes, checksums).

**Params:** `type` (`all` \| `images` \| `audio`), `lang`, `since` (ISO 8601)

**Response:** `{ files: [{ type, url, size_bytes, checksum, related_type, related_id }], total_files, total_size_mb }`
