# ToursApp — "Tour Guide trong túi"

Ứng dụng mobile du lịch (Android + iOS) đóng vai trò **hướng dẫn viên cá nhân** — thay thế guide man bằng audio thuyết minh, bản đồ thông minh và thông tin dịch vụ địa phương. Giải quyết vấn đề: nhiều địa điểm du lịch không đủ hướng dẫn viên, khách đi tự do thường miss thông tin lịch sử, văn hóa, câu chuyện bản địa quan trọng.

Phạm vi ban đầu: **chỉ Hà Giang** (data), nhưng kiến trúc multi-province từ đầu. App tự động detect tỉnh theo GPS khi mở — nếu tỉnh chưa có data hoặc không detect được GPS → cho chọn thủ công / default Hà Giang. Khi mở rộng tỉnh mới, chỉ cần seed thêm data — code không đổi. Hướng tương lai: Travel Journal/Timeline, AI Chatbot.

## Tech Stack

- **Mobile + Admin Web**: Flutter 3.x (Dart)
- **Backend**: Supabase Cloud (PostgreSQL + Edge Functions + Storage)
- **State Management**: flutter_riverpod
- **Offline DB**: drift (SQLite)
- **Map**: flutter_map + OpenStreetMap
- **Audio**: just_audio + audio_service
- **Ngôn ngữ**: Việt / Anh / Hàn / Trung

## Kiến trúc tổng thể

```
Flutter App (Android + iOS + Web Admin)
    ├── Features Layer (UI screens)
    ├── Providers Layer (Riverpod state)
    ├── Data Layer (repositories + models)
    └── Local Data Layer (drift SQLite + file cache)
            │
            ▼  HTTPS REST
       Supabase Cloud
    ├── PostgREST (Auto API)
    ├── PostgreSQL (pgvector + earthdistance)
    ├── Edge Functions (Deno)
    └── Storage (S3-compatible)
            │
            ▼
       External Services
    ├── OpenStreetMap tiles
    ├── Cloudflare R2 CDN
    ├── OpenAI TTS / GPT (Phase 2/5)
    └── FCM Push (Phase 3)
```

## Lộ trình

| Phase | Tính năng | Timeline |
|-------|-----------|----------|
| 1 — MVP Lean | GPS auto-detect → Audio, QR (backup), Map, Routes, Services, Offline | 6-8 tuần |
| 2 — Smart Autoplay | Alert Intelligence, AI TTS, Battery opt, Background mode | 4-6 tuần |
| 3 — Travel Journal | Auth, Trip Timeline, Photo Capture, Export, Reviews | 6-8 tuần |
| 4 — Monetization | Freemium, IAP, Provider Dashboard, Ads | 4-6 tuần |
| 5 — AI Chatbot | RAG Chatbot, Voice Input, AI Planner, Personalize | 4-6 tuần |

## Tài liệu chi tiết

- [00 — Tổng quan](docs/00-overview.md)
- [01 — Vấn đề & Giải pháp](docs/01-problem-and-solution.md)
- [02 — Tech Stack](docs/02-tech-stack.md)
- [03 — Kiến trúc hệ thống](docs/03-system-architecture.md)
- [04 — Database Design](docs/04-database-design.md)
- [05 — Mobile App Architecture](docs/05-mobile-app-architecture.md)
- [06 — Backend Services](docs/06-backend-services.md)
- [07 — Maps & Location](docs/07-maps-and-location.md)
- [08 — AI Integration](docs/08-ai-integration.md)
- [09 — Project Structure](docs/09-project-structure.md)
- [10 — Phase Roadmap](docs/10-phase-roadmap.md)
- [11 — DevOps & Tooling](docs/11-devops-and-tooling.md)
- [12 — Cost Analysis](docs/12-cost-analysis.md)
