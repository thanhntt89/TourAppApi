# 00 — Tổng quan dự án / Project Overview

> **"Tour Guide trong túi"** — Your Personal Tour Guide

---

[<< Architecture.md](../Architecture.md) | **00 Overview** | [01 Problem & Solution >>](01-problem-and-solution.md)

| # | Tài liệu | Link |
|---|----------|------|
| 00 | **Tổng quan (đang xem)** | — |
| 01 | Vấn đề & Giải pháp | [01-problem-and-solution.md](01-problem-and-solution.md) |
| 02 | Tech Stack | [02-tech-stack.md](02-tech-stack.md) |
| 03 | Kiến trúc hệ thống | [03-system-architecture.md](03-system-architecture.md) |
| 04 | Database Design | [04-database-design.md](04-database-design.md) |
| 05 | Mobile App Architecture | [05-mobile-app-architecture.md](05-mobile-app-architecture.md) |
| 06 | Backend Services | [06-backend-services.md](06-backend-services.md) |
| 07 | Maps & Location | [07-maps-and-location.md](07-maps-and-location.md) |
| 08 | AI Integration | [08-ai-integration.md](08-ai-integration.md) |
| 09 | Project Structure | [09-project-structure.md](09-project-structure.md) |
| 10 | Phase Roadmap | [10-phase-roadmap.md](10-phase-roadmap.md) |
| 11 | DevOps & Tooling | [11-devops-and-tooling.md](11-devops-and-tooling.md) |
| 12 | Cost Analysis | [12-cost-analysis.md](12-cost-analysis.md) |

---

## 1. Thông tin dự án / Project Identity

| Mục | Chi tiết |
|-----|---------|
| **Tên dự án** | ToursApp — "Tour Guide trong túi" |
| **Tagline** | Your Personal Tour Guide / Hướng dẫn viên cá nhân |
| **Tầm nhìn** | Thay thế hướng dẫn viên du lịch bằng app — cung cấp audio thuyết minh, thông tin địa điểm, dịch vụ địa phương cho khách đi tự do. Phase 1 chỉ có data Hà Giang, nhưng kiến trúc multi-province từ đầu — tự động detect tỉnh theo GPS khi mở app. Hướng tương lai: mở rộng tỉnh, Travel Journal, AI Chatbot |
| **Nền tảng** | Android + iOS (Flutter) + Web Admin (Flutter Web) |
| **Ngôn ngữ** | Tiếng Việt, English, 한국어, 中文 |
| **License** | Proprietary |
| **Repository** | *(TBD — GitHub/Bitbucket)* |

---

## 2. Tầm nhìn / Vision

**Vấn đề cốt lõi**: Nhiều điểm du lịch tại Hà Giang **không có đủ hướng dẫn viên**. Khách đi tự do đến một địa điểm — chỉ thấy tấm biển nhỏ bằng tiếng Việt, không ai kể cho họ nghe câu chuyện lịch sử, văn hóa, bí mật bản địa phía sau. Họ **miss thông tin quan trọng** mà đáng lẽ một guide man sẽ giới thiệu.

Ngoài ra còn: kết nối internet yếu trên đèo, rào cản ngôn ngữ, thông tin dịch vụ rải rác.

**Giải pháp**: App đóng vai trò **hướng dẫn viên cá nhân** — luôn có sẵn trong túi, hoạt động offline, nói được 4 ngôn ngữ:

