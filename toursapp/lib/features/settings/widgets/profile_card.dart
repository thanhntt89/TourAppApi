import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar + name
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.forestGreen.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, size: 36, color: AppColors.forestGreen),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.anonymousExplorer, style: AppTextStyles.titleLarge),
                      const SizedBox(height: 4),
                      const Text(
                        'Phase 1: Device-based profile',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.location_on,
                  value: '12',
                  label: l10n.placesVisited,
                ),
                _StatItem(
                  icon: Icons.headphones,
                  value: '8',
                  label: l10n.audioPlayed,
                ),
                _StatItem(
                  icon: Icons.local_florist,
                  value: '150',
                  label: l10n.flowersEarned,
                ),
                _StatItem(
                  icon: Icons.route,
                  value: '2',
                  label: l10n.journeysCompleted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.forestGreen, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.titleMedium),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
