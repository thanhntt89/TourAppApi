[< 06 — Backend Services](06-backend-services.md) | [08 — AI Integration >](08-ai-integration.md)

---

# 07 — Maps & Location

Ban do, dinh vi va cac tinh nang vi tri cho ung dung du lich Ha Giang — su dung **flutter_map** voi **OpenStreetMap** (mien phi, khong can API key).

---

## 1. Map Technology

### 1.1 Tai sao flutter_map + OpenStreetMap?

| Tieu chi | Google Maps | flutter_map + OSM |
|----------|-------------|-------------------|
| Chi phi | $7/1000 loads | **Mien phi** |
| API key | Bat buoc | Khong can |
| Offline tiles | Kho, ton kem | **flutter_map_tile_caching** |
| Custom style | Han che | Tu do |
| Open source | Khong | **Co** |

Doi voi ung dung du lich nhu ToursApp, **chi phi thap** va **offline support** quan trong hon tinh nang nang cao cua Google Maps.

### 1.2 Package Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter_map: ^6.x
  flutter_map_tile_caching: ^9.x
  latlong2: ^0.9.x
  geolocator: ^11.x
  geocoding: ^3.x
```

---

## 2. Online Mode

### 2.1 Basic Map Setup

```dart
FlutterMap(
  options: MapOptions(
    initialCenter: const LatLng(23.2735, 105.2542), // Ha Giang city
    initialZoom: 10.0,
    minZoom: 8.0,
    maxZoom: 18.0,
    onTap: (tapPosition, latLng) {
      // Handle map tap
    },
  ),
  children: [
    // 1. Tile layer (ban do nen)
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.hagiang.toursapp',
      tileProvider: _getTileProvider(), // Online hoac cached
    ),

    // 2. Location markers
    MarkerLayer(markers: locationMarkers),

    // 3. User position
    MarkerLayer(markers: [userPositionMarker]),

    // 4. Route polyline
    PolylineLayer(polylines: routePolylines),

    // 5. Nearby radius circle
    CircleLayer(circles: nearbyCircles),
  ],
)
```

### 2.2 OSM Tile Server URL

```
Standard:  https://tile.openstreetmap.org/{z}/{x}/{y}.png
Cycle:     https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png
Topo:      https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