```
┌─────────────────────────────────────────────────────────┐
│              "Tour Guide trong túi"                      │
│                                                         │
│   ┌────────────────────────┐     ┌──────────────────┐   │
│   │  CORE: Audio Guide     │     │  Dịch vụ         │   │
│   │  (Thay thế guide man)  │     │  địa phương      │   │
│   │                        │     │                  │   │
│   │  • GPS auto-detect →   │     │  • Homestay      │   │
│   │    tự phát audio       │     │  • Ăn uống       │   │
│   │  • QR scan (backup)    │     │  • Sửa xe        │   │
│   │  • Offline hoàn toàn   │     │  • Y tế, cấp cứu │   │
│   │  • 4 ngôn ngữ          │     │  • Thuê xe, SIM  │   │
│   │  • Cung đường tối ưu   │     │                  │   │
│   └────────────────────────┘     └──────────────────┘   │
│                                                         │
│   ┌─────────────────────────────────────────────────┐   │
│   │  TƯƠNG LAI: Travel Journal + AI Chatbot          │   │
│   │  • Timeline chuyến đi (Phase 3)                  │   │
│   │  • AI hỏi đáp thông minh (Phase 5)              │   │
│   └─────────────────────────────────────────────────┘   │
│                                                         │
│            ▼ Offline-first / 4 Languages ▼              │
└─────────────────────────────────────────────────────────┘
```

---

## 3. Đối tượng người dùng / Target Users

### 3.1 Nhóm chính — Khách du lịch lần đầu (Newbie Tourist)
- Lần đầu đến Hà Giang, cần thông tin an toàn và hướng dẫn chi tiết
- Thích chụp ảnh, chia sẻ lên mạng xã hội
- Sẵn sàng trả tiền cho trải nghiệm tốt
- Lo lắng về an toàn, thời tiết, đường sá

### 3.2 Nhóm chính — Phượt thủ có kinh nghiệm (Hardcore Backpacker)
- Đã đi Hà Giang nhiều lần, tìm kiếm trải nghiệm sâu hơn
- Cần app hoạt động hands-free khi lái xe máy
- Quan tâm đến tiết kiệm pin
- Thích tự do khám phá, không thích bị làm phiền bởi thông báo thừa

### 3.3 Nhóm phụ
- **Tour operators**: quản lý tour, đưa khách đến đúng điểm
- **Nhà cung cấp dịch vụ địa phương**: homestay, quán ăn, tiệm sửa xe — muốn hiển thị trên app
- **Content creators**: viết bài, tạo audio guide

---

## 4. Giá trị cốt lõi / Core Value Proposition

### Khoảng trống thị trường (Market Gap)

| Loại app | Ví dụ | Audio Guide | Travel Journal | Local Services | Offline |
|----------|-------|:-----------:|:--------------:|:--------------:|:-------:|
| Audio Guide | SmartGuide, VoiceMap, PocketGuide | **Yes** | No | No | Partial |
| Travel Journal | Polarsteps, FindPenguins | No | **Yes** | No | Partial |
| Local Services | Google Maps, TripAdvisor | No | No | **Yes** | No |
| **ToursApp** | **"Tour Guide trong túi"** | **Yes** | **Yes** | **Yes** | **Yes** |

**Không có app nào kết hợp cả 3 tính năng + offline-first + 4 ngôn ngữ.**

ToursApp lấp đầy khoảng trống này bằng cách tạo ra trải nghiệm liền mạch: nghe audio guide tại điểm tham quan → ghi lại hành trình → tìm dịch vụ gần đó — tất cả hoạt động offline trên đèo.

---

## 5. Lộ trình phát triển / Phase Summary

| Phase | Tên | Tính năng chính | Timeline | Trạng thái |
|:-----:|-----|-----------------|:--------:|:----------:|
| **1** | **MVP Lean** | GPS auto-detect → Audio Guide, QR scan (backup), Map, Routes, Services, Articles, Offline cache, Admin Panel (Web) | 6-8 tuần | **Đang phát triển** |
| **2** | Smart Autoplay | Alert Intelligence (cooldown, speed-aware, priority), AI TTS pipeline, Battery optimization, Background mode | 4-6 tuần | Kế hoạch |
| **3** | Travel Journal | Auth (Supabase Auth), Trip Timeline, Photo Capture, Export PDF, Reviews & Ratings | 6-8 tuần | Kế hoạch |
| **4** | Monetization | Freemium model, In-App Purchase, Provider Dashboard, Targeted Ads | 4-6 tuần | Kế hoạch |
| **5** | AI Chatbot | RAG Chatbot, Voice Input, AI Trip Planner, Personalization | 4-6 tuần | Kế hoạch |

