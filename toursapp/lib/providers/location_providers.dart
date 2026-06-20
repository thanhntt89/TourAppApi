import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/location.dart';
import 'package:stoneecho/providers/app_providers.dart';

part 'location_providers.g.dart';

// API returns 'latitude'/'longitude' and feature_image as {url,...} object.
// Parse manually to avoid needing build_runner for @JsonKey changes.
Location _parseLocation(Map<String, dynamic> json, int provinceId) {
  final img = json['feature_image'];
  final imageUrl = img is Map
      ? img['url'] as String?
      : img as String?;

  return Location(
    id: json['id'] as int,
    provinceId: provinceId,
    name: json['name'] as String,
    lat: (json['latitude'] as num).toDouble(),
    lng: (json['longitude'] as num).toDouble(),
    description: json['description'] as String?,
    imageUrl: imageUrl,
    orderNum: (json['sort_order'] as int?) ?? 0,
  );
}

@riverpod
Future<List<Location>> locations(Ref ref, {required int provinceId}) async {
  final dio = ref.watch(dioProvider);
  // API route: GET /provinces/{province_id}/locations (path param, not query)
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.provinces}/$provinceId/locations',
    queryParameters: {'lang': ref.watch(appLangProvider)},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => _parseLocation(e as Map<String, dynamic>, provinceId))
      .toList();
}

/// Featured locations for homepage — no @riverpod so no build_runner needed.
final featuredLocationsProvider = FutureProvider.family<List<Location>, int>((ref, provinceId) async {
  final dio = ref.watch(dioProvider);
  final lang = ref.watch(appLangProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.provinces}/$provinceId/locations',
    queryParameters: {'lang': lang, 'featured': 'true'},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => _parseLocation(e as Map<String, dynamic>, provinceId))
      .toList();
});

@riverpod
Future<Location> locationDetail(Ref ref, {required int id}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.locations}/$id',
  );
  final json = response.data!['data'] as Map<String, dynamic>;
  final provinceId =
      (json['province'] as Map<String, dynamic>?)?['id'] as int? ?? 0;
  return _parseLocation(json, provinceId);
}
