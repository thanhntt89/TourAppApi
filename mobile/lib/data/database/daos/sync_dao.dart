// lib/data/database/daos/sync_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sync_meta_table.dart';
import '../tables/provinces_table.dart';
import '../tables/locations_table.dart';
import '../tables/places_table.dart';
import '../tables/sub_places_table.dart';
import '../tables/sub_items_table.dart';
import '../tables/journeys_table.dart';
import '../tables/news_table.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [
  SyncMetaTable, ProvincesTable, LocationsTable, PlacesTable,
  SubPlacesTable, SubItemsTable, JourneysTable, NewsTable
])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(AppDatabase db) : super(db);

  Future<SyncMetaData?> getSyncMeta(int provinceId, String lang) {
    return (select(syncMetaTable)
          ..where((t) => t.provinceId.equals(provinceId) & t.lang.equals(lang)))
        .getSingleOrNull();
  }

  // Placeholder for the massive transaction that inserts a full sync package
  Future<void> insertSyncPackage(Map<String, dynamic> package) async {
    await transaction(() async {
      // Logic to parse and batch insert all tables will go here
    });
  }
}
