import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stoneecho/core/constants/map_constants.dart';
import 'package:stoneecho/core/router/route_names.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/providers/news_providers.dart';

class AlertTicker extends ConsumerStatefulWidget {
  const AlertTicker({super.key});

  @override
  ConsumerState<AlertTicker> createState() => _AlertTickerState();
}

class _AlertTickerState extends ConsumerState<AlertTicker> {
  int _current = 0;
  Timer? _timer;
  Timer? _refreshTimer;
  int _lastCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (!mounted) return;
      ref.invalidate(pinnedNewsProvider(MapConstants.haGiangProvinceId));
    });
  }

  void _startRotation(int count) {
    if (count == _lastCount && _timer != null) return;
    _timer?.cancel();
    _lastCount = count;
    if (count <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      setState(() => _current = (_current + 1) % count);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(
      pinnedNewsProvider(MapConstants.haGiangProvinceId),
    );

    return alertsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (alerts) {
        if (alerts.isEmpty) return const SizedBox.shrink();

        // Ensure index is valid after data refresh
        if (_current >= alerts.length) _current = 0;

        // Start/restart rotation when data arrives
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startRotation(alerts.length);
        });

        final item = alerts[_current];
        final title = (item['title'] as String?) ?? '';
        final type = (item['type'] as String?) ?? 'news';
        final id = item['id'] as int;

        final (icon, iconColor, bgColor, borderColor) = _typeStyle(type);

        return GestureDetector(
          onTap: () => context.pushNamed(
            RouteNames.newsDetail,
            pathParameters: {'id': '$id'},
          ),
          child: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Text(
                      title,
                      key: ValueKey('$id-$_current'),
                      style: const TextStyle(fontSize: 13, color: Colors.brown),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                if (alerts.length > 1) ...[
                  const SizedBox(width: 6),
                  Text(
                    '${_current + 1}/${alerts.length}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.brown.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, color: iconColor, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }

  (IconData, Color, Color, Color) _typeStyle(String type) {
    return switch (type) {
      'warning' => (Icons.warning_amber, Colors.orange, AppColors.warningYellow, AppColors.warningBorder),
      'alert'   => (Icons.error_outline, Colors.red, const Color(0xFFFDE8E8), Colors.red),
      'event'   => (Icons.celebration, AppColors.forestGreen, const Color(0xFFE8F5E9), AppColors.forestGreen),
      _         => (Icons.campaign, Colors.blue, const Color(0xFFE3F2FD), Colors.blue),
    };
  }
}
