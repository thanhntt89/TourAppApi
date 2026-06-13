// lib/core/config/app_config.dart
//
// Runtime configuration constants.
// Static values that don't change at runtime but aren't environment secrets.

/// Default request timeout for API calls.
const Duration kApiTimeout = Duration(seconds: 15);

/// Default geofence radius for GPS audio trigger (meters).
/// Overridden per-place by [place.geofence_radius] from API.
const int kDefaultGeofenceRadius = 300;

/// Cooldown before re-triggering audio for the same place (minutes).
const int kAudioCooldownMinutes = 30;

/// Max places to fetch from /places/nearby.
const int kNearbyPlacesLimit = 20;

/// Sync check interval when app is in foreground (minutes).
const int kSyncCheckIntervalMinutes = 30;

/// Default items per page for paginated lists.
const int kDefaultPageSize = 20;

/// Maximum custom user journeys on free plan.
const int kFreeJourneyLimit = 5;

/// Supported content languages (must match TA_LANGUAGES in WordPress plugin).
const List<String> kSupportedLangs = ['vi', 'en', 'ko', 'zh', 'fr'];

/// Default content language.
const String kDefaultLang = 'vi';

/// Default province ID (Hà Giang) when GPS detect fails.
const int kDefaultProvinceId = 1;

/// Map default center — Hà Giang.
const double kHaGiangLat = 22.8025;
const double kHaGiangLng = 104.9784;

/// Map default zoom level.
const double kDefaultMapZoom = 11.0;
const double kDetailMapZoom = 15.0;
