import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/data/database/app_database.dart';
import 'package:stoneecho/data/models/journey.dart' as domain;
import 'package:stoneecho/data/models/journey_stop.dart' as domain;

// ─── Result wrapper ────────────────────────────────────────────────────────────
//
// Every repository returns a typed Result so callers know whether
// data came from the network or local cache. Use isFromCache to
// show an offline banner in the UI.

class JourneyResult {
  const JourneyResult({required this.journeys, required this.isFromCache});
  final List<domain.Journey> journeys;
  final bool isFromCache;
}

// ─── Repository ───────────────────────────────────────────────────────────────
//
// Offline-first strategy for the journey CATALOG (/journeys endpoint).
// This is the pattern to follow for all content repositories.
//
//   Online  → API → upsert Drift → return fresh (isFromCache: false)
//   Offline → read Drift → return stale (isFromCache: true)
//   Online but API fails → fallback to Drift cache

class JourneyRepository {
  JourneyRepository({required this.dio, required this.db});

  final Dio dio;
  final AppDatabase db;

  Future<JourneyResult> getAll() async {
    if (await _isOnline()) {
      try {
        final journeys = await _fetchFromApi();
        await _saveToDb(journeys);
        return JourneyResult(journeys: journeys, isFromCache: false);
      } catch (_) {
        // Network available but API failed — fall through to cache
      }
    }

    final cached = await _loadFromDb();
    return JourneyResult(journeys: cached, isFromCache: true);
  }

  // ── API layer ─────────────────────────────────────────────────────────────

  Future<List<domain.Journey>> _fetchFromApi() async {
    final response =
        await dio.get<Map<String, dynamic>>(ApiConstants.journeys);
    final list = response.data!['data'] as List;
    return list
        .map((e) => domain.Journey.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Local cache (Drift) ───────────────────────────────────────────────────

  Future<List<domain.Journey>> _loadFromDb() async {
    final rows = await db.journeyDao.getAll();
    final result = <domain.Journey>[];
    for (final row in rows) {
      final stopRows = await db.journeyDao.getStops(row.id);
      result.add(_toDomain(row, stopRows));
    }
    return result;
  }

  Future<void> _saveToDb(List<domain.Journey> journeys) async {
    await db.journeyDao.upsertAll(
      journeys.map(_toJourneyCompanion).toList(),
    );
    final stops =
        journeys.expand((j) => j.stops.map(_toStopCompanion)).toList();
    if (stops.isNotEmpty) {
      await db.journeyDao.upsertStops(stops);
    }
  }

  // ── Mappers ───────────────────────────────────────────────────────────────

  // Drift row → domain model
  domain.Journey _toDomain(Journey row, List<JourneyStop> stopRows) {
    return domain.Journey(
      id: row.id,
      name: row.name,
      nameEn: row.nameEn,
      nameKo: row.nameKo,
      nameZh: row.nameZh,
      description: row.description,
      descriptionEn: row.descriptionEn,
      imageUrl: row.imageUrl,
      totalDistance: row.totalDistance,
      estimatedDays: row.estimatedDays,
      difficulty: row.difficulty,
      isPopular: row.isPopular,
      stops: stopRows.map(_toStopDomain).toList(),
    );
  }

  domain.JourneyStop _toStopDomain(JourneyStop row) {
    return domain.JourneyStop(
      id: row.id,
      journeyId: row.journeyId,
      placeId: row.placeId,
      orderNum: row.orderNum,
      placeName: row.placeName,
      placeImageUrl: row.placeImageUrl,
      lat: row.lat,
      lng: row.lng,
      distanceFromPrev: row.distanceFromPrev,
    );
  }

  // Domain model → Drift companion
  JourneysCompanion _toJourneyCompanion(domain.Journey j) {
    return JourneysCompanion(
      id: Value(j.id),
      name: Value(j.name),
      nameEn: Value(j.nameEn),
      nameKo: Value(j.nameKo),
      nameZh: Value(j.nameZh),
      description: Value(j.description),
      descriptionEn: Value(j.descriptionEn),
      imageUrl: Value(j.imageUrl),
      totalDistance: Value(j.totalDistance),
      estimatedDays: Value(j.estimatedDays),
      difficulty: Value(j.difficulty),
      isPopular: Value(j.isPopular),
      lastSyncedAt: Value(DateTime.now()),
    );
  }

  JourneyStopsCompanion _toStopCompanion(domain.JourneyStop s) {
    return JourneyStopsCompanion(
      id: Value(s.id),
      journeyId: Value(s.journeyId),
      placeId: Value(s.placeId),
      orderNum: Value(s.orderNum),
      placeName: Value(s.placeName),
      placeImageUrl: Value(s.placeImageUrl),
      lat: Value(s.lat),
      lng: Value(s.lng),
      distanceFromPrev: Value(s.distanceFromPrev),
    );
  }

  // ── Connectivity ──────────────────────────────────────────────────────────

  Future<bool> _isOnline() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}
