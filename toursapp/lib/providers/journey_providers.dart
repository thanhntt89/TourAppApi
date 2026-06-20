import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/journey.dart';

part 'journey_providers.g.dart';

@riverpod
Future<List<Journey>> journeys(Ref ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(ApiConstants.journeys);
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => Journey.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
Future<Journey> journeyDetail(Ref ref, {required int id}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.journeys}/$id',
  );
  final data = response.data!;
  return Journey.fromJson(data['data'] as Map<String, dynamic>);
}

@riverpod
Future<List<Journey>> popularJourneys(Ref ref) async {
  final allJourneys = await ref.watch(journeysProvider.future);
  return allJourneys.where((j) => j.isPopular).toList();
}
