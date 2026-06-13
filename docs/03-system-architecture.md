# 03 — Kiến trúc hệ thống / System Architecture

> Kiến trúc tổng thể, data flow patterns, offline strategy, battery optimization, và sync architecture.

---

[<< 02 Tech Stack](02-tech-stack.md) | **03 System Architecture** | [04 Database Design >>](04-database-design.md)

| # | Tài liệu | Link |
|---|----------|------|
| 00 | Tổng quan | [00-overview.md](00-overview.md) |
| 01 | Vấn đề & Giải pháp | [01-problem-and-solution.md](01-problem-and-solution.md) |
| 02 | Tech Stack | [02-tech-stack.md](02-tech-stack.md) |
| 03 | **Kiến trúc hệ thống (đang xem)** | — |
| 04 | Database Design | [04-database-design.md](04-database-design.md) |

---

## 1. High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         FLUTTER APP                                  │
│                   (Android + iOS + Web Admin)                        │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                    FEATURES LAYER (UI)                        │   │
│  │  MapScreen  RoutesScreen  ServicesScreen  ArticlesScreen     │   │
│  │  AudioPlayerWidget  QRScanScreen  AdminDashboard (Web)      │   │
│  └──────────────────────────┬───────────────────────────────────┘   │
│                              │                                       │
│  ┌──────────────────────────┴───────────────────────────────────┐   │
│  │                   PROVIDERS LAYER (Riverpod)                  │   │
│  │  locationProviders  audioProviders  routeProviders           │   │
│  │  serviceProviders   articleProviders  syncProviders          │   │
│  │  mapProviders       settingsProviders  connectivityProvider  │   │
│  └──────────────────────────┬───────────────────────────────────┘   │
│                              │                                       │
│  ┌──────────────────────────┴───────────────────────────────────┐   │
│  │                  REPOSITORIES LAYER                           │   │
│  │  LocationRepository  AudioRepository  RouteRepository        │   │
│  │  ServiceRepository   ArticleRepository  SyncRepository      │   │
│  │                                                               │   │
│  │  Pattern: check connectivity → offline (drift) / online      │   │
│  │           (supabase) → merge → return                        │   │
│  └──────────┬──────────────────────────────┬────────────────────┘   │
│             │                              │                        │
│  ┌──────────┴──────────┐     ┌─────────────┴────────────────┐      │
│  │  LOCAL SERVICES     │     │  REMOTE SERVICES              │      │
│  │                     │     │                               │      │
│  │  drift SQLite DB    │     │  SupabaseClient               │      │
│  │  File Cache Manager │     │  ├─ .from('table').select()   │      │
│  │  Tile Cache Store   │     │  ├─ .storage.from('bucket')   │      │
│  │  Audio File Cache   │     │  └─ .functions.invoke('fn')   │      │
│  │  SharedPreferences  │     │                               │      │
│  └──────────┬──────────┘     └─────────────┬────────────────┘      │
│             │                              │                        │
└─────────────┼──────────────────────────────┼────────────────────────┘
              │                              │
              ▼                              ▼ HTTPS REST + WebSocket
    ┌─────────────────┐         ┌────────────────────────────────────┐
    │  LOCAL DEVICE    │         │         SUPABASE CLOUD              │
    │                  │         │                                     │
    │  SQLite file     │         │  ┌─────────┐  ┌────────┐  ┌─────┐ │
    │  Cached tiles    │         │  │PostgREST│  │Supabase│  │Edge │ │
    │  Cached audio    │         │  │Auto API │  │Storage │  │Funcs│ │
    │  Cached images   │         │  └────┬────┘  └───┬────┘  └──┬──┘ │
    └─────────────────┘         │       │            │          │    │
                                 │  ┌────┴────────────┴──────────┴──┐ │
                                 │  │    PostgreSQL Database         │ │
                                 │  │    + earthdistance             │ │
                                 │  │    + pgvector (Phase 5)        │ │
                                 │  │    + pg_trgm                   │ │
                                 │  └───────────────────────────────┘ │
                                 └────────────────────────────────────┘
                                                  │
                                                  ▼
                                 ┌────────────────────────────────────┐
                                 │       EXTERNAL SERVICES             │
                                 │                                     │
                                 │  OpenStreetMap tile servers         │
                                 │  Cloudflare R2 CDN (audio/images)  │
                                 │  OpenAI API (Phase 2/5 — TTS, GPT) │
                                 │  FCM Push (Phase 3)                 │
                                 └────────────────────────────────────┘
