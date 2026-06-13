[< 04 — Database Design](04-database-design.md) | [06 — Backend Services >](06-backend-services.md)

---

# 05 — Mobile App Architecture

Kiến truc ung dung mobile Flutter cho **"Cuon nhat ky biet noi"** — ung dung du lich Ha Giang voi Audio Guide, offline-first, da ngon ngu.

---

## 1. Navigation Structure (GoRouter)

Ung dung su dung **go_router** de quan ly navigation voi **ShellRoute** cho tab layout va nested routes cho detail screens.

### 1.1 Tab Layout (Bottom Navigation)

```
ShellRoute (MainScaffold + BottomNavigationBar)
├── /home          → HomeScreen (Explore)
├── /routes        → RoutesListScreen
├── /services      → ServicesScreen
├── /articles      → ArticlesScreen
└── /more          → MoreScreen (Settings, About, Downloads)
```

| Tab | Icon | Ma man hinh | Mo ta |
|-----|------|-------------|-------|
| Home / Explore | `Icons.explore` | `HomeScreen` | Ban do, dia diem gan, banner |
| Routes | `Icons.route` | `RoutesListScreen` | Danh sach tuyen duong du lich |
| Services | `Icons.store` | `ServicesScreen` | Nha nghi, homestay, xe may |
| Articles | `Icons.article` | `ArticlesScreen` | Bai viet, meo du lich |
| More | `Icons.more_horiz` | `MoreScreen` | Cai dat, tai xuong, gioi thieu |

### 1.2 Detail Screens

```dart
GoRoute(
  path: '/location/:id',   // Chi tiet dia diem + audio player
  builder: (context, state) => LocationDetailScreen(
    id: state.pathParameters['id']!,
  ),
),
GoRoute(
  path: '/route/:id',      // Chi tiet tuyen duong + ban do
  builder: (context, state) => RouteDetailScreen(
    id: state.pathParameters['id']!,
  ),
),
GoRoute(
  path: '/provider/:id',   // Chi tiet nha cung cap dich vu
  builder: (context, state) => ProviderDetailScreen(
    id: state.pathParameters['id']!,
  ),
),
GoRoute(
  path: '/article/:slug',  // Bai viet chi tiet
  builder: (context, state) => ArticleDetailScreen(
    slug: state.pathParameters['slug']!,
  ),
),
```

### 1.3 Standalone Screens

| Route | Screen | Phase | Mo ta |
|-------|--------|-------|-------|
| `/scanner` | QRScannerScreen | Phase 1 | Quet QR code tai dia diem |
| `/chat` | AIChatScreen | Phase 5 | Chatbot AI du lich |
| `/trip-planner` | TripPlannerScreen | Phase 3 | Lap ke hoach chuyen di |
| `/downloads` | DownloadManagerScreen | Phase 1 | Quan ly tai lieu offline |
| `/settings` | SettingsScreen | Phase 1 | Ngon ngu, theme, storage |

### 1.4 Deep Linking (QR Code Flow)

```
QR code tai dia diem
    → URL: https://hagiangtour.app/location/{uuid}
    → app_links (Android) / Universal Links (iOS)
    → GoRouter match: /location/:id
    → LocationDetailScreen + tu dong phat audio
```

Cau hinh trong `AndroidManifest.xml` va `apple-app-site-association`:

```dart
// router.dart
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [/* tab routes */],
    ),
    // Detail routes (ngoai ShellRoute de hien thi full screen)
    GoRoute(path: '/location/:id', ...),
    GoRoute(path: '/route/:id', ...),
    GoRoute(path: '/scanner', ...),
    GoRoute(path: '/chat', ...),
  ],
);
```

---

## 2. State Management (Riverpod)

Su dung **flutter_riverpod** voi pattern **AsyncNotifier** cho async data va **Notifier** cho synchronous state.

### 2.1 Provider Categories

```
lib/providers/
├── province_providers.dart     → Active province, auto-detect, province picker
├── proximity_providers.dart    → ⭐ GPS auto-detect location, proximity check, auto-play trigger
├── location_providers.dart     → Dia diem, nearby, chi tiet (filter by province)
├── audio_providers.dart        → Audio player state, playlist, progress
├── route_providers.dart        → Tuyen duong, stops, progress (filter by province)
├── content_providers.dart      → Articles, banners, categories
├── offline_providers.dart      → Offline status, sync state
├── locale_providers.dart       → Ngon ngu UI, ngon ngu noi dung
└── download_providers.dart     → Download queue, progress, storage
```

