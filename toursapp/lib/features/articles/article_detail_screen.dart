import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/theme/app_text_styles.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({required this.slug, super.key});
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // TODO: Toggle bookmark
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Share article
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.creamDark),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Article content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Category + date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Culture',
                        style: TextStyle(color: AppColors.forestGreen, fontSize: 12),
                      ),
                    ),
                    const Spacer(),
                    const Text('June 15, 2026', style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                const Text(
                  'Discovering the Ancient Hmong Markets of Ha Giang',
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 8),

                // Author + read time
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.creamDark,
                      child: Icon(Icons.person, size: 16, color: AppColors.textLight),
                    ),
                    SizedBox(width: 8),
                    Text('StoneEcho Team', style: AppTextStyles.bodySmall),
                    SizedBox(width: 12),
                    Icon(Icons.schedule, size: 14, color: AppColors.textLight),
                    SizedBox(width: 4),
                    Text('8 min read', style: AppTextStyles.caption),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                // Article body placeholder
                const Text(
                  'Every Sunday morning, as the mist lifts from the karst mountains, '
                  'the ancient market square of Dong Van comes alive with color and sound. '
                  'Hmong women in their intricate indigo-dyed outfits lay out handwoven textiles, '
                  'while the aroma of thang co — a traditional horse meat stew — fills the air.',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 16),
                const Text(
                  'These weekly markets have been a cornerstone of highland culture for centuries, '
                  'serving not just as trading posts but as social gatherings where news travels, '
                  "marriages are arranged, and the region's diverse ethnic groups connect.",
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 16),

                // Inline image placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: AppColors.creamDark,
                    child: const Center(
                      child: Icon(Icons.photo, size: 48, color: AppColors.textLight),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hmong women at the Dong Van Sunday market',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                const Text(
                  'The market tradition has survived through decades of change. '
                  'Today, visitors can experience the authentic atmosphere while supporting local communities. '
                  'Many of the products sold here — from beeswax candles to hand-forged knives — '
                  'represent skills passed down through generations.',
                  style: AppTextStyles.bodyLarge,
                ),

                const SizedBox(height: 32),

                // Audio version
                Card(
                  color: AppColors.forestGreen.withValues(alpha: 0.05),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.forestGreen,
                      child: Icon(Icons.headphones, color: Colors.white),
                    ),
                    title: Text(l10n.listenToArticle, style: AppTextStyles.titleSmall),
                    subtitle: const Text('8:45'),
                    trailing: const Icon(Icons.play_arrow, color: AppColors.forestGreen),
                    onTap: () {
                      // TODO: Play article audio
                    },
                  ),
                ),

                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
