import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';

class AlertTicker extends StatelessWidget {
  const AlertTicker({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Read from newsProvider for active alerts
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.warningYellow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warningBorder.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tap to see latest news & alerts...',
              style: TextStyle(fontSize: 13, color: Colors.brown),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.orange, size: 18),
        ],
      ),
    );
  }
}
