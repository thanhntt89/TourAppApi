# ToursApp Backend — Tracking, Engagement & Analytics Plan

## Context

Plugin hiện tại có 9 DB tables, 8 CPTs, 14 endpoint files, 4 models. User cần bổ sung:
- **Tracking tự động** hành vi user với nội dung (bật/tắt theo từng content)
- **Comment & Rating** (bật/tắt theo từng content)  
- **Paywall per-item** cho article/audio (bật/tắt, mặc định free)
- **Offline download tracking**
- **API request logging** (tách riêng, để tối ưu API sau)
- **Content quality analytics** (tách riêng khỏi API logs, để cải thiện nội dung)

---

## Kiến trúc tổng thể

4 subsystem tách biệt:

| Subsystem | Mục đích | Table mới |
|---|---|---|
| Content Engagement | Track hành vi user + phân tích chất lượng nội dung | `ta_content_events` |
| Comments & Ratings | UGC: comment + đánh giá sao | `ta_comments`, `ta_ratings` |
| API Request Logging | Log request endpoint/thời gian/status (infra) | `ta_api_logs` |
| Download Tracking | Track offline download | `ta_downloads` |

**Tại sao tách Content Events khỏi API Logs?**
- API logs = infrastructure (endpoint nào chậm, dùng nhiều → tối ưu server)
- Content events = business analytics (bài nào đọc nhiều, audio nghe hết bao nhiêu % → cải thiện nội dung)
- Trộn lẫn = khó query, khó archive, khác lifecycle

**Paywall**: Không cần table mới — chỉ thêm ACF toggle fields. Logic unlock đã có sẵn trong `class-ta-ep-checkin.php`, chỉ mở rộng thêm story + audio cost.

---

## 5 DB Tables Mới

```sql
-- 1. Content engagement tracking (scroll depth, audio completion, etc.)
ta_content_events: id, device_uuid, content_type, content_id, event_type, 
                   duration_sec, scroll_depth(0-100), completion_pct(0-100), extra, created_at

-- 2. Comments
ta_comments: id, device_uuid, content_type, content_id, comment_text, 
             photo_id, status(approved/pending/rejected), created_at, updated_at

-- 3. Ratings (1 rating/device/content, upsert)
ta_ratings: id, device_uuid, content_type, content_id, rating(1-5), 
            created_at, updated_at  [UNIQUE: device_uuid + content_type + content_id]

-- 4. API request logs (infra-level, mọi request trong namespace toursapp/v1)
ta_api_logs: id, device_uuid, endpoint, method, status_code, response_ms, ip_address, created_at

-- 5. Download tracking
ta_downloads: id, device_uuid, province_id, download_type, lang, 
              file_count, total_size_mb, status, started_at, completed_at
```

---

## ACF Fields Mới (toggle bật/tắt)

Thêm vào tab **General** của mỗi CPT:

| CPT | Fields mới |
|---|---|
| **Place** | `place_enable_tracking`, `place_allow_comments`, `place_allow_ratings`, `place_audio_cost` |
| **Story** | `story_show_content_free`, `story_content_cost`, `story_enable_tracking`, `story_allow_comments`, `story_allow_ratings`, `story_available_offline` |
| **Sub-Place** | `sub_place_enable_tracking`, `sub_place_allow_comments`, `sub_place_allow_ratings`, `sub_place_show_audio_free`, `sub_place_audio_cost` |
| **Sub-Item** | `sub_item_enable_tracking`, `sub_item_allow_comments`, `sub_item_allow_ratings` |

Tất cả mặc định **bật** (default=1 cho toggle, default free cho paywall).

---

## 13 API Routes Mới

```
# Engagement Tracking
POST   /user/track                              [auth] — ghi event
GET    /analytics/content/{id}                   [public] — stats 1 content
GET    /analytics/top-content                    [public] — ranking

# Comments  
GET    /content/{type}/{id}/comments             [public]
POST   /content/{type}/{id}/comments             [auth] — max 5/ngày
PUT    /content/{type}/{id}/comments/{cid}       [auth] — chỉ sửa comment mình
DELETE /content/{type}/{id}/comments/{cid}       [auth]

# Ratings
GET    /content/{type}/{id}/rating               [public] — avg + distribution
POST   /content/{type}/{id}/rating               [auth] — upsert 1-5 sao

# Photo Upload (cho comment)
POST   /user/upload-photo                        [auth] — max 2MB, jpg/png/webp

# Download Tracking
POST   /user/downloads/start                     [auth]
POST   /user/downloads/complete                  [auth]
GET    /user/downloads                           [auth]
```

---

## 9 Files Mới

