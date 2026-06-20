import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';

class JourneyCard extends StatelessWidget {
  const JourneyCard({
    required this.name,
    required this.stops,
    required this.distance,
    required this.duration,
    required this.progress,
    required this.onTap,
    super.key,
  });

  final String name;
  final int stops;
  final String distance;
  final String duration;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(name, style: AppTextStyles.titleMedium),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textLight),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$duration · $stops stops · $distance',
              style: AppTextStyles.caption,
            ),
            if (progress > 0) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.creamDark,
                  color: AppColors.forestGreen,
                  minHeight: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
