import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/data/models/passport_data.dart';
import 'package:stoneecho/providers/passport_provider.dart';
import 'package:stoneecho/providers/wallet_providers.dart';

class JourneyListScreen extends ConsumerStatefulWidget {
  const JourneyListScreen({super.key});

  @override
  ConsumerState<JourneyListScreen> createState() => _JourneyListScreenState();
}

class _JourneyListScreenState extends ConsumerState<JourneyListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletProvider);
    final passportAsync = ref.watch(userPassportProvider);
    final journeysAsync = ref.watch(userJourneysProvider);

    // Show offline banner when any provider returned cached data
    final isOffline = (passportAsync.asData?.value.isFromCache ?? false) ||
        (journeysAsync.asData?.value.isFromCache ?? false);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            if (isOffline) const _OfflineBanner(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero banner
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: journeysAsync.when(
                        data: (result) => walletAsync.when(
                          data: (wallet) => _HeroJourneyCard(
                            journey: result.journeys.isNotEmpty
                                ? result.journeys.first
                                : null,
                            wallet: wallet,
                          ),
                          loading: () => const _HeroJourneyCard(
                            journey: null,
                            wallet: null,
                          ),
                          error: (_, __) => const _HeroJourneyCard(
                            journey: null,
                            wallet: null,
                          ),
                        ),
                        loading: () =>
                            const _HeroJourneyCard(journey: null, wallet: null),
                        error: (_, __) =>
                            const _HeroJourneyCard(journey: null, wallet: null),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tab bar
                    _buildTabBar(),

                    // Tab content — driven by tab controller, no TabBarView needed
                    ListenableBuilder(
                      listenable: _tabController,
                      builder: (_, __) {
                        return passportAsync.when(
                          data: (result) => walletAsync.when(
                            data: (wallet) =>
                                _buildTabContent(result.passport, wallet),
                            loading: () => _buildTabContent(null, null),
                            error: (_, __) =>
                                _buildTabContent(result.passport, null),
                          ),
                          loading: () => _buildTabContent(null, null),
                          error: (e, _) => _buildErrorState(e),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            color: AppColors.forestGreen,
            onPressed: () {},
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Journey',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.forestGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Track your Ha Giang adventure',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.info_outline,
                size: 16, color: AppColors.textSecondary),
            label: const Text(
              'How it works',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.forestGreen,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.forestGreen,
        indicatorWeight: 2,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        tabs: const [
          Tab(text: 'Passport'),
          Tab(text: 'Collection'),
        ],
      ),
    );
  }

  Widget _buildTabContent(PassportData? passport, WalletState? wallet) {
    return _tabController.index == 0
        ? _PassportTab(passport: passport)
        : _CollectionTab(passport: passport, wallet: wallet);
  }

  Widget _buildErrorState(Object error) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.textLight, size: 48),
          const SizedBox(height: 12),
          Text(
            'Could not load journey data',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.invalidate(userPassportProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ─── Offline Banner ───────────────────────────────────────────────────────────

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF3E0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 16, color: Color(0xFFE65100)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Offline mode — showing last synced data',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFE65100),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Journey Card ────────────────────────────────────────────────────────

class _HeroJourneyCard extends StatelessWidget {
  const _HeroJourneyCard({
    required this.journey,
    required this.wallet,
  });

  final UserJourneyProgress? journey;
  final WalletState? wallet;

  @override
  Widget build(BuildContext context) {
    final name = journey?.journeyName ?? 'Ha Giang Explorer';
    final explored = journey?.exploredCount ?? 0;
    final total = journey?.totalLocations ?? 15;
    final progress = journey?.progress ?? 0.0;
    final lastPlace = journey?.lastVisitedPlace;
    final collected = wallet?.wallet.totalEarned ?? 0;
    final spent = wallet?.wallet.totalSpent ?? 0;
    final imageUrl = journey?.journeyImageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.forestGreen,
                ),
              )
            else
              Container(color: AppColors.forestGreen),

            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.landscape,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  const Text(
                    'Total Progress',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.forestGreenLight),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    '$explored / $total locations explored',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                  const Spacer(),

                  // Flowers + Continue row
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('🌸',
                                  style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 4),
                              Text(
                                'Buckwheat Flowers',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                          Text(
                            '$collected Collected  •  $spent Spent',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                          if (lastPlace != null)
                            Text(
                              'Last visited: $lastPlace',
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 11),
                            ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.forestGreen,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Continue Journey',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward,
                                  size: 14, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Passport Tab ─────────────────────────────────────────────────────────────

class _PassportTab extends ConsumerWidget {
  const _PassportTab({required this.passport});
  final PassportData? passport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeysAsync = ref.watch(userJourneysProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Ha Giang Journey',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.deepBrown,
            ),
          ),
          const SizedBox(height: 16),
          journeysAsync.when(
            data: (result) => result.journeys.isEmpty
                ? _buildEmpty()
                : Column(
                    children: result.journeys
                        .map((j) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _JourneyProgressCard(journey: j),
                            ))
                        .toList(),
                  ),
            loading: () => Column(
              children: List.generate(
                3,
                (_) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: _JourneyProgressCardSkeleton(),
                ),
              ),
            ),
            error: (e, _) => Center(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const Icon(Icons.error_outline,
                      color: AppColors.textLight, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Could not load journeys',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(userJourneysProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.menu_book_outlined,
                size: 56, color: AppColors.textLight),
            SizedBox(height: 12),
            Text(
              'No journeys started yet',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyProgressCard extends StatelessWidget {
  const _JourneyProgressCard({required this.journey});
  final UserJourneyProgress journey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
            child: SizedBox(
              width: 100,
              height: 110,
              child: journey.journeyImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: journey.journeyImageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _imageFallback(),
                    )
                  : _imageFallback(),
            ),
          ),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journey.journeyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBrown,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Places visited
                  Text(
                    '${journey.exploredCount} / ${journey.totalLocations} Places Visited',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: journey.progress,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.forestGreen),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Stamps
                  Text(
                    '${journey.stampCollected} / ${journey.totalStamps} Stamps Collected',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),

                  // Action
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            journey.isCompleted
                                ? 'Review Again'
                                : 'Continue Journey',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.forestGreen,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_forward,
                              size: 13, color: AppColors.forestGreen),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppColors.creamDark,
      child: const Icon(Icons.landscape,
          color: AppColors.textLight, size: 36),
    );
  }
}

class _JourneyProgressCardSkeleton extends StatelessWidget {
  const _JourneyProgressCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.creamDark,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

// ─── Collection Tab ───────────────────────────────────────────────────────────

class _CollectionTab extends StatelessWidget {
  const _CollectionTab({required this.passport, required this.wallet});
  final PassportData? passport;
  final WalletState? wallet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          _StatsRow(passport: passport, wallet: wallet),
          const SizedBox(height: 24),

          // Destination Stamps
          _DestinationStampsSection(stamps: passport?.stamps ?? []),
          const SizedBox(height: 24),

          // Visited Places
          _VisitedPlacesSection(places: passport?.visitedPlaces ?? []),
          const SizedBox(height: 24),

          // Flowers summary
          _FlowersSummaryCard(wallet: wallet),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.passport, required this.wallet});
  final PassportData? passport;
  final WalletState? wallet;

  @override
  Widget build(BuildContext context) {
    final flowers = wallet?.wallet.totalEarned ?? passport?.flowersCollected ?? 0;
    final stamps = passport?.stampCount ?? 0;
    final discovered = passport?.placesDiscovered ?? 0;
    final explored = passport?.placesExplored ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatItem(
            icon: '🌸',
            value: '$flowers',
            label: 'Flowers\nCollected',
          ),
          _StatDivider(),
          _StatItem(
            icon: '🏛️',
            value: '$stamps',
            label: 'Destination\nStamps',
          ),
          _StatDivider(),
          _StatItem(
            icon: '🖼️',
            value: '$discovered',
            label: 'Places\nDiscovered',
          ),
          _StatDivider(),
          _StatItem(
            icon: '📖',
            value: '$explored',
            label: 'Places\nExplored',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.deepBrown,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: const Color(0xFFEEEEEE),
    );
  }
}

