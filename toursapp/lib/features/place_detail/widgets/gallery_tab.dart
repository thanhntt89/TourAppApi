import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Load gallery from placeDetailProvider
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // TODO: Open full-screen image viewer
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const ColoredBox(
              color: AppColors.creamDark,
              child: Icon(
                Icons.image,
                color: AppColors.textLight,
              ),
            ),
          ),
        );
      },
    );
  }
}