### 2.2 Province Auto-Detection (App Launch)

```dart
@riverpod
class ActiveProvince extends _$ActiveProvince {
  @override
  Future<Province> build() async {
    // 1. Try GPS detect
    final province = await _detectFromGPS();
    if (province != null) return province;

    // 2. Fallback: last used province
    final lastId = ref.read(sharedPrefsProvider).getString('last_province_id');
    if (lastId != null) {
      final saved = await ref.read(provinceRepositoryProvider).getById(lastId);
      if (saved != null) return saved;
    }

    // 3. Default: Ha Giang
    return ref.read(provinceRepositoryProvider).getDefault();
  }

  Future<Province?> _detectFromGPS() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 5),
      );
      return ref.read(provinceRepositoryProvider)
          .findNearest(pos.latitude, pos.longitude);
    } catch (_) {
      return null;
    }
  }

  // User chon thu cong tu province picker
  Future<void> switchProvince(Province province) async {
    ref.read(sharedPrefsProvider).setString('last_province_id', province.id);
    state = AsyncData(province);
  }
}
```

Moi provider fetch data deu phu thuoc `activeProvinceProvider`:

```dart
@riverpod
Future<List<Location>> locationList(Ref ref) async {
  final province = await ref.watch(activeProvinceProvider.future);
  return ref.read(locationRepositoryProvider)
      .getByProvince(province.id);
}
```

### 2.3 GPS Proximity Auto-Detect → Auto-Play Audio (Phase 1) ⭐

Tinh nang CHINH cua app — tu dong nhan dien dia diem va phat audio:

```dart
@riverpod
class ProximityDetector extends _$ProximityDetector {
  final Set<String> _playedLocationIds = {};

  @override
  Stream<Location?> build() async* {
    final locationService = ref.watch(locationServiceProvider);
    final province = await ref.watch(activeProvinceProvider.future);

    await for (final position in locationService.positionStream(
      distanceFilter: 100, // chi update khi di chuyen 100m
    )) {
      final nearest = await ref.read(locationRepositoryProvider)
          .findNearestInRadius(
            latitude: position.latitude,
            longitude: position.longitude,
            radiusMeters: 300, // geofence_radius_meters
            provinceId: province.id,
          );

      if (nearest != null && !_playedLocationIds.contains(nearest.id)) {
        _playedLocationIds.add(nearest.id);
        yield nearest; // trigger auto-play
      }
    }
  }

  void resetPlayed() => _playedLocationIds.clear();
}

// Listen va tu dong phat audio
@riverpod
class AutoPlayController extends _$AutoPlayController {
  @override
  void build() {
    ref.listen(proximityDetectorProvider, (_, next) {
      final location = next.valueOrNull;
      if (location != null) {
        _autoPlayAudio(location);
      }
    });
  }

  Future<void> _autoPlayAudio(Location location) async {
    final locale = ref.read(localeProvider);
    final audio = await ref.read(audioRepositoryProvider)
        .getForLocation(location.id, language: locale.languageCode);
    if (audio != null) {
      ref.read(audioPlayerProvider.notifier).play(audio);
    }
  }
}
```

**Uu tien phat hien**: GPS auto-detect (tu dong, khong can thao tac) > QR scan (thu cong, backup).

### 2.4 AsyncNotifier Pattern (Du lieu tu API/Database)

```dart
// Dung cho du lieu can fetch tu Supabase hoac drift cache
@riverpod
class LocationList extends _$LocationList {
  @override
  Future<List<Location>> build() async {
    final repo = ref.watch(locationRepositoryProvider);
    return repo.getLocations(); // offline-first logic trong repo
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(locationRepositoryProvider);
      return repo.getLocations(forceRefresh: true);
    });
  }
}

// Dung cho chi tiet voi parameter
@riverpod
class LocationDetail extends _$LocationDetail {
  @override
  Future<Location> build(String id) async {
    final repo = ref.watch(locationRepositoryProvider);
    return repo.getLocationById(id);
  }
}
```

### 2.3 Notifier Pattern (Synchronous State)

