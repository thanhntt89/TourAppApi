// lib/core/utils/device_id.dart
//
// Generates and persists a unique device UUID.
// Used as the X-Device-UUID header for all authenticated API calls.
//
// The UUID is generated once on first launch and stored in SharedPreferences.
// It remains stable for the lifetime of the app installation.

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const String _kDeviceUuidKey = 'ta_device_uuid';

class DeviceIdService {
  DeviceIdService._();

  static String? _cachedUuid;

  /// Returns the persistent device UUID.
  /// Generates and stores a new one if not already set.
  static Future<String> getOrCreate() async {
    if (_cachedUuid != null) return _cachedUuid!;

    final prefs = await SharedPreferences.getInstance();
    String? existing = prefs.getString(_kDeviceUuidKey);

    if (existing == null || existing.isEmpty) {
      existing = const Uuid().v4();
      await prefs.setString(_kDeviceUuidKey, existing);
    }

    _cachedUuid = existing;
    return existing;
  }

  /// Returns the cached UUID synchronously.
  /// Must call [getOrCreate] at least once during app init.
  static String get current {
    assert(
      _cachedUuid != null,
      'DeviceIdService.getOrCreate() must be called before accessing .current',
    );
    return _cachedUuid!;
  }

  /// Clears the cached UUID (for testing only).
  static void clearCache() => _cachedUuid = null;
}
