# 02 — Tech Stack & Justification

> Lựa chọn công nghệ và lý do — tại sao Flutter, Supabase, drift, flutter_map?

---

[<< 01 Problem & Solution](01-problem-and-solution.md) | **02 Tech Stack** | [03 System Architecture >>](03-system-architecture.md)

| # | Tài liệu | Link |
|---|----------|------|
| 00 | Tổng quan | [00-overview.md](00-overview.md) |
| 01 | Vấn đề & Giải pháp | [01-problem-and-solution.md](01-problem-and-solution.md) |
| 02 | **Tech Stack (đang xem)** | — |
| 03 | Kiến trúc hệ thống | [03-system-architecture.md](03-system-architecture.md) |
| 04 | Database Design | [04-database-design.md](04-database-design.md) |

---

## 1. Framework: Flutter 3.x

### 1.1 Tại sao Flutter?

| Tiêu chí | Flutter | React Native | Lý do chọn Flutter |
|----------|:-------:|:------------:|-------------------|
| **Shared codebase** | Mobile + Web + Desktop | Mobile + Web (limited) | Admin panel dùng Flutter Web — cùng codebase |
| **Ngôn ngữ** | Dart (strongly typed) | JavaScript/TypeScript | Dart compile AOT → native performance |
| **UI rendering** | Skia engine (own render) | Native bridge | Consistent UI trên Android/iOS, không bị "looks different" |
| **Map packages** | flutter_map (mature) | react-native-maps | flutter_map + OSM = free, offline tiles support |
| **Audio packages** | just_audio + audio_service | expo-av / react-native-track-player | just_audio hỗ trợ background playback + lock screen controls |
| **Offline DB** | drift (code-gen, type-safe) | WatermelonDB / Realm | drift = type-safe SQL, reactive streams, migrations |
| **State Management** | Riverpod (compile-safe) | Redux / Zustand / Jotai | Riverpod = compile-time safety, no context dependency |
| **Material 3** | Native support | Third-party | Material 3 theming out-of-the-box |
| **Performance** | ~60 FPS, AOT compiled | JS bridge overhead | Map scrolling + audio playback mượt hơn |
| **Hot reload** | Sub-second | ~2-3 seconds | Developer productivity cao hơn |
| **Community** | 165k+ GitHub stars | 120k+ GitHub stars | Cả hai đều mature, Flutter growing faster |

### 1.2 Rủi ro của Flutter

| Rủi ro | Mức độ | Giải pháp |
|--------|:------:|-----------|
| Web performance (Admin panel) | Trung bình | Admin panel ít animation, chủ yếu CRUD — acceptable |
| Package ecosystem nhỏ hơn RN | Thấp | Các packages cần thiết đều có và mature |
| Dart ít developer quen | Thấp | Dart syntax gần Java/Kotlin, học nhanh |

---

## 2. Backend: Supabase

### 2.1 So sánh Backend-as-a-Service

| Tiêu chí | Supabase | Firebase | Appwrite | Lý do chọn Supabase |
|----------|:--------:|:--------:|:--------:|---------------------|
| **Database** | PostgreSQL (relational) | Firestore (NoSQL) | MariaDB | Tourism data = relational (locations → routes → stops). PostgreSQL phù hợp nhất |
| **Query language** | SQL (full PostgreSQL) | Firestore queries (limited) | REST/GraphQL | Complex geo queries, JOIN, aggregate — cần full SQL |
| **Geo extensions** | PostGIS / earthdistance | GeoPoint (basic) | Không có | earthdistance → tìm điểm gần, distance calculation |
| **Vector search** | pgvector (native) | Không có | Không có | Phase 5: RAG chatbot cần vector embeddings |
| **Auth** | Built-in (Phase 3) | Built-in | Built-in | Supabase Auth + RLS = row-level security |
| **Storage** | S3-compatible | Cloud Storage | S3-compatible | Audio files, images |
| **Edge Functions** | Deno runtime | Cloud Functions | Cloud Functions | Serverless cho webhook, sync, AI pipeline |
| **Realtime** | WebSocket (built-in) | WebSocket (built-in) | WebSocket | Phase 3: real-time sync |
| **Free tier** | 500MB DB, 1GB storage, unlimited API | 1GB Firestore, 5GB storage | Self-hosted (free) | Supabase free tier đủ cho MVP |
| **Pricing** | Predictable ($25/mo Pro) | Pay-per-read/write (khó dự đoán) | Free (self-host) | Firebase có thể "bill shock" với read-heavy app |
| **Open source** | Yes (self-hostable) | No | Yes | Có thể self-host nếu cần |
| **Vendor lock-in** | Thấp (PostgreSQL standard) | Cao (Firestore proprietary) | Thấp | Migrate sang bất kỳ PostgreSQL nào |