```dart
// Dung cho state don gian, dong bo
@riverpod
class AudioPlayerState extends _$AudioPlayerState {
  @override
  AudioState build() {
    return AudioState.idle();
  }

  void play(AudioGuide guide) {
    state = AudioState.playing(guide: guide, position: Duration.zero);
  }

  void pause() {
    state = state.copyWith(isPlaying: false);
  }

  void updatePosition(Duration position) {
    state = state.copyWith(position: position);
  }
}

// Locale state
@riverpod
class LocaleState extends _$LocaleState {
  @override
  AppLocale build() {
    return AppLocale(
      uiLanguage: 'vi',       // Ngon ngu giao dien
      contentLanguage: 'vi',   // Ngon ngu noi dung audio/text
    );
  }

  void setUILanguage(String lang) {
    state = state.copyWith(uiLanguage: lang);
  }

  void setContentLanguage(String lang) {
    state = state.copyWith(contentLanguage: lang);
  }
}
```

### 2.4 Khi nao dung AsyncNotifier vs Notifier

| Tinh huong | Pattern | Vi du |
|------------|---------|-------|
| Fetch data tu API/DB | `AsyncNotifier` | LocationList, ArticleList |
| State don gian, dong bo | `Notifier` | AudioPlayerState, LocaleState |
| Data voi parameter | `AsyncNotifier` voi `family` | LocationDetail(id) |
| Computed/derived data | `Provider` | filteredLocations |
| Stream data | `StreamNotifier` | RealtimeBanners (Phase 3) |

---

## 3. Offline-First Data Flow

### 3.1 Repository Pattern

Moi entity co 1 Repository lam trung gian giua UI va data sources (Supabase remote + drift local).

```
UI (Screen/Widget)
    ↓ ref.watch(provider)
Provider (Riverpod)
    ↓ repo.getData()
Repository
    ├── 1. Check drift cache (SQLite)
    │   ├── Co data + chua stale → Return cache
    │   └── Khong co data HOAC stale
    │       ├── 2. Check connectivity
    │       │   ├── Online → Fetch Supabase → Update cache → Return
    │       │   └── Offline → Return cache (du cu) HOAC empty state
    └── Error handling: return cache on any network error
```

### 3.2 Implementation

```dart
class LocationRepository {
  final SupabaseClient _supabase;
  final AppDatabase _db;  // drift
  final ConnectivityService _connectivity;

  static const _cacheMaxAge = Duration(hours: 6);

  Future<List<Location>> getLocations({bool forceRefresh = false}) async {
    // 1. Check cache
    if (!forceRefresh) {
      final cached = await _db.locationDao.getAllLocations();
      final lastSync = await _db.syncMetaDao.getLastSync('locations');

      if (cached.isNotEmpty && lastSync != null) {
        final age = DateTime.now().difference(lastSync);
        if (age < _cacheMaxAge) {
          return cached; // Cache con tuoi
        }
      }
    }

    // 2. Try fetch from Supabase
    if (await _connectivity.isOnline) {
      try {
        final response = await _supabase
            .from('locations')
            .select('*, audio_guides(*), categories(*)')
            .eq('status', 'published')
            .order('sort_order');

        final locations = (response as List)
            .map((json) => Location.fromJson(json))
            .toList();

        // 3. Update cache
        await _db.locationDao.upsertLocations(locations);
        await _db.syncMetaDao.updateLastSync('locations');

        return locations;
      } catch (e) {
        // Network error → fallback to cache
        final cached = await _db.locationDao.getAllLocations();
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    }

    // 4. Offline → return whatever cache we have
    return _db.locationDao.getAllLocations();
  }
}
```

### 3.3 Connectivity Detection

```dart
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(
        (result) => result != ConnectivityResult.none,
      );

  Future<bool> get isOnline async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
```

### 3.4 Sync Metadata (drift table)

```dart
// Theo doi thoi gian sync cho tung entity type
class SyncMeta extends Table {
  TextColumn get entityType => text()();  // 'locations', 'articles', ...
  DateTimeColumn get lastSyncAt => dateTime()();
  IntColumn get recordCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {entityType};
}
```

---

## 4. Audio Player Architecture

### 4.1 Global Audio State

Audio player la **global state** vi nguoi dung co the navigate giua cac man hinh ma van nghe audio (giong Spotify mini player).

