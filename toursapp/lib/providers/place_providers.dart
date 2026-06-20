import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/place.dart';
import 'package:stoneecho/providers/gps_providers.dart';

part 'place_providers.g.dart';

@riverpod
Future<List<Place>> places(Ref ref, {required int locationId}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.places,
    queryParameters: {'location_id': locationId},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => Place.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
Future<Place> placeDetail(Ref ref, {required int id}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.places}/$id',
  );
  final data = response.data!;
  return Place.fromJson(data['data'] as Map<String, dynamic>);
}

@riverpod
Future<List<Place>> nearbyPlaces(Ref ref) async {
  const nearbyRadiusKm = 5.0;
  final position = await ref.watch(currentPositionProvider.future);
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.placesNearby,
    queryParameters: {
      'lat': position.latitude,
      'lng': position.longitude,
      'radius': nearbyRadiusKm,
    },
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => Place.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
Future<List<Place>> placeSearch(Ref ref, {required String query}) async {
  if (query.trim().isEmpty) return [];

  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.placesSearch,
    queryParameters: {'q': query},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => Place.fromJson(e as Map<String, dynamic>))
      .toList();
}
