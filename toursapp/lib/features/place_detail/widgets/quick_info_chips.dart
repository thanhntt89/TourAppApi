import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

class QuickInfoChips extends StatelessWidget {
  const QuickInfoChips({
    required this.distance,
    required this.visitDuration,
    required this.category,
    required this.audioCount,
    super.key,
  });

  final String distance;
  final String visitDuration;
  final String category;
  final int audioCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(icon: Icons.location_on, label: distance),
          _Chip(icon: Icons.timer, label: visitDuration),
          _Chip(icon: Icons.category, label: category),
          _Chip(icon: Icons.headphones, label: '$audioCount audio'),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.creamDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.forestGreen),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.deepBrown),
          ),
        ],
      ),
    );
  }
}
