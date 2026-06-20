import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class ScanSuccessCard extends StatelessWidget {
  const ScanSuccessCard({
    required this.qrCode,
    required this.onPlayAudio,
    required this.onViewDetails,
    required this.onDismiss,
    super.key,
  });

  final String qrCode;
  final VoidCallback onPlayAudio;
  final VoidCallback onViewDetails;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.creamDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Reward badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.flowerPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.checkinReward(10),
                style: const TextStyle(
                  color: AppColors.flowerPink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Place info placeholder
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: AppColors.creamDark,
                    child: const Icon(Icons.landscape, color: AppColors.textLight, size: 32),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Place Name', style: AppTextStyles.titleLarge),
                      SizedBox(height: 4),
                      Text(
                        'Location District',
                        style: AppTextStyles.bodyMedium,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "You're here! (50m away)",
                        style: TextStyle(
                          color: AppColors.forestGreen,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Play audio button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPlayAudio,
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.playAudio),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // View details link
            TextButton(
              onPressed: onViewDetails,
              child: const Text('View Place Details →'),
            ),
          ],
        ),
      ),
    );
  }
}
