# 01 — Vấn đề & Giải pháp / Problem & Solution

> Tại sao cần "Tour Guide trong túi" — và nó giải quyết vấn đề gì cho du khách Hà Giang?

---

[<< 00 Overview](00-overview.md) | **01 Problem & Solution** | [02 Tech Stack >>](02-tech-stack.md)

| # | Tài liệu | Link |
|---|----------|------|
| 00 | Tổng quan | [00-overview.md](00-overview.md) |
| 01 | **Vấn đề & Giải pháp (đang xem)** | — |
| 02 | Tech Stack | [02-tech-stack.md](02-tech-stack.md) |
| 03 | Kiến trúc hệ thống | [03-system-architecture.md](03-system-architecture.md) |
| 04 | Database Design | [04-database-design.md](04-database-design.md) |

---

## 1. Phát biểu vấn đề / Problem Statement

### 1.1 Bối cảnh — Hà Giang

Hà Giang là một trong những điểm du lịch hấp dẫn nhất Việt Nam: Cao nguyên đá Đồng Văn (UNESCO Global Geopark), đèo Mã Pí Lèng, sông Nho Quế, chợ phiên Đồng Văn... Mỗi năm có hàng trăm nghìn du khách trong nước và quốc tế.

**Nhưng du khách đến Hà Giang đang gặp 5 vấn đề lớn:**

### 1.2 Năm vấn đề cốt lõi

```
┌─────────────────────────────────────────────────────────────────┐
│                   5 VẤN ĐỀ CỐT LÕI                            │
│                                                                 │
│  P1  THIẾU HƯỚNG DẪN VIÊN — Vấn đề số 1                       │
│      → Nhiều điểm du lịch không đủ guide man. Khách đi tự do   │
│        đến đỉnh Mã Pí Lèng, chỉ thấy tấm biển nhỏ bằng       │
│        tiếng Việt. Không ai kể câu chuyện lịch sử, văn hóa.   │
│        Họ MISS thông tin quan trọng mà guide sẽ giới thiệu.    │
│                                                                 │
│  P2  Kết nối internet yếu/không có                              │
│      → Trên đèo Mã Pí Lèng, qua Sủng Là, Lũng Cú —           │
│        4G gần như không có. Google Maps không load được.         │
│                                                                 │
│  P3  Rào cản ngôn ngữ                                          │
│      → Đa số thông tin chỉ bằng tiếng Việt. Du khách Hàn,     │
│        Trung, Tây không đọc được menu, biển chỉ đường.         │
│                                                                 │
│  P4  Thông tin dịch vụ nằm rải rác                              │
│      → Homestay, quán ăn, tiệm sửa xe — nằm trên Facebook     │
│        groups, TripAdvisor, blog cá nhân. Không tập trung.     │
│                                                                 │
│  P5  Không có cách dễ dàng ghi lại hành trình                  │
│      → Du khách muốn ghi lại timeline chuyến đi, nhưng phải   │
│        dùng 3-4 app khác nhau (camera, notes, maps, social).   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 1.3 Tác động cụ thể

| Vấn đề | Tác động lên du khách | Tác động lên địa phương |
|--------|----------------------|------------------------|
| **Thiếu guide man** | **Bỏ lỡ giá trị văn hóa, lịch sử, câu chuyện bản địa** | **Điểm tham quan bị đánh giá "nhạt", khách không quay lại** |
| Mất kết nối | Lạc đường, không gọi được cứu hộ | Không quảng bá được dịch vụ online |
| Rào cản ngôn ngữ | Khó giao tiếp, đặt sai món, hiểu sai chỉ dẫn | Mất khách quốc tế |
| Thông tin rải rác | Tốn thời gian tìm kiếm, dễ bị lừa giá | Doanh nghiệp nhỏ không tiếp cận được khách |
| Không ghi hành trình | Thiếu kỷ niệm, không share được dễ dàng | Ít word-of-mouth marketing |

---

## 2. Phân tích thị trường / Market Analysis

### 2.1 Ba loại app du lịch hiện tại

Thị trường app du lịch hiện tại chia thành 3 nhóm rõ rệt, **không nhóm nào kết hợp tốt cả 3**:

```
        Audio Guide Apps          Travel Journal Apps         Local Service Apps
       ┌──────────────┐         ┌──────────────┐           ┌──────────────┐
       │ SmartGuide   │         │ Polarsteps   │           │ Google Maps  │
       │ VoiceMap     │         │ FindPenguins │           │ TripAdvisor  │
       │ PocketGuide  │         │ Day One      │           │ Booking.com  │
       │ izi.TRAVEL   │         │ Journi       │           │ Traveloka    │
       └──────────────┘         └──────────────┘           └──────────────┘
              │                        │                          │
              ▼                        ▼                          ▼
       Chỉ phát audio             Chỉ ghi chép              Chỉ tìm dịch vụ
       tại điểm tham quan         hành trình                 không có audio/journal
       Không ghi hành trình       Không có audio guide       Cần internet liên tục
       Ít offline support         Ít dịch vụ local           Không phù hợp vùng sâu
