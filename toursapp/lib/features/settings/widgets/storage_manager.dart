import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/utils/formatters.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class StorageManager extends ConsumerWidget {
  const StorageManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.map_outlined, color: AppColors.forestGreen),
            title: Text(l10n.mapTileCache),
            subtitle: Text(Formatters.fileSize(45 * 1024 * 1024)),
            trailing: TextButton(
              onPressed: () {
                // TODO: Clear map cache
              },
              child: Text(l10n.clear),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.music_note, color: AppColors.gold),
            title: Text(l10n.audioCache),
            subtitle: Text(Formatters.fileSize(62 * 1024 * 1024)),
            trailing: TextButton(
              onPressed: () {
                // TODO: Clear audio cache
              },
              child: Text(l10n.clear),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.image_outlined, color: AppColors.coral),
            title: Text(l10n.imageCache),
            subtitle: Text(Formatters.fileSize(18 * 1024 * 1024)),
            trailing: TextButton(
              onPressed: () {
                // TODO: Clear image cache
              },
              child: Text(l10n.clear),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: Text(l10n.clearAllCache),
            subtitle: Text(
              '${l10n.totalUsed}: ${Formatters.fileSize(125 * 1024 * 1024)}',
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // TODO: Clear all cache
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.clearAll),
            ),
          ),
        ],
      ),
    );
  }
}
