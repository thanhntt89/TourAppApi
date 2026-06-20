import 'package:flutter/material.dart';
import 'package:stoneecho/core/l10n/generated/app_localizations.dart';

/// Convenience extensions on [BuildContext] for quick access to
/// commonly used theme and layout properties.
extension ContextExtensions on BuildContext {
  /// Current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Current [ColorScheme] from the theme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Current [TextTheme] from the theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Localized strings via [AppLocalizations].
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width in logical pixels.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height in logical pixels.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Bottom padding (safe area).
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  /// Top padding (safe area / status bar).
  double get topPadding => MediaQuery.paddingOf(this).top;

  /// Whether the device is in dark mode.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
