// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../shared/widgets/app_scaffold.dart';

// Placeholder screens to satisfy the router temporarily
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text(title)));
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppScaffold(child: child); // The 5-tab bottom nav
      },
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.home,
          builder: (context, state) => const PlaceholderScreen(title: 'Home / Provinces'),
        ),
        GoRoute(
          path: '/map',
          name: RouteNames.map,
          builder: (context, state) => const PlaceholderScreen(title: 'Interactive Map'),
        ),
        GoRoute(
          path: '/routes',
          name: RouteNames.routes,
          builder: (context, state) => const PlaceholderScreen(title: 'Journeys'),
        ),
        GoRoute(
          path: '/stories',
          name: RouteNames.stories,
          builder: (context, state) => const PlaceholderScreen(title: 'Stories'),
        ),
        GoRoute(
          path: '/news',
          name: RouteNames.news,
          builder: (context, state) => const PlaceholderScreen(title: 'News & Alerts'),
        ),
      ],
    ),
    
    // Top-level routes (hide bottom nav)
    GoRoute(
      path: '/places/:id',
      name: RouteNames.placeDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PlaceholderScreen(title: 'Place Detail: $id');
      },
    ),
    GoRoute(
      path: '/scanner',
      name: RouteNames.qrScanner,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PlaceholderScreen(title: 'QR Scanner'),
    ),
  ],
);
