import 'package:flutter/material.dart';
import 'package:stoneecho/core/constants/app_constants.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

/// Badge displaying a content status: Discovered, Explored, or Locked.
/// Each status has a distinct color and icon.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.status,
    this.compact = false,
    super.key,
  });

  /// One of [AppConstants.statusDiscovered], [AppConstants.statusExplored],
  /// or [AppConstants.statusLocked].
  final String status;

  /// When true, shows only the icon without text.
  final bool compact;

  Color get _color {
    switch (status) {
      case AppConstants.statusDiscovered:
        return AppColors.discovered;
      case AppConstants.statusExplored:
        return AppColors.explored;
      case AppConstants.statusLocked:
        return AppColors.locked;
      default:
        return AppColors.locked;
    }
  }

  IconData get _icon {
    switch (status) {
      case AppConstants.statusDiscovered:
        return Icons.visibility_outlined;
      case AppConstants.statusExplored:
        return Icons.check_circle_outline;
      case AppConstants.statusLocked:
        return Icons.lock_outline;
      default:
        return Icons.lock_outline;
    }
  }

  String get _label {
    switch (status) {
      case AppConstants.statusDiscovered:
        return 'Discovered';
      case AppConstants.statusExplored:
        return 'Explored';
      case AppConstants.statusLocked:
        return 'Locked';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Icon(_icon, color: _color, size: 18);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color, size: 14),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
