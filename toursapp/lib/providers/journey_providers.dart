import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/database/database_provider.dart';
import 'package:stoneecho/data/repositories/journey_repository.dart';

export 'package:stoneecho/data/repositories/journey_repository.dart'
    show JourneyResult;

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  return JourneyRepository(
    dio: ref.read(dioProvider),
    db: ref.read(appDatabaseProvider),
  );
});

/// Journey catalog with offline fallback.
/// Check result.isFromCache to decide whether to show the offline banner.
final journeysProvider = FutureProvider.autoDispose<JourneyResult>((ref) {
  return ref.watch(journeyRepositoryProvider).getAll();
});

/// Convenience provider — filters popular journeys from the cached catalog.
final popularJourneysProvider =
    FutureProvider.autoDispose<JourneyResult>((ref) async {
  final result = await ref.watch(journeysProvider.future);
  return JourneyResult(
    journeys: result.journeys.where((j) => j.isPopular).toList(),
    isFromCache: result.isFromCache,
  );
});
