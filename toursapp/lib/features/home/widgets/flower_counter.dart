import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

class FlowerCounter extends ConsumerWidget {
  const FlowerCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Read from walletProvider
    const flowerCount = 12;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to wallet screen
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.flowerPink.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🌸', style: TextStyle(fontSize: 16)),
            SizedBox(width: 4),
            Text(
              '$flowerCount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.flowerPink,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
