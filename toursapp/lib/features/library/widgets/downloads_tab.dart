import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/core/utils/formatters.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class DownloadsTab extends ConsumerWidget {
  const DownloadsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Storage info
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.offlineStorage, style: AppTextStyles.titleMedium),
                    Text(
                      Formatters.fileSize(125 * 1024 * 1024),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.35,
                    minHeight: 8,
                    backgroundColor: AppColors.creamDark,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _LegendDot(color: AppColors.forestGreen, label: l10n.mapTiles),
                    const SizedBox(width: 16),
                    _LegendDot(color: AppColors.gold, label: l10n.audioFiles),
                    const SizedBox(width: 16),
                    _LegendDot(color: AppColors.coral, label: l10n.images),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Offline packages
        Text(l10n.offlinePackages, style: AppTextStyles.titleMedium),
        const SizedBox(height: 12),

        const _OfflinePackageCard(
          name: 'Dong Van - Meo Vac',
          size: '45 MB',
          places: 12,
          isDownloaded: true,
        ),
        const SizedBox(height: 8),
        const _OfflinePackageCard(
          name: 'Ha Giang City Area',
          size: '32 MB',
          places: 8,
          isDownloaded: false,
        ),
        const SizedBox(height: 8),
        const _OfflinePackageCard(
          name: 'Quan Ba - Yen Minh',
          size: '38 MB',
          places: 10,
          isDownloaded: false,
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _OfflinePackageCard extends StatelessWidget {
  const _OfflinePackageCard({
    required this.name,
    required this.size,
    required this.places,
    required this.isDownloaded,
  });

  final String name;
  final String size;
  final int places;
  final bool isDownloaded;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDownloaded
              ? AppColors.forestGreen.withValues(alpha: 0.1)
              : AppColors.creamDark,
          child: Icon(
            isDownloaded ? Icons.check_circle : Icons.download,
            color: isDownloaded ? AppColors.forestGreen : AppColors.textLight,
          ),
        ),
        title: Text(name, style: AppTextStyles.titleSmall),
        subtitle: Text('$places places • $size'),
        trailing: isDownloaded
            ? IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.coral),
                onPressed: () {
                  // TODO: Delete offline package
                },
              )
            : ElevatedButton(
                onPressed: () {
                  // TODO: Download package
                },
                child: const Text('Download'),
              ),
      ),
    );
  }
}
