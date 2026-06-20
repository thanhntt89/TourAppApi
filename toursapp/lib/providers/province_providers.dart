import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/core/utils/haversine.dart';
import 'package:stoneecho/data/models/province.dart';
import 'package:stoneecho/providers/app_providers.dart';
import 'package:stoneecho/providers/gps_providers.dart';

part 'province_providers.g.dart';

const _currentProvinceIdKey = 'current_province_id';

@riverpod
class Provinces extends _$Provinces {
  @override
  Future<List<Province>> build() => _fetchFromApi();

  Future<List<Province>> _fetchFromApi() async {
    final dio = ref.read(dioProvider);
    final response = await dio.get<Map<String, dynamic>>(ApiConstants.provinces);
    final data = response.data!;
    return (data['data'] as List)
        .map((e) => Province.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchFromApi);
  }
}

@riverpod
class CurrentProvince extends _$CurrentProvince {
  @override
  Province? build() {
    unawaited(_loadFromPrefs());
    return null;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final savedId = prefs.getInt(_currentProvinceIdKey);
    if (savedId != null) {
      final provinces = await ref.read(provincesProvider.future);
      final match = provinces.where((p) => p.id == savedId).firstOrNull;
      if (match != null) {
        state = match;
      }
    }
  }

  Future<void> select(Province province) async {
    state = province;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt(_currentProvinceIdKey, province.id);
  }

  void clear() {
    state = null;
  }
}

@riverpod
Future<Province?> provinceDetect(Ref ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  final provinces = await ref.watch(provincesProvider.future);

  if (provinces.isEmpty) return null;

  Province? nearest;
  var minDistance = double.infinity;

  for (final province in provinces) {
    final distance = Haversine.distanceKm(
      position.latitude,
      position.longitude,
      province.lat,
      province.lng,
    );
    if (distance < minDistance) {
      minDistance = distance;
      nearest = province;
    }
  }

  return nearest;
}
