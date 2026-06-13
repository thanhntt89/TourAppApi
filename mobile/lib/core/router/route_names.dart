// lib/core/router/route_names.dart
//
// String constants for all named routes.
// Prevents typos when using GoRouter context.goNamed()

abstract class RouteNames {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';

  // Bottom Nav Tabs (Main Shell)
  static const String home = 'home';
  static const String map = 'map';
  static const String routes = 'routes';
  static const String stories = 'stories';
  static const String news = 'news';

  // Detail Screens
  static const String placeDetail = 'place_detail';
  static const String subPlaceDetail = 'sub_place_detail';
  static const String routeDetail = 'route_detail';
  static const String storyDetail = 'story_detail';

  // Utilities & Settings
  static const String qrScanner = 'qr_scanner';
  static const String settings = 'settings';
  static const String offlineManager = 'offline_manager';
  static const String wallet = 'wallet';
  static const String userJourneys = 'user_journeys';
}
