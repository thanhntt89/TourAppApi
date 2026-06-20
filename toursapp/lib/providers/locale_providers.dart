import 'dart:async';
import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/app_constants.dart';
import 'package:stoneecho/providers/app_providers.dart';

part 'locale_providers.g.dart';

const _uiLocaleKey = 'ui_locale';
const _contentLanguageKey = 'content_language';

/// Controls the UI language (app chrome, labels, buttons).
@Riverpod(keepAlive: true)
class UiLocale extends _$UiLocale {
  @override
  Locale build() {
    unawaited(_loadFromPrefs());
    return const Locale(AppConstants.defaultUiLanguage);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final saved = prefs.getString(_uiLocaleKey);
    if (saved != null) {
      state = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_uiLocaleKey, locale.languageCode);
  }
}

/// Controls the content/audio language (stories, narration, descriptions).
/// This can differ from the UI language — e.g., Vietnamese UI but English
/// audio for a Korean tourist who speaks English.
@Riverpod(keepAlive: true)
class ContentLanguage extends _$ContentLanguage {
  @override
  String build() {
    unawaited(_loadFromPrefs());
    return AppConstants.defaultContentLanguage;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final saved = prefs.getString(_contentLanguageKey);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> setLanguage(String languageCode) async {
    state = languageCode;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_contentLanguageKey, languageCode);
  }
}
