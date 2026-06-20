import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight JSON cache backed by SharedPreferences.
///
/// Used for user-specific API responses (passport, wallet, user journeys)
/// that don't have a dedicated Drift table but still need offline fallback.
///
/// For structured catalog data (journeys, places, provinces) use Drift instead.
class OfflineCache {
  static const _prefix = 'offline_cache_';

  static Future<void> save(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix$key', jsonEncode(data));
  }

  static Future<T?> load<T>(
    String key,
    T Function(dynamic json) fromJson,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return null;
    try {
      return fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$key');
  }
}