```
App Root (ProviderScope)
├── MaterialApp.router
│   ├── MainScaffold
│   │   ├── Body (tab content)
│   │   ├── MiniPlayerOverlay ← hien khi dang phat
│   │   └── BottomNavigationBar
│   └── Detail Screens
│       └── LocationDetailScreen
│           └── FullAudioPlayer ← controls day du
└── AudioService (background, global)
```

### 4.2 Audio State Model

```dart
@freezed
class AudioState with _$AudioState {
  const factory AudioState.idle() = _Idle;
  const factory AudioState.loading({
    required AudioGuide guide,
  }) = _Loading;
  const factory AudioState.playing({
    required AudioGuide guide,
    required Duration position,
    required Duration duration,
    required double speed,
  }) = _Playing;
  const factory AudioState.paused({
    required AudioGuide guide,
    required Duration position,
    required Duration duration,
  }) = _Paused;
  const factory AudioState.error({
    required String message,
    AudioGuide? guide,
  }) = _Error;
}
```

### 4.3 just_audio Integration

```dart
@riverpod
class AudioController extends _$AudioController {
  late final AudioPlayer _player;

  @override
  AudioState build() {
    _player = AudioPlayer();

    // Listen to player state changes
    _player.playerStateStream.listen((playerState) {
      // Update Riverpod state based on player events
    });

    _player.positionStream.listen((position) {
      state = state.maybeMap(
        playing: (s) => s.copyWith(position: position),
        orElse: () => state,
      );
    });

    ref.onDispose(() => _player.dispose());

    return const AudioState.idle();
  }

  Future<void> play(AudioGuide guide) async {
    state = AudioState.loading(guide: guide);

    try {
      // Uu tien file offline, fallback to URL
      final source = await _resolveAudioSource(guide);
      await _player.setAudioSource(source);
      await _player.play();

      state = AudioState.playing(
        guide: guide,
        position: Duration.zero,
        duration: _player.duration ?? Duration.zero,
        speed: 1.0,
      );
    } catch (e) {
      state = AudioState.error(message: e.toString(), guide: guide);
    }
  }

  Future<AudioSource> _resolveAudioSource(AudioGuide guide) async {
    // 1. Check local file (downloaded offline)
    final localPath = await _offlineStorage.getAudioPath(guide.id);
    if (localPath != null && File(localPath).existsSync()) {
      return AudioSource.file(localPath);
    }

    // 2. Pre-buffer from URL
    return AudioSource.uri(
      Uri.parse(guide.audioUrl),
      tag: MediaItem(
        id: guide.id,
        title: guide.title,
        artist: 'Ha Giang Tour Guide',
      ),
    );
  }

  Future<void> pause() async => await _player.pause();
  Future<void> resume() async => await _player.play();
  Future<void> seek(Duration position) async => await _player.seek(position);
  void setSpeed(double speed) => _player.setSpeed(speed);
}
```

### 4.4 Mini Player Overlay

```dart
class MiniPlayerOverlay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioControllerProvider);

    return audioState.maybeMap(
      playing: (state) => _MiniPlayer(state: state),
      paused: (state) => _MiniPlayer(state: state),
      orElse: () => const SizedBox.shrink(), // An khi khong phat
    );
  }
}

// Hien thi o cuoi man hinh, tren BottomNavigationBar
// Bao gom: thumbnail, ten bai, progress bar, play/pause button
// Tap de mo FullAudioPlayer (bottom sheet)
```

### 4.5 Background Playback

```dart
// Cau hinh audio_service de phat nhac khi app o background
// Android: Foreground Service voi notification
// iOS: Background Audio mode trong Info.plist

// pubspec.yaml
// audio_service: ^0.18.x
// just_audio_background: ^0.0.x
```

### 4.6 Track List va Pre-buffer

- Data tu bang `audio_guides` — lien ket voi `locations` qua `location_id`
- Moi location co the co nhieu audio guides (nhieu ngon ngu)
- Chon audio theo `contentLanguage` hien tai cua nguoi dung
- Pre-buffer: khi nguoi dung mo LocationDetail, bat dau buffer audio truoc khi bam Play
- Playlist mode: phat lien tuc cac audio trong 1 route

---

## 5. Offline Download Manager

### 5.1 Download Types

