import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to search screen or show search overlay
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: AppColors.creamDark),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.textLight,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.searchPlaceholder,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