```

---

## 2. Layer Architecture Chi Tiết

### 2.1 Features Layer (UI)

```
lib/features/
├── map/
│   ├── screens/         # MapScreen, LocationDetailScreen
│   ├── widgets/         # MapWidget, MarkerCluster, LocationCard
│   └── map_module.dart  # Module exports
├── audio/
│   ├── screens/         # AudioPlayerScreen, QRScanScreen
│   ├── widgets/         # MiniPlayer, AudioProgress, PlaybackControls
│   └── audio_module.dart
├── routes/
│   ├── screens/         # RoutesListScreen, RouteDetailScreen
│   ├── widgets/         # RouteCard, StopTimeline, DifficultyBadge
│   └── routes_module.dart
├── services/
│   ├── screens/         # ServicesListScreen, ServiceDetailScreen
│   ├── widgets/         # ServiceCard, CategoryFilter, ContactButtons
│   └── services_module.dart
├── articles/
│   ├── screens/         # ArticlesListScreen, ArticleDetailScreen
│   ├── widgets/         # ArticleCard, ReadingProgress
│   └── articles_module.dart
├── settings/
│   ├── screens/         # SettingsScreen, LanguageSelector, OfflineManager
│   └── settings_module.dart
└── admin/               # (Flutter Web only)
    ├── screens/         # AdminDashboard, ContentEditor, LocationEditor
    └── admin_module.dart
```

### 2.2 Providers Layer (Riverpod)

```
lib/providers/
├── location_providers.dart    # nearbyLocations, locationDetail, locationSearch
├── audio_providers.dart       # currentAudio, playbackState, audioQueue
├── route_providers.dart       # routesList, routeDetail, routeStops
├── service_providers.dart     # servicesList, serviceDetail, categoryFilter
├── article_providers.dart     # articlesList, articleDetail
├── map_providers.dart         # mapController, currentPosition, mapBounds
├── sync_providers.dart        # syncStatus, lastSyncTime, pendingSync
├── connectivity_provider.dart # isOnline, connectionType
└── settings_providers.dart    # selectedLanguage, theme, offlinePackages
```

### 2.3 Repositories Layer (Offline-First Logic)

```dart
// Pattern: mỗi repository quản lý offline-first logic
class LocationRepository {
  final SupabaseClient _supabase;
  final AppDatabase _localDb;       // drift
  final ConnectivityService _connectivity;

  Future<List<Location>> getNearby(double lat, double lng, double radius) async {
    // 1. Luôn đọc từ local DB trước (nhanh, offline-safe)
    final localResults = await _localDb.locationDao.getNearby(lat, lng, radius);

    // 2. Nếu online, fetch fresh data + update local
    if (await _connectivity.isOnline) {
      try {
        final remoteResults = await _supabase
            .from('locations')
            .select()
            .filter(/* geo filter */)
            .execute();

        // 3. Upsert vào local DB
        await _localDb.locationDao.upsertAll(remoteResults);

        return remoteResults;
      } catch (e) {
        // Network error → fallback to local
        return localResults;
      }
    }

    return localResults;
  }
}
```

### 2.4 Services Layer

```
lib/services/
├── supabase_service.dart       # Supabase client wrapper
├── connectivity_service.dart   # Network status monitoring
├── sync_service.dart           # Background sync queue
├── audio_cache_service.dart    # Audio file download + cache
├── tile_cache_service.dart     # Map tile download + cache
├── location_service.dart       # GPS position stream
└── analytics_service.dart      # Event tracking
```

---

## 3. Data Flow Patterns

### Pattern A — Online Content Browsing (có internet)

```
User mở Danh sách Routes
        │
        ▼
    RoutesListScreen
        │
        ▼
    ref.watch(routesListProvider)
        │
        ▼
    RouteRepository.getAll()
        │
        ├─── [1] Đọc local DB (drift) → có data cũ → hiển thị ngay
        │
        ├─── [2] Fetch Supabase (background)
        │         POST /rest/v1/routes?select=*,route_stops(*)
        │                │
        │                ▼
        │         [3] Upsert local DB (drift)
        │                │
        │                ▼
        └─── [4] Provider emit new data → UI rebuild → smooth transition
