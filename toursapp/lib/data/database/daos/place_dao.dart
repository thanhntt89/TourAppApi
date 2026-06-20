import 'dart:math';

import 'package:drift/drift.dart';
import 'package:stoneecho/data/database/app_database.dart';
import 'package:stoneecho/data/database/tables/places_table.dart';

part 'place_dao.g.dart';

@DriftAccessor(tables: [Places])
class PlaceDao extends DatabaseAccessor<AppDatabase> with _$PlaceDaoMixin {
  PlaceDao(super.attachedDatabase);

  Future<List<Place>> getByLocation(int locationId) =>
      (select(places)..where((t) => t.locationId.equals(locationId))).get();

  Future<Place?> getById(int id) =>
      (select(places)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Place?> getByQrCode(String code) =>
      (select(places)..where((t) => t.qrCode.equals(code))).getSingleOrNull();

  /// Returns places within [radiusKm] of the given coordinates.
  ///
  /// Uses a bounding-box pre-filter in SQL for efficiency, then refines
  /// with the Haversine formula in Dart.
  Future<List<Place>> getNearby(double lat, double lng, double radiusKm) async {
    final latDelta = radiusKm / 111.0;
    final lngDelta = radiusKm / (111.0 * cos(lat * pi / 180));

    final rows = await (select(places)
          ..where(
            (t) =>
                t.lat.isBetweenValues(lat - latDelta, lat + latDelta) &
                t.lng.isBetweenValues(lng - lngDelta, lng + lngDelta),
          ))
        .get();

    return rows.where((p) {
      final distance = _haversineKm(lat, lng, p.lat, p.lng);
      return distance <= radiusKm;
    }).toList();
  }

  Future<List<Place>> search(String query) {
    final pattern = '%$query%';
    return (select(places)
          ..where(
            (t) =>
                t.name.like(pattern) |
                t.nameEn.like(pattern) |
                t.description.like(pattern) |
                t.descriptionEn.like(pattern),
          ))
        .get();
  }

  Future<void> upsertAll(List<PlacesCompanion> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(places, entries);
    });
  }

  static double _haversineKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const r = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  static double _degToRad(double deg) => deg * (pi / 180);
}
