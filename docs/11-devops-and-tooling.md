# 11 — DevOps & Tooling

> **"Tour Guide trong túi"** — A talking diary for Ha Giang

---

[<< 10 Phase Roadmap](10-phase-roadmap.md) | **11 DevOps & Tooling** | [12 Cost Analysis >>](12-cost-analysis.md)

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
| 10 | Lộ trình | [10-phase-roadmap.md](10-phase-roadmap.md) |
| 11 | **DevOps & Tooling (đang xem)** | — |
| 12 | Cost Analysis | [12-cost-analysis.md](12-cost-analysis.md) |

---

## 1. IDE Setup

### 1.1 Lựa chọn IDE

| IDE | Ưu điểm | Phù hợp cho |
|-----|---------|-------------|
| **VS Code** (khuyến nghị) | Nhẹ, extensions tốt, terminal tích hợp | Solo dev / nhóm nhỏ |
| **Android Studio** | Full IDE, emulator tích hợp, profiler | Team lớn, cần debugging nâng cao |

### 1.2 VS Code Extensions (Bắt buộc)

| Extension | Mục đích |
|-----------|----------|
| `Dart-Code.dart-code` | Dart language support |
| `Dart-Code.flutter` | Flutter tools, hot reload, device selector |
| `Nash.awesome-flutter-snippets` | Flutter code snippets |
| `alexisvt.flutter-snippets` | Thêm snippets cho Flutter |
| `jeroen-meijer.pubspec-assist` | Quản lý pubspec.yaml |
| `FelixAngeworworworworwor.bloc` | Bloc/Riverpod snippets (nếu dùng) |

### 1.3 VS Code Extensions (Khuyến nghị)

| Extension | Mục đích |
|-----------|----------|
| `eamodio.gitlens` | Git blame, history inline |
| `streetsidesoftware.code-spell-checker` | Kiểm tra chính tả |
| `gruntfuggly.todo-tree` | Highlight TODO/FIXME/HACK comments |
| `usernamehw.errorlens` | Hiện lỗi inline thay vì hover |
| `pflannery.vscode-versionlens` | Hiện version mới nhất cho packages |
| `ms-azuretools.vscode-docker` | Docker support (Supabase local) |
| `mtxr.sqltools` | SQL editor cho database |

### 1.4 VS Code Settings (`.vscode/settings.json`)

```json
{
  "dart.flutterSdkPath": "auto",
  "dart.lineLength": 100,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true,
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off"
  }
}
```

### 1.5 Android Studio Setup

| Plugin | Mục đích |
|--------|----------|
| Flutter plugin | Flutter support + hot reload |
| Dart plugin | Dart language support |
| Flutter Riverpod Snippets | Riverpod code generation |
| Rainbow Brackets | Dễ đọc nested widgets |
| Key Promoter X | Học keyboard shortcuts |

---

## 2. Git Workflow

### 2.1 Branch Strategy

```
main ─────────────────────────────────────────────────── (production)
  │
  ├── release/1.0.0 ──────────────────────── (release candidate)
  │
  ├── develop ────────────────────────────── (integration branch)
  │     │
  │     ├── feature/location-detail ───────── (feature branch)
  │     ├── feature/audio-player ──────────── (feature branch)
  │     ├── feature/offline-sync ──────────── (feature branch)
  │     ├── fix/map-tile-cache ────────────── (bugfix branch)
  │     └── chore/update-dependencies ─────── (maintenance)
  │
  └── hotfix/critical-crash ──────────────── (hotfix → main directly)
```

### 2.2 Branch Naming Convention

| Loại | Format | Ví dụ |
|------|--------|-------|
| Feature | `feature/<mô-tả>` | `feature/audio-player` |
| Bugfix | `fix/<mô-tả>` | `fix/map-tile-cache` |
| Hotfix | `hotfix/<mô-tả>` | `hotfix/critical-crash` |
| Chore | `chore/<mô-tả>` | `chore/update-dependencies` |
| Release | `release/<version>` | `release/1.0.0` |

### 2.3 Conventional Commits