**Luu y**: Tuan thu [OSM Tile Usage Policy](https://operations.osmfoundation.org/policies/tiles/) — dat `userAgentPackageName`, khong request qua nhieu tiles dong thoi.

---

## 3. Offline Mode (flutter_map_tile_caching)

### 3.1 Ha Giang Bounding Box

```
Vung Ha Giang va lân can:
┌─────────────────────────────────┐
│  Lat max: 23.5 (bac - Lung Cu)  │
│  Lat min: 22.5 (nam)            │
│  Lon min: 104.3 (tay)           │
│  Lon max: 105.6 (dong)          │
│                                 │
│  Dien tich: ~1.3° × 1.1°       │
│  Bao gom: Dong Van, Meo Vac,   │
│  Yen Minh, Quan Ba, Vi Xuyen   │
└─────────────────────────────────┘
```

### 3.2 Zoom Levels va Estimated Storage

| Zoom | Do chi tiet | So tiles (uoc tinh) | Dung luong |
|------|-------------|----------------------|------------|
| 8 | Vung rong | ~4 | < 1 MB |
| 9 | Tinh | ~12 | < 1 MB |
| 10 | Huyen | ~40 | ~1 MB |
| 11 | Duong chinh | ~150 | ~3 MB |
| 12 | Duong phu | ~550 | ~10 MB |
| 13 | Chi tiet xa | ~2,100 | ~25 MB |
| 14 | Chi tiet cao | ~8,200 | ~50 MB |
| 15 | Rat chi tiet | ~32,000 | ~80 MB |
| **Tong** | Zoom 8-15 | **~43,000 tiles** | **~80-150 MB** |

**Khong tai zoom 16+**: qua nhieu tiles (~128,000+), tang kich thuoc gap 4 lan moi zoom level.

### 3.3 Tile Download Implementation

```dart
class MapTileDownloader {
  final FMTCStore _store;

  static const _haGiangRegion = LatLngBounds(
    LatLng(22.5, 104.3),  // Southwest
    LatLng(23.5, 105.6),  // Northeast
  );

  Future<void> downloadHaGiangTiles({
    required void Function(DownloadProgress) onProgress,
  }) async {
    // 1. Khoi tao store
    final store = FMTC.instance('ha_giang_offline');
    await store.manage.create();

    // 2. Dinh nghia region
    final region = RectangleRegion(_haGiangRegion);

    // 3. Uoc tinh so tiles truoc
    final tileCount = await store.download.check(
      region.toDownloadable(
        minZoom: 8,
        maxZoom: 15,
        options: TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
      ),
    );

    // 4. Bat dau download
    final downloadStream = store.download.startForeground(
      region: region.toDownloadable(
        minZoom: 8,
        maxZoom: 15,
        options: TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
      ),
      parallelThreads: 3,
      maxBufferLength: 200,
      skipExistingTiles: true,  // Resume support
    );

    // 5. Track progress
    await for (final progress in downloadStream) {
      onProgress(DownloadProgress(
        downloadedTiles: progress.successfulTiles,
        totalTiles: tileCount,
        percentage: progress.percentageProgress,
        downloadedSize: progress.successfulSize,
        elapsedTime: progress.elapsedDuration,
        tilesPerSecond: progress.tilesPerSecond,
      ));
    }
  }

  /// Chuyen sang offline tile provider
  TileProvider getOfflineTileProvider() {
    final store = FMTC.instance('ha_giang_offline');
    return store.getTileProvider();
  }

  /// Xoa tiles da tai
  Future<void> clearOfflineTiles() async {
    final store = FMTC.instance('ha_giang_offline');
    await store.manage.delete();
  }

  /// Lay thong tin storage
  Future<TileStoreStats> getStats() async {
    final store = FMTC.instance('ha_giang_offline');
    return TileStoreStats(
      tileCount: await store.stats.tileCount,
      sizeBytes: await store.stats.size,
    );
  }
}
```

### 3.4 Auto-switch Online/Offline

```dart
TileProvider _getTileProvider() {
  if (_connectivityService.isOnline) {
    // Online: load tu server, cache lai
    return FMTC.instance('ha_giang_offline')
        .getTileProvider(
          FMTCTileProviderSettings(
            behavior: CacheBehavior.cacheFirst,  // Dung cache truoc, fetch neu khong co
          ),
        );
  } else {
    // Offline: chi doc tu cache
    return FMTC.instance('ha_giang_offline')
        .getTileProvider(
          FMTCTileProviderSettings(
            behavior: CacheBehavior.cacheOnly,
          ),
        );
  }
}
```

### 3.5 Progress Indicator UI

```
┌────────────────────────────────────┐
│  Tai ban do Ha Giang offline       │
│  ████████████░░░░░░░░░  58%       │
│                                    │
│  24,950 / 43,000 tiles             │
│  72 MB / ~130 MB                   │
│  Toc do: 45 tiles/s               │
│  Thoi gian con lai: ~6 phut       │
│                                    │
│  [Tam dung]  [Huy]                │
└────────────────────────────────────┘
```

---

## 4. Geolocation

### 4.1 geolocator Package

```dart
class GeolocationService {
  /// Kiem tra va xin quyen
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // Hien dialog bat Location
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Mo Settings de nguoi dung cap quyen thu cong
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  /// Vi tri hien tai
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,  // Tiet kiem pin
    );
  }

  /// Theo doi vi tri (battery-efficient)
  Stream<Position> watchPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 100,  // Chi update khi di chuyen > 100m
      ),
    );
  }
}
```

### 4.2 Permission Strategy

| Platform | Permission | Khi nao xin |
|----------|-----------|-------------|
| Android | `ACCESS_FINE_LOCATION` | Khi mo ban do lan dau |
| iOS | `NSLocationWhenInUseUsageDescription` | Khi mo ban do lan dau |
| Android | `ACCESS_BACKGROUND_LOCATION` | Chi Phase 2 (GPS Autoplay) |
| iOS | `NSLocationAlwaysAndWhenInUseUsageDescription` | Chi Phase 2 |

**Nguyen tac**: Chi xin quyen khi can, giai thich ro ly do cho nguoi dung.

---

## 5. Nearby Locations

Hai cach tinh dia diem gan:

### 5.1 Client-side: Haversine (Nhanh, Offline)

Tinh khoang cach truc tiep tu cached data — hoat dong offline, rat nhanh.

```dart
import 'dart:math';

class HaversineCalculator {
  static const double _earthRadiusKm = 6371.0;

  /// Tinh khoang cach giua 2 diem (km)
  /// Su dung cong thuc Haversine
  static double distanceKm(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  static double _toRadians(double degrees) => degrees * pi / 180;

  /// Tim dia diem gan nhat tu danh sach cached
  static List<NearbyLocation> findNearby({
    required double userLat,
    required double userLon,
    required List<Location> locations,
    double radiusKm = 10.0,
  }) {
    return locations
        .map((loc) {
          final distance = distanceKm(
            userLat, userLon,
            loc.latitude, loc.longitude,
          );
          return NearbyLocation(location: loc, distanceKm: distance);
        })
        .where((nearby) => nearby.distanceKm <= radiusKm)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }
}
```

### 5.2 Server-side: earthdistance Edge Function (Chinh xac)

Dung khi can ket qua chinh xac hon hoac filter phuc tap — goi Edge Function `nearby-locations` (xem doc 06).

### 5.3 Khi nao dung cach nao?

| Tinh huong | Phuong phap | Ly do |
|------------|-------------|-------|
| Offline | Haversine client | Khong co mang |
| Data da cache day du | Haversine client | Nhanh hon goi API |
| Can filter phuc tap | earthdistance server | SQL manh hon |
| Lan dau (chua cache) | earthdistance server | Chua co data local |

---

## 6. Route Display

### 6.1 Phase 1 — Straight-line Polyline

Noi thang cac diem dung bang duong thang (don gian, hoat dong offline):

```dart
PolylineLayer(
  polylines: [
    Polyline(
      points: routeStops
          .map((stop) => LatLng(stop.latitude, stop.longitude))
          .toList(),
      color: Colors.blue,
      strokeWidth: 3.0,
      isDotted: false,
    ),
  ],
)
```

### 6.2 Phase 2+ — Road-following Route (OSRM)

Su dung [OSRM](http://project-osrm.org/) (Open Source Routing Machine) de lay duong di thuc te theo duong bo:

```dart
class OSRMService {
  static const _baseUrl = 'https://router.project-osrm.org';

  /// Lay route giua nhieu diem
  Future<List<LatLng>> getRoute(List<LatLng> waypoints) async {
    final coordinates = waypoints
        .map((p) => '${p.longitude},${p.latitude}')
        .join(';');

    final response = await http.get(Uri.parse(
      '$_baseUrl/route/v1/driving/$coordinates'
      '?overview=full&geometries=polyline',
    ));

    final data = json.decode(response.body);
    final geometry = data['routes'][0]['geometry'];

    // Decode polyline
    return decodePolyline(geometry);
  }
}
```

---

## 7. GPS Autoplay Geofencing (Phase 2)

### 7.1 Concept

Khi nguoi dung di xe may qua gan 1 dia diem, tu dong thong bao va phat audio guide.

### 7.2 Implementation

```dart
class AutoplayGeofenceService {
  static const _checkDistanceFilter = 200; // meters — tiet kiem pin
  static const _defaultGeofenceRadius = 500; // meters
  static const _cooldownDuration = Duration(minutes: 30);
  static const _maxSpeedKmh = 80; // Khong trigger khi chay qua nhanh

  final Map<String, DateTime> _cooldownMap = {};

  Stream<AutoplayTrigger> watchForTriggers({
    required List<Location> locations,
  }) async* {
    await for (final position in Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: _checkDistanceFilter,
      ),
    )) {
      // 1. Kiem tra toc do — khong trigger khi chay xe nhanh
      final speedKmh = (position.speed * 3.6); // m/s -> km/h
      if (speedKmh > _maxSpeedKmh) continue;

      // 2. Tim dia diem trong geofence
      for (final location in locations) {
        final distance = Geolocator.distanceBetween(
          position.latitude, position.longitude,
          location.latitude, location.longitude,
        );

        final radius = location.geofenceRadiusMeters ?? _defaultGeofenceRadius;

        if (distance <= radius) {
          // 3. Kiem tra cooldown
          if (_isOnCooldown(location.id)) continue;

          // 4. Trigger!
          _setCooldown(location.id);

          yield AutoplayTrigger(
            location: location,
            distanceMeters: distance,
            priority: _calculatePriority(location, distance),
          );
        }
      }
    }
  }

  bool _isOnCooldown(String locationId) {
    final lastTrigger = _cooldownMap[locationId];
    if (lastTrigger == null) return false;
    return DateTime.now().difference(lastTrigger) < _cooldownDuration;
  }

  void _setCooldown(String locationId) {
    _cooldownMap[locationId] = DateTime.now();
  }

  double _calculatePriority(Location location, double distance) {
    // Uu tien: gan hon + featured + chua nghe
    double score = 1.0 - (distance / 1000); // gan = diem cao
    if (location.isFeatured) score += 0.5;
    // TODO: kiem tra da nghe chua
    return score;
  }
}
```

### 7.3 Alert Intelligence Rules

| Rule | Dieu kien | Hanh dong |
|------|-----------|-----------|
| **Khoang cach** | distance <= geofence_radius_meters | Trigger alert |
| **Cooldown** | Da trigger < 30 phut truoc | Skip (tranh spam) |
| **Toc do** | speed > 80 km/h | Skip (dang tren cao toc) |
| **Speed zone** | 0-5 km/h | Dang di bo → notification nhe |
| **Speed zone** | 5-30 km/h | Di xe cham → notification + mini player |
| **Speed zone** | 30-80 km/h | Di xe nhanh → chi notification, khong auto-play |
| **Priority** | Nhieu locations cung luc | Chon location co priority cao nhat |
| **Da nghe** | Audio da nghe 80%+ | Giam priority, van notify nhung khong auto-play |
| **Thoi gian** | 22:00 - 06:00 | Tat autoplay (ban dem) |
| **Battery** | Battery < 15% | Tat GPS tracking |

### 7.4 Notification + Auto-play Flow

```
GPS update (moi 200m)
    ↓
Kiem tra locations trong geofence
    ↓
Tim thay location "Dinh Ma Pi Leng" (300m)
    ↓
Kiem tra rules (cooldown? toc do? battery?)
    ↓ OK
Hien notification:
    "Ban dang gan Dinh Ma Pi Leng (300m)
     Bam de nghe audio huong dan"
    ↓ Nguoi dung bam
Auto-play audio guide
    ↓
Set cooldown 30 phut cho location nay
```

---

## 8. Battery Considerations

### 8.1 Location Tracking Modes

| Mode | distanceFilter | Accuracy | Khi nao |
|------|---------------|----------|---------|
| Browsing | 100m | Medium | Xem ban do binh thuong |
| Autoplay (Phase 2) | 200m | Medium | GPS autoplay dang bat |
| Background (Phase 2) | 500m | Low | App o background |
| Off | — | — | Nguoi dung tat GPS |

### 8.2 Significant Location Changes vs Continuous

| Phuong phap | Pin | Do chinh xac | Dung cho |
|-------------|-----|-------------|----------|
| `distanceFilter: 200m` | Thap | Trung binh | GPS Autoplay |
| `distanceFilter: 50m` | Trung binh | Cao | Real-time navigation |
| Continuous (no filter) | **Cao** | Rat cao | **KHONG DUNG** |
| Significant changes only | Rat thap | Thap | Background rough tracking |

### 8.3 Background Location Permissions

- **Phase 1**: Chi `whenInUse` — khong can background
- **Phase 2**: Can `always` cho GPS Autoplay khi man hinh tat
- iOS: Phai giai thich ro trong `NSLocationAlwaysUsageDescription`
- Android: `ACCESS_BACKGROUND_LOCATION` — Google Play review nghiem ngat

---

## 9. Map UI Components

### 9.1 LocationMarker

```dart
class LocationMarker extends StatelessWidget {
  final Location location;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
            ),
            child: Text(
              location.name,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.location_on,
            color: _getCategoryColor(location.category),
            size: isSelected ? 40 : 32,
          ),
        ],
      ),
    );
  }
}
```

### 9.2 UserPositionMarker

```dart
// Hien thi vi tri nguoi dung voi vong tron do chinh xac
Marker(
  point: userPosition,
  child: Stack(
    alignment: Alignment.center,
    children: [
      // Vong tron do chinh xac
      Container(
        width: 60, height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.withOpacity(0.15),
        ),
      ),
      // Cham xanh
      Container(
        width: 16, height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
          border: Border.all(color: Colors.white, width: 3),
        ),
      ),
    ],
  ),
)
```

### 9.3 RoutePolyline

```dart
Polyline(
  points: routePoints,
  color: const Color(0xFF2196F3),
  strokeWidth: 4.0,
  borderColor: const Color(0xFF1565C0),
  borderStrokeWidth: 1.0,
)
```

### 9.4 NearbyRadius Circle

```dart
// Hien thi ban kinh "dia diem gan day" tren ban do
CircleMarker(
  point: userPosition,
  radius: radiusInPixels, // Convert km → pixels dua tren zoom
  color: Colors.blue.withOpacity(0.05),
  borderColor: Colors.blue.withOpacity(0.3),
  borderStrokeWidth: 1.0,
)
```

---

## 10. Turn-by-Turn Navigation

**Ngoai pham vi (out of scope)** — khong tu xay dung navigation turn-by-turn.

Thay vao do, deep link sang Google Maps hoac Apple Maps:

```dart
class NavigationLauncher {
  static Future<void> navigateTo(double lat, double lon, String name) async {
    // Android: Google Maps
    final googleUrl = Uri.parse(
      'google.navigation:q=$lat,$lon&mode=d',
    );

    // iOS: Apple Maps
    final appleUrl = Uri.parse(
      'https://maps.apple.com/?daddr=$lat,$lon&dirflg=d',
    );

    // Fallback: Google Maps web
    final webUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon',
    );

    if (Platform.isAndroid && await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else if (Platform.isIOS && await canLaunchUrl(appleUrl)) {
      await launchUrl(appleUrl);
    } else {
      await launchUrl(webUrl);
    }
  }
}
```

---

**Tong ket**: Giai phap ban do cua ToursApp uu tien **mien phi** (OSM), **offline** (tile caching), va **tiet kiem pin** (distanceFilter). GPS Autoplay (Phase 2) la tinh nang doc dao — tu dong huong dan khi nguoi dung di qua dia diem ma khong can thao tac.
