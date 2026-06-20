import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/passport_data.dart';

final userPassportProvider = FutureProvider.autoDispose<PassportData>((ref) async {
  final dio = ref.watch(dioProvider);
  final response =
      await dio.get<Map<String, dynamic>>(ApiConstants.userPassport);
  final data = response.data!['data'] as Map<String, dynamic>;
  return PassportData.fromJson(data);
});

final userJourneysProvider =
    FutureProvider.autoDispose<List<UserJourneyProgress>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response =
      await dio.get<Map<String, dynamic>>(ApiConstants.userJourneys);
  final list = response.data!['data'] as List;
  return list
      .map((e) => UserJourneyProgress.fromJson(e as Map<String, dynamic>))
      .toList();
});