Sử dụng [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

| Type | Mô tả | Ví dụ |
|------|-------|-------|
| `feat` | Tính năng mới | `feat(audio): add mini player persistent bar` |
| `fix` | Sửa bug | `fix(map): correct tile cache invalidation` |
| `docs` | Tài liệu | `docs: add offline sync architecture doc` |
| `style` | Format code (không đổi logic) | `style: apply dart format` |
| `refactor` | Refactor (không đổi behavior) | `refactor(repo): extract sync logic to mixin` |
| `perf` | Cải thiện performance | `perf(list): add pagination to location list` |
| `test` | Thêm/sửa tests | `test(audio): add unit tests for player state` |
| `chore` | Build, tooling, config | `chore: update flutter to 3.22` |
| `ci` | CI/CD changes | `ci: add integration test to PR workflow` |

### 2.4 Merge Strategy

- **Feature → develop**: Squash merge (clean history)
- **develop → release**: Merge commit (giữ history)
- **release → main**: Merge commit + tag
- **hotfix → main**: Merge commit + tag + cherry-pick to develop

### 2.5 Code Review Checklist

```markdown
## PR Review Checklist
- [ ] Code follows naming conventions (doc 09)
- [ ] No direct imports between features
- [ ] Models use freezed + json_serializable
- [ ] Providers follow naming convention
- [ ] Offline fallback works (nếu applicable)
- [ ] i18n: tất cả strings dùng AppLocalizations
- [ ] No hardcoded strings/colors/sizes
- [ ] Tests cover happy path + edge cases
- [ ] No TODO without ticket reference
- [ ] build_runner generates cleanly
```

---

## 3. CI/CD Pipeline

### 3.1 GitHub Actions — PR Check

```yaml
# .github/workflows/pr-check.yml
name: PR Check

on:
  pull_request:
    branches: [develop, main]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: flutter pub run build_runner build --delete-conflicting-outputs

      - name: Analyze
        run: flutter analyze --fatal-infos

      - name: Format check
        run: dart format --set-exit-if-changed .

      - name: Run tests
        run: flutter test --coverage

      - name: Check coverage
        run: |
          # Fail nếu coverage < 60%
          lcov_summary=$(lcov --summary coverage/lcov.info 2>&1)
          coverage=$(echo "$lcov_summary" | grep "lines" | awk '{print $2}' | sed 's/%//')
          if (( $(echo "$coverage < 60" | bc -l) )); then
            echo "Coverage $coverage% < 60% minimum"
            exit 1
          fi
```

### 3.2 Build Pipeline (Codemagic)

```yaml
# codemagic.yaml
workflows:
  android-release:
    name: Android Release
    triggering:
      events:
        - tag
      tag_patterns:
        - pattern: 'v*'
    environment:
      flutter: stable
      java: 17
    scripts:
      - name: Setup
        script: |
          flutter pub get
          flutter pub run build_runner build --delete-conflicting-outputs
      - name: Build APK
        script: flutter build appbundle --release
      - name: Run tests
        script: flutter test
    artifacts:
      - build/**/outputs/**/*.aab
    publishing:
      google_play:
        credentials: $GPLAY_SERVICE_ACCOUNT
        track: internal

  ios-release:
    name: iOS Release
    triggering:
      events:
        - tag
      tag_patterns:
        - pattern: 'v*'
    environment:
      flutter: stable
      xcode: latest
      cocoapods: default
    scripts:
      - name: Setup
        script: |
          flutter pub get
          flutter pub run build_runner build --delete-conflicting-outputs
      - name: Build IPA
        script: flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
    artifacts:
      - build/ios/ipa/*.ipa
    publishing:
      app_store_connect:
        api_key: $APP_STORE_CONNECT_KEY
        submit_to_testflight: true
```

### 3.3 Release Flow

```
feature branch → PR → develop → release/x.y.z → main → tag vx.y.z
                  ↑                                        ↓
              PR Check                              Codemagic build
              (lint+test)                           → Google Play Internal
                                                    → TestFlight
                                                          ↓
                                                    Manual promote
                                                    → Production
```

### 3.4 CI/CD Pipeline Summary

| Trigger | Actions | Tool |
|---------|---------|------|
| PR opened/updated | Lint + format + test + coverage check | GitHub Actions |
| Merge to develop | Build debug APK (artifact) | GitHub Actions |
| Tag `v*` | Build release APK/IPA → internal track | Codemagic |
| Manual | Promote internal → production | Google Play Console / App Store Connect |

---

## 4. Testing Strategy

### 4.1 Testing Pyramid

```
        ╱╲
       ╱  ╲        E2E Tests (patrol)
      ╱ 5% ╲       → Native interaction: GPS, camera, audio permission
     ╱──────╲
    ╱        ╲      Integration Tests (integration_test)
   ╱   15%    ╲     → Full screen flows, navigation, multi-widget
  ╱────────────╲
 ╱              ╲    Widget Tests (flutter_test)
╱     25%        ╲   → Individual widgets in isolation
╱──────────────────╲
╱                    ╲  Unit Tests (flutter_test)
╱       55%           ╲  → Models, utils, repositories, providers
╱──────────────────────╲
```

### 4.2 Testing Matrix

| Loại | Framework | Target | Coverage Goal | Ví dụ |
|------|-----------|--------|---------------|-------|
| **Unit** | `flutter_test` | Models, utils, repositories, providers | 80%+ | `location_test.dart` — serialization roundtrip |
| **Widget** | `flutter_test` | Individual widgets, components | 60%+ | `audio_player_card_test.dart` — play/pause states |
| **Integration** | `integration_test` | Full screen flows, navigation | Key flows | `location_flow_test.dart` — list → detail → audio |
| **E2E** | `patrol` | Native interaction (GPS, camera) | Critical paths | `gps_autoplay_test.dart` — geofence trigger |

### 4.3 Test File Organization

```
test/
├── unit/
│   ├── models/
│   │   ├── location_test.dart           # Location model serialization
│   │   ├── route_test.dart              # Route model
│   │   └── audio_track_test.dart        # AudioTrack model
│   ├── repositories/
│   │   ├── location_repository_test.dart # Mock Supabase, test CRUD
│   │   ├── audio_repository_test.dart    # Audio caching logic
│   │   └── sync_repository_test.dart     # Offline sync logic
│   ├── providers/
│   │   ├── location_providers_test.dart  # Provider state transitions
│   │   └── audio_providers_test.dart     # Audio player notifier
│   └── utils/
│       ├── formatters_test.dart          # Date, distance formatters
│       └── validators_test.dart          # Input validation
│
├── widget/
│   ├── features/
│   │   ├── home/
│   │   │   └── home_screen_test.dart
│   │   ├── location/
│   │   │   ├── location_list_screen_test.dart
│   │   │   └── location_detail_screen_test.dart
│   │   └── routes/
│   │       └── route_detail_screen_test.dart
│   └── shared/
│       ├── audio_mini_player_test.dart
│       ├── map_widget_test.dart
│       └── offline_banner_test.dart
│
├── helpers/
│   ├── test_helpers.dart                 # pumpApp, createProviderScope
│   ├── mocks.dart                        # MockLocationRepository, etc.
│   ├── fakes.dart                        # FakeSupabaseClient, etc.
│   └── fixtures.dart                     # Sample data factories
│
integration_test/
├── app_test.dart                          # Full app smoke test
├── location_flow_test.dart                # Home → location → audio
├── route_flow_test.dart                   # Route list → detail → navigate
├── offline_flow_test.dart                 # Download → airplane mode → use
└── helpers/
    └── integration_helpers.dart           # Setup real Supabase test env
```

### 4.4 Test Naming Convention

```dart
// Pattern: should_<expected>_when_<condition>
test('should return nearby locations when valid coordinates provided', () {
  // ...
});

test('should fallback to cached data when offline', () {
  // ...
});

// Widget test group
group('AudioPlayerCard', () {
  testWidgets('should show play button when idle', (tester) async {
    // ...
  });

  testWidgets('should show pause button when playing', (tester) async {
    // ...
  });
});
```

### 4.5 Mock Strategy

```dart
// Sử dụng Mockito cho repositories
@GenerateMocks([LocationRepository, AudioRepository, SupabaseService])
void main() {}

// Sử dụng Riverpod overrides cho providers
final container = ProviderContainer(
  overrides: [
    locationRepositoryProvider.overrideWithValue(mockLocationRepo),
    connectivityProvider.overrideWithValue(const AsyncData(true)),
  ],
);
```

---

## 5. Logging Strategy

### 5.1 Client-side Logging

| Tool | Mục đích | Setup |
|------|----------|-------|
| **Sentry** | Crash reporting + performance monitoring | `sentry_flutter` package |
| **Custom analytics** | User events (views, plays, downloads) | Supabase Edge Function `track-analytics` |
| **Console logging** | Dev debugging (chỉ debug mode) | Custom `Logger` class wrapper |

### 5.2 Logger Implementation

```dart
// lib/core/utils/logger.dart
class AppLogger {
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? 'APP'}] $message');
    }
  }

  static void info(String message, {String? tag}) {
    // Gửi tới analytics nếu cần
    debugPrint('[INFO] [${tag ?? 'APP'}] $message');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    debugPrint('[ERROR] $message');
    if (!kDebugMode) {
      Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  static void trackEvent(String event, {Map<String, dynamic>? properties}) {
    // Gửi tới Supabase track-analytics Edge Function
    AnalyticsService.instance.track(event, properties: properties);
  }
}
```

### 5.3 Sentry Configuration

```dart
// lib/main.dart
Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      options.environment = kDebugMode ? 'debug' : 'production';
      options.tracesSampleRate = 0.2; // 20% performance traces
      options.attachScreenshot = true;
      options.enableAutoPerformanceTracing = true;
    },
    appRunner: () => runApp(
      ProviderScope(child: const ToursApp()),
    ),
  );
}
```

### 5.4 Analytics Events

| Event | Properties | Khi nào |
|-------|-----------|---------|
| `screen_view` | `screen_name` | Mỗi lần navigate |
| `audio_play` | `location_id`, `language`, `duration` | Nhấn play |
| `audio_complete` | `location_id`, `listen_duration` | Nghe hết |
| `location_view` | `location_id`, `source` (map/list/qr/link) | Mở location detail |
| `route_view` | `route_id` | Mở route detail |
| `download_start` | `pack_id`, `size_mb` | Bắt đầu download offline |
| `download_complete` | `pack_id`, `duration_sec` | Download xong |
| `search` | `query`, `results_count` | Tìm kiếm |
| `qr_scan` | `location_id`, `success` | Quét QR |
| `share` | `content_type`, `content_id`, `platform` | Chia sẻ link |

### 5.5 Server-side Logging

| Tool | Mục đích |
|------|----------|
| **Supabase Dashboard** | Query logs, auth logs, storage logs |
| **Edge Function logs** | Structured JSON logs trong function code |
| **Sentry (server)** | Error tracking cho Edge Functions (optional) |

```typescript
// supabase/functions/track-analytics/index.ts
Deno.serve(async (req) => {
  const event = await req.json();
  console.log(JSON.stringify({
    level: 'info',
    event: event.name,
    properties: event.properties,
    user_id: event.user_id || 'anonymous',
    timestamp: new Date().toISOString(),
    app_version: event.app_version,
    platform: event.platform,
  }));

  // Insert vào bảng analytics
  const { error } = await supabase
    .from('analytics_events')
    .insert(event);

  return new Response(JSON.stringify({ ok: !error }));
});
```

---

## 6. Monitoring

### 6.1 Sentry Performance Monitoring

| Metric | Target | Alert |
|--------|--------|-------|
| App start time | < 2s | > 4s |
| Screen load (cold) | < 500ms | > 1.5s |
| Audio playback start | < 1s (online), < 200ms (offline) | > 3s |
| API response time | < 500ms | > 2s |
| Crash-free rate | > 99% | < 98% |

### 6.2 Supabase Usage Dashboard

| Metric | Free tier limit | Alert threshold |
|--------|-----------------|-----------------|
| Database size | 500 MB | 400 MB (80%) |
| Storage | 1 GB | 800 MB (80%) |
| Bandwidth (egress) | 5 GB/month | 4 GB (80%) |
| Edge Function invocations | 500K/month | 400K (80%) |
| Realtime connections | 200 concurrent | 150 (75%) |

### 6.3 Uptime Monitoring

| Service | Tool | Check interval |
|---------|------|---------------|
| Supabase API | UptimeRobot (free) | 5 phút |
| Edge Functions | Supabase Dashboard | Realtime |
| App crashes | Sentry | Realtime |
| App Store status | Manual check | Weekly |

---

## 7. Environment Management

### 7.1 Environment Variables

```bash
# .env.example (commit vào git)
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SENTRY_DSN=https://xxxxx@sentry.io/xxxxx
MAP_TILE_URL=https://tile.openstreetmap.org/{z}/{x}/{y}.png

# .env.development (KHÔNG commit)
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=eyJ...local...

# .env.production (KHÔNG commit)
SUPABASE_URL=https://production.supabase.co
SUPABASE_ANON_KEY=eyJ...production...
```

### 7.2 Sử dụng `--dart-define` (Khuyến nghị)

```bash
# Development
flutter run \
  --dart-define=SUPABASE_URL=http://localhost:54321 \
  --dart-define=SUPABASE_ANON_KEY=eyJ... \
  --dart-define=SENTRY_DSN=...

# Production build
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://production.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ... \
  --dart-define=SENTRY_DSN=...
```

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');

  static bool get isProduction => supabaseUrl.contains('supabase.co');
}
```

### 7.3 Alternative: `flutter_dotenv`

```dart
// Nếu thích dùng .env files
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
}
```

### 7.4 `.gitignore` Entries

```gitignore
# Environment
.env
.env.*
!.env.example