### 2.2 Tại sao không Firebase?

1. **Firestore = NoSQL** — Tourism data rất relational: `locations` → `routes` → `route_stops` → `audio_guides`. NoSQL sẽ cần denormalization phức tạp.
2. **Geo queries hạn chế** — Firestore chỉ hỗ trợ GeoPoint basic, không có PostGIS-level queries.
3. **Pricing** — Read-heavy app (map browse, list services) → Firebase charges per-read → khó kiểm soát chi phí.
4. **Không có pgvector** — Phase 5 cần vector search cho AI chatbot.

### 2.3 Supabase Architecture cho ToursApp

```
┌──────────────────────────────────────────────┐
│              Supabase Cloud                   │
│                                               │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐ │
│  │ PostgREST │  │ Supabase  │  │ Supabase  │ │
│  │ Auto API  │  │ Auth      │  │ Storage   │ │
│  │           │  │ (Phase 3) │  │ (audio,   │ │
│  │ REST +    │  │           │  │  images)  │ │
│  │ Realtime  │  │ JWT +     │  │           │ │
│  │           │  │ RLS       │  │ S3-compat │ │
│  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘ │
│        │              │              │        │
│        ▼              ▼              ▼        │
│  ┌───────────────────────────────────────┐    │
│  │         PostgreSQL Database            │    │
│  │                                        │    │
│  │  + earthdistance (geo queries)         │    │
│  │  + pgvector (AI embeddings, Phase 5)   │    │
│  │  + pg_trgm (text search)               │    │
│  │  + RLS (Row-Level Security)            │    │
│  └───────────────────────────────────────┘    │
│                                               │
│  ┌───────────────────────────────────────┐    │
│  │     Edge Functions (Deno runtime)      │    │
│  │  • Sync endpoint                       │    │
│  │  • AI TTS pipeline (Phase 2)           │    │
│  │  • Push notifications (Phase 3)        │    │
│  └───────────────────────────────────────┘    │
└──────────────────────────────────────────────┘
```

---

## 3. Flutter Packages

### 3.1 Core Packages

| Package | Mục đích | Phase | Ghi chú |
|---------|----------|:-----:|---------|
| `flutter_riverpod` ^2.5 | State management | P1 | Compile-safe, no context dependency |
| `riverpod_annotation` ^2.3 | Code generation cho Riverpod | P1 | `@riverpod` annotation → less boilerplate |
| `go_router` ^14.0 | Declarative routing | P1 | Deep linking, nested navigation, redirect |
| `supabase_flutter` ^2.5 | Supabase SDK | P1 | Auth, DB, Storage, Realtime |
| `drift` ^2.18 | SQLite ORM (offline DB) | P1 | Type-safe, reactive, migrations, code-gen |
| `sqlite3_flutter_libs` ^0.5 | SQLite native library | P1 | Required by drift |

### 3.2 Map & Location Packages

