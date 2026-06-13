// lib/core/theme/app_colors.dart
//
// Color palette inspired by Hà Giang landscapes:
// - Deep mountain blue-greens
// - Warm terracotta of buckwheat flowers
// - Mist grey of high passes

import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary — Deep Teal (mountain lakes) ──────────────────────────────────
  static const Color primary = Color(0xFF1A7A6E);
  static const Color primaryLight = Color(0xFF4AADA0);
  static const Color primaryDark = Color(0xFF00524A);
  static const MaterialColor primarySwatch = MaterialColor(0xFF1A7A6E, {
    50: Color(0xFFE3F4F2),
    100: Color(0xFFB8E4DF),
    200: Color(0xFF88D2CA),
    300: Color(0xFF57C0B5),
    400: Color(0xFF33B3A4),
    500: Color(0xFF1A7A6E),
    600: Color(0xFF157A6E),
    700: Color(0xFF116962),
    800: Color(0xFF0E5958),
    900: Color(0xFF073F3D),
  });

  // ── Secondary — Buckwheat Flower Warm Rose ────────────────────────────────
  static const Color secondary = Color(0xFFD4517A);
  static const Color secondaryLight = Color(0xFFFF8099);
  static const Color secondaryDark = Color(0xFF9F1B55);

  // ── Accent — Golden harvest ───────────────────────────────────────────────
  static const Color accent = Color(0xFFE8A827);
  static const Color accentLight = Color(0xFFFFC83D);
  static const Color accentDark = Color(0xFFB07E00);

  // ── Neutrals ──────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F7F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEF2F1);

  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1C2322);
  static const Color onSurface = Color(0xFF1C2322);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1C2322);
  static const Color textSecondary = Color(0xFF546663);
  static const Color textHint = Color(0xFF8FA8A5);
  static const Color textDisabled = Color(0xFFBFCFCC);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D52);
  static const Color error = Color(0xFFB3261E);
  static const Color warning = Color(0xFFE8A827);
  static const Color info = Color(0xFF1565C0);

  // ── Dark Mode ─────────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0D1615);
  static const Color darkSurface = Color(0xFF1A2523);
  static const Color darkSurfaceVariant = Color(0xFF253331);
  static const Color darkOnBackground = Color(0xFFE1EEEC);
  static const Color darkOnSurface = Color(0xFFE1EEEC);
  static const Color darkPrimary = Color(0xFF4AADA0);
  static const Color darkSecondary = Color(0xFFFF8099);

  // ── Map ───────────────────────────────────────────────────────────────────
  static const Color mapMarkerDefault = primary;
  static const Color mapMarkerFeatured = secondary;
  static const Color mapMarkerVisited = Color(0xFF78909C);
  static const Color mapGeofenceCircle = Color(0x331A7A6E);

  // ── Wallet / Flowers ──────────────────────────────────────────────────────
  static const Color flowerGold = Color(0xFFE8A827);
  static const Color flowerEarn = Color(0xFF2E7D52);
  static const Color flowerSpend = Color(0xFFB3261E);
}
