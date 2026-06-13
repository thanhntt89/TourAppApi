// lib/data/database/daos/place_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/places_table.dart';
import '../tables/sub_places_table.dart';
import '../tables/sub_items_table.dart';

part 'place_dao.g.dart';

@DriftAccessor(tables: [PlacesTable, SubPlacesTable, SubItemsTable])
class PlaceDao extends DatabaseAccessor<AppDatabase> with _$PlaceDaoMixin {
  PlaceDao(AppDatabase db) : super(db);

  /// Fetch all places in a province
  Future<List<PlaceData>> getPlaces(int provinceId) {
    return (select(placesTable)
          ..where((t) => t.provinceId.equals(provinceId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  /// Get single place
  Future<PlaceData?> getPlaceById(int id) {
    return (select(placesTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get sub-places for a place
  Future<List<SubPlaceData>> getSubPlaces(int placeId) {
    return (select(subPlacesTable)
          ..where((t) => t.placeId.equals(placeId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }
}
