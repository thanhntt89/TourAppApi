# 10 — Lộ trình phát triển / Phase Roadmap

> **"Tour Guide trong túi"** — A talking diary for Ha Giang

---

[<< 09 Project Structure](09-project-structure.md) | **10 Phase Roadmap** | [11 DevOps & Tooling >>](11-devops-and-tooling.md)

| # | Tài liệu | Link |
|---|----------|------|
| 00 | Tổng quan | [00-overview.md](00-overview.md) |
| 01 | Vấn đề & Giải pháp | [01-problem-and-solution.md](01-problem-and-solution.md) |
| 02 | Tech Stack | [02-tech-stack.md](02-tech-stack.md) |
| 03 | Kiến trúc hệ thống | [03-system-architecture.md](03-system-architecture.md) |
| 04 | Database Design | [04-database-design.md](04-database-design.md) |
| 05 | Mobile App Architecture | [05-mobile-app-architecture.md](05-mobile-app-architecture.md) |
| 06 | Backend Services | [06-backend-services.md](06-backend-services.md) |
| 07 | Maps & Location | [07-maps-and-location.md](07-maps-and-location.md) |
| 08 | AI Integration | [08-ai-integration.md](08-ai-integration.md) |
| 09 | Cấu trúc dự án | [09-project-structure.md](09-project-structure.md) |
| 10 | **Lộ trình (đang xem)** | — |
| 11 | DevOps & Tooling | [11-devops-and-tooling.md](11-devops-and-tooling.md) |
| 12 | Cost Analysis | [12-cost-analysis.md](12-cost-analysis.md) |

---

## Tổng quan Phases

| Phase | Tên | Thời gian | Chi phí/tháng | Mục tiêu chính |
|-------|-----|-----------|---------------|-----------------|
| **1** | MVP Lean | 6-8 tuần | **$0/tháng** | GPS auto-detect → audio guide, QR backup, bản đồ, offline, admin |
| **2** | Smart Autoplay + AI Content | 4-6 tuần | ~$10-25/tháng | Alert Intelligence, background mode, AI TTS, battery opt |
| **3** | User Accounts + Travel Journal | 6-8 tuần | ~$25-50/tháng | Đăng nhập, nhật ký hành trình, yêu thích |
| **4** | Monetization | 4-6 tuần | ~$50-100/tháng | Freemium, IAP, quảng cáo, dashboard |
| **5** | AI Chatbot | 4-6 tuần | ~$75-150/tháng | RAG chatbot, voice input, AI trip planner |
| **6+** | Expansion | Ongoing | Varies | Mở rộng tỉnh, AR, cộng đồng, OTA |

---

## Phase 1 — MVP Lean (6-8 tuần, $0/tháng)

> **Mục tiêu**: Ship một app hoạt động hoàn chỉnh với audio guide, bản đồ, offline support.
> Toàn bộ dùng Supabase free tier. Không cần user accounts.

### Sprint 1: Foundation (Tuần 1-2)

**Mục tiêu**: Nền tảng kỹ thuật hoàn chỉnh, dev có thể bắt đầu build features.

| Task | Chi tiết | Estimate |
|------|----------|----------|
| Flutter project setup | `flutter create`, folder structure theo doc 09 | 2h |
| Supabase project | Tạo project, config `config.toml` | 1h |
| Database schema | Chạy migrations: locations, routes, services, articles | 4h |
| Drift local DB | Setup tables mirrors Supabase, DAOs | 6h |
| Riverpod setup | Provider scope, base notifiers | 2h |
| GoRouter config | Route definitions, deep links | 4h |
| i18n setup | ARB files (vi, en), gen-l10n pipeline | 3h |
| Theme system | Light/dark theme, colors, typography | 3h |
| Supabase client | Service wrapper, environment config | 2h |
| Base widgets | Scaffold, loading, error, empty states | 4h |
| Seed data | 10 locations Hà Giang + 2 routes + dịch vụ mẫu | 4h |

**Deliverables Sprint 1**:
- App khởi động được, có navigation giữa các tab
- Local DB hoạt động, seed data hiển thị
- Theme + i18n hoạt động (vi/en)
- Admin web build được (skeleton)

### Sprint 2: Map + Location + Audio (Tuần 3-4)

**Mục tiêu**: Core experience — xem bản đồ, chọn location, nghe audio.

