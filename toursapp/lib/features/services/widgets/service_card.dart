import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({required this.index, required this.onTap, super.key});
  final int index;
  final VoidCallback onTap;

  static const _categories = ['Homestay', 'Restaurant', 'Motorbike', 'Guide', 'Cafe', 'Shop', 'Transport', 'Medical'];
  static const _icons = [Icons.hotel, Icons.restaurant, Icons.two_wheeler, Icons.person, Icons.local_cafe, Icons.shopping_bag, Icons.directions_bus, Icons.medical_services];

  @override
  Widget build(BuildContext context) {
    final category = _categories[index % _categories.length];
    final icon = _icons[index % _icons.length];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Image
            Container(
              width: 100,
              height: 100,
              color: AppColors.creamDark,
              child: Icon(icon, color: AppColors.forestGreen, size: 36),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.forestGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: AppColors.forestGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: AppColors.gold, size: 14),
                        const SizedBox(width: 2),
                        Text('4.${index + 1}', style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$category Name ${index + 1}',
                      style: AppTextStyles.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${(index + 1) * 0.5} km away',
                            style: AppTextStyles.caption,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
