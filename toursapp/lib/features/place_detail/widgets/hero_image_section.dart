import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/widgets/status_badge.dart';

class HeroImageSection extends StatelessWidget {
  const HeroImageSection({
    required this.placeName,
    required this.locationName,
    required this.status,
    this.imageUrl,
    super.key,
  });

  final String? imageUrl;
  final String placeName;
  final String locationName;
  final String status;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          if (imageUrl != null)
            Image.network(imageUrl!, fit: BoxFit.cover)
          else
            ColoredBox(
              color: AppColors.forestGreen.withValues(alpha: 0.3),
              child: const Icon(
                Icons.landscape,
                size: 80,
                color: Colors.white54,
              ),
            ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // Back + Share buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.deepBrown),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: AppColors.deepBrown),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: AppColors.coral,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Place name + status
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName,
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  locationName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                StatusBadge(status: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
