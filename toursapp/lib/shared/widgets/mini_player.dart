import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stoneecho/core/router/route_names.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/providers/audio_providers.dart';

/// Floating mini player bar shown when audio is playing.
/// Appears above the bottom navigation bar.
/// Tapping navigates to the place detail screen.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);
    final track = audioState.currentTrack;

    if (track == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteNames.placeDetail,
          pathParameters: {'id': track.placeId.toString()},
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: track.localPath != null
                        ? ColoredBox(
                            color: AppColors.forestGreen.withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.headphones,
                              color: AppColors.forestGreen,
                              size: 20,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: '', // Place image would come from place data
                            fit: BoxFit.cover,
                            placeholder: (_, _) => ColoredBox(
                              color: AppColors.forestGreen.withValues(alpha: 0.1),
                              child: const Icon(
                                Icons.headphones,
                                color: AppColors.forestGreen,
                                size: 20,
                              ),
                            ),
                            errorWidget: (_, _, _) => ColoredBox(
                              color: AppColors.forestGreen.withValues(alpha: 0.1),
                              child: const Icon(
                                Icons.headphones,
                                color: AppColors.forestGreen,
                                size: 20,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                // Track name
                Expanded(
                  child: Text(
                    track.placeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(width: 8),

                // Play/Pause button
                if (audioState.isLoading)
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      audioState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: AppColors.forestGreen,
                    ),
                    iconSize: 32,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      if (audioState.isPlaying) {
                        notifier.pause();
                      } else {
                        notifier.resume();
                      }
                    },
                  ),

                // Close button
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  onPressed: notifier.stop,
                ),
              ],
            ),

            // Progress bar
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: audioState.progress,
                minHeight: 3,
                backgroundColor: AppColors.forestGreen.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.forestGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