```

**Key**: Hiển thị data cũ ngay lập tức, update ngầm khi fetch xong. User không phải chờ loading.

### Pattern B — Offline Mode (trên đèo Hà Giang, không có 4G)

```
User mở Map trên đèo Mã Pí Lèng
        │
        ▼
    MapScreen
        │
        ├─── Map tiles: flutter_map_tile_caching
        │    └─ Render từ cached tiles (đã download qua WiFi)
        │
        ├─── GPS position: geolocator
        │    └─ GPS hardware → không cần internet
        │
        ├─── Nearby locations: drift SQLite
        │    └─ SELECT * FROM locations
        │       WHERE earth_distance(ll_to_earth(lat, lng),
        │             ll_to_earth(?, ?)) < ?
        │
        ├─── Audio guides: local file cache
        │    └─ File đã download → just_audio play local file
        │
        └─── Actions (favorite, note): drift sync_queue
             └─ INSERT INTO sync_queue (action, data)
                → Sync lên Supabase khi có mạng
```

**Key**: Mọi thứ hoạt động từ local storage. User actions được queue lại để sync sau.

### Pattern C — GPS Auto-Detect Location → Audio (Phase 1) ⭐ PRIMARY

```
User đứng tại / đi qua một địa điểm du lịch
        │
        ▼
    LocationService (geolocator)
        │
    GPS position update (distanceFilter: 100m)
        │
        ▼
    ProximityChecker (foreground)
        │
        ├── Query drift: SELECT * FROM locations
        │   WHERE distance(user_lat, user_lng, loc_lat, loc_lng)
        │         < geofence_radius_meters (default 300m)
        │   ORDER BY distance ASC LIMIT 1
        │
        ├── [Không có location gần] → skip, chờ GPS update tiếp
        │
        └── [Tìm thấy location gần nhất]
                │
                ├── Đã phát audio location này rồi? → skip (basic dedup)
                │
                ▼
            Hiển thị location card + auto-play audio
                │
                ▼
            AudioRepository.getForLocation(locationId)
                │
                ├── [Cached] Local file → just_audio play
                └── [Not cached] Stream URL + cache for next time
                │
                ▼
            AudioPlayerWidget
                │
                ├── Auto-select language theo locale setting
                ├── just_audio → play
                ├── audio_service → lock screen controls
                └── MiniPlayer → persistent bottom bar
```

**Key**: Đây là tính năng CHÍNH — user chỉ cần đi đến địa điểm, app tự nhận diện và phát audio. Không cần thao tác gì.

### Pattern C2 — QR Scan to Audio (Phase 1) — BACKUP

```
User quét QR code tại điểm tham quan
        │
        ▼
    QRScanScreen (mobile_scanner)
        │
    QR data = "toursapp://location/{location_id}"
        │
        ▼
    go_router: navigate to LocationDetailScreen(id)
        │
        ▼
    AudioRepository.getForLocation(locationId)
        │
        ├── [Cached] → play local
        └── [Not cached] → stream + cache
        │
        ▼
    AudioPlayerWidget (same as Pattern C)
```

**Key**: Phương thức phụ — dùng khi GPS không chính xác, trong nhà, hoặc user muốn chọn cụ thể.

### Pattern D — Smart Autoplay + Alert Intelligence (Phase 2)

```
Nâng cấp Pattern C với các quy tắc thông minh:
        │
        ▼
    LocationService (geolocator BACKGROUND mode)
        │
    GPS position update (adaptive frequency)
        │
        ▼
    SmartGeofenceChecker (thay thế ProximityChecker đơn giản)
        │
        ├── Query drift: locations within adaptive radius
        │
        ├── Check Alert Intelligence rules:
        │   ├── Cooldown: đã alert location này trong 30 phút? → skip
        │   ├── Speed-aware: đang chạy > 40km/h? → chỉ alert priority ≥ 7
        │   ├── Priority: location importance (1-10 scoring)
        │   ├── Battery: < 20%? → reduce check frequency, tắt auto-play
        │   └── User preference: auto-play on/off, notification style
        │
        ▼
    [Pass all rules] → Trigger Smart Alert
        │
        ├── flutter_local_notifications (khi app background)
        ├── Audio auto-play (khi app foreground + setting enabled)
        └── Log to trip timeline (if Phase 3)
