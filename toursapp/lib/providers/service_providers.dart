import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/service_provider.dart';

part 'service_providers.g.dart';

/// Services, optionally filtered by category.
/// When [category] is null, returns all services.
@riverpod
Future<List<ServiceProvider>> services(Ref ref, {String? category}) async {
  final dio = ref.watch(dioProvider);

  final queryParams = <String, dynamic>{};
  if (category != null) {
    queryParams['category'] = category;
  }

  final response = await dio.get<Map<String, dynamic>>(
    '/services',
    queryParameters: queryParams,
  );
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => ServiceProvider.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
Future<ServiceProvider> serviceDetail(Ref ref, {required int id}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>('/services/$id');
  final data = response.data!;
  return ServiceProvider.fromJson(data['data'] as Map<String, dynamic>);
}