// ─── Destination Stamps ───────────────────────────────────────────────────────

class _DestinationStampsSection extends StatelessWidget {
  const _DestinationStampsSection({required this.stamps});
  final List<DestinationStamp> stamps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Destination Stamps',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBrown,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.forestGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        size: 16, color: AppColors.forestGreen),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: stamps.isEmpty
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => const _StampPlaceholder(),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stamps.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _StampCard(stamp: stamps[i]),
                ),
        ),
      ],
    );
  }
}

class _StampCard extends StatelessWidget {
  const _StampCard({required this.stamp});
  final DestinationStamp stamp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB03A2E), width: 2.5),
            ),
            child: ClipOval(
              child: stamp.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: stamp.imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          const _StampPlaceholderInner(),
                    )
                  : const _StampPlaceholderInner(),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stamp.placeName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: AppColors.deepBrown),
          ),
          Text(
            '${stamp.collectedCount} of ${stamp.totalInJourney} locations',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

class _StampPlaceholder extends StatelessWidget {
  const _StampPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFB03A2E).withValues(alpha: 0.3),
                  width: 2.5),
              color: AppColors.creamDark,
            ),
            child: const _StampPlaceholderInner(),
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.creamDark,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _StampPlaceholderInner extends StatelessWidget {
  const _StampPlaceholderInner();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.place_outlined,
        color: AppColors.textLight, size: 32);
  }
}

