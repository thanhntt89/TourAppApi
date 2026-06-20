import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

class UserStatsGrid extends StatelessWidget {
  const UserStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: '🌸',
            count: '12',
            label: 'Flowers\nCollected',
            color: AppColors.flowerPink,
          ),
          _StatItem(
            icon: '🏺', // Closest to stamp icon in emoji
            count: '8',
            label: 'Destination\nStamps',
            color: Colors.brown,
          ),
          _StatItem(
            icon: '🖼️',
            count: '5',
            label: 'Places\nDiscovered',
            color: AppColors.forestGreen,
          ),
          _StatItem(
            icon: '📖',
            count: '3',
            label: 'Places\nExplored',
            color: AppColors.forestGreenDark,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  final String icon;
  final String count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepBrown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