```

**Phase 1 vs Phase 2**:
| Khía cạnh | Phase 1 (Basic) | Phase 2 (Smart) |
|-----------|-----------------|-----------------|
| GPS mode | Foreground only | Foreground + Background |
| Proximity check | Đơn giản (nearest within radius) | Alert Intelligence rules |
| Cooldown | Basic dedup (đã phát rồi → skip) | Timer 30 phút + priority override |
| Speed-aware | Không | Có (>40km/h → chỉ điểm quan trọng) |
| Battery-aware | Không | Có (<20% → giảm frequency) |
| Notification | Không (chỉ foreground) | Có (background notification) |

### Pattern E — Trip Timeline Recording (Phase 3)

```
User bắt đầu "Ghi hành trình"
        │
        ▼
    TripService.startTrip()
        │
        ├── Create trip record (drift)
        ├── Start GPS tracking (geolocator background)
        │     └── Record position every 30s → trip_entries
        ├── Listen for events:
        │     ├── Audio played → auto-add entry (type: 'audio')
        │     ├── Photo taken → auto-add entry (type: 'photo')
        │     ├── QR scanned → auto-add entry (type: 'checkin')
        │     └── User note → manual entry (type: 'note')
        │
        ▼
    [End of day / User stops trip]
        │
        ▼
    TripTimeline display:
        │
        09:00  ── Started at Hà Giang city
        10:30  ── 📍 Dinh Vua Mèo (audio played)
        11:15  ── 📷 Photo at Mã Pí Lèng viewpoint
        12:00  ── 🍜 Lunch at Quán Phở Lý Sơn
        14:30  ── 📍 Sông Nho Quế (QR scanned)
        16:00  ── ✏️ "Đẹp quá! Đèo khó nhưng đáng"
        18:00  ── Arrived at Đồng Văn homestay
        │
        ▼
    Export options:
        ├── Share as image (Instagram story)
        ├── Export PDF travel book
        └── Sync to cloud (Supabase)
```

### Pattern F — Province Auto-Detection on App Launch (Phase 1)

```
User mở app
        │
        ▼
    SplashScreen / AppInit
        │
        ▼
    geolocator.getCurrentPosition()
        │
        ├── [GPS OK] Got (lat, lng)
        │       │
        │       ▼
        │   ProvinceRepository.detectProvince(lat, lng)
        │       │
        │       ├── Query drift: SELECT * FROM provinces
        │       │   WHERE earth_distance(ll_to_earth(lat,lng),
        │       │         ll_to_earth(?,?)) < 50km
        │       │   ORDER BY distance ASC LIMIT 1
        │       │
        │       ├── [Found] → Set activeProvince → Load nội dung tỉnh
        │       │
        │       └── [Not found / tỉnh chưa có data]
        │               │
        │               ▼
        │           Hiện province picker (danh sách tỉnh có data)
        │           Default highlight: Hà Giang
        │
        └── [GPS denied / error / timeout 5s]
                │
                ▼
            Check SharedPreferences (last_province_id)
                │
                ├── [Có] → Load tỉnh đã dùng lần trước
                └── [Không] → Default Hà Giang
