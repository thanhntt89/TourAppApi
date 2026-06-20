import 'package:flutter/material.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Load from placeDetailProvider
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _InfoRow(icon: Icons.access_time, label: 'Opening hours', value: '8:00 - 17:00'),
        const _InfoRow(icon: Icons.attach_money, label: 'Entrance fee', value: '40,000 VND'),
        const _InfoRow(icon: Icons.gps_fixed, label: 'Coordinates', value: '23.2742, 105.3542'),
        const _InfoRow(icon: Icons.info_outline, label: 'Tips', value: 'Wear comfortable shoes'),
        const SizedBox(height: 16),

        // Navigate button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              // TODO: Open Google Maps with coordinates
              final uri = Uri.parse('https://maps.google.com/?q=23.2742,105.3542');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.navigation),
            label: Text(context.l10n.navigateHere),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.forestGreen,
              side: const BorderSide(color: AppColors.forestGreen),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.forestGreen),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }
}
