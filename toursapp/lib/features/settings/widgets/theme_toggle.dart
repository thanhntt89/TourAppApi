import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _ThemeOption(
              icon: Icons.light_mode,
              label: l10n.light,
              isSelected: true, // TODO: Read from provider
              onTap: () {
                // TODO: Set light mode
              },
            ),
            const SizedBox(width: 8),
            _ThemeOption(
              icon: Icons.dark_mode,
              label: l10n.dark,
              isSelected: false,
              onTap: () {
                // TODO: Set dark mode
              },
            ),
            const SizedBox(width: 8),
            _ThemeOption(
              icon: Icons.brightness_auto,
              label: l10n.system,
              isSelected: false,
              onTap: () {
                // TODO: Set system mode
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.forestGreen.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.forestGreen : AppColors.creamDark,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.forestGreen : AppColors.textLight,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.forestGreen : AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
