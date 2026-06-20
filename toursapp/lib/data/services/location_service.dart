import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// Thin wrapper around [Geolocator] for easier testing and DI.
class LocationService {
  /// Requests location permission from the user.
  ///
  /// Returns the resulting [LocationPermission].
  Future<LocationPermission> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermission.deniedForever;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  /// Checks the current permission status without prompting the user.
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  /// Returns the device's current position.
  Future<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) {
    return Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: accuracy),
    );
  }

  /// Streams position updates whenever the device moves beyond
  /// [distanceFilter] meters.
  Stream<Position> watchPosition({int distanceFilter = 50}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// Calculates the distance in meters between two coordinates.
  double distanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