| Task | Chi tiết | Estimate |
|------|----------|----------|
| flutter_map integration | Bản đồ OpenStreetMap, markers, camera | 6h |
| Map tile caching | Offline tile cache với flutter_map_tile_caching | 4h |
| Home screen | Map section + nearby list + featured banner | 6h |
| Location list screen | Danh sách, search, filter theo category | 4h |
| Location detail screen | Info card, photo gallery, description | 6h |
| Audio player | just_audio integration, play/pause/seek | 6h |
| Audio player UI | Player card, mini player persistent | 4h |
| GPS service | Lấy vị trí hiện tại, permission handling, position stream | 3h |
| **Proximity detector** | **⭐ GPS auto-detect location trong bán kính 300m → trigger audio** | **6h** |
| **Auto-play controller** | **Tự phát audio khi detect location, basic dedup (đã phát → skip)** | **4h** |
| Nearby locations | Tính khoảng cách, sort theo gần nhất | 3h |
| QR Scanner | mobile_scanner integration, scan → navigate (backup method) | 3h |
| Location detail deep link | Mở location từ QR code hoặc shared link | 2h |

**Deliverables Sprint 2**:
- ⭐ **Đứng gần địa điểm → app tự nhận diện → tự phát audio** (tính năng chính)
- Bản đồ hiển thị markers các điểm tham quan
- Nhấn marker → xem chi tiết → nghe audio
- QR scan hoạt động (phương thức backup)
- Mini player phát audio khi navigate giữa screens

### Sprint 3: Routes + Services + Content (Tuần 5-6)

**Mục tiêu**: Content đầy đủ — tuyến đường, dịch vụ, bài viết.

| Task | Chi tiết | Estimate |
|------|----------|----------|
| Route list screen | Danh sách tuyến (vòng cung, đông tây...) | 4h |
| Route detail screen | Bản đồ tuyến + polyline + điểm dừng | 6h |
| Route navigation | Chỉ đường giữa các stop, estimated time | 4h |
| Service list screen | Danh sách homestay, ăn uống, sửa xe | 4h |
| Service detail screen | Info, liên hệ, directions, ảnh | 3h |
| Service filter | Lọc theo loại, khoảng cách | 2h |
| Article list screen | Danh sách bài viết du lịch | 3h |
| Article detail screen | Rich text rendering (Markdown) | 4h |
| Featured banners | Banner carousel trên home | 3h |
| Share functionality | Share location/route/article via deep link | 3h |
| Provider layer | Tất cả providers cho routes, services, articles | 6h |

**Deliverables Sprint 3**:
- Tuyến đường với bản đồ và điểm dừng
- Danh sách dịch vụ với filter
- Bài viết du lịch
- Share deep links hoạt động

### Sprint 4: Offline + Admin + Ship (Tuần 7-8)

**Mục tiêu**: Offline hoàn chỉnh, admin panel, testing, submit app store.

| Task | Chi tiết | Estimate |
|------|----------|----------|
| Sync service | Supabase → Drift sync (initial + incremental) | 6h |
| Download manager | Download offline packs (audio + data + tiles) | 6h |
| Download UI | Settings → manage downloads, progress indicator | 4h |
| Offline detection | Connectivity listener, auto-switch online/offline | 3h |
| Offline banner | "Bạn đang offline" indicator | 1h |
| Admin dashboard | Overview stats (Flutter Web) | 4h |
| Admin CRUD locations | Create/edit/delete locations + upload images | 6h |
| Admin CRUD routes | Create/edit routes, manage stops | 4h |
| Admin CRUD articles | Rich text editor, manage articles | 4h |
| Admin audio upload | Upload audio files, assign to locations | 3h |
| Unit tests | Models, repositories, utils | 6h |
| Widget tests | Key screens + widgets | 4h |
| Integration tests | Flows: home → location → audio, offline | 4h |
| App icons + splash | Launcher icon, splash screen | 2h |
| App Store prep | Screenshots, description, metadata | 4h |
| Google Play submit | Build APK/AAB, submit internal track | 2h |
| TestFlight submit | Build IPA, submit TestFlight | 2h |

**Deliverables Sprint 4**:
- App hoạt động offline hoàn chỉnh
- Admin panel quản lý nội dung
- Test coverage > 60%
- App trên Google Play Internal + TestFlight