```
includes/
  class-ta-api-logger.php              — hook rest_pre_dispatch/rest_post_dispatch, ghi async trên shutdown
  class-ta-admin.php                   — WP Admin page: liệt kê endpoints + export CSV
  models/
    class-ta-engagement-model.php      — record(), get_content_stats(), get_top_content()
    class-ta-comment-model.php         — CRUD + rate limit check
    class-ta-rating-model.php          — upsert(), get_summary(), get_user_rating()
    class-ta-download-model.php        — start(), complete(), get_user_downloads()
  endpoints/
    class-ta-ep-engagement.php         — 3 routes
    class-ta-ep-comments.php           — 9 routes (comments + ratings + upload)
    class-ta-ep-downloads.php          — 3 routes
```

---

## Files Cần Sửa

| File | Thay đổi |
|---|---|
| `toursapp-api.php` | Version → 1.2.0, require 4 models mới + api-logger, hook logger init |
| `class-ta-activator.php` | Thêm 5 CREATE TABLE |
| `class-ta-api.php` | Require + register 3 endpoint classes mới |
| `class-ta-fields.php` | Thêm ACF toggle fields cho 4 CPTs |
| `class-ta-ep-checkin.php` | Mở rộng unlock: thêm story, audio cost riêng |
| `class-ta-ep-places.php` | Response thêm rating_summary, comment_count, toggles |
| `class-ta-ep-stories.php` | Response thêm paywall info, rating_summary, comment_count, toggles |
| `uninstall.php` | Thêm 5 table names + group key story |

---

## Thứ tự Implementation (6 phases)

| Phase | Tasks | Files |
|---|---|---|
| **A. Foundation** | DB tables + ACF fields + version bump | activator, fields, uninstall, main |
| **B. API Logger** | Logger class + hook vào main | api-logger, main |
| **C. Engagement** | Model + endpoint + register | engagement-model, ep-engagement, api, main |
| **D. Comments & Ratings** | 2 models + endpoint + extend places/stories | comment-model, rating-model, ep-comments, ep-places, ep-stories |
| **E. Paywall Extension** | Mở rộng unlock logic | ep-checkin |
| **F. Downloads** | Model + endpoint | download-model, ep-downloads, api |
| **G. Admin Panel + API Export** | Admin page liệt kê endpoints + export CSV/Excel | class-ta-admin, main |

---

## Verification

1. Activate plugin → 14 DB tables tạo đúng (9 cũ + 5 mới)
2. ACF admin → thấy toggle fields mới trên Place/Story/Sub-Place/Sub-Item edit screens
3. POST `/user/track` → row xuất hiện trong `ta_content_events`
4. Gọi bất kỳ API → row xuất hiện trong `ta_api_logs` (async, không chậm response)
5. POST comment + rating → verify CRUD đúng, rate limit 5/ngày
6. Toggle `place_allow_comments` = false → POST comment trả 403
7. Unlock story content → wallet trừ đúng cost
8. Download start/complete → tracking đúng status

---

## Phase G: Admin Panel + API Export

### Mục đích
- Trang admin trong WP để xem toàn bộ API endpoints
- Export ra CSV (mở được trong Excel) cho mobile team

### File mới: `includes/class-ta-admin.php`

Chức năng:
1. **Menu page** trong WP Admin sidebar: "ToursApp API"
2. **Bảng endpoints**: tự scan từ `rest_get_server()->get_routes()` lọc namespace `toursapp/v1`
3. Mỗi endpoint hiển thị:
   - Method (GET/POST/PUT/DELETE)
   - URL pattern (ví dụ: `/toursapp/v1/content/{type}/{id}/comments`)
   - Parameters: tên, type, required/optional, default value
   - Auth: Public hoặc Device UUID required
   - Mô tả ngắn
4. **Nút Export CSV**: tải file `toursapp-api-docs.csv` gồm tất cả thông tin trên
5. **Bật/tắt endpoint** (optional): toggle enable/disable từng route qua `wp_options`

### Cột CSV Export

```
Method | Endpoint | Auth | Parameters | Description
GET    | /toursapp/v1/provinces | Public | lang(string,optional,default:vi) | List all active provinces
POST   | /toursapp/v1/user/track | Device UUID | content_type(string,required), content_id(int,required), event_type(string,required)... | Record engagement event
```

### Wire vào main plugin

```php
// toursapp-api.php __construct()
if (is_admin()) {
    require_once TA_PLUGIN_DIR . 'includes/class-ta-admin.php';
    add_action('admin_menu', ['TA_Admin', 'register_menu']);
}
```

### Verification
- WP Admin sidebar → thấy menu "ToursApp API"
- Bấm vào → thấy bảng tất cả endpoints
- Bấm "Export CSV" → tải file, mở trong Excel đúng format

---

## Lưu ý

- `ta_content_events` sẽ phình to → sau này cần WP-Cron archive rows > 90 ngày
- API logger ghi async trên `shutdown` hook → không ảnh hưởng response time
- Comment photo: upload attachment trước, truyền ID khi tạo comment (1 ảnh/comment)
- ACF `post_object` với `multiple=1` cho story related places/provinces (many-to-many)
- Tất cả PHP 7.4 compatible, ACF Free only
