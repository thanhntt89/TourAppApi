import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';

class StoriesTab extends ConsumerWidget {
  const StoriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (context, index) => _StoryItem(index: index),
    );
  }
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 80,
            height: 80,
            color: AppColors.creamDark,
            child: const Icon(Icons.auto_stories, color: AppColors.gold, size: 32),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cultural Story ${index + 1}',
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 4),
              const Text(
                'A fascinating tale about the local Hmong people and their traditions that have been passed down through generations...',
                style: AppTextStyles.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.headphones, size: 14, color: AppColors.forestGreen),
                  SizedBox(width: 4),
                  Text('8:45', style: AppTextStyles.caption),
                  SizedBox(width: 12),
                  Icon(Icons.location_on, size: 14, color: AppColors.coral),
                  SizedBox(width: 4),
                  Text('Dong Van', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
