# 09 — Cấu trúc dự án / Project Structure

> **"Tour Guide trong túi"** — A talking diary for Ha Giang

---

[<< 08 AI Integration](08-ai-integration.md) | **09 Project Structure** | [10 Phase Roadmap >>](10-phase-roadmap.md)

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
| 09 | **Cấu trúc dự án (đang xem)** | — |
| 10 | Phase Roadmap | [10-phase-roadmap.md](10-phase-roadmap.md) |
| 11 | DevOps & Tooling | [11-devops-and-tooling.md](11-devops-and-tooling.md) |
| 12 | Cost Analysis | [12-cost-analysis.md](12-cost-analysis.md) |

---

## 1. Tổng quan cấu trúc / Directory Tree

```
toursapp/
├── lib/
│   ├── main.dart                          # Entry point — khởi tạo app
│   ├── app.dart                           # MaterialApp + GoRouter + Theme config
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_config.dart            # Environment config (Supabase URL, keys)
│   │   │   ├── supabase_config.dart       # Supabase client initialization
│   │   │   └── drift_config.dart          # Drift database setup
│   │   ├── constants/
│   │   │   ├── app_constants.dart         # Hằng số chung (timeout, pagination size...)
│   │   │   ├── api_constants.dart         # API endpoints, Supabase table names
│   │   │   ├── asset_constants.dart       # Đường dẫn assets (images, sounds)
│   │   │   └── map_constants.dart         # Map tile URLs, default zoom, Ha Giang bounds
│   │   ├── router/
│   │   │   ├── app_router.dart            # GoRouter configuration + route definitions
│   │   │   ├── route_names.dart           # Named route constants
│   │   │   └── router_observer.dart       # Navigation analytics tracking
│   │   ├── l10n/
│   │   │   ├── app_vi.arb                 # Tiếng Việt (ngôn ngữ chính)
│   │   │   ├── app_en.arb                 # English
│   │   │   ├── app_ko.arb                 # 한국어
│   │   │   └── app_zh.arb                 # 中文
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # ThemeData cho light/dark mode
│   │   │   ├── app_colors.dart            # Color palette
│   │   │   └── app_text_styles.dart       # Typography definitions
│   │   └── utils/
│   │       ├── extensions.dart            # Dart extension methods
│   │       ├── formatters.dart            # Date, number, distance formatters
│   │       ├── validators.dart            # Input validation helpers
│   │       ├── logger.dart                # Structured logging wrapper
│   │       └── connectivity_helper.dart   # Kiểm tra kết nối mạng
│   │
│   ├── data/
│   │   ├── database/
│   │   │   ├── app_database.dart          # Drift database class chính
│   │   │   ├── app_database.g.dart        # Generated code (drift)
│   │   │   ├── tables/
│   │   │   │   ├── locations_table.dart   # Bảng locations (offline)
│   │   │   │   ├── routes_table.dart      # Bảng routes
│   │   │   │   ├── audio_cache_table.dart # Bảng cache audio metadata
│   │   │   │   ├── articles_table.dart    # Bảng articles
│   │   │   │   ├── services_table.dart    # Bảng dịch vụ địa phương
│   │   │   │   └── sync_queue_table.dart  # Queue đồng bộ offline → cloud
│   │   │   └── daos/
│   │   │       ├── location_dao.dart      # Data Access Object cho locations
│   │   │       ├── route_dao.dart         # DAO cho routes
│   │   │       ├── article_dao.dart       # DAO cho articles
│   │   │       └── service_dao.dart       # DAO cho services
│   │   ├── repositories/
│   │   │   ├── location_repository.dart   # Abstract + impl cho locations
│   │   │   ├── route_repository.dart      # Abstract + impl cho routes
│   │   │   ├── audio_repository.dart      # Quản lý audio files + streaming
│   │   │   ├── article_repository.dart    # Articles repository
│   │   │   ├── service_repository.dart    # Local services repository
│   │   │   ├── sync_repository.dart       # Đồng bộ offline ↔ Supabase
│   │   │   └── download_repository.dart   # Download manager cho offline packs
│   │   ├── models/
│   │   │   ├── location.dart              # Location model (freezed)
│   │   │   ├── location.freezed.dart      # Generated (freezed)
│   │   │   ├── location.g.dart            # Generated (json_serializable)
│   │   │   ├── route.dart                 # Route model
│   │   │   ├── audio_track.dart           # Audio track metadata
│   │   │   ├── article.dart               # Article model
│   │   │   ├── local_service.dart         # Dịch vụ địa phương model
│   │   │   ├── download_pack.dart         # Offline download pack
│   │   │   └── sync_item.dart             # Sync queue item
│   │   └── services/
│   │       ├── supabase_service.dart       # Supabase client wrapper
│   │       ├── audio_service.dart          # just_audio playback service
│   │       ├── location_service.dart       # GPS + geofencing service
│   │       ├── qr_scanner_service.dart     # QR/barcode scanning
│   │       ├── share_service.dart          # Deep link + social sharing
│   │       ├── notification_service.dart   # Local notifications [Phase 3]
│   │       ├── analytics_service.dart      # Track user events
│   │       └── cache_service.dart          # Cache management (audio, images, tiles)
│   │
│   ├── providers/
│   │   ├── location_providers.dart        # LocationNotifier, nearbyLocationsProvider
│   │   ├── route_providers.dart           # RouteNotifier, routeDetailProvider
│   │   ├── audio_providers.dart           # AudioPlayerNotifier, playbackStateProvider
│   │   ├── article_providers.dart         # ArticleNotifier, articleListProvider
│   │   ├── service_providers.dart         # LocalServiceNotifier
│   │   ├── download_providers.dart        # DownloadNotifier, downloadProgressProvider
│   │   ├── connectivity_providers.dart    # ConnectivityNotifier (online/offline state)
│   │   ├── locale_providers.dart          # LocaleNotifier (ngôn ngữ)
│   │   ├── theme_providers.dart           # ThemeNotifier (light/dark)
│   │   ├── map_providers.dart             # MapNotifier, tileProvider
│   │   ├── auth_providers.dart            # AuthNotifier [Phase 3]
│   │   └── trip_providers.dart            # TripNotifier [Phase 3]
│   │
│   ├── features/
│   │   ├── home/
│   │   │   ├── home_screen.dart           # Màn hình chính — map + danh sách
│   │   │   ├── widgets/
│   │   │   │   ├── home_map_section.dart   # Map widget trên home
│   │   │   │   ├── featured_banner.dart    # Banner quảng bá
│   │   │   │   ├── nearby_locations_list.dart # Danh sách điểm gần
│   │   │   │   └── quick_action_bar.dart   # Thanh hành động nhanh
│   │   │   └── home_controller.dart       # Business logic cho home
│   │   │
│   │   ├── location/
│   │   │   ├── location_list_screen.dart  # Danh sách tất cả điểm tham quan
│   │   │   ├── location_detail_screen.dart # Chi tiết điểm + audio player
│   │   │   ├── location_map_screen.dart   # Bản đồ full-screen cho 1 điểm
│   │   │   └── widgets/
│   │   │       ├── audio_player_card.dart  # Card phát audio
│   │   │       ├── location_info_card.dart # Thông tin điểm tham quan
│   │   │       ├── photo_gallery.dart      # Gallery ảnh
│   │   │       └── location_tile.dart      # Tile item trong danh sách
│   │   │
│   │   ├── scanner/
│   │   │   └── qr_scanner_screen.dart     # Quét QR → mở location detail
│   │   │
│   │   ├── routes/
│   │   │   ├── route_list_screen.dart     # Danh sách tuyến đường
│   │   │   ├── route_detail_screen.dart   # Chi tiết tuyến + bản đồ
│   │   │   └── widgets/
│   │   │       ├── route_map_widget.dart   # Bản đồ tuyến đường
│   │   │       ├── route_stop_list.dart    # Danh sách điểm dừng
│   │   │       └── route_card.dart         # Card tuyến trong danh sách
│   │   │
│   │   ├── services/
│   │   │   ├── service_list_screen.dart   # Danh sách dịch vụ (homestay, ăn uống...)
│   │   │   ├── service_detail_screen.dart # Chi tiết dịch vụ
│   │   │   └── widgets/
│   │   │       ├── service_card.dart       # Card dịch vụ
│   │   │       └── service_filter_bar.dart # Bộ lọc loại dịch vụ
│   │   │
│   │   ├── articles/
│   │   │   ├── article_list_screen.dart   # Danh sách bài viết
│   │   │   ├── article_detail_screen.dart # Chi tiết bài viết (rich text)
│   │   │   └── widgets/
│   │   │       └── article_card.dart       # Card bài viết
│   │   │
│   │   ├── settings/
│   │   │   ├── settings_screen.dart       # Cài đặt app
│   │   │   └── widgets/
│   │   │       ├── language_selector.dart  # Chọn ngôn ngữ
│   │   │       ├── theme_toggle.dart       # Light/dark mode
│   │   │       ├── download_manager.dart   # Quản lý dữ liệu offline
│   │   │       └── about_section.dart      # Thông tin app
│   │   │
│   │   ├── trip_journal/                  # [Phase 3]
│   │   │   ├── trip_list_screen.dart      # Danh sách chuyến đi
│   │   │   ├── trip_detail_screen.dart    # Timeline chuyến đi
│   │   │   ├── trip_recording_screen.dart # Ghi hành trình real-time
│   │   │   └── widgets/
│   │   │       ├── timeline_widget.dart    # Auto-generated timeline
│   │   │       ├── quick_capture_button.dart # Chụp ảnh/ghi chú nhanh
│   │   │       └── trip_export_dialog.dart  # Xuất timeline → ảnh/video
│   │   │
│   │   ├── auth/                          # [Phase 3]
│   │   │   ├── login_screen.dart          # Đăng nhập (social + email)
│   │   │   ├── register_screen.dart       # Đăng ký
│   │   │   ├── profile_screen.dart        # Hồ sơ người dùng
│   │   │   └── widgets/
│   │   │       └── social_login_buttons.dart
│   │   │
│   │   ├── social/                        # [Phase 3]
│   │   │   ├── favorites_screen.dart      # Danh sách yêu thích
│   │   │   ├── reviews_screen.dart        # Đánh giá & bình luận
│   │   │   └── widgets/
│   │   │       ├── review_card.dart
│   │   │       └── rating_widget.dart
│   │   │
│   │   ├── chat/                          # [Phase 5]
│   │   │   ├── chat_screen.dart           # RAG chatbot UI
│   │   │   └── widgets/
│   │   │       ├── chat_bubble.dart
│   │   │       └── voice_input_button.dart
│   │   │
│   │   └── admin/
│   │       ├── admin_dashboard_screen.dart # Dashboard tổng quan (Flutter Web)
│   │       ├── location_editor_screen.dart # CRUD locations
│   │       ├── route_editor_screen.dart   # CRUD routes
│   │       ├── article_editor_screen.dart # CRUD articles
│   │       ├── service_editor_screen.dart # CRUD services
│   │       ├── audio_manager_screen.dart  # Upload/manage audio files
│   │       └── widgets/
│   │           ├── admin_sidebar.dart      # Navigation sidebar
│   │           ├── data_table_widget.dart  # Reusable data table
│   │           └── rich_text_editor.dart   # Rich text editor cho articles
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── app_scaffold.dart           # Scaffold chung với bottom nav
│       │   ├── loading_indicator.dart      # Loading states
│       │   ├── error_widget.dart           # Error display
│       │   ├── empty_state_widget.dart     # Empty state placeholder
│       │   ├── cached_network_image.dart   # Image với cache
│       │   ├── map_widget.dart             # Reusable flutter_map wrapper
│       │   ├── audio_mini_player.dart      # Mini player persistent
│       │   ├── offline_banner.dart         # Banner "Đang offline"
│       │   └── shimmer_loading.dart        # Shimmer placeholder
│       └── extensions/
│           ├── context_extensions.dart     # BuildContext extensions (theme, l10n)
│           ├── string_extensions.dart      # String helpers
│           ├── datetime_extensions.dart    # DateTime formatting
│           └── iterable_extensions.dart    # List/Iterable helpers
│
├── supabase/
│   ├── config.toml                        # Supabase project config
│   ├── migrations/
│   │   ├── 20240101000000_initial_schema.sql    # Bảng chính: locations, routes, ...
│   │   ├── 20240101000001_rls_policies.sql      # Row Level Security
│   │   ├── 20240101000002_storage_buckets.sql   # Storage buckets setup
│   │   ├── 20240101000003_indexes.sql           # Performance indexes
│   │   └── 20240101000004_seed_data.sql         # Dữ liệu mẫu Hà Giang
│   ├── functions/
│   │   ├── sync-locations/index.ts        # Sync client ↔ server locations
│   │   ├── track-analytics/index.ts       # Nhận analytics events
│   │   ├── generate-audio/index.ts        # AI TTS pipeline [Phase 2]
│   │   ├── translate-content/index.ts     # AI Translation [Phase 2]
│   │   └── chat-rag/index.ts             # RAG chatbot [Phase 5]
│   └── seed/
│       ├── locations.json                 # Dữ liệu điểm tham quan Hà Giang
│       ├── routes.json                    # Dữ liệu tuyến đường mẫu
│       └── services.json                  # Dữ liệu dịch vụ mẫu
│
├── docs/
│   ├── 00-overview.md                     # Tổng quan dự án
│   ├── 01-problem-and-solution.md
│   ├── 02-tech-stack.md
│   ├── ...
│   └── 12-cost-analysis.md
│
├── tools/
│   ├── seed_database.dart                 # Script seed dữ liệu
│   ├── generate_models.sh                 # Run build_runner cho freezed/drift
│   └── check_translations.dart            # Kiểm tra thiếu key trong ARB files
│
├── test/
│   ├── unit/
│   │   ├── models/                        # Test models (serialization, validation)
│   │   ├── repositories/                  # Test repositories (mock Supabase)
│   │   └── utils/                         # Test utility functions
│   ├── widget/
│   │   ├── features/                      # Widget test theo feature
│   │   └── shared/                        # Test shared widgets
│   └── helpers/
│       ├── test_helpers.dart              # Shared test utilities
│       └── mocks.dart                     # Mock objects (Mockito)
│
├── integration_test/
│   ├── app_test.dart                      # Full app flow test
│   ├── location_flow_test.dart            # Xem location → phát audio
│   ├── route_flow_test.dart               # Xem route → navigate
│   ├── offline_flow_test.dart             # Download → offline usage
│   └── helpers/
│       └── integration_helpers.dart
│
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── splash.png
│   │   ├── placeholders/                  # Placeholder images
│   │   └── icons/                         # Custom icons
│   ├── fonts/                             # Custom fonts (nếu có)
│   ├── l10n/                              # Symlink hoặc copy từ lib/core/l10n
│   └── map_tiles/                         # Pre-cached map tiles cho offline [Phase 1]
│
├── android/                               # Android native config
├── ios/                                   # iOS native config
├── web/                                   # Flutter Web (admin panel)
├── pubspec.yaml                           # Dependencies
├── analysis_options.yaml                  # Lint rules
├── .env.example                           # Template cho environment variables
├── .gitignore
└── README.md
```

