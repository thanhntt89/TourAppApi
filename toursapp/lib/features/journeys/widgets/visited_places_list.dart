import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/shared/widgets/status_badge.dart';

class VisitedPlacesList extends StatelessWidget {
  const VisitedPlacesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Visited Places',
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
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
          children: [
            _VisitedPlaceCard(
              title: 'The Last Hmong King',
              imageUrl: 'https://hagiang.caremycars.com/wp-content/uploads/2026/06/Vuameo-palace.png',
              status: 'explored',
              description: 'Story & Audio Completed',
              flowerCount: 2,
              buttonLabel: 'Review Again',
              isExplored: true,
            ),
            _VisitedPlaceCard(
              title: 'Pho Bang Old Quarter',
              imageUrl: 'https://hagiang.caremycars.com/wp-content/uploads/2026/06/Lung-Cu.png',
              status: 'discovered',
              description: 'Story & Audio Ready',
              flowerReward: 2,
              buttonLabel: 'Start Exploring',
              isExplored: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _VisitedPlaceCard extends StatelessWidget {
  const _VisitedPlaceCard({
    required this.title,
    required this.imageUrl,
    required this.status,
    required this.description,
    required this.buttonLabel,
    required this.isExplored,
    this.flowerCount,
    this.flowerReward,
  });

  final String title;
  final String imageUrl;
  final String status;
  final String description;
  final String buttonLabel;
  final bool isExplored;
  final int? flowerCount;
  final int? flowerReward;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image part
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.black, size: 20),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info part
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusBadge(status: status, compact: false),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                  ),
                  if (flowerCount != null || flowerReward != null)
                    Row(
                      children: [
                        const Text('🌸', style: TextStyle(fontSize: 10)),
                        const SizedBox(width: 4),
                        Text(
                          flowerCount != null
                            ? '$flowerCount Flowers Collected'
                            : 'Reward: $flowerReward Flowers',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isExplored ? AppColors.flowerPink : AppColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                  const Divider(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          buttonLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isExplored ? AppColors.textSecondary : AppColors.forestGreen,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 10,
                          color: isExplored ? AppColors.textSecondary : AppColors.forestGreen,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
