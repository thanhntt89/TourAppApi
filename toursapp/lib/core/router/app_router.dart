import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/router/route_names.dart';
import 'package:stoneecho/features/articles/article_detail_screen.dart';
import 'package:stoneecho/features/home/home_screen.dart';
import 'package:stoneecho/features/journeys/journey_detail_screen.dart';
import 'package:stoneecho/features/journeys/journey_list_screen.dart';
import 'package:stoneecho/features/library/library_screen.dart';
import 'package:stoneecho/features/onboarding/onboarding_screen.dart';
import 'package:stoneecho/features/place_detail/place_detail_screen.dart';
import 'package:stoneecho/features/scanner/qr_scanner_screen.dart';
import 'package:stoneecho/features/services/service_detail_screen.dart';
import 'package:stoneecho/features/settings/settings_screen.dart';
import 'package:stoneecho/shared/widgets/app_scaffold.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/journeys',
            name: RouteNames.journeys,
            builder: (context, state) => const JourneyListScreen(),
          ),
          GoRoute(
            path: '/library',
            name: RouteNames.library,
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),

      // Full-screen routes (outside shell)
      GoRoute(
        path: '/scanner',
        name: RouteNames.scanner,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const QrScannerScreen(),
      ),
      GoRoute(
        path: '/place/:id',
        name: RouteNames.placeDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PlaceDetailScreen(placeId: id);
        },
      ),
      GoRoute(
        path: '/journey/:id',
        name: RouteNames.journeyDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return JourneyDetailScreen(journeyId: id);
        },
      ),
      GoRoute(
        path: '/article/:slug',
        name: RouteNames.articleDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return ArticleDetailScreen(slug: slug);
        },
      ),
      GoRoute(
        path: '/service/:id',
        name: RouteNames.serviceDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServiceDetailScreen(serviceId: id);
        },
      ),
    ],
  );
}
