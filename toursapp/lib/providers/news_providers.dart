import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/news_alert.dart';
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