```

**Key**: Mọi query data (locations, routes, services, articles) đều filter theo `activeProvince`. Khi mở rộng thêm tỉnh, chỉ cần seed thêm data — code không đổi.

**Lưu ý khi mở rộng multi-province:**
- provinces table đã sẵn sàng (Phase 1 chỉ seed Hà Giang)
- Tất cả locations, routes, service_providers đều có `province_id` FK
- articles có `related_location_ids` → tự liên kết theo province
- Offline packages tổ chức theo province
- User có thể switch tỉnh thủ công bất kỳ lúc nào (Settings hoặc Province Picker)

---

## 4. Offline-First Strategy

### 4.1 Ba tầng cache / Three Cache Tiers

```
┌─────────────────────────────────────────────────────────────────┐
│                    OFFLINE CACHE STRATEGY                        │
│                                                                  │
│  TIER 1: AUTO-CACHE (tự động, không cần user action)            │
│  ├── Map tiles đã xem → flutter_map_tile_caching (LRU)         │
│  ├── Location data đã browse → drift SQLite                     │
│  ├── Images đã hiển thị → cached_network_image                  │
│  ├── Article text đã đọc → drift SQLite                         │
│  └── Size limit: 200 MB (configurable)                          │
│                                                                  │
│  TIER 2: USER DOWNLOAD (user chọn download)                     │
│  ├── "Offline Package" cho route:                               │
│  │     Map tiles (zoom 10-16) + location data + audio files     │
│  │     Ví dụ: "Vòng cung đông" package = ~100 MB               │
│  ├── Individual audio guide download                            │
│  └── Size: hiển thị trước khi download                          │
│                                                                  │
│  TIER 3: ONLINE-ONLY (không cache)                              │
│  ├── Bản đồ zoom rất cao (>16) ở vùng ngoài route              │
│  ├── Real-time data: reviews, ratings (Phase 3)                 │
│  ├── Admin panel content                                        │
│  └── AI chatbot responses (Phase 5)                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Offline Package Structure

```
offline_packages/
├── vong-cung-dong/
│   ├── manifest.json          # Package metadata, version, size
│   ├── tiles/                 # Map tiles (zoom 10-16)
│   │   ├── 10/               # ~500 tiles
│   │   ├── 12/               # ~2000 tiles
│   │   ├── 14/               # ~8000 tiles
│   │   └── 16/               # ~32000 tiles
│   ├── audio/                 # Audio files (Opus 64kbps)
│   │   ├── dinh-vua-meo_vi.opus
│   │   ├── dinh-vua-meo_en.opus
│   │   ├── ma-pi-leng_vi.opus
│   │   └── ...
│   ├── images/                # Location images (compressed)
│   └── data.json              # Location + route + service data
│
├── vong-cung-tay/
│   └── ... (same structure)
│
└── ha-giang-city/
    └── ... (same structure)
```

---

## 5. Battery Optimization Strategy

### 5.1 Bảng kỹ thuật tối ưu pin / Battery Optimization Techniques

| # | Kỹ thuật | Mô tả | Phase | Tiết kiệm |
|---|----------|-------|:-----:|:----------:|
| 1 | **Significant Motion API** | Chỉ bật GPS khi device đang di chuyển. Dừng GPS khi user ngồi yên (ăn trưa, nghỉ) | P2 | ~40% GPS drain |
| 2 | **Adaptive Polling Interval** | Tốc độ cao (>30km/h): GPS mỗi 10s. Tốc độ thấp (<10km/h): GPS mỗi 30s. Dừng: mỗi 60s | P2 | ~25% GPS drain |
| 3 | **Geofence Batching** | Dùng OS-level geofence (Android: GeofencingClient, iOS: CLCircularRegion) thay vì liên tục check khoảng cách trong app | P2 | ~30% CPU |
| 4 | **Background Audio Priority** | Khi phát audio, giảm GPS polling. Audio service chạy foreground service (Android) để OS không kill | P1 | Prevent kill |
| 5 | **Tile Pre-fetch** | Download tiles khi có WiFi. Không fetch tiles qua cellular khi battery < 30% | P1 | Network drain |
| 6 | **Battery Kill Switch** | Battery < 15%: tắt GPS background, chỉ giữ audio playback. Hiển thị warning | P2 | Emergency save |
| 7 | **Dark Mode Map** | Dark mode tile style giảm OLED screen power. Auto-switch dark mode khi battery < 25% | P2 | ~15% screen |

### 5.2 GPS Power States

