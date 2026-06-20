import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/features/journeys/widgets/destination_stamps_grid.dart';
import 'package:stoneecho/features/journeys/widgets/journey_hero_banner.dart';
import 'package:stoneecho/features/journeys/widgets/user_stats_grid.dart';
import 'package:stoneecho/features/journeys/widgets/visited_places_list.dart';

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
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero banner
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: JourneyHeroBanner(),
                    ),
                    const SizedBox(height: 16),

                    // Tab bar
                    _buildTabBar(),

                    // Tab content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const UserStatsGrid(),
                          const SizedBox(height: 24),
                          const DestinationStampsGrid(),
                          const SizedBox(height: 24),
                          const VisitedPlacesList(),
                          const SizedBox(height: 24),
                          _buildFlowersSummaryCard(),
                          const SizedBox(height: 100), // Space for nav bar
                        ],
                      ),
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
            icon: const Icon(Icons.chevron_left, size: 28),
            color: AppColors.deepBrown,
            onPressed: () {},
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Journey',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.deepBrown,
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
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
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
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Passport'),
          Tab(text: 'Collection'),
        ],
      ),
    );
  }

  Widget _buildFlowersSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.creamDark),
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
                _buildFlowerRow('Collected:', '12'),
                _buildFlowerRow('Spent:', '3'),
                _buildFlowerRow('Available:', '9'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBrown)),
        ],
      ),
    );
  }
}
