import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class RecentScansSheet extends StatelessWidget {
  const RecentScansSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.recentScans, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          // TODO: Load from local storage
          const Text(
            'No recent scans',
            style: TextStyle(color: AppColors.textLight),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(l10n.enterCodeManually),
            ),
          ),
        ],
      ),
    );
  }
}