```
Battery Level       GPS Mode              Polling         Features
─────────────       ────────              ───────         ────────
> 50%               Full accuracy         10-30s          All features
30-50%              Balanced              20-45s          All features
15-30%              Battery saver         45-90s          Reduced alerts
< 15%               Kill switch           OFF             Audio only
Charging            Full accuracy         10s             All features
```

---

## 6. Alert Intelligence Rules (Phase 2)

Hệ thống thông báo thông minh — tránh spam user khi đi qua nhiều điểm liên tiếp trên đèo.

### 6.1 Quy tắc / Rules

| Rule | Mô tả | Ví dụ |
|------|-------|-------|
| **Cooldown** | Sau khi alert 1 location, chờ ít nhất 5 phút (configurable) trước alert tiếp. Cùng location: cooldown 30 phút | Qua Mã Pí Lèng → alert. 2 phút sau qua viewpoint gần → skip |
| **Speed-aware radius** | Tốc độ > 40km/h: mở rộng radius (800m) + alert sớm hơn. Tốc độ < 10km/h (đi bộ): radius 200m | Xe máy chạy nhanh → cần alert sớm để kịp dừng |
| **Priority ranking** | Location có priority A/B/C. Nếu 2 locations gần nhau, chỉ alert priority cao hơn | Dinh Vua Mèo (A) vs quán nước gần đó (C) → chỉ alert A |
| **Radius adaptive** | Vùng đông điểm (Đồng Văn): giảm radius (300m). Vùng thưa (đèo): tăng radius (1km) | Tránh alert liên tục ở vùng nhiều điểm |
| **Battery-aware** | Battery < 30%: chỉ alert priority A. Battery < 15%: tắt alerts | Tiết kiệm pin cho navigation |
| **Time-of-day** | Sau 20:00: chỉ alert restaurants, homestay. Không alert điểm tham quan (đã tối) | Đêm → chỉ cần biết ăn ở đâu, ngủ đâu |
| **User feedback** | User dismiss alert → giảm priority location đó. User listen audio → tăng priority tương tự | Học từ hành vi user |

### 6.2 Alert Flow

```
GPS Position Update
       │
       ▼
  ┌─────────────────┐
  │ Query nearby    │ drift: locations within radius
  │ locations       │ (radius = f(speed))
  └────────┬────────┘
           │ candidates[]
           ▼
  ┌─────────────────┐
  │ Filter:         │ Remove locations in cooldown
  │ Cooldown check  │ Remove low-priority if battery low
  └────────┬────────┘
           │ filtered[]
           ▼
  ┌─────────────────┐
  │ Rank:           │ Sort by priority × distance × user_pref
  │ Priority sort   │ Take top 1
  └────────┬────────┘
           │ best_candidate
           ▼
  ┌─────────────────┐
  │ Time-of-day     │ Night? Only services. Day? All types.
  │ filter          │
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐     ┌──────────────────┐
  │ ALERT!          │────▶│ Notification +   │
  │ Set cooldown    │     │ Optional autoplay │
  └─────────────────┘     └──────────────────┘
```

---

## 7. Sync Architecture

### 7.1 Sync Queue (drift → Supabase)

