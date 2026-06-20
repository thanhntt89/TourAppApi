import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';

class StopTimeline extends StatelessWidget {
  const StopTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Load from journeyDetailProvider stops
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        final isVisited = index < 3;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dots + line
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isVisited ? AppColors.forestGreen : AppColors.textLight,
                      shape: BoxShape.circle,
                    ),
                    child: isVisited
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                  if (index < 5)
                    Container(
                      width: 2,
                      height: 60,
                      color: isVisited
                          ? AppColors.forestGreen
                          : AppColors.creamDark,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Stop info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stop ${index + 1}: Place Name',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(index + 1) * 12}km from previous',
                      style: AppTextStyles.caption,
                    ),
                    if (isVisited)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.headphones,
                              size: 14,
                              color: AppColors.forestGreen,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Audio available',
                              style: TextStyle(
                                color: AppColors.forestGreen,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