---

## 2. Chi tiết từng thư mục / Directory Details

### 2.1 `lib/core/` — Nền tảng ứng dụng

| Thư mục | Mục đích | Ví dụ file |
|---------|----------|-----------|
| `config/` | Cấu hình environment, khởi tạo services | `supabase_config.dart`, `drift_config.dart` |
| `constants/` | Hằng số toàn app — không thay đổi khi runtime | `app_constants.dart`, `map_constants.dart` |
| `router/` | GoRouter setup, route definitions, guards | `app_router.dart`, `route_names.dart` |
| `l10n/` | ARB files cho đa ngôn ngữ (vi, en, ko, zh) | `app_vi.arb`, `app_en.arb` |
| `theme/` | ThemeData, colors, typography | `app_theme.dart`, `app_colors.dart` |
| `utils/` | Utility functions dùng chung | `formatters.dart`, `logger.dart` |

**Lưu ý**: `core/` KHÔNG chứa business logic. Chỉ chứa infrastructure code.

### 2.2 `lib/data/` — Tầng dữ liệu

```
data/
├── database/     # Drift (SQLite) — local storage
│   ├── tables/   # Table definitions
│   └── daos/     # Data Access Objects
├── repositories/  # Repository pattern — abstract + implementation
├── models/        # Domain models (freezed + json_serializable)
└── services/      # External service wrappers (Supabase, audio, GPS...)
```