### Phase 1 KHÔNG bao gồm

| Tính năng | Lý do bỏ qua | Phase |
|-----------|--------------|-------|
| ❌ Smart Autoplay (alert intelligence, background, battery-aware) | Phức tạp: geofencing rules, background service | Phase 2 |
| ❌ AI Text-to-Speech | Cần OpenAI API, chi phí | Phase 2 |
| ❌ AI Translation | Cần API, review pipeline | Phase 2 |
| ❌ User accounts / đăng nhập | MVP không cần auth | Phase 3 |
| ❌ Trip recording / nhật ký hành trình | Cần auth + GPS tracking phức tạp | Phase 3 |
| ❌ Favorites / yêu thích | Cần auth | Phase 3 |
| ❌ Reviews & ratings | Cần auth + moderation | Phase 3 |
| ❌ Push notifications | Cần auth + FCM setup | Phase 3 |
| ❌ In-app purchase | Cần user base trước | Phase 4 |
| ❌ Freemium gating | Cần IAP infrastructure | Phase 4 |
| ❌ Ads / quảng cáo | Cần user base | Phase 4 |
| ❌ AI Chatbot | Phức tạp nhất, cần RAG pipeline | Phase 5 |
| ❌ AR features | Experimental, chưa cần thiết | Phase 6+ |
| ❌ Multi-province data | MVP chỉ seed Hà Giang (kiến trúc multi-province sẵn) | Phase 6+ |

---

## Phase 2 — Smart Autoplay + AI Content (4-6 tuần, ~$10-25/tháng)

> **Mục tiêu**: Nâng cấp proximity detection (Phase 1) thành smart autoplay với alert intelligence, background mode, battery optimization. Admin có thể dùng AI tạo audio + dịch nội dung.
>
> Phase 1 đã có GPS auto-detect cơ bản (foreground, simple dedup). Phase 2 thêm:

### 2.1 Smart Autoplay (nâng cấp từ Phase 1 basic proximity)

| Task | Chi tiết |
|------|----------|
| Background location | `geolocator` background mode, Android foreground service |
| Permission flow | Giải thích tại sao cần "Always" location permission |
| Notification system | Local notification khi app background: "Bạn đang gần [Location Name]" |
| Adaptive radius | Thành phố 200m, đường đèo 500m, vùng hẻo 1km |

### 2.2 Alert Intelligence System

| Tính năng | Mô tả |
|-----------|-------|
| **Cooldown** | Không trigger lại cùng location trong 30 phút |
| **Speed-aware** | Nếu đang chạy xe > 60km/h → chỉ notification, không auto-play |
| **Priority queue** | Nếu nhiều locations gần nhau → play location gần nhất / quan trọng nhất |
| **Battery-aware** | < 20% battery → giảm GPS frequency, < 10% → tắt autoplay |
| **User preference** | Toggle on/off autoplay, chỉnh radius, DND mode |

### 2.3 Battery Optimization

```
GPS Strategy:
- Foreground (app mở): High accuracy, 5s interval
- Background (app ẩn): Balanced, 30s interval
- Low battery (< 20%): Low power, 60s interval
- Charging: High accuracy luôn
```

### 2.4 AI TTS Pipeline (Admin Tool)

```
Admin Upload Text → OpenAI TTS API → Audio File → Review → Publish
                     (vi/en/ko/zh)
```

| Bước | Chi tiết |
|------|----------|
| 1. Input | Admin nhập/paste text mô tả location |
| 2. Generate | Gọi OpenAI TTS (`tts-1` model, `nova` voice) |
| 3. Languages | Generate cho mỗi ngôn ngữ (vi, en, ko, zh) |
| 4. Review | Admin nghe preview, approve hoặc regenerate |
| 5. Optimize | Convert → AAC 64kbps mono (~2.4MB/5 phút) |
| 6. Upload | Upload lên Supabase Storage |
| 7. Publish | Cập nhật location record với audio URLs |

### 2.5 AI Translation Pipeline

```
Vietnamese Content → OpenAI GPT-4o-mini → English/Korean/Chinese
                     → Human Review → Publish
```

