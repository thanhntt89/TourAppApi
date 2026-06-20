import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/core/utils/haversine.dart';
import 'package:stoneecho/features/home/widgets/alert_ticker.dart';
import 'package:stoneecho/features/home/widgets/category_chips.dart';
import 'package:stoneecho/features/home/widgets/flower_counter.dart';
import 'package:stoneecho/features/home/widgets/home_map_section.dart';
import 'package:stoneecho/features/home/widgets/home_search_bar.dart';
import 'package:stoneecho/features/home/widgets/location_card.dart';
import 'package:stoneecho/features/home/widgets/place_card.dart';
import 'package:stoneecho/core/constants/map_constants.dart';
import 'package:stoneecho/providers/gps_providers.dart';
import 'package:stoneecho/providers/location_providers.dart';
import 'package:stoneecho/providers/place_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(currentPositionProvider).asData?.value;
    // Phase 1: Ha Giang only — province ID is fixed
    final locationsAsync = ref.watch(
      featuredLocationsProvider(MapConstants.haGiangProvinceId),
    );
    final placesAsync = ref.watch(
      placesByProvinceProvider(MapConstants.haGiangProvinceId),
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
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

            // Section header + tab pills
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _tab.index == 0 ? 'Explore by Location' : 'Highlights — Places',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.deepBrown,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    _TabPills(controller: _tab),
                  ],
                ),
              ),
            ),

            // Locations tab: 2-column grid
            if (_tab.index == 0) ...[
              locationsAsync.when(
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
                          'Locations error: $e',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.errorRed,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  data: (locations) => SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: locations.length,
                      itemBuilder: (context, i) => LocationCard(
                        location: locations[i],
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
            ],

            // Places tab: list
            if (_tab.index == 1) ...[
              placesAsync.when(
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
                        'Places error: $e',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.errorRed,
                          fontSize: 12,
                        ),
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
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        sliver: SliverList.builder(
                          itemCount: places.length,
                          itemBuilder: (context, i) {
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
                        ),
                      ),
              ),
            ],
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

class _TabPills extends StatelessWidget {
  const _TabPills({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.creamDark,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Pill(
                label: 'Locations',
                selected: controller.index == 0,
                onTap: () => controller.animateTo(0),
              ),
              _Pill(
                label: 'Places',
                selected: controller.index == 1,
                onTap: () => controller.animateTo(1),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.deepBrown : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
