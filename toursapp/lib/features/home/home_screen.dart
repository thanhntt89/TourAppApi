import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/utils/haversine.dart';
import 'package:stoneecho/features/home/widgets/alert_ticker.dart';
import 'package:stoneecho/features/home/widgets/category_chips.dart';
import 'package:stoneecho/features/home/widgets/flower_counter.dart';
import 'package:stoneecho/features/home/widgets/home_map_section.dart';
import 'package:stoneecho/features/home/widgets/home_search_bar.dart';
import 'package:stoneecho/features/home/widgets/place_card.dart';
import 'package:stoneecho/providers/gps_providers.dart';
import 'package:stoneecho/providers/place_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyAsync = ref.watch(nearbyPlacesProvider);
    final position = ref.watch(currentPositionProvider).asData?.value;

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
                        'STONEECHO',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5,
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

            // Offline map
            const SliverToBoxAdapter(child: HomeMapSection()),

            // Section title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  nearbyAsync.maybeWhen(
                    data: (places) => 'Nearby (${places.length})',
                    orElse: () => 'Nearby Places',
                  ),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.deepBrown,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            // Place cards from API
            nearbyAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Could not load places.\nMake sure GPS is enabled.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
              data: (places) => places.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text('No places found nearby.'),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final place = places[i];
                            final distText = position == null
                                ? '...'
                                : _formatDistance(
                                    Haversine.distanceKm(
                                      position.latitude,
                                      position.longitude,
                                      place.lat,
                                      place.lng,
                                    ),
                                  );
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: PlaceCard(
                                index: i + 1,
                                name: place.name,
                                distance: distText,
                                status: place.status ?? 'locked',
                                imageUrl: place.imageUrl,
                                flowerCost: place.flowerCost,
                                onTap: () {},
                              ),
                            );
                          },
                          childCount: places.length,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }
}