// ─── Visited Places ───────────────────────────────────────────────────────────

class _VisitedPlacesSection extends StatelessWidget {
  const _VisitedPlacesSection({required this.places});
  final List<VisitedPlaceEntry> places;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Visited Places',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBrown,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.forestGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        size: 16, color: AppColors.forestGreen),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (places.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _VisitedPlaceCardPlaceholder()),
                const SizedBox(width: 12),
                Expanded(child: _VisitedPlaceCardPlaceholder()),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: places.length > 4 ? 4 : places.length,
              itemBuilder: (_, i) => _VisitedPlaceCard(place: places[i]),
            ),
          ),
      ],
    );
  }
}

class _VisitedPlaceCard extends StatelessWidget {
  const _VisitedPlaceCard({required this.place});
  final VisitedPlaceEntry place;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (place.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: place.imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.creamDark,
                        child: const Icon(Icons.landscape,
                            color: AppColors.textLight, size: 40),
                      ),
                    )
                  else
                    Container(
                      color: AppColors.creamDark,
                      child: const Icon(Icons.landscape,
                          color: AppColors.textLight, size: 40),
                    ),

                  // Gradient
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),

                  // Play button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          size: 18, color: AppColors.forestGreen),
                    ),
                  ),

                  // Place name
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Text(
                      place.placeName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Info area
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Row(
                  children: [
                    Icon(
                      place.isExplored
                          ? Icons.check_circle
                          : Icons.location_on,
                      size: 14,
                      color: place.isExplored
                          ? AppColors.successGreen
                          : AppColors.gold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      place.isExplored ? 'Explored' : 'Discovered',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: place.isExplored
                            ? AppColors.successGreen
                            : AppColors.gold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  place.isExplored
                      ? 'Story & Audio Completed'
                      : 'Story & Audio Ready',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('🌸', style: TextStyle(fontSize: 11)),
                    const SizedBox(width: 3),
                    Text(
                      place.isExplored
                          ? '${place.flowersEarned} Flowers Collected'
                          : 'Reward: ${place.flowersEarned} Flowers',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.flowerPink,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        place.isExplored ? 'Review Again' : 'Start Exploring',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_forward,
                          size: 12, color: AppColors.forestGreen),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitedPlaceCardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.creamDark,
      ),
      child: const Center(
        child: Icon(Icons.landscape_outlined,
            color: AppColors.textLight, size: 48),
      ),
    );
  }
}

// ─── Flowers Summary Card ─────────────────────────────────────────────────────

class _FlowersSummaryCard extends StatelessWidget {
  const _FlowersSummaryCard({required this.wallet});
  final WalletState? wallet;

  @override
  Widget build(BuildContext context) {
    final collected = wallet?.wallet.totalEarned ?? 0;
    final spent = wallet?.wallet.totalSpent ?? 0;
    final available = wallet?.wallet.balance ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🌸', style: TextStyle(fontSize: 48)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buckwheat Flowers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.deepBrown,
                  ),
                ),
                const SizedBox(height: 8),
                _FlowerRow(label: 'Collected:', value: '$collected'),
                _FlowerRow(label: 'Spent:', value: '$spent'),
                _FlowerRow(label: 'Available:', value: '$available'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowerRow extends StatelessWidget {
  const _FlowerRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepBrown)),
        ],
      ),
    );
  }
}