```
┌──────────────────────────────────────────────────────────────┐
│                     SYNC ARCHITECTURE                         │
│                                                               │
│  OFFLINE (trên đèo)                                          │
│  ─────────────────                                           │
│  User actions → drift sync_queue table                       │
│                                                               │
│  sync_queue:                                                  │
│  ┌─────┬──────────┬───────────────────┬──────────┬────────┐  │
│  │ id  │ action   │ data (JSON)       │ status   │ retry  │  │
│  ├─────┼──────────┼───────────────────┼──────────┼────────┤  │
│  │ 1   │ favorite │ {location_id: x}  │ pending  │ 0      │  │
│  │ 2   │ note     │ {text: "..."}     │ pending  │ 0      │  │
│  │ 3   │ photo    │ {path: "/..."}    │ pending  │ 0      │  │
│  └─────┴──────────┴───────────────────┴──────────┴────────┘  │
│                                                               │
│  ONLINE (có WiFi)                                            │
│  ────────────────                                            │
│  connectivity_plus detects online                            │
│       │                                                      │
│       ▼                                                      │
│  SyncService.processQueue()                                  │
│       │                                                      │
│       ├── Read sync_queue WHERE status = 'pending'           │
│       ├── For each item:                                     │
│       │     ├── POST to Supabase                             │
│       │     ├── Success → mark 'synced'                      │
│       │     └── Fail → increment retry, mark 'failed'       │
│       │           └── retry > 3 → mark 'error' (manual)     │
│       │                                                      │
│       ├── Fetch remote changes (sync_metadata.updated_at)   │
│       │     └── Upsert into drift tables                    │
│       │                                                      │
│       └── Clean up synced items older than 7 days           │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

### 7.2 Conflict Resolution

| Loại data | Strategy | Lý do |
|-----------|----------|-------|
| **Content** (locations, routes, articles) | Server-wins | Admin quản lý content → server là source of truth |
| **User data** (favorites, notes, photos) | Client-wins | User action mới nhất là đúng nhất |
| **Trip data** (GPS track, timeline) | Merge (append) | GPS points là append-only, không conflict |
| **Settings** | Client-wins (last-write) | User settings luôn ưu tiên device hiện tại |

### 7.3 Sync Metadata

```sql
-- Mỗi bảng có sync version tracking
-- App lưu last_sync_version per table
-- Fetch: WHERE updated_at > last_sync_time

-- sync_metadata table (drift local)
CREATE TABLE sync_metadata (
  table_name   TEXT PRIMARY KEY,
  last_sync_at TEXT,  -- ISO 8601 timestamp
  sync_version INTEGER DEFAULT 0,
  row_count    INTEGER DEFAULT 0
);
```

### 7.4 Sync Triggers

| Trigger | Action |
|---------|--------|
| App launch (online) | Full sync check (all tables) |
| connectivity_plus: offline → online | Process sync queue + incremental sync |
| Background timer (every 15 min, if online) | Incremental sync |
| User pull-to-refresh | Force sync specific table |
| Admin publishes new content | Push notification → trigger sync (Phase 3) |

---

## 8. Security Architecture (Phase 1)

### 8.1 Phase 1 — No Auth, Read-Only

```
Phase 1 Security Model:
─────────────────────────

Flutter App (anon)  ──────────────────►  Supabase
                     anon API key           │
                     (public, in APK)       ▼
                                      PostgREST
                                           │
                                           ▼
                                      RLS Policies:
                                      ┌─────────────────────────┐
                                      │ SELECT: is_published=true│
                                      │ INSERT: DENY (anon)     │
                                      │ UPDATE: DENY (anon)     │
                                      │ DELETE: DENY (anon)     │
                                      └─────────────────────────┘

Admin Panel (Web)  ───────────────────►  Supabase
                    service_role key       │
                    (server-side only,     ▼
                     NEVER in client)   Full CRUD access
```

### 8.2 API Key Strategy

| Key | Nơi lưu | Quyền |
|-----|---------|-------|
| `anon` key | Flutter app (envied, compile-time) | Chỉ SELECT published content |
| `service_role` key | Admin panel server-side / Edge Functions | Full CRUD |

**Lưu ý**: `anon` key có trong APK là acceptable vì RLS policies chỉ cho phép đọc published content. Không có sensitive data trong Phase 1.

---

## 9. Tổng kết kiến trúc / Architecture Summary

```
NGUYÊN TẮC THIẾT KẾ:
─────────────────────

1. OFFLINE-FIRST    → Mọi data có local copy. Online = bonus.
2. BATTERY-AWARE    → GPS adaptive. Kill switch < 15%.
3. SMART ALERTS     → Cooldown + priority + speed-aware. Không spam.
4. SYNC QUEUE       → Actions offline → queue → sync khi online.
5. LAYERED          → UI → Providers → Repositories → Services.
6. SERVER WINS      → Content: server là truth. User data: client wins.
7. PROGRESSIVE      → Phase 1 simple (QR). Phase 2 smart (GPS).
                       Phase 3 rich (Journal). Scale up dần.
```

---

*Cập nhật lần cuối: 2026-06-08*