| Package | Mục đích | Phase | Ghi chú |
|---------|----------|:-----:|---------|
| `flutter_map` ^7.0 | OSM map widget | P1 | Free, no API key, tile layers |
| `flutter_map_tile_caching` ^9.0 | Offline tile caching | P1 | Download regions, LRU cache |
| `latlong2` ^0.9 | Lat/lng utilities | P1 | Distance calculation, bounding box |
| `geolocator` ^12.0 | GPS location | P1 | High accuracy, background location |
| `flutter_map_marker_cluster` ^1.4 | Marker clustering | P1 | Cluster khi zoom out |
| `flutter_compass` ^0.8 | Compass heading | P2 | Hướng di chuyển trên map |

### 3.3 Audio Packages

| Package | Mục đích | Phase | Ghi chú |
|---------|----------|:-----:|---------|
| `just_audio` ^0.9 | Audio playback | P1 | Stream + local file, background play |
| `audio_service` ^0.18 | Background audio + lock screen | P1 | Lock screen controls, notification |
| `audio_session` ^0.1 | Audio focus management | P1 | Duck other apps, handle interruptions |

### 3.4 UI & UX Packages

| Package | Mục đích | Phase | Ghi chú |
|---------|----------|:-----:|---------|
| `cached_network_image` ^3.3 | Image caching | P1 | Lazy load + disk cache |
| `shimmer` ^3.0 | Loading skeleton | P1 | Skeleton loading cho UX |
| `flutter_animate` ^4.5 | Animations | P1 | Declarative animations |
| `photo_view` ^0.15 | Image zoom/pan | P1 | Gallery zoom |
| `share_plus` ^9.0 | Share content | P1 | Share to social media |
| `url_launcher` ^6.2 | Open external URLs | P1 | Phone, email, web links |
| `flutter_svg` ^2.0 | SVG rendering | P1 | Icons, illustrations |

### 3.5 Utility Packages

| Package | Mục đích | Phase | Ghi chú |
|---------|----------|:-----:|---------|
| `mobile_scanner` ^5.0 | QR code scanning | P1 | Camera-based QR scan |
| `connectivity_plus` ^6.0 | Network status | P1 | Detect online/offline |
| `path_provider` ^2.1 | File system paths | P1 | App documents, cache directory |
| `package_info_plus` ^8.0 | App version info | P1 | Version display, update check |
| `permission_handler` ^11.3 | Runtime permissions | P1 | Location, camera, storage |
| `sentry_flutter` ^8.0 | Error tracking | P1 | Crash reporting, performance monitoring |
| `freezed` ^2.5 | Immutable models | P1 | Code-gen immutable data classes |
| `json_serializable` ^6.8 | JSON serialization | P1 | toJson/fromJson code-gen |
| `envied` ^0.5 | Environment variables | P1 | Compile-time env vars (API keys) |

### 3.6 Phase 2+ Packages (dự kiến)

| Package | Mục đích | Phase | Ghi chú |
|---------|----------|:-----:|---------|
| `workmanager` ^0.5 | Background tasks | P2 | Background sync, geofence check |
| `flutter_local_notifications` ^17.0 | Local notifications | P2 | GPS proximity alerts |
| `camera` ^0.11 | Camera capture | P3 | Trip photos |
| `image_picker` ^1.1 | Gallery picker | P3 | Pick from gallery |
| `pdf` ^3.10 | PDF generation | P3 | Export travel book |
| `google_sign_in` ^6.2 | Google auth | P3 | Social login |
| `sign_in_with_apple` ^6.1 | Apple auth | P3 | iOS social login |
| `in_app_purchase` ^3.2 | IAP | P4 | Premium features |

---

## 4. State Management: Riverpod

### 4.1 Tại sao Riverpod? (vs BLoC, Provider, GetX)

