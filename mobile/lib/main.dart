// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/utils/device_id.dart';
import 'data/database/app_database.dart';

// Top-level provider for SharedPreferences (initialized synchronously in main)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialized in main()');
});

// Top-level provider for Drift Database
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

void main() async {
  // Ensure bindings are initialized before async work
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make system navigation bar transparent for edge-to-edge look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  // Initialize Core Services
  final prefs = await SharedPreferences.getInstance();
  await DeviceIdService.getOrCreate(); // Generate/load X-Device-UUID

  // Run the app wrapped in ProviderScope for Riverpod
  runApp(
    ProviderScope(
      overrides: [
        // Inject the synchronously resolved SharedPreferences
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ToursApp(),
    ),
  );
}
