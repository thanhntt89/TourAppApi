import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/features/place_detail/widgets/audio_player_card.dart';
import 'package:stoneecho/features/place_detail/widgets/gallery_tab.dart';
import 'package:stoneecho/features/place_detail/widgets/hero_image_section.dart';
import 'package:stoneecho/features/place_detail/widgets/info_tab.dart';
import 'package:stoneecho/features/place_detail/widgets/quick_info_chips.dart';
import 'package:stoneecho/features/place_detail/widgets/related_places.dart';
import 'package:stoneecho/features/place_detail/widgets/reviews_tab.dart';
import 'package:stoneecho/features/place_detail/widgets/story_tab.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class PlaceDetailScreen extends ConsumerWidget {
  const PlaceDetailScreen({required this.placeId, super.key});

  final int placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    // TODO: Watch placeDetailProvider(placeId) for real data

    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // Hero image
            SliverToBoxAdapter(
              child: HeroImageSection(
                placeName: 'Place #$placeId',
                locationName: 'Ha Giang',
                status: 'discovered',
              ),
            ),

            // Audio player
            const SliverToBoxAdapter(
              child: AudioPlayerCard(),
            ),

            // Quick info chips
            const SliverToBoxAdapter(
              child: QuickInfoChips(
                distance: '50m',
                visitDuration: '30-45 min',
                category: 'Cultural Heritage',
                audioCount: 3,
              ),
            ),

            // Tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  labelColor: AppColors.forestGreen,
                  unselectedLabelColor: AppColors.textLight,
                  indicatorColor: AppColors.forestGreen,
                  tabs: [
                    Tab(text: l10n.tabStory),
                    Tab(text: l10n.tabInfo),
                    Tab(text: l10n.tabGallery),
                    Tab(text: l10n.tabReviews),
                  ],
                ),
              ),
            ),
          ],
          body: const TabBarView(
            children: [
              StoryTab(),
              InfoTab(),
              GalleryTab(),
              ReviewsTab(),
            ],
          ),
        ),
      ),

      // Related places at bottom
      bottomNavigationBar: const RelatedPlaces(),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: AppColors.cream,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
