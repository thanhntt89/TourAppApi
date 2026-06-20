import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

/// Wraps flutter_map_tile_caching (FMTC) for offline map tile management.
class MapTileService {
  MapTileService({this.storeName = 'toursapp_tiles'});

  final String storeName;

  FMTCStore get _store => FMTCStore(storeName);

  /// Downloads map tiles for the given geographic bounds.
  ///
  /// Returns a stream of download progress events.
  Stream<DownloadProgress> downloadRegion({
    required LatLng southWest,
    required LatLng northEast,
    int minZoom = 10,
    int maxZoom = 16,
  }) {
    final region = RectangleRegion(LatLngBounds(southWest, northEast));
    final downloadable = region.toDownloadable(
      minZoom: minZoom,
      maxZoom: maxZoom,
      options: TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      ),
    );
    return _store.download.startForeground(region: downloadable);
  }

  /// Cancels any in-progress download.
  Future<void> cancelDownload() async {
    await _store.download.cancel();
  }

  /// Returns the total cache size in bytes for this store.
  Future<double> getCacheSize() async {
    final stats = _store.stats;
    return stats.size;
  }

  /// Returns the number of cached tiles.
  Future<int> getTileCount() async {
    final stats = _store.stats;
    return stats.length;
  }

  /// Removes all cached tiles for this store.
  Future<void> clearCache() async {
    await _store.manage.reset();
  }
}
