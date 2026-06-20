import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/providers/connectivity_providers.dart';

/// Persistent banner at the top of the screen shown when the device is offline.
/// Displays "You're offline" with a subtle yellow background.
/// Automatically shows/hides based on [isOnlineProvider].
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return isOnline.when(
      data: (online) {
        if (online) return const SizedBox.shrink();
        return _BannerContent();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => _BannerContent(),
    );
  }
}

class _BannerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        bottom: 6,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.warningYellow,
        border: Border(
          bottom: BorderSide(color: AppColors.warningBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 16,
            color: Colors.orange.shade800,
          ),
          const SizedBox(width: 8),
          Text(
            "You're offline",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.orange.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