| Tiêu chí | Riverpod | BLoC | Provider | GetX |
|----------|:--------:|:----:|:--------:|:----:|
| **Compile-time safety** | Yes | No | No | No |
| **No BuildContext dependency** | Yes | No | No | Partial |
| **Testability** | Excellent (ProviderContainer) | Good (BlocTest) | Moderate | Poor |
| **Code generation** | Yes (`@riverpod`) | Yes (`@bloc`) | No | No |
| **Learning curve** | Medium | High | Low | Low |
| **Combining providers** | Native (ref.watch) | Complex (MultiBlocProvider) | ProxyProvider | Not great |
| **Auto-dispose** | Built-in | Manual | Manual | Unreliable |
| **Async support** | `AsyncValue<T>` built-in | Streams | ChangeNotifier | Rx |
| **Package maintenance** | Active (Remi Rousselet) | Active (Very Good Ventures) | Deprecated (same author → Riverpod) | Controversial |

### 4.2 Riverpod patterns cho ToursApp

```dart
// Provider types sử dụng trong project:

// 1. Simple state
@riverpod
class SelectedLanguage extends _$SelectedLanguage {
  @override
  String build() => 'vi'; // default Vietnamese
}

// 2. Async data from Supabase
@riverpod
Future<List<Location>> nearbyLocations(
  NearbyLocationsRef ref, {
  required double lat,
  required double lng,
  double radius = 5000,
}) async {
  final repo = ref.watch(locationRepositoryProvider);
  return repo.getNearby(lat, lng, radius);
}

// 3. Stream (realtime updates)
@riverpod
Stream<SyncStatus> syncStatus(SyncStatusRef ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.statusStream;
}

// 4. Family (parameterized)
@riverpod
Future<AudioGuide?> audioGuide(
  AudioGuideRef ref,
  String locationId,
) async {
  final repo = ref.watch(audioRepositoryProvider);
  return repo.getForLocation(locationId);
}
```

---

## 5. Offline Database: drift (SQLite)

### 5.1 Tại sao drift? (vs sqflite, Hive, Isar)

| Tiêu chí | drift | sqflite | Hive | Isar |
|----------|:-----:|:-------:|:----:|:----:|
| **Type-safe queries** | Yes (code-gen) | No (raw SQL strings) | N/A (KV store) | Yes |
| **Reactive streams** | Built-in `watch()` | No | `box.watch()` | `watchLazy()` |
| **Migrations** | `@DriftDatabase(version)` + `MigrationStrategy` | Manual | No concept | Auto |
| **SQL support** | Full SQL (JOINs, subqueries, aggregate) | Full SQL | No SQL | Limited |
| **Code generation** | `build_runner` → type-safe DAOs | None | `build_runner` (adapters) | `build_runner` |
| **Relations** | References, JOINs | Manual JOINs | Manual | Links |
| **Testing** | In-memory database | In-memory | In-memory | In-memory |
| **Web support** | Yes (sql.js / IndexedDB) | No | Yes | Discontinued |
| **Performance** | Excellent (SQLite native) | Good | Fast (binary) | Fast |

### 5.2 Tại sao cần relational DB cho offline?

Tourism data có nhiều quan hệ:
- `locations` ← `audio_guides` (1:N)
- `routes` ← `route_stops` → `locations` (M:N through table)
- `service_providers` ← `provider_categories` (N:1)
- `locations` + `service_providers` → geo queries (earthdistance)

**Hive/Isar = key-value / document store** → phải denormalize, duplicate data, manual joins → phức tạp.

**drift = SQLite with full SQL** → giữ nguyên relational schema, JOINs, geo queries → đơn giản, consistent với PostgreSQL schema trên Supabase.

### 5.3 drift schema ví dụ

```dart
// Drift table definitions mirror Supabase PostgreSQL schema
class Locations extends Table {
  TextColumn get id => text()();
  TextColumn get nameVi => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get nameKo => text().nullable()();
  TextColumn get nameZh => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get provinceId => text().references(Provinces, #id)();
  IntColumn get syncVersion => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
```

---

## 6. Map: flutter_map + OpenStreetMap

### 6.1 Tại sao không Google Maps?