# Generated
*.g.dart
*.freezed.dart

# IDE
.idea/
.vscode/launch.json

# Build
build/
.dart_tool/

# Platform
android/app/google-services.json
ios/Runner/GoogleService-Info.plist

# Signing
android/key.properties
android/app/*.keystore
ios/Runner/*.mobileprovision
ios/Runner/*.p12
```

---

## 8. Code Quality

### 8.1 `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'
  errors:
    invalid_annotation_target: ignore
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    # Style
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - annotate_overrides
    - avoid_empty_else
    - avoid_print
    - avoid_relative_lib_imports
    - avoid_returning_null_for_future
    - avoid_slow_async_io
    - avoid_type_to_string
    - avoid_unnecessary_containers
    - avoid_web_libraries_in_flutter
    - cancel_subscriptions
    - close_sinks
    - directives_ordering
    - no_logic_in_create_state
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_final_locals
    - prefer_single_quotes
    - require_trailing_commas
    - sized_box_for_whitespace
    - sort_child_properties_last
    - sort_constructors_first
    - sort_unnamed_constructors_first
    - unawaited_futures
    - unnecessary_await_in_return
    - unnecessary_lambdas
    - use_build_context_synchronously
    - use_key_in_widget_constructors
```

### 8.2 Pre-commit Hooks

Sử dụng `lefthook` hoặc `husky` cho Git hooks:

```yaml
# lefthook.yml
pre-commit:
  parallel: true
  commands:
    format:
      glob: '*.dart'
      run: dart format --set-exit-if-changed {staged_files}
    analyze:
      run: flutter analyze --fatal-infos
    test:
      run: flutter test --no-pub

commit-msg:
  commands:
    conventional:
      run: |
        # Kiểm tra conventional commit format
        message=$(cat {1})
        pattern="^(feat|fix|docs|style|refactor|perf|test|chore|ci)(\(.+\))?: .{1,72}$"
        if ! echo "$message" | head -1 | grep -qE "$pattern"; then
          echo "Commit message must follow conventional commits format"
          echo "Example: feat(audio): add mini player bar"
          exit 1
        fi
```

### 8.3 Dart Fix

```bash
# Apply automated fixes
dart fix --apply

# Dry run (xem sẽ fix gì)
dart fix --dry-run
```

---

## 9. i18n Workflow

### 9.1 Localization Files

```
lib/core/l10n/
├── app_vi.arb      # Tiếng Việt (source of truth)
├── app_en.arb      # English
├── app_ko.arb      # 한국어
└── app_zh.arb      # 中文
```

### 9.2 ARB File Format

```json
// app_vi.arb
{
  "@@locale": "vi",
  "appTitle": "Tour Guide trong túi",
  "@appTitle": {
    "description": "Tên ứng dụng hiển thị trên app bar"
  },
  "locationCount": "{count} điểm tham quan",
  "@locationCount": {
    "description": "Số lượng điểm tham quan",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "42"
      }
    }
  },
  "distanceAway": "Cách {distance} km",
  "playAudio": "Nghe audio",
  "downloadOffline": "Tải về offline",
  "nearbyServices": "Dịch vụ gần đây",
  "offlineBanner": "Bạn đang offline — dữ liệu có thể không mới nhất"
}
```

### 9.3 i18n Workflow

```
1. Thêm key mới vào app_vi.arb (Vietnamese first)
       ↓
2. Chạy: flutter gen-l10n
       ↓
3. Dùng trong code: AppLocalizations.of(context)!.playAudio
       ↓
4. Dịch sang en/ko/zh (manual hoặc AI [Phase 2])
       ↓
5. Chạy: dart run tools/check_translations.dart
       (Kiểm tra thiếu key giữa các ARB files)
       ↓
6. Review translations
       ↓
7. Commit tất cả ARB files cùng PR
```

### 9.4 `l10n.yaml` Configuration

```yaml
arb-dir: lib/core/l10n
template-arb-file: app_vi.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
preferred-supported-locales: [vi]
nullable-getter: false
```

### 9.5 Sử dụng trong code

```dart
// Truy cập translations
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle);
Text(l10n.locationCount(42));
Text(l10n.distanceAway('2.5'));

// Extension cho tiện (shared/extensions/context_extensions.dart)
extension ContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// Sử dụng extension
Text(context.l10n.playAudio);
```

---

## 10. Release Checklist Template

```markdown
## Release Checklist v{x.y.z}

### Pre-release
- [ ] All features for this release are merged to `develop`
- [ ] `flutter analyze` passes with zero issues
- [ ] All tests pass: `flutter test`
- [ ] Integration tests pass on Android emulator + iOS simulator
- [ ] Test on physical device (Android + iOS)
- [ ] Offline mode works correctly
- [ ] Audio playback works (online + offline)
- [ ] Map displays correctly with markers
- [ ] QR scanner works
- [ ] All supported languages display correctly
- [ ] No hardcoded strings (all via AppLocalizations)
- [ ] Version bumped in `pubspec.yaml`
- [ ] CHANGELOG.md updated

### Build
- [ ] Create `release/{x.y.z}` branch from `develop`
- [ ] Build APK: `flutter build appbundle --release`
- [ ] Build IPA: `flutter build ipa --release`
- [ ] Test release builds on physical devices
- [ ] App size acceptable (< 50MB base, < 100MB with offline data)

### Deploy
- [ ] Upload AAB to Google Play Internal Track
- [ ] Upload IPA to TestFlight
- [ ] Internal team testing (2-3 days)
- [ ] Fix critical bugs (if any)
- [ ] Promote to Production (Google Play)
- [ ] Submit for Review (App Store)

### Post-release
- [ ] Merge `release/{x.y.z}` → `main`
- [ ] Tag `v{x.y.z}` on main
- [ ] Merge `main` back to `develop`
- [ ] Monitor Sentry for new crashes (48h)
- [ ] Monitor Supabase usage dashboard
- [ ] Announce release (if applicable)
```

---

## 11. Useful Commands Cheat Sheet

```bash
# === Development ===
flutter run                              # Run debug mode
flutter run -d chrome                    # Run on Chrome (admin panel)
flutter run --dart-define=ENV=dev         # Run with env variable

# === Code Generation ===
flutter pub run build_runner build --delete-conflicting-outputs  # Generate once
flutter pub run build_runner watch --delete-conflicting-outputs  # Watch mode
flutter gen-l10n                         # Generate localizations

# === Testing ===
flutter test                             # Run all unit + widget tests
flutter test --coverage                  # With coverage report
flutter test test/unit/                  # Run only unit tests
flutter test --name "should play audio"  # Run tests matching name
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart  # Integration test

# === Quality ===
flutter analyze                          # Static analysis
dart format .                            # Format all dart files
dart fix --apply                         # Auto-fix issues

# === Build ===
flutter build apk --release              # Android APK
flutter build appbundle --release        # Android AAB (for Play Store)
flutter build ipa --release              # iOS IPA
flutter build web --release              # Web (admin panel)

# === Supabase Local ===
supabase start                           # Start local Supabase
supabase stop                            # Stop local Supabase
supabase db reset                        # Reset DB + run migrations
supabase db push                         # Push migrations to remote
supabase functions serve                 # Run Edge Functions locally
supabase gen types dart --local          # Generate Dart types from schema

# === Dependencies ===
flutter pub get                          # Install dependencies
flutter pub upgrade                      # Upgrade to latest versions
flutter pub outdated                     # Check outdated packages
flutter pub deps                         # Show dependency tree
```

---

*Tiếp theo: [12 — Cost Analysis](12-cost-analysis.md) — Phân tích chi phí và mô hình Freemium*
