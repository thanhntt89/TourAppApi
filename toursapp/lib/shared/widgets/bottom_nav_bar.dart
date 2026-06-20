import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoneecho/core/router/route_names.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

/// Custom bottom navigation bar with 5 tabs.
/// The center QR button is an elevated floating action button.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static const _tabs = [
    _NavTab(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', route: '/home'),
    _NavTab(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Journeys', route: '/journeys'),
    _NavTab(icon: Icons.qr_code_scanner, activeIcon: Icons.qr_code_scanner, label: 'QR', route: '/scanner'),
    _NavTab(icon: Icons.library_books_outlined, activeIcon: Icons.library_books, label: 'Library', route: '/library'),
    _NavTab(icon: Icons.more_horiz, activeIcon: Icons.more_horiz, label: 'More', route: '/settings'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/journeys')) return 1;
    if (location.startsWith('/library')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final theme = Theme.of(context);

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];

            // Center QR button — elevated FAB
            if (index == 2) {
              return _QrCenterButton(
                onTap: () => context.pushNamed(RouteNames.scanner),
              );
            }

            final isActive = index == currentIndex;
            return _NavBarItem(
              icon: isActive ? tab.activeIcon : tab.icon,
              label: tab.label,
              isActive: isActive,
              onTap: () => context.go(tab.route),
            );
          }),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.forestGreen : AppColors.textLight;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrCenterButton extends StatelessWidget {
  const _QrCenterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.forestGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.forestGreen.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
}
