import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/place.dart';
import 'package:stoneecho/providers/app_providers.dart';
import 'package:stoneecho/providers/gps_providers.dart';

part 'place_providers.g.dart';

// API returns 'latitude'/'longitude', feature_image as {url,...} object,
// and nearby endpoint omits locationId/slug. Parse manually to avoid build_runner.
Place _parsePlace(Map<String, dynamic> json) {
  final img = json['feature_image'];
  final imageUrl = img is Map ? img['url'] as String? : img as String?;

  // /places/nearby omits 'location'; /places/{id} returns 'location' object
  final locationObj = json['location'];
  final locationId = locationObj is Map
      ? (locationObj['id'] as int?) ?? 0
      : (json['location_id'] as int?) ?? 0;

  return Place(
    id: json['id'] as int,
    locationId: locationId,
    name: (json['name'] as String?) ?? '',
    slug: (json['id'] as int).toString(),
    lat: (json['latitude'] as num).toDouble(),
    lng: (json['longitude'] as num).toDouble(),
    imageUrl: imageUrl,
    description: json['info'] as String?,
    status: json['user_status'] as String?,
    flowerCost: (json['article_cost'] as int?) ?? 5,
    category: json['place_type'] as String?,
  );
}

@riverpod
Future<List<Place>> places(Ref ref, {required int locationId}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.places,
    queryParameters: {'location_id': locationId, 'lang': ref.watch(appLangProvider)},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => _parsePlace(e as Map<String, dynamic>))
      .toList();
}

@riverpod
Future<Place> placeDetail(Ref ref, {required int id}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.places}/$id',
  );
  final data = response.data!;
  return _parsePlace(data['data'] as Map<String, dynamic>);
}

@riverpod
Future<List<Place>> nearbyPlaces(Ref ref) async {
  // 50 km covers all of Ha Giang; API expects radius in meters
  const radiusMeters = 50000;
  final position = await ref.watch(currentPositionProvider.future);
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.placesNearby,
    queryParameters: {
      'lat': position.latitude,
      'lng': position.longitude,
      'radius': radiusMeters,
      'province_id': 144,
      'limit': 50,
      'lang': ref.watch(appLangProvider),
    },
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => _parsePlace(e as Map<String, dynamic>))
      .toList();
}

final placesByProvinceProvider = FutureProvider.family<List<Place>, int>((ref, provinceId) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.places,
    queryParameters: {'province_id': provinceId, 'featured': 'true', 'lang': ref.watch(appLangProvider)},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => _parsePlace(e as Map<String, dynamic>))
      .toList();
});

@riverpod
Future<List<Place>> placeSearch(Ref ref, {required String query}) async {
  if (query.trim().isEmpty) return [];

  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.placesSearch,
    queryParameters: {'q': query, 'lang': ref.watch(appLangProvider)},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => _parsePlace(e as Map<String, dynamic>))
      .toList();
}
