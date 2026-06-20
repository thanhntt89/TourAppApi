import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoneecho/data/database/app_database.dart';

part 'app_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

/// Device language mapped to supported API langs: vi, en, ko, zh. Fallback: en.
final appLangProvider = Provider<String>((ref) {
  const supported = {'vi', 'en', 'ko', 'zh'};
  final code = PlatformDispatcher.instance.locale.languageCode;
  return supported.contains(code) ? code : 'en';
});
