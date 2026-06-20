import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/features/home/widgets/alert_ticker.dart';
import 'package:stoneecho/features/home/widgets/category_chips.dart';
import 'package:stoneecho/features/home/widgets/flower_counter.dart';
import 'package:stoneecho/features/home/widgets/home_search_bar.dart';
import 'package:stoneecho/features/home/widgets/place_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top bar: KM0 + Search + Flower counter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    // KM0 badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'KM0',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: HomeSearchBar()),
                    const SizedBox(width: 12),
                    const FlowerCounter(),
                  ],
                ),
              ),
            ),

            // Alert ticker
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: AlertTicker(),
              ),
            ),

            // Category chips
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CategoryChips(),
              ),
            ),

            // Section title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Highlights — Places',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.deepBrown,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            // Place cards list
            // TODO: Replace with real data from placesProvider
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PlaceCard(
                      index: index + 1,
                      name: 'Sample Place ${index + 1}',
                      distance: '${(index + 1) * 5.2} km',
                      status: index.isEven ? 'discovered' : 'locked',
                      onTap: () {},
                    ),
                  ),
                  childCount: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
