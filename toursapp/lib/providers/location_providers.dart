import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/location.dart';

part 'location_providers.g.dart';

@riverpod
Future<List<Location>> locations(Ref ref, {required int provinceId}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    ApiConstants.locations,
    queryParameters: {'province_id': provinceId},
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => Location.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
Future<Location> locationDetail(Ref ref, {required int id}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.locations}/$id',
  );
  final data = response.data!;
  return Location.fromJson(data['data'] as Map<String, dynamic>);
}
