import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/news_alert.dart';
import 'package:stoneecho/providers/app_providers.dart';
import 'package:stoneecho/providers/province_providers.dart';

part 'news_providers.g.dart';

/// News items for the currently selected province.
@riverpod
Future<List<NewsAlert>> news(Ref ref) async {
  final currentProvince = ref.watch(currentProvinceProvider);
  if (currentProvince == null) return [];

  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.news,
    queryParameters: {'province_id': currentProvince.id},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => NewsAlert.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Pinned news for a province (used by AlertTicker on home).
/// API: GET /news?province_id=X&pinned=true — already filtered by active date range server-side.
final pinnedNewsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, provinceId) async {
  final dio = ref.watch(dioProvider);
  final lang = ref.watch(appLangProvider);

  try {
    final response = await dio.get<Map<String, dynamic>>(
      ApiConstants.news,
      queryParameters: {
        'province_id': provinceId,
        'pinned': true,
        'lang': lang,
        'per_page': 20,
      },
    );
    final data = response.data!;
    return ((data['data'] as List?) ?? [])
        .map((e) => e as Map<String, dynamic>)
        .toList();
  } catch (_) {
    return [];
  }
});