| Loai | Noi dung | Kich thuoc uoc tinh |
|------|----------|---------------------|
| Audio Guides | MP3 files cho 1 khu vuc | ~50-100 MB (50 locations × 4 langs) |
| Map Tiles | OSM tiles cho Ha Giang | ~80-150 MB (zoom 8-15) |
| Content Data | Location + route data (JSON → drift) | ~5-10 MB |
| Images | Thumbnails va hinh anh chinh | ~30-50 MB |

### 5.2 Download Queue Architecture

```dart
@riverpod
class DownloadManager extends _$DownloadManager {
  @override
  DownloadState build() {
    return DownloadState(
      queue: [],
      activeDownloads: {},
      completedPacks: {},
      totalProgress: 0.0,
    );
  }

  Future<void> downloadRegionPack(String regionId) async {
    // 1. Fetch manifest: danh sach files can tai
    final manifest = await _getManifest(regionId);

    // 2. Add to queue
    for (final item in manifest.items) {
      _addToQueue(DownloadTask(
        id: item.id,
        url: item.url,
        localPath: item.localPath,
        type: item.type, // audio, tile, image
        sizeBytes: item.sizeBytes,
      ));
    }

    // 3. Start parallel downloads (max 3 concurrent)
    await _processQueue(maxConcurrent: 3);
  }

  // Resume support: check existing partial downloads
  Future<void> resumeIncomplete() async {
    final incomplete = await _db.downloadDao.getIncomplete();
    for (final task in incomplete) {
      _addToQueue(task);
    }
    await _processQueue(maxConcurrent: 3);
  }
}
```

### 5.3 Storage Management

```dart
class StorageManager {
  Future<StorageInfo> getStorageInfo() async {
    final appDir = await getApplicationDocumentsDirectory();
    return StorageInfo(
      audioSize: await _calculateDirSize('${appDir.path}/audio'),
      tilesSize: await _calculateDirSize('${appDir.path}/tiles'),
      imagesSize: await _calculateDirSize('${appDir.path}/images'),
      cacheSize: await _calculateDirSize('${appDir.path}/cache'),
      freeSpace: await _getFreeDiskSpace(),
    );
  }

  Future<void> clearRegionData(String regionId) async { ... }
  Future<void> clearAllOfflineData() async { ... }
}
```

### 5.4 Progress Tracking UI

```
DownloadManagerScreen
├── Region selector (Ha Giang, Dong Van, Meo Vac, ...)
├── Download button per region
├── Overall progress bar
├── Per-item progress list
│   ├── Audio files: 45/120 (37%)
│   ├── Map tiles: 1,200/3,500 (34%)
│   └── Images: 80/200 (40%)
├── Storage usage breakdown
└── Clear data button per region
```

---

## 6. Battery Optimization

Du lich ngoai troi = battery la van de lon. Cac bien phap toi uu:

### 6.1 GPS

| Thong so | Gia tri | Ly do |
|----------|---------|-------|
| `distanceFilter` | 100m (browsing), 200m (autoplay) | Giam so lan GPS update |
| `desiredAccuracy` | `LocationAccuracy.medium` | Khong can GPS chinh xac cao |
| Update interval | 30 giay (minimum) | Tranh update qua nhanh |
| Background mode | Chi Phase 2 (autoplay) | Khong track lien tuc |

### 6.2 Network

- **Batch sync**: gom nhieu thay doi va sync 1 lan thay vi tung cai
- **Cache-first**: luon doc cache truoc, chi fetch khi stale
- **Lazy loading**: chi tai data khi can (pagination, infinite scroll)
- **Image caching**: `cached_network_image` voi disk cache

### 6.3 Audio

- Pre-buffer chi khi nguoi dung mo detail screen
- Audio cache: file da tai thi khong tai lai
- Stop streaming khi pause qua 5 phut

### 6.4 Map Tiles

- Cache tiles da tai (LRU cache)
- Offline tiles: khong can network khi da tai
- Gioi han zoom level tai: 8-15 (khong tai zoom 16+ vi qua nhieu tiles)

---

## 7. Internationalization (i18n)

### 7.1 ARB Files

```
lib/l10n/
├── app_vi.arb    → Tieng Viet (mac dinh)
├── app_en.arb    → English
├── app_ko.arb    → 한국어
└── app_zh.arb    → 中文
```