```

### 2.2 Phân tích đối thủ / Competitor Analysis

| Tiêu chí | SmartGuide | VoiceMap | PocketGuide | Polarsteps | FindPenguins | **ToursApp** |
|----------|:----------:|:--------:|:-----------:|:----------:|:------------:|:------------:|
| **Audio guide** | Yes | Yes | Yes | No | No | **Yes** |
| **GPS autoplay** | Yes | Yes | Partial | No | No | **Yes (P2)** |
| **Travel journal** | No | No | No | Yes | Yes | **Yes (P3)** |
| **Local services** | No | No | No | No | No | **Yes** |
| **Offline maps** | Partial | Download | Partial | No | No | **Yes** |
| **Offline audio** | Download | Download | No | — | — | **Yes** |
| **Đa ngôn ngữ** | Theo content | Theo content | 3 ngôn ngữ | 10+ | 10+ | **4 (Vi/En/Ko/Zh)** |
| **Hà Giang content** | Rất ít | Không có | Không có | Không có | Không có | **Có (focus)** |
| **Free tier** | Limited | Paid/tour | Free/ads | Free | Free/premium | **Free (P1)** |
| **Business model** | B2B + B2C | Per-tour fee | Freemium | Freemium | Freemium | **Freemium (P4)** |

#### Phân tích chi tiết từng đối thủ

**SmartGuide** (smartguide.org)
- Mạnh: GPS-triggered audio, B2B platform cho destination managers
- Yếu: Không có journal, không có local services, ít content châu Á
- Content Hà Giang: Gần như không có

**VoiceMap** (voicemap.me)
- Mạnh: Chất lượng audio cao (narrator chuyên nghiệp), GPS walking tours
- Yếu: Mô hình per-tour fee (2-10 USD/tour), không free, không journal
- Content Hà Giang: Không có

**PocketGuide** (pocketguideapp.com)
- Mạnh: GPS-triggered, 3 ngôn ngữ tích hợp
- Yếu: UI cũ, content chủ yếu châu Âu, offline yếu
- Content Hà Giang: Không có

**Polarsteps** (polarsteps.com)
- Mạnh: Auto-tracking GPS tuyệt vời, travel journal đẹp, export book
- Yếu: Không có audio guide, không có local services, cần internet để sync
- Content Hà Giang: User-generated (không curated)

**FindPenguins** (findpenguins.com)
- Mạnh: Travel journal + travel book export, community
- Yếu: Giống Polarsteps — không audio, không services
- Content Hà Giang: User-generated (rất ít)

---

## 3. Giải pháp / Solution

### 3.1 "Tour Guide trong túi" — All-in-one Tourist Companion

```
┌─────────────────────────────────────────────────────────────────┐
│              GIẢI PHÁP: "Tour Guide trong túi"                │
│                                                                 │
│  Vấn đề P1 (Không audio)     → QR Scan → Audio Guide (Phase 1) │
│                                 GPS Autoplay (Phase 2)          │
│                                                                 │
│  Vấn đề P2 (Mất kết nối)    → Offline-first architecture       │
│                                 Download map + audio + data     │
│                                                                 │
│  Vấn đề P3 (Ngôn ngữ)       → 4 ngôn ngữ: Vi / En / Ko / Zh   │
│                                 Audio guide song ngữ            │
│                                                                 │
│  Vấn đề P4 (Thông tin rải)  → Service Provider directory       │
│                                 Filters: loại, khoảng cách, giá│
│                                                                 │
│  Vấn đề P5 (Ghi hành trình) → Trip Timeline (Phase 3)          │
│                                 Auto GPS track + photo + notes  │
│                                 Export PDF travel book           │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Hành trình người dùng mẫu / Sample User Journey