| Tiêu chí | flutter_map + OSM | Google Maps Flutter | Lý do chọn OSM |
|----------|:-----------------:|:-------------------:|----------------|
| **Chi phí** | Free (OSM tiles) | $7/1000 requests (sau free tier) | Budget MVP = 0 đồng cho map |
| **API key required** | No | Yes | Không cần quản lý API keys |
| **Offline tiles** | flutter_map_tile_caching | Không hỗ trợ (vi phạm ToS) | Critical: offline trên đèo |
| **Custom tiles** | Yes (bất kỳ tile server) | Limited | Có thể dùng tile server riêng |
| **Map style** | Multiple tile providers | Google style only | Tùy chỉnh theme (dark mode, terrain) |
| **Marker clustering** | flutter_map_marker_cluster | google_maps_cluster_manager | Cả hai đều có |
| **Performance** | Good | Better (native) | flutter_map đủ cho use case |
| **Open source** | Yes | Proprietary | Không bị vendor lock-in |

### 6.2 Tile providers dự kiến

| Provider | Dùng cho | Chi phí |
|----------|---------|---------|
| **OpenStreetMap** (tile.openstreetmap.org) | Development, default | Free (fair use policy) |
| **Thunderforest Outdoors** | Outdoor/terrain view | Free tier: 150K tiles/month |
| **MapTiler** | Production | Free tier: 100K tiles/month |
| **Self-hosted** (Phase 2+) | Offline package generation | VPS cost |

### 6.3 Offline tile strategy

```
WiFi (homestay/city):
  ├─ App auto-download route tiles khi browse
  ├─ User có thể download "Offline Package":
  │     "Vòng cung đông" → zoom 10-16 → ~50 MB
  │     "Vòng cung tây"  → zoom 10-16 → ~45 MB
  │     "Hà Giang city"  → zoom 12-18 → ~20 MB
  └─ Tiles lưu trong flutter_map_tile_caching store

Trên đèo (không có 4G):
  ├─ Map render từ cached tiles
  ├─ GPS overlay vẫn hoạt động (geolocator = GPS hardware)
  └─ Markers + location data từ drift SQLite
```

---

## 7. Development Tools & Workflow

### 7.1 IDE & Tools

| Tool | Mục đích | Ghi chú |
|------|----------|---------|
| **VS Code** / **Android Studio** | IDE chính | Flutter extension + Dart extension |
| **Git** | Version control | GitHub / Bitbucket |
| **FVM** (Flutter Version Manager) | Flutter SDK management | Lock Flutter version across team |
| **Melos** *(nếu monorepo)* | Monorepo management | Nếu tách packages |

### 7.2 Code Generation

| Generator | Package | Chạy khi nào |
|-----------|---------|-------------|
| Riverpod | `riverpod_generator` | `@riverpod` annotation |
| drift | `drift_dev` | Table definitions |
| Freezed | `freezed` | `@freezed` data classes |
| JSON | `json_serializable` | `@JsonSerializable` models |
| Env | `envied_generator` | `@Envied` env vars |

```bash
# Chạy code generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode (development)
dart run build_runner watch --delete-conflicting-outputs
```

### 7.3 Linting & Formatting

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
    require_trailing_commas: true
    prefer_single_quotes: true
