import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:stoneecho/core/constants/map_constants.dart';
import 'package:stoneecho/data/services/map_tile_service.dart';

enum MapDownloadStatus { idle, downloading, done, error }

class MapDownloadState {
  const MapDownloadState({
    this.status = MapDownloadStatus.idle,
    this.progress = 0.0,
  });

  final MapDownloadStatus status;
  final double progress;
}

class MapDownloadNotifier extends Notifier<MapDownloadState> {
  final _service = MapTileService();

  @override
  MapDownloadState build() => const MapDownloadState();

  Future<void> startDownload() async {
    if (state.status == MapDownloadStatus.downloading) return;
    state = const MapDownloadState(status: MapDownloadStatus.downloading);
    try {
      final stream = _service.downloadRegion(
        southWest: const LatLng(
          MapConstants.haGiangSouthLat,
          MapConstants.haGiangWestLng,
        ),
        northEast: const LatLng(
          MapConstants.haGiangNorthLat,
          MapConstants.haGiangEastLng,
        ),
        minZoom: MapConstants.offlineMinZoom,
        maxZoom: MapConstants.offlineMaxZoom,
      );
      await for (final p in stream) {
        state = MapDownloadState(
          status: MapDownloadStatus.downloading,
          progress: p.percentageProgress / 100.0,
        );
        if (p.isComplete) break;
      }
      state = const MapDownloadState(
        status: MapDownloadStatus.done,
        progress: 1.0,
      );
    } catch (_) {
      state = const MapDownloadState(status: MapDownloadStatus.error);
    }
  }

  void cancel() {
    _service.cancelDownload();
    state = const MapDownloadState();
  }
}

final mapDownloadProvider =
    NotifierProvider<MapDownloadNotifier, MapDownloadState>(
  MapDownloadNotifier.new,
);
