import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/core/offline/offline_cache.dart';
import 'package:stoneecho/data/models/passport_data.dart';

// ─── Result wrappers ──────────────────────────────────────────────────────────
//
// isFromCache = true  → data came from local cache (offline mode)
// isFromCache = false → data came from the network (fresh)

class PassportResult {
  const PassportResult({required this.passport, required this.isFromCache});
  final PassportData passport;
  final bool isFromCache;
}

class UserJourneysResult {
  const UserJourneysResult({
    required this.journeys,
    required this.isFromCache,
  });
  final List<UserJourneyProgress> journeys;
  final bool isFromCache;
}

// ─── Providers ────────────────────────────────────────────────────────────────

final userPassportProvider =
    FutureProvider.autoDispose<PassportResult>((ref) async {
  const cacheKey = 'user_passport';
  final dio = ref.watch(dioProvider);

  try {
    final response =
        await dio.get<Map<String, dynamic>>(ApiConstants.userPassport);
    final data = response.data!['data'] as Map<String, dynamic>;
    await OfflineCache.save(cacheKey, data);
    return PassportResult(
      passport: PassportData.fromJson(data),
      isFromCache: false,
    );
  } catch (_) {
    final cached = await OfflineCache.load<PassportData>(
      cacheKey,
      (json) => PassportData.fromJson(json as Map<String, dynamic>),
    );
    if (cached != null) {
      return PassportResult(passport: cached, isFromCache: true);
    }
    rethrow;
  }
});

final userJourneysProvider =
    FutureProvider.autoDispose<UserJourneysResult>((ref) async {
  const cacheKey = 'user_journeys';
  final dio = ref.watch(dioProvider);

  try {
    final response =
        await dio.get<Map<String, dynamic>>(ApiConstants.userJourneys);
    final rawList = response.data!['data'] as List;
    final journeys = rawList
        .map((e) => UserJourneyProgress.fromJson(e as Map<String, dynamic>))
        .toList();
    await OfflineCache.save(cacheKey, response.data!['data']);
    return UserJourneysResult(journeys: journeys, isFromCache: false);
  } catch (_) {
    final cached = await OfflineCache.load<List<UserJourneyProgress>>(
      cacheKey,
      (json) => (json as List)
          .map((e) =>
              UserJourneyProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (cached != null) {
      return UserJourneysResult(journeys: cached, isFromCache: true);
    }
    rethrow;
  }
});
