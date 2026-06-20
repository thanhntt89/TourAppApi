import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';

class StoryTab extends StatelessWidget {
  const StoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Load from placeDetailProvider - story content
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'The Story',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Rich article content will be rendered here with beautiful typography, '
          'inline images, and expandable sections. '
          'Content is loaded from the WordPress API with multi-language support.',
          style: AppTextStyles.bodyLarge.copyWith(
            height: 1.8,
            color: AppColors.deepBrown,
          ),
        ),
        const SizedBox(height: 16),
        // Placeholder for rich content
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.creamDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Story content from API',
              style: TextStyle(color: AppColors.textLight),
            ),
          ),
        ),
      ],
    );
  }
}