**Repository Pattern**: Mỗi repository có:
- Abstract class định nghĩa interface
- Implementation class kết nối Supabase (online) hoặc Drift (offline)
- Tự động fallback: online → offline khi mất kết nối

```dart
// Ví dụ: location_repository.dart
abstract class LocationRepository {
  Future<List<Location>> getLocations({String? language});
  Future<Location?> getLocationById(String id);
  Future<List<Location>> getNearbyLocations(double lat, double lng, double radiusKm);
  Stream<List<Location>> watchLocations();
}

class LocationRepositoryImpl implements LocationRepository {
  final SupabaseService _supabase;
  final LocationDao _localDao;
  final ConnectivityHelper _connectivity;
  // ... implementation with online/offline fallback
}
```

### 2.3 `lib/providers/` — State Management (Riverpod)

Mỗi file chứa các providers liên quan đến một domain. Sử dụng Riverpod 2.x với code generation.

```dart
// Ví dụ: audio_providers.dart
@riverpod
class AudioPlayerNotifier extends _$AudioPlayerNotifier {
  @override
  AudioPlayerState build() => const AudioPlayerState.idle();

  Future<void> play(AudioTrack track) async { ... }
  void pause() { ... }
  void seek(Duration position) { ... }
}

@riverpod
Stream<Duration> playbackPosition(PlaybackPositionRef ref) {
  return ref.watch(audioPlayerNotifierProvider.notifier).positionStream;
}
```

