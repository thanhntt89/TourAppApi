import 'dart:async';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/providers/app_providers.dart';

part 'theme_providers.g.dart';

const _themeModeKey = 'theme_mode';

/// Persisted theme mode (light / dark / system).
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    unawaited(_loadFromPrefs());
    return ThemeMode.system;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final saved = prefs.getString(_themeModeKey);
    if (saved != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> toggle() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}
