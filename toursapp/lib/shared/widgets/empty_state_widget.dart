import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

/// Empty state widget with illustration placeholder, title, description,
/// and an optional call-to-action button.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title,
    this.description,
    this.icon,
    this.ctaLabel,
    this.onCtaTap,
    super.key,
  });

  final String title;
  final String? description;
  final IconData? icon;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 56,
                color: AppColors.forestGreen.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.deepBrown,
              ),
            ),

            // Description
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],

            // CTA button
            if (ctaLabel != null && onCtaTap != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onCtaTap,
                child: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