### Phase 1 — MVP Lean (Chi tiết)

| Tính năng | Mô tả | Yêu cầu không có |
|-----------|-------|-------------------|
| Auto-detect province | GPS detect tỉnh khi mở app → hiển thị nội dung tỉnh đó. Nếu tỉnh chưa có data hoặc không detect được → chọn thủ công / default Hà Giang | Không cần auth |
| **GPS auto-detect → Audio** | **Tự nhận diện địa điểm đang đứng (proximity ~300m) → tự phát audio guide. Đây là tính năng CHÍNH.** | Không cần AI |
| QR scan → Audio (backup) | Quét QR tại điểm tham quan → phát audio guide. Phương thức phụ khi GPS không chính xác hoặc user muốn chọn cụ thể | Không cần AI |
| Map + GPS nearby | Bản đồ OSM, hiển thị các điểm gần trong tỉnh hiện tại, cluster markers | Không cần auth |
| Routes | Danh sách tuyến đường (Vòng cung đông, Vòng cung tây...) | Free |
| Service Providers | Homestay, quán ăn, sửa xe... với bộ lọc | Không cần đăng nhập |
| Articles | Bài viết du lịch, tips | Không cần comment |
| Offline cache | Download map tiles + audio + data để dùng offline | Auto-sync khi có mạng |
| Admin Panel | Flutter Web — quản lý content, locations, audio | Chỉ admin truy cập |

---

## 6. Tech Stack tổng quan / Tech Stack Summary

| Layer | Công nghệ | Tài liệu |
|-------|-----------|-----------|
| **Mobile + Web** | Flutter 3.x (Dart) | [02-tech-stack.md](02-tech-stack.md) |
| **State Management** | flutter_riverpod | [02-tech-stack.md](02-tech-stack.md) |
| **Backend** | Supabase Cloud (PostgreSQL + Edge Functions + Storage) | [06-backend-services.md](06-backend-services.md) |
| **Offline DB** | drift (SQLite) | [04-database-design.md](04-database-design.md) |
| **Map** | flutter_map + OpenStreetMap | [07-maps-and-location.md](07-maps-and-location.md) |
| **Audio** | just_audio + audio_service | [05-mobile-app-architecture.md](05-mobile-app-architecture.md) |
| **Kiến trúc** | Feature-first + Repository pattern | [03-system-architecture.md](03-system-architecture.md) |

---

## 7. Team & Stakeholders

| Vai trò | Người | Ghi chú |
|---------|-------|---------|
| **Project Lead / Developer** | *(TBD)* | Flutter + Supabase full-stack |
| **UI/UX Designer** | *(TBD)* | Mobile-first design, Material 3 |
| **Content Creator** | *(TBD)* | Audio scripts, articles (4 ngôn ngữ) |
| **Local Partner** | *(TBD)* | Hà Giang — homestay, tour operators |
| **QA / Tester** | *(TBD)* | Field testing tại Hà Giang (offline scenarios) |

### Liên hệ & Quyết định

| Quyết định | Người phê duyệt | Ghi chú |
|-----------|-----------------|---------|
| Kiến trúc kỹ thuật | Project Lead | — |
| UI/UX flow | Designer + Project Lead | — |
| Nội dung audio/bài viết | Content Creator | Cần native speaker review cho mỗi ngôn ngữ |
| Partnership & monetization | Project Lead | Phase 4 |

---

## 8. Quy ước tài liệu / Document Conventions

- **Ngôn ngữ**: Tài liệu viết song ngữ Việt-Anh. Technical terms giữ nguyên tiếng Anh.
- **Diagrams**: ASCII art cho compatibility tối đa (render trên mọi editor/terminal).
- **Code examples**: Dart/SQL với syntax highlighting.
- **Version**: Mỗi tài liệu ghi ngày cập nhật cuối.
- **Phase tagging**: Mỗi tính năng được tag phase rõ ràng (P1, P2, P3...).

---

*Cập nhật lần cuối: 2026-06-08*
