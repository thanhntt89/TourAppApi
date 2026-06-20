import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/core/utils/haversine.dart';
import 'package:stoneecho/data/models/place.dart';

part 'gps_providers.g.dart';

/// Stream of the user's current GPS position.
/// Updates based on AppConstants.gpsDistanceFilterBrowse.
@Riverpod(keepAlive: true)
Stream<Position> currentPosition(Ref ref) async* {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return;
  }

  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    ),
  );
}

/// Current GPS permission status.
@riverpod
Future<LocationPermission> gpsPermission(Ref ref) async {
  return Geolocator.checkPermission();
}

/// Request GPS permission from the user.
@riverpod
Future<LocationPermission> requestGpsPermission(Ref ref) async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  return permission;
}

/// Detects nearby places using the API, sorted by distance from current position.
@riverpod
Future<List<NearbyPlace>> nearbyDetection(Ref ref) async {
  const detectionRadiusKm = 0.5; // 500 meters

  final position = await ref.watch(currentPositionProvider.future);
  final dio = ref.watch(dioProvider);

  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.placesNearby,
    queryParameters: {
      'lat': position.latitude,
      'lng': position.longitude,
      'radius': detectionRadiusKm,
    },
  );
  final data = response.data!;
  final places = (data['data'] as List)
      .map((e) => Place.fromJson(e as Map<String, dynamic>))
      .toList();

  final nearby = places.map((place) {
    final distance = Haversine.distanceKm(
      position.latitude,
      position.longitude,
      place.lat,
      place.lng,
    );
    return NearbyPlace(place: place, distanceKm: distance);
  }).toList()
    ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

  return nearby;
}

/// A place with its distance from the user's current position.
class NearbyPlace {
  const NearbyPlace({required this.place, required this.distanceKm});

  final Place place;
  final double distanceKm;

  int get distanceMeters => (distanceKm * 1000).round();
}