| Bước | Chi tiết |
|------|----------|
| 1. Source | Nội dung tiếng Việt (location descriptions, articles) |
| 2. Translate | Batch translate qua GPT-4o-mini |
| 3. Context | Prompt bao gồm context du lịch Hà Giang |
| 4. Review | Admin review, edit nếu cần |
| 5. Publish | Cập nhật content đa ngôn ngữ |

---

## Phase 3 — User Accounts + Travel Journal (6-8 tuần, ~$25-50/tháng)

> **Mục tiêu**: Users có account, ghi lại hành trình, chia sẻ trải nghiệm.

### 3.1 Supabase Auth

| Task | Chi tiết |
|------|----------|
| Email/password auth | Supabase Auth basic flow |
| Social login | Google, Facebook, Apple Sign-In |
| Auth state | Riverpod AuthNotifier, auto-refresh token |
| Protected routes | GoRouter redirect guard cho authenticated screens |
| Profile setup | Avatar, display name, language preference |
| RLS policies | Row Level Security cho user-owned data |

### 3.2 User Profiles

| Tính năng | Mô tả |
|-----------|-------|
| Profile screen | Avatar, tên, stats (trips, photos, reviews) |
| Edit profile | Cập nhật thông tin, đổi ngôn ngữ |
| Privacy settings | Public/private profile |
| Account management | Đổi password, xóa account (GDPR) |

### 3.3 Trip Recording + Quick Capture

| Tính năng | Mô tả |
|-----------|-------|
| **Start Trip** | Bắt đầu ghi hành trình (GPS tracking) |
| **GPS Track** | Ghi lại route polyline real-time |
| **Quick Capture** | Chụp ảnh + ghi chú tại bất kỳ điểm nào (1 tap) |
| **Auto-detect** | Tự nhận diện khi user ở location → gắn tag |
| **Stop Trip** | Kết thúc ghi, lưu trip record |
| **Background recording** | Tiếp tục ghi khi app ẩn |

### 3.4 Auto Timeline Generation

```
GPS Track + Photos + Location Visits + Notes
         ↓
    Timeline Engine
         ↓
┌─────────────────────────────┐
│ Chuyến đi Hà Giang          │
│ 3 ngày • 12 điểm • 47 ảnh   │
├─────────────────────────────┤
│ 08:00  🚗 Xuất phát Hà Nội  │
│ 14:00  📍 Cổng trời Quản Bạ │
│         📸 3 ảnh             │
│ 16:30  📍 Núi đôi Quản Bạ   │
│         🎵 Nghe audio guide  │
│ 18:00  🏠 Homestay Yên Minh  │
│ ...                          │
└─────────────────────────────┘
```

### 3.5 Timeline Export

| Loại export | Mô tả |
|-------------|-------|
| **Image Grid** | Collage ảnh đẹp nhất + bản đồ route |
| **Video Clip** | Slideshow ảnh + nhạc nền (30s-60s) |
| **Share to Social** | Export → Instagram Stories / Facebook |
| **PDF Journal** | Nhật ký PDF với ảnh + bản đồ + notes |

### 3.6 Favorites, Gallery, Reviews

| Tính năng | Mô tả |
|-----------|-------|
| **Favorites** | Đánh dấu location / route / article yêu thích |
| **Photo Gallery** | Tất cả ảnh đã chụp, filter theo trip/location |
| **Reviews & Ratings** | Đánh giá location/service 1-5 sao + comment |
| **Moderation** | Admin review comments trước khi publish |

### 3.7 Push Notifications

| Loại | Trigger |
|------|---------|
| Content mới | Location mới, bài viết mới |
| Trip reminder | "Bạn có muốn tiếp tục chuyến đi?" |
| Review reminder | "Bạn đã đến X — hãy để lại đánh giá!" |
| Promotional | Khuyến mãi từ providers (opt-in) |

---

## Phase 4 — Monetization (4-6 tuần, ~$50-100/tháng)

> **Mục tiêu**: Tạo doanh thu từ app, xây dựng mô hình freemium bền vững.

### 4.1 Freemium Model

| Tier | Nội dung |
|------|----------|
| **Free** | 5 location audio + 3 trip recordings + articles + nearby services + bản đồ |
| **Premium Tour** | $2-5/tour — Mở khóa tất cả audio cho 1 route cụ thể |
| **Premium Monthly** | $5-10/tháng — Full access tất cả tính năng |
| **Premium Yearly** | $40-80/năm — Giảm giá so với monthly |

