// lib/core/utils/geo_utils.dart
//
// Geospatial utility functions.
// - Haversine distance calculation
// - Geofence check (is device within radius?)
// - Format distance for display

import 'dart:math';

class GeoUtils {
  GeoUtils._();

  static const double _earthRadiusMeters = 6371000.0;

  /// Calculates the distance between two coordinates in meters using Haversine formula.
  /// This mirrors the server-side Haversine used for GPS check-in validation.
  static double distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) *
            cos(_toRad(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusMeters * c;
  }

  /// Returns true if the device is within [radiusMeters] of the target point.
  static bool isWithinGeofence({
    required double deviceLat,
    required double deviceLng,
    required double targetLat,
    required double targetLng,
    required int radiusMeters,
  }) {
    final distance = distanceMeters(deviceLat, deviceLng, targetLat, targetLng);
    return distance <= radiusMeters;
  }

  /// Formats a distance value to a human-readable string.
  /// Returns "120 m" for < 1km, "1.2 km" for >= 1km.
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }

  static double _toRad(double deg) => deg * pi / 180;
}