```json
// app_vi.arb
{
  "@@locale": "vi",
  "appTitle": "Tour Guide trong túi",
  "exploreTab": "Khám phá",
  "routesTab": "Tuyến đường",
  "servicesTab": "Dịch vụ",
  "articlesTab": "Bài viết",
  "nearbyLocations": "Địa điểm gần đây",
  "downloadForOffline": "Tải về để dùng offline",
  "audioGuide": "Audio hướng dẫn",
  "minutesAway": "{minutes} phút đi bộ",
  "@minutesAway": {
    "placeholders": {
      "minutes": {"type": "int"}
    }
  }
}
```

### 7.2 Phan biet UI Language vs Content Language

Hai khai niem ngon ngu rieng biet:

| Loai | Mo ta | Vi du |
|------|-------|-------|
| **UI Language** | Ngon ngu giao dien (buttons, labels, menus) | Khach Han Quoc chon UI = 한국어 |
| **Content Language** | Ngon ngu noi dung (audio, mo ta dia diem) | Cung khach do chon content = English (vi muon nghe audio tieng Anh) |

```dart
// Locale state quan ly ca 2
class AppLocale {
  final String uiLanguage;      // 'vi', 'en', 'ko', 'zh'
  final String contentLanguage;  // 'vi', 'en', 'ko', 'zh'
}
```

### 7.3 Locale Switching

```dart
// MaterialApp cau hinh
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: Locale(ref.watch(localeProvider).uiLanguage),
  routerConfig: router,
);
```

---

## 8. Error Handling

### 8.1 Sentry Integration

```dart
Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://xxx@sentry.io/yyy';
      options.tracesSampleRate = 0.2;
      options.environment = kReleaseMode ? 'production' : 'development';
    },
    appRunner: () => runApp(
      ProviderScope(child: MyApp()),
    ),
  );
}
```

### 8.2 Offline Error Queuing

Khi offline, loi khong gui duoc den Sentry → queue lai va gui khi co mang:

```dart
class OfflineErrorQueue {
  final AppDatabase _db;

  Future<void> captureError(Object error, StackTrace stack) async {
    if (await _connectivity.isOnline) {
      Sentry.captureException(error, stackTrace: stack);
    } else {
      // Luu vao drift table, gui lai khi online
      await _db.errorQueueDao.insert(ErrorQueueEntry(
        error: error.toString(),
        stackTrace: stack.toString(),
        timestamp: DateTime.now(),
      ));
    }
  }

  // Goi khi phát hien online tro lai
  Future<void> flushQueue() async {
    final pending = await _db.errorQueueDao.getAll();
    for (final entry in pending) {
      await Sentry.captureMessage(entry.error);
      await _db.errorQueueDao.delete(entry.id);
    }
  }
}
```

### 8.3 Error UI Pattern

```dart
// Moi AsyncValue trong Riverpod xu ly 3 trang thai
ref.watch(locationListProvider).when(
  data: (locations) => LocationListView(locations: locations),
  loading: () => const ShimmerLoading(),
  error: (err, stack) => ErrorRetryWidget(
    message: context.l10n.loadingError,
    onRetry: () => ref.refresh(locationListProvider),
  ),
);
```

---

## 9. Deep Linking (QR Code Flow)

### 9.1 QR Code tai dia diem

Moi dia diem co 1 QR code chua URL:

```
https://hagiangtour.app/location/{uuid}
```

### 9.2 App Links Configuration

**Android** (`AndroidManifest.xml`):
```xml
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="https"
        android:host="hagiangtour.app"
        android:pathPrefix="/location" />
</intent-filter>
```

**iOS** (`apple-app-site-association`):
```json
{
  "applinks": {
    "apps": [],
    "details": [{
      "appID": "TEAM_ID.com.hagiang.toursapp",
      "paths": ["/location/*", "/route/*", "/article/*"]
    }]
  }
}
```

### 9.3 GoRouter Deep Link Handling

```dart
// GoRouter tu dong handle deep links
// URL https://hagiangtour.app/location/abc-123
// → Match GoRoute(path: '/location/:id')
// → Mo LocationDetailScreen(id: 'abc-123')
// → Tu dong phat audio guide

// Neu app chua cai → mo web fallback page voi link App Store/Play Store
```

---

**Tong ket**: Kien truc mobile tap trung vao 3 nguyen tac chinh:
1. **Offline-first** — moi thu hoat dong khong can mang
2. **Battery-efficient** — toi uu GPS, network, audio cho du lich ngoai troi
3. **Global audio** — audio player hoat dong xuyen suot app nhu Spotify