### 4.2 In-App Purchase

| Platform | Phương thức |
|----------|-------------|
| **Google Play** | Google Play Billing Library (consumable + subscription) |
| **Apple** | StoreKit 2 (consumable + subscription) |
| **Implementation** | `purchases_flutter` (RevenueCat) hoặc `in_app_purchase` |
| **Server validation** | Supabase Edge Function verify receipt |

### 4.3 Provider Dashboard

Dashboard cho homestay, nhà hàng, dịch vụ:
- Đăng ký / claim listing
- Cập nhật thông tin, ảnh, giờ mở cửa
- Xem analytics (views, calls, directions)
- Mua featured listing (quảng cáo ưu tiên)

### 4.4 Ad Platform

| Loại quảng cáo | Vị trí |
|-----------------|--------|
| **Banner ads** | Giữa danh sách locations/services (native ad) |
| **Featured listing** | Provider trả phí để hiển thị đầu danh sách |
| **Sponsored content** | Bài viết sponsored (rõ ràng label "Tài trợ") |
| **No intrusive ads** | KHÔNG popup, KHÔNG video ads, KHÔNG interstitial |

### 4.5 Analytics Dashboard (Admin)

| Metric | Mô tả |
|--------|-------|
| DAU/MAU | Số user active hàng ngày/tháng |
| Audio plays | Số lượt phát audio theo location |
| Route popularity | Route nào được xem nhiều nhất |
| Conversion rate | Free → Premium conversion |
| Revenue | MRR, ARPU, churn rate |
| Geography | Users theo quốc tịch/ngôn ngữ |

---

## Phase 5 — AI Chatbot (4-6 tuần, ~$75-150/tháng)

> **Mục tiêu**: AI assistant giúp plan trip, trả lời câu hỏi, gợi ý cá nhân hóa.

### 5.1 RAG Chatbot

```
User Question → Embedding → Vector Search (Supabase pgvector)
                                    ↓
                             Top-K Documents
                                    ↓
                    Context + Question → GPT-4o-mini → Answer
```

| Component | Công nghệ |
|-----------|-----------|
| **Embedding** | OpenAI `text-embedding-3-small` |
| **Vector DB** | Supabase pgvector extension |
| **LLM** | GPT-4o-mini (cost-effective) |
| **Knowledge base** | Locations, routes, services, articles, travel tips |
| **Edge Function** | `chat-rag/index.ts` xử lý RAG pipeline |

### 5.2 Voice Input

| Tính năng | Mô tả |
|-----------|-------|
| Speech-to-text | `speech_to_text` package, hỗ trợ vi/en/ko/zh |
| Voice button | Hold-to-talk hoặc tap-to-toggle |
| Real-time transcription | Hiện text khi user đang nói |

### 5.3 AI Trip Planner

```
User: "Tôi muốn đi Hà Giang 3 ngày, thích chụp ảnh và ẩm thực"
         ↓
AI analyzes: duration=3 days, interests=[photography, food]
         ↓
Generated itinerary:
  Ngày 1: Hà Giang → Quản Bạ → Yên Minh (photo spots + quán ăn)
  Ngày 2: Yên Minh → Đồng Văn → Mã Pì Lèng (viewpoints)
  Ngày 3: Lũng Cú → Sà Phìn → Hà Giang (homestay food)
```

### 5.4 Personalized Recommendations

| Input | Output |
|-------|--------|
| User history (locations visited) | "Bạn có thể thích..." suggestions |
| Current location + time | Context-aware recommendations |
| Weather | "Trời mưa — gợi ý indoor activities" |
| User preferences | Filter theo dietary, budget, accessibility |

---

## Phase 6+ — Expansion (Ongoing)

> **Tầm nhìn dài hạn**: Trở thành nền tảng du lịch audio guide cho Việt Nam.

| Tính năng | Mô tả | Timeline |
|-----------|-------|----------|
| **Multi-province** | Mở rộng: Cao Bằng, Lào Cai, Ninh Bình, Huế... | Q3-Q4 |
| **Photo recognition** | Chụp ảnh → AI nhận diện location/món ăn | Q4 |
| **AR experiences** | AR overlays tại điểm tham quan | Q4-Q5 |
| **Community** | User-generated content, travel stories, tips | Q3 |
| **OTA partnerships** | Kết nối booking.com, Agoda, Klook | Q4 |
| **Photo book** | AI tạo photo book từ trip → in/ship | Q5 |
| **Local guide matching** | Kết nối tourist với hướng dẫn viên địa phương | Q5 |
| **Event calendar** | Lễ hội, chợ phiên, sự kiện văn hóa | Q3 |