### 2.4 `lib/features/` — Feature-first Architecture

Mỗi feature là một thư mục độc lập chứa:
- **Screens** (full pages)
- **Widgets** (components riêng cho feature)
- **Controller/Logic** (nếu cần, ngoài Riverpod providers)

```
features/
├── home/              # [Phase 1] Màn hình chính
├── location/          # [Phase 1] Điểm tham quan + audio
├── scanner/           # [Phase 1] QR scanner
├── routes/            # [Phase 1] Tuyến đường
├── services/          # [Phase 1] Dịch vụ địa phương
├── articles/          # [Phase 1] Bài viết / tin tức
├── settings/          # [Phase 1] Cài đặt
├── trip_journal/      # [Phase 3] Nhật ký hành trình
├── auth/              # [Phase 3] Xác thực người dùng
├── social/            # [Phase 3] Yêu thích, đánh giá
├── chat/              # [Phase 5] AI Chatbot
└── admin/             # [Phase 1] Admin panel (Flutter Web)
```

**Nguyên tắc**: Feature folder KHÔNG import trực tiếp từ feature khác. Giao tiếp qua `providers/` hoặc `shared/`.

### 2.5 `lib/shared/` — Components tái sử dụng

```
shared/
├── widgets/       # UI components dùng chung giữa nhiều features
└── extensions/    # Dart extension methods
```

