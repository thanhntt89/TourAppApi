import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

/// Error state widget with icon, message, and a "Retry" button.
class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({
    required this.onRetry,
    this.message,
    this.icon,
    super.key,
  });

  final VoidCallback onRetry;
  final String? message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline_rounded,
              size: 64,
              color: AppColors.errorRed.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
