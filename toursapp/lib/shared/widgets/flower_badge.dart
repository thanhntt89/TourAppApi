import 'package:flutter/material.dart';
import 'package:stoneecho/core/constants/app_constants.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

/// Display style for the flower badge.
enum FlowerBadgeStyle {
  /// Used when showing a cost (spending flowers).
  cost,

  /// Used when showing a reward (earning flowers).
  reward,
}

/// Small badge showing a flower emoji and count.
/// Used to display costs (e.g. unlock audio) and rewards (e.g. check-in bonus).
class FlowerBadge extends StatelessWidget {
  const FlowerBadge({
    required this.count,
    this.style = FlowerBadgeStyle.cost,
    this.textStyle,
    super.key,
  });

  final int count;
  final FlowerBadgeStyle style;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final isCost = style == FlowerBadgeStyle.cost;

    final bgColor = isCost
        ? AppColors.flowerPink.withValues(alpha: 0.1)
        : AppColors.successGreen.withValues(alpha: 0.1);

    final textColor = isCost ? AppColors.flowerPink : AppColors.successGreen;

    final prefix = isCost ? '-' : '+';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            AppConstants.flowerEmoji,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            '$prefix$count',
            style: textStyle ??
                TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }
}
