import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/providers/audio_providers.dart';
import 'package:stoneecho/providers/connectivity_providers.dart';
import 'package:stoneecho/shared/widgets/bottom_nav_bar.dart';
import 'package:stoneecho/shared/widgets/mini_player.dart';
import 'package:stoneecho/shared/widgets/offline_banner.dart';

/// Root scaffold that wraps the shell route's child with:
/// - [OfflineBanner] at the top (shown when offline)
/// - [MiniPlayer] floating above the bottom nav (shown when audio is playing)
/// - [BottomNavBar] at the bottom
class AppScaffold extends ConsumerWidget {
  const AppScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final showOfflineBanner = isOnline.whenOrNull(data: (online) => !online) ?? false;
    final showMiniPlayer = audioState.hasTrack;

    return Scaffold(
      body: Stack(
        children: [
          // Main content with padding for banners and mini player
          Positioned.fill(
            child: Column(
              children: [
                if (showOfflineBanner) const OfflineBanner(),
                Expanded(child: child),
                // Reserve space for mini player + bottom nav
                if (showMiniPlayer) const SizedBox(height: 64),
                const SizedBox(height: 80), // Bottom nav height
              ],
            ),
          ),

          // Mini player — positioned above bottom nav
          if (showMiniPlayer)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 80, // Above the bottom nav bar
              child: MiniPlayer(),
            ),

          // Bottom navigation bar
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(),
          ),
        ],
      ),
    );
  }
}