```
Sáng: Xuất phát từ Hà Giang city
  │
  ├─ Mở app → xem bản đồ → thấy các điểm trên route "Vòng cung đông"
  ├─ Download offline package (map tiles + audio + data) qua WiFi homestay
  │
  ▼
Trên đường đèo (không có 4G):
  │
  ├─ [P1] Đến Dinh vua Mèo → quét QR → nghe audio guide (offline)
  ├─ [P2] GPS autoplay: gần Mã Pí Lèng → tự động phát audio
  ├─ [P3] Auto-record GPS track vào timeline
  ├─ Xem service providers gần: homestay, quán ăn (offline data)
  │
  ▼
Tối: Về homestay (có WiFi):
  │
  ├─ [P3] Thêm ảnh, ghi chú vào timeline hôm nay
  ├─ App auto-sync data lên cloud
  ├─ Xem bài viết "Tips đèo Mã Pí Lèng" trong mục Articles
  └─ Share timeline lên Facebook/Instagram
```

---

## 4. User Personas

### 4.1 Persona A — Phượt thủ có kinh nghiệm (Hardcore Backpacker)

```
┌─────────────────────────────────────────────────────┐
│  MINH, 28 tuổi — Software Engineer, TP.HCM          │
│                                                      │
│  "Tôi muốn tự do khám phá, không muốn bị làm phiền │
│   bởi thông báo thừa. Chỉ cần thông tin đúng lúc."  │
│                                                      │
│  Kinh nghiệm: Đã đi Hà Giang 3 lần                 │
│  Phương tiện: Xe máy, một mình hoặc nhóm nhỏ        │
│  Tech: iPhone 13, dùng nhiều app                     │
│                                                      │
│  NEEDS:                                              │
│  ✓ Hands-free audio khi lái xe máy                   │
│  ✓ Offline maps + data (đèo không có 4G)             │
│  ✓ Tiết kiệm pin (cả ngày trên đường)               │
│  ✓ Điểm ẩn, off-the-beaten-path                     │
│  ✓ GPS tracking tự động (không muốn bấm liên tục)   │
│                                                      │
│  PAIN POINTS:                                        │
│  ✗ Pin điện thoại cạn nhanh vì GPS liên tục          │
│  ✗ Quá nhiều notification làm mất tập trung          │
│  ✗ App nào cũng yêu cầu tạo account mới dùng được   │
│                                                      │
│  APP USAGE (dự kiến):                                │
│  Phase 1: Map + offline + audio (QR tại điểm)        │
│  Phase 2: GPS autoplay (core feature cho persona)    │
│  Phase 3: Auto GPS tracking + export                 │
└─────────────────────────────────────────────────────┘
```

### 4.2 Persona B — Khách du lịch lần đầu (Newbie Tourist)

```
┌─────────────────────────────────────────────────────┐
│  SARAH, 32 tuổi — Marketing Manager, Seoul          │
│                                                      │
│  "Tôi chưa đến Việt Nam bao giờ. Muốn biết mọi thứ│
│   — an toàn, ăn gì, ở đâu, cần mang gì."           │
│                                                      │
│  Kinh nghiệm: Lần đầu đến Hà Giang                 │
│  Phương tiện: Easy Rider (người lái thuê)            │
│  Tech: Samsung Galaxy S24, chụp ảnh nhiều           │
│                                                      │
│  NEEDS:                                              │
│  ✓ Thông tin an toàn (SOS, bệnh viện, công an)      │
│  ✓ Audio guide bằng tiếng Hàn                        │
│  ✓ Gợi ý route phù hợp (3-4 ngày)                   │
│  ✓ Homestay và quán ăn có review                     │
│  ✓ Chia sẻ hành trình lên Instagram/KakaoTalk       │
│                                                      │
│  PAIN POINTS:                                        │
│  ✗ Không đọc được tiếng Việt                         │
│  ✗ Quá nhiều thông tin, không biết chọn gì           │
│  ✗ Sợ bị lạc trên đèo, không ai giúp                │
│  ✗ Alert fatigue — quá nhiều app thông báo           │
│                                                      │
│  APP USAGE (dự kiến):                                │
│  Phase 1: Routes + services + audio (Korean)         │
│  Phase 2: GPS alerts (smart, không spam)             │
│  Phase 3: Travel journal + share                     │
└─────────────────────────────────────────────────────┘
```

---

## 5. Điểm khác biệt cốt lõi / Key Differentiators