---

## Gantt Timeline (ASCII)

```
2024
Month:  M1    M2    M3    M4    M5    M6    M7    M8    M9    M10   M11   M12
        ├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤

Phase 1 ██████████████████                                            $0/mo
        MVP Lean (8w)
        S1    S2    S3    S4
        Found  Map   Route  Ship
              +Audio +Svc   +Offline

Phase 2             ████████████                                     $10-25/mo
                    GPS Auto + AI (6w)
                    Geofence  AI TTS
                    Alert IQ  Translation

Phase 3                       ████████████████████                   $25-50/mo
                              User + Journal (8w)
                              Auth    Trip    Social
                              Profile Record  Reviews

Phase 4                                       ████████████           $50-100/mo
                                              Monetize (6w)
                                              Freemium  Provider
                                              IAP       Dashboard

Phase 5                                                 ████████████ $75-150/mo
                                                        AI Chat (6w)
                                                        RAG    Voice
                                                        Planner Recommend

Phase 6+                                                        ▸▸▸▸▸▸▸▸▸▸▸
                                                                Expansion
        ├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
        M1    M2    M3    M4    M5    M6    M7    M8    M9    M10   M11   M12

Legend: ██ = Development    ▸▸ = Ongoing/Iterative    S = Sprint
```

---

## Key Milestones

| Milestone | Target | Tiêu chí thành công |
|-----------|--------|---------------------|
| **M1: Alpha** | Tuần 4 | Map + audio player hoạt động, 10 locations |
| **M2: Beta** | Tuần 6 | Full MVP features, offline work |
| **M3: App Store** | Tuần 8 | Trên Google Play + TestFlight |
| **M4: GPS Auto** | Tuần 14 | Autoplay hoạt động, battery < 5% drain/hr |
| **M5: Auth Launch** | Tuần 22 | 100 registered users |
| **M6: First Revenue** | Tuần 28 | $100 MRR |
| **M7: AI Chat** | Tuần 34 | Chatbot trả lời 80% câu hỏi chính xác |
| **M8: Break-even** | Tuần 40 | Revenue >= costs |

---

## Risk Matrix

| Risk | Khả năng | Ảnh hưởng | Giải pháp |
|------|----------|-----------|-----------|
| Supabase free tier hết | Trung bình | Cao | Monitor usage, optimize storage, upgrade khi cần |
| GPS drain battery | Cao | Cao | Alert Intelligence + adaptive GPS strategy |
| Offline sync conflict | Trung bình | Trung bình | Server-wins strategy + conflict UI |
| Low user adoption | Trung bình | Cao | QR codes tại điểm du lịch + SEO + social media |
| AI costs vượt budget | Thấp | Trung bình | Cache AI results, batch processing, model fallback |
| App Store rejection | Thấp | Cao | Follow guidelines, beta test kỹ |

---

## Decision Log

| Quyết định | Lý do | Alternatives đã xem xét |
|------------|-------|--------------------------|
| Flutter (not native) | 1 codebase, nhanh hơn 2x, admin web cùng stack | React Native, native iOS+Android |
| Supabase (not Firebase) | Free tier mạnh hơn, SQL, self-host option | Firebase, custom backend |
| drift (not sqflite) | Type-safe, code gen, reactive streams | sqflite, hive, isar |
| flutter_map (not Google Maps) | Free, offline tiles, no API key | google_maps_flutter |
| just_audio (not audioplayers) | Tốt hơn cho streaming, gapless playback | audioplayers |
| Riverpod (not Bloc) | Code gen, testable, less boilerplate | Bloc, GetX, Provider |
| GoRouter (not auto_route) | Official Flutter team, declarative | auto_route, go_router_builder |
| Freemium (not paid-only) | Lower barrier, viral potential | Paid app, ads-only |

---

*Tiếp theo: [11 — DevOps & Tooling](11-devops-and-tooling.md) — CI/CD, testing, monitoring*