Widget trong `shared/` phải:
- Không phụ thuộc vào bất kỳ feature nào
- Có thể tái sử dụng ở nhiều nơi
- Nhận data qua parameters, không tự fetch

### 2.6 `supabase/` — Backend Configuration

```
supabase/
├── config.toml         # Project settings
├── migrations/         # SQL migrations (chạy theo thứ tự timestamp)
├── functions/          # Edge Functions (Deno/TypeScript)
└── seed/               # Dữ liệu mẫu JSON
```

**Migrations** được đánh số theo timestamp để đảm bảo thứ tự. Mỗi migration phải idempotent (chạy lại không lỗi).

### 2.7 `test/` — Test Structure

```
test/
├── unit/
│   ├── models/         # Mirrors lib/data/models/
│   ├── repositories/   # Mirrors lib/data/repositories/
│   └── utils/          # Mirrors lib/core/utils/
├── widget/
│   ├── features/       # Mirrors lib/features/
│   └── shared/         # Mirrors lib/shared/widgets/
└── helpers/            # Shared test utilities
```

Test file đặt ở vị trí tương ứng với source file, thêm suffix `_test.dart`.

---

## 3. Quy ước đặt tên / Naming Conventions

### 3.1 Files & Directories

| Quy tắc | Ví dụ |
|---------|-------|
| Tên file: `snake_case.dart` | `location_detail_screen.dart` |
| Tên thư mục: `snake_case` | `trip_journal/`, `local_service/` |
| Test files: `<source>_test.dart` | `location_repository_test.dart` |
| Generated files: `<source>.g.dart`, `<source>.freezed.dart` | `location.g.dart` |
| ARB files: `app_<locale>.arb` | `app_vi.arb`, `app_en.arb` |

### 3.2 Classes & Types

