import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:stoneecho/core/constants/map_constants.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/providers/map_providers.dart';

class HomeMapSection extends ConsumerWidget {
  const HomeMapSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(mapDownloadProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ha Giang Map',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.deepBrown,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              _DownloadControl(state: downloadState),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 200,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: MapConstants.haGiangCenter,
                      initialZoom: MapConstants.defaultZoom,
                      minZoom: MapConstants.minZoom,
                      maxZoom: MapConstants.maxZoom,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom |
                            InteractiveFlag.drag |
                            InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: MapConstants.osmTileUrl,
                        userAgentPackageName: 'com.stoneecho.app',
                        tileProvider: FMTCStore('toursapp_tiles').getTileProvider(
                          settings: FMTCTileProviderSettings(
                            behavior: CacheBehavior.cacheFirst,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Download progress bar at bottom
                  if (downloadState.status == MapDownloadStatus.downloading)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LinearProgressIndicator(
                        value: downloadState.progress,
                        backgroundColor: Colors.white38,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.forestGreen,
                        ),
                        minHeight: 4,
                      ),
                    ),

                  // Offline badge when done
                  if (downloadState.status == MapDownloadStatus.done)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.forestGreen.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.offline_pin,
                                size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Offline ready',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadControl extends ConsumerWidget {
  const _DownloadControl({required this.state});
  final MapDownloadState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (state.status) {
      MapDownloadStatus.idle => TextButton.icon(
          onPressed: () =>
              ref.read(mapDownloadProvider.notifier).startDownload(),
          icon: const Icon(Icons.download_outlined, size: 16),
          label: const Text('Download offline'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.forestGreen,
            textStyle: const TextStyle(fontSize: 13),
            padding: EdgeInsets.zero,
          ),
        ),
      MapDownloadStatus.downloading => TextButton.icon(
          onPressed: () => ref.read(mapDownloadProvider.notifier).cancel(),
          icon: const Icon(Icons.stop_circle_outlined, size: 16),
          label: Text(
            'Cancel  ${(state.progress * 100).toStringAsFixed(0)}%',
          ),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            textStyle: const TextStyle(fontSize: 13),
            padding: EdgeInsets.zero,
          ),
        ),
      MapDownloadStatus.done => const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 16, color: AppColors.successGreen),
            SizedBox(width: 4),
            Text(
              'Saved offline',
              style: TextStyle(fontSize: 13, color: AppColors.successGreen),
            ),
          ],
        ),
      MapDownloadStatus.error => TextButton.icon(
          onPressed: () =>
              ref.read(mapDownloadProvider.notifier).startDownload(),
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Retry'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            textStyle: const TextStyle(fontSize: 13),
            padding: EdgeInsets.zero,
          ),
        ),
    };
  }
}