```

### 7.4 Testing Strategy

| Loại test | Tool | Coverage target | Phase |
|-----------|------|:---------------:|:-----:|
| Unit test | `flutter_test` + `mocktail` | 80%+ repositories, services | P1 |
| Widget test | `flutter_test` | 60%+ critical widgets | P1 |
| Integration test | `integration_test` | Happy paths | P1 |
| Golden test | `golden_toolkit` | UI regression | P2 |
| E2E test | `patrol` | Critical flows | P2 |

### 7.5 CI/CD (dự kiến)

| Stage | Tool | Trigger |
|-------|------|---------|
| Lint + analyze | `dart analyze` | Every push |
| Test | `flutter test` | Every push |
| Build Android | `flutter build apk/appbundle` | PR merge → main |
| Build iOS | `flutter build ipa` | PR merge → main |
| Deploy Web Admin | `flutter build web` → Vercel/Cloudflare Pages | PR merge → main |
| App Distribution | Firebase App Distribution | Tag release |
| Store Release | Google Play Console + App Store Connect | Manual trigger |

---

## 8. Internationalization (i18n)

### 8.1 Strategy

| Aspect | Choice | Ghi chú |
|--------|--------|---------|
| **Package** | `flutter_localizations` + `intl` | Flutter built-in |
| **Format** | ARB (Application Resource Bundle) | Standard cho Flutter |
| **Languages** | vi (default), en, ko, zh | 4 ngôn ngữ |
| **Content i18n** | Database columns: `name_vi`, `name_en`, `name_ko`, `name_zh` | Separate columns, không dùng JSON |
| **UI i18n** | ARB files: `app_vi.arb`, `app_en.arb`, `app_ko.arb`, `app_zh.arb` | Code-gen `AppLocalizations` |

### 8.2 ARB file structure

```
lib/l10n/
├── app_vi.arb     # Tiếng Việt (default/source)
├── app_en.arb     # English
├── app_ko.arb     # 한국어
└── app_zh.arb     # 中文
```

```json
// app_vi.arb (source)
{
  "@@locale": "vi",
  "appTitle": "Tour Guide trong túi",
  "mapTab": "Bản đồ",
  "routesTab": "Tuyến đường",
  "servicesTab": "Dịch vụ",
  "articlesTab": "Bài viết",
  "nearbyLocations": "Điểm gần đây",
  "downloadOffline": "Tải offline",
  "scanQR": "Quét QR",
  "audioGuide": "Audio Guide",
  "distanceAway": "{distance} km",
  "@distanceAway": {
    "placeholders": {
      "distance": { "type": "String" }
    }
  }
}
```

### 8.3 Quy trình dịch

| Phase | Vi | En | Ko | Zh |
|:-----:|:--:|:--:|:--:|:--:|
| P1 | Manual (source) | Manual | GPT + review | GPT + review |
| P2+ | Manual | Manual | Native speaker | Native speaker |

**UI text**: ~200-300 strings → dịch 1 lần, maintain theo feature.
**Content** (audio, articles, location descriptions): ~500-1000 entries → workload lớn hơn, cần pipeline.

---

## 9. Tổng kết Tech Stack

```
┌──────────────────────────────────────────────────────────────┐
│                      ToursApp Tech Stack                      │
│                                                               │
│  FRONTEND           STATE          ROUTING                    │
│  Flutter 3.x        Riverpod       go_router                  │
│  Dart               @riverpod      Declarative                │
│  Material 3         AsyncValue     Deep links                 │
│                                                               │
│  MAP                AUDIO          OFFLINE DB                  │
│  flutter_map        just_audio     drift (SQLite)             │
│  OSM tiles          audio_service  Type-safe SQL              │
│  Tile caching       Background     Reactive streams           │
│  Marker cluster     Lock screen    Migrations                 │
│                                                               │
│  BACKEND            STORAGE        AUTH (Phase 3)             │
│  Supabase           Supabase       Supabase Auth              │
│  PostgreSQL         Storage (S3)   Google / Apple             │
│  Edge Functions     CDN            JWT + RLS                  │
│  PostgREST          Cloudflare R2                             │
│                                                               │
│  EXTENSIONS         I18N           MONITORING                 │
│  earthdistance      flutter_intl   Sentry                    │
│  pgvector (P5)      ARB format     Firebase Analytics         │
│  pg_trgm            4 languages    Crashlytics                │
│                                                               │
│  DEV TOOLS          CODE GEN       CI/CD                      │
│  VS Code            build_runner   GitHub Actions             │
│  FVM                freezed        Firebase App Dist          │
│  dart analyze       riverpod_gen   Vercel (web admin)         │
│                     drift_dev                                 │
└──────────────────────────────────────────────────────────────┘
```

---

*Cập nhật lần cuối: 2026-06-08*