| Loại | Quy tắc | Ví dụ |
|------|---------|-------|
| Classes | `PascalCase` | `LocationRepository`, `AudioService` |
| Models (freezed) | `PascalCase`, không suffix | `Location`, `Route`, `AudioTrack` |
| Widgets | `PascalCase`, suffix `Widget` chỉ khi mơ hồ | `AudioPlayerCard`, `LocationTile` |
| Screens | `PascalCase` + suffix `Screen` | `LocationDetailScreen`, `HomeScreen` |
| Enums | `PascalCase`, values `camelCase` | `ServiceType { homestay, restaurant }` |
| Extensions | `PascalCase` + suffix `Extension` | `StringExtension`, `ContextExtension` |

### 3.3 Providers (Riverpod)

| Loại | Quy tắc | Ví dụ |
|------|---------|-------|
| StateNotifier | suffix `Notifier` | `AudioPlayerNotifier` |
| Provider | suffix `Provider` | `nearbyLocationsProvider` |
| FutureProvider | suffix `Provider` | `locationDetailProvider` |
| StreamProvider | suffix `Provider` | `playbackPositionProvider` |
| Provider variable | `camelCase` + suffix `Provider` | `locationRepositoryProvider` |

### 3.4 Repositories

| Quy tắc | Ví dụ |
|---------|-------|
| Abstract class: suffix `Repository` | `LocationRepository` |
| Implementation: suffix `RepositoryImpl` | `LocationRepositoryImpl` |
| File name: `<domain>_repository.dart` | `location_repository.dart` |

### 3.5 Models (freezed + json_serializable)

```dart
// File: lib/data/models/location.dart
@freezed
class Location with _$Location {
  const factory Location({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    String? description,
    @Default([]) List<String> imageUrls,
    @Default([]) List<AudioTrack> audioTracks,
    DateTime? createdAt,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
```

### 3.6 Phase Tags trong Comments

Sử dụng phase tags để đánh dấu code thuộc phase nào:

```dart
/// Ghi hành trình real-time [Phase 3]
class TripRecordingScreen extends ConsumerWidget { ... }

/// RAG chatbot service [Phase 5]
class ChatRagService { ... }

// TODO: [Phase 2] Thêm geofencing cho GPS autoplay
// TODO: [Phase 3] Thêm user authentication check
// FIXME: [Phase 1] Xử lý edge case khi GPS timeout
```

---

## 4. Dependency Flow / Luồng phụ thuộc

```
┌─────────────┐
│  features/   │  ← UI Layer (Screens + Widgets)
└──────┬──────┘
       │ depends on
       ▼
┌─────────────┐
│  providers/  │  ← State Management Layer
└──────┬──────┘
       │ depends on
       ▼
┌─────────────┐
│  data/       │  ← Data Layer
│  ├── repos   │     (repositories, models, services)
│  ├── models  │
│  └── services│
└──────┬──────┘
       │ depends on
       ▼
┌─────────────┐
│  core/       │  ← Foundation Layer
│  (config,    │     (config, constants, utils)
│   constants, │
│   utils)     │
└─────────────┘
```

**Quy tắc phụ thuộc**:
- `features/` → `providers/`, `shared/`, `core/` (KHÔNG trực tiếp vào `data/`)
- `providers/` → `data/`, `core/`
- `data/` → `core/`
- `shared/` → `core/` (KHÔNG vào `data/` hay `providers/`)
- `core/` → không phụ thuộc vào gì trong app

---

## 5. Import Order Convention

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Third-party packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';

// 4. Project imports — core
import 'package:toursapp/core/constants/app_constants.dart';

// 5. Project imports — data
import 'package:toursapp/data/models/location.dart';

// 6. Project imports — providers
import 'package:toursapp/providers/location_providers.dart';

// 7. Relative imports (same feature)
import 'widgets/location_tile.dart';
```

---

## 6. File Generation Commands

```bash
# Chạy build_runner cho freezed + json_serializable + drift + riverpod
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild khi thay đổi)
flutter pub run build_runner watch --delete-conflicting-outputs

# Generate l10n files
flutter gen-l10n

# Generate launcher icons
flutter pub run flutter_launcher_icons

# Generate splash screen
flutter pub run flutter_native_splash:create
```

---

*Tiếp theo: [10 — Phase Roadmap](10-phase-roadmap.md) — Lộ trình phát triển chi tiết theo từng phase*