| # | Differentiator | Chi tiết | Phase |
|---|---------------|---------|:-----:|
| 1 | **All-in-one** | Audio Guide + Journal + Services trong 1 app (đối thủ chỉ có 1) | P1-P3 |
| 2 | **Offline-first** | Map tiles + audio + data hoạt động 100% offline | P1 |
| 3 | **GPS Autoplay** | Tự động phát audio khi đến gần điểm tham quan — hands-free | P2 |
| 4 | **Alert Intelligence** | Thông báo thông minh: cooldown, speed-aware, priority, battery-aware | P2 |
| 5 | **Travel Timeline** | Tự động ghi lại hành trình (GPS + photo + audio + notes) | P3 |
| 6 | **4 ngôn ngữ** | Tiếng Việt, English, 한국어, 中文 — cả UI và audio content | P1 |
| 7 | **Hà Giang focus** | Nội dung chuyên sâu cho Hà Giang (đối thủ không có) | P1 |
| 8 | **Không cần auth (P1)** | Dùng ngay, không cần tạo tài khoản — giảm friction | P1 |
| 9 | **AI Content Pipeline** | GPT + TTS tạo audio guide tự động từ text (Phase 2/5) | P2/P5 |
| 10 | **Export Travel Book** | Xuất hành trình thành PDF book đẹp để in hoặc share | P3 |

---

## 6. Phân tích rủi ro & Giải pháp / Risks and Mitigations

### 6.1 Rủi ro kỹ thuật

| Rủi ro | Mức độ | Giải pháp |
|--------|:------:|-----------|
| **Battery drain** do GPS liên tục | Cao | 7 kỹ thuật tối ưu pin (xem [03-system-architecture.md](03-system-architecture.md)): significant motion API, adaptive polling, geofence batching, background audio ưu tiên, kill switch khi < 15% |
| **Offline reliability** — data không đồng bộ | Trung bình | drift SQLite local → sync_queue → background sync khi có mạng. Conflict resolution: server-wins cho content, client-wins cho user data |
| **Map tile storage** lớn | Trung bình | 3-tier caching: auto (tiles đã xem), user download (route packages), online-only (zoom thấp). Limit cache size, LRU eviction |
| **Audio file size** | Thấp | Opus codec (64kbps), average 2-3 MB/file. Package download cho offline |

### 6.2 Rủi ro sản phẩm

| Rủi ro | Mức độ | Giải pháp |
|--------|:------:|-----------|
| **Content quality** — audio/bài viết chưa đủ hấp dẫn | Cao | Phase 1: human-curated, chất lượng cao cho 20-30 điểm chính. Phase 2: AI pipeline bổ sung. Community contribution (Phase 4) |
| **4-language content workload** — dịch 4 ngôn ngữ tốn nhiều công | Cao | Phase 1: Vi + En (manual). Ko + Zh: GPT translation + native speaker review. Phase 5: AI auto-translation pipeline |
| **Cold start** — ít content ban đầu | Trung bình | Focus Hà Giang trước, curated 20-30 điểm chính + 10 routes + 50 service providers. Mở rộng dần |
| **Adoption** — khó thu hút người dùng | Trung bình | Free hoàn toàn Phase 1. QR code tại điểm tham quan. Partner với homestay/tour operators |

### 6.3 Rủi ro kinh doanh

| Rủi ro | Mức độ | Giải pháp |
|--------|:------:|-----------|
| **Revenue model chưa rõ** | Trung bình | Phase 1-3 free, focus growth. Phase 4 mới monetize: freemium + provider listing + ads |
| **Đối thủ lớn nhảy vào** | Thấp | Niche market (Hà Giang), local knowledge advantage, offline-first khó copy nhanh |
| **Quy định pháp luật** | Thấp | Theo dõi luật du lịch, bản đồ, dữ liệu cá nhân. Không thu thập data nhạy cảm trong P1 |

---

## 7. Tổng kết / Summary

```
VẤN ĐỀ                          GIẢI PHÁP
─────────                        ─────────
Không audio guide         →      QR → Audio (P1) + GPS Autoplay (P2)
Mất kết nối               →      Offline-first architecture
Rào cản ngôn ngữ          →      4 ngôn ngữ (Vi/En/Ko/Zh)
Thông tin rải rác          →      Service Provider directory
Không ghi hành trình       →      Trip Timeline + Export (P3)

CẠNH TRANH                       LỢI THẾ
──────────                        ──────
SmartGuide = chỉ audio    →      All-in-one (Audio + Journal + Services)
Polarsteps = chỉ journal  →      Offline-first + 4 ngôn ngữ
Google Maps = cần internet →      Hoạt động offline trên đèo
Không ai = Hà Giang focus →      Nội dung chuyên sâu + local partners
```

---

*Cập nhật lần cuối: 2026-06-08*
