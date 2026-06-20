import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

class DestinationStampsGrid extends StatelessWidget {
  const DestinationStampsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Destination Stamps',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.deepBrown,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text('View All', style: TextStyle(fontSize: 12)),
                  Icon(Icons.chevron_right, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _StampItem(
                label: 'Lung Cu Flag Tower',
                subLabel: '8 of 15 locations',
                color: Colors.orange.shade800,
                icon: Icons.flag,
              ),
              const SizedBox(width: 16),
              _StampItem(
                label: 'Vuong Palace',
                subLabel: '8 of 13 locations',
                color: Colors.red.shade900,
                icon: Icons.account_balance,
              ),
              const SizedBox(width: 16),
              _StampItem(
                label: 'Nho Que River',
                subLabel: '8 of 15 locations',
                color: Colors.teal.shade700,
                icon: Icons.water,
              ),
              const SizedBox(width: 16),
              _StampItem(
                label: 'Ma Pi Leng Pass',
                subLabel: '8 of 15 locations',
                color: AppColors.forestGreen,
                icon: Icons.terrain,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StampItem extends StatelessWidget {
  const _StampItem({
    required this.label,
    required this.subLabel,
    required this.color,
    required this.icon,
  });

  final String label;
  final String subLabel;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            color: color.withValues(alpha: 0.05),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 2),
              const Text(
                'EXPLORER',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        Text(
          subLabel,
          style: const TextStyle(fontSize: 9, color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
