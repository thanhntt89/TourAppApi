import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailScreen extends ConsumerWidget {
  const ServiceDetailScreen({required this.serviceId, super.key});
  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero image
          const SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ColoredBox(
                color: AppColors.creamDark,
                child: Icon(Icons.store, size: 64, color: AppColors.textLight),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Service name + category
                const Text('Service Name', style: AppTextStyles.headlineLarge),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Homestay',
                    style: TextStyle(color: AppColors.forestGreen, fontSize: 12),
                  ),
                ),

                const SizedBox(height: 16),

                // Rating + price range
                const Row(
                  children: [
                    Icon(Icons.star, color: AppColors.gold, size: 20),
                    SizedBox(width: 4),
                    Text('4.5', style: AppTextStyles.titleSmall),
                    SizedBox(width: 4),
                    Text('(28 reviews)', style: AppTextStyles.caption),
                    Spacer(),
                    Text(r'$$', style: AppTextStyles.titleMedium),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),

                // Contact info
                _InfoRow(
                  icon: Icons.location_on,
                  label: l10n.address,
                  value: '123 Street, Dong Van, Ha Giang',
                ),
                _InfoRow(
                  icon: Icons.phone,
                  label: l10n.phone,
                  value: '+84 123 456 789',
                  onTap: () => launchUrl(Uri.parse('tel:+84123456789')),
                ),
                _InfoRow(
                  icon: Icons.access_time,
                  label: l10n.openingHours,
                  value: '06:00 - 22:00',
                ),
                _InfoRow(
                  icon: Icons.language,
                  label: l10n.website,
                  value: 'www.example.com',
                  onTap: () => launchUrl(Uri.parse('https://www.example.com')),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),

                // Description
                Text(l10n.description, style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                const Text(
                  'A cozy homestay nestled in the heart of Dong Van, offering authentic local experiences with stunning mountain views. '
                  'Our family has been welcoming travelers for over 10 years, sharing traditional Hmong culture and cuisine.',
                  style: AppTextStyles.bodyMedium,
                ),

                const SizedBox(height: 20),

                // Photos grid placeholder
                Text(l10n.photos, style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 100,
                        color: AppColors.creamDark,
                        child: const Icon(Icons.photo, color: AppColors.textLight),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),

      // Bottom CTA
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => launchUrl(Uri.parse('tel:+84123456789')),
                  icon: const Icon(Icons.phone),
                  label: Text(l10n.call),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Open Google Maps navigation
                  },
                  icon: const Icon(Icons.directions),
                  label: Text(l10n.getDirections),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.forestGreen),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: onTap != null ? AppColors.forestGreen : null,
                    decoration: onTap != null ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
