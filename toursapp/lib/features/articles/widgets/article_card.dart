import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({required this.index, required this.onTap, super.key});
  final int index;
  final VoidCallback onTap;

  static const _titles = [
    'Discovering the Ancient Hmong Markets',
    'The Buckwheat Flower Season Guide',
    'Ma Pi Leng Pass: A Journey Through Clouds',
    "Lung Cu Flag Tower: Vietnam's Northern Peak",
    'Traditional Cuisine of Ha Giang Highlands',
    'The Legend of the Stone Plateau',
    'Ethnic Minorities: A Cultural Tapestry',
    'Motorbike Routes Through the Mountains',
    'Photography Guide: Capturing Ha Giang',
    "Sustainable Tourism: Traveler's Responsibility",
  ];

  static const _categories = ['Culture', 'Nature', 'Adventure', 'History', 'Food', 'Culture', 'Culture', 'Adventure', 'Guide', 'Guide'];

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 160,
              width: double.infinity,
              color: AppColors.creamDark,
              child: const Center(
                child: Icon(Icons.landscape, size: 48, color: AppColors.textLight),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _categories[index % _categories.length],
                      style: const TextStyle(
                        color: AppColors.forestGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    _titles[index % _titles.length],
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Meta info
                  Row(
                    children: [
                      const Text('StoneEcho Team', style: AppTextStyles.caption),
                      const SizedBox(width: 8),
                      const Text('•'),
                      const SizedBox(width: 8),
                      Text('${5 + index} min read', style: AppTextStyles.caption),
                      const Spacer(),
                      const Icon(Icons.headphones, size: 14, color: AppColors.forestGreen),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
