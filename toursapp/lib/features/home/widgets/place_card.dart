import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/widgets/cached_image.dart';
import 'package:stoneecho/shared/widgets/status_badge.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    required this.index,
    required this.name,
    required this.distance,
    required this.status,
    required this.onTap,
    this.imageUrl,
    this.flowerCost,
    super.key,
  });

  final int index;
  final String name;
  final String distance;
  final String status;
  final String? imageUrl;
  final int? flowerCost;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image with index badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: SizedBox(
                      width: 100,
                      child: imageUrl != null
                          ? CachedImage(imageUrl: imageUrl!)
                          : const ColoredBox(
                              color: AppColors.creamDark,
                              child: Center(
                                child: Icon(
                                  Icons.landscape,
                                  color: AppColors.textLight,
                                  size: 40,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.forestGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              distance,
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      StatusBadge(status: status),
                    ],
                  ),
                ),
              ),

              // Chevron
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
