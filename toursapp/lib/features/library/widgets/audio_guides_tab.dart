import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class AudioGuidesTab extends ConsumerWidget {
  const AudioGuidesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recently played section
        Text(l10n.recentlyPlayed, style: AppTextStyles.titleMedium),
        const SizedBox(height: 12),

        // TODO: Load from audio history provider
        ...List.generate(3, (index) => _AudioGuideItem(index: index)),

        const SizedBox(height: 24),

        // By location section
        Text(l10n.byLocation, style: AppTextStyles.titleMedium),
        const SizedBox(height: 12),

        ...List.generate(4, (index) => _AudioGuideItem(index: index + 3)),
      ],
    );
  }
}

class _AudioGuideItem extends StatelessWidget {
  const _AudioGuideItem({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 56,
          height: 56,
          color: AppColors.creamDark,
          child: const Icon(Icons.headphones, color: AppColors.forestGreen),
        ),
      ),
      title: Text('Audio Guide ${index + 1}', style: AppTextStyles.titleSmall),
      subtitle: const Text('Location Name • 5:30'),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_filled, color: AppColors.forestGreen, size: 36),
        onPressed: () {
          // TODO: Play audio
        },
      ),
    );
  }
}
