// lib/data/database/app_database.dart
//
// Main Drift database — mirrors the /sync/package/{province_id} response schema.
// See: docs/api-design.md §10.2 SQLite Schema

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/provinces_table.dart';
import 'tables/locations_table.dart';
import 'tables/places_table.dart';
import 'tables/sub_places_table.dart';
import 'tables/sub_items_table.dart';
import 'tables/journeys_table.dart';
import 'tables/news_table.dart';
import 'tables/media_cache_table.dart';
import 'tables/sync_meta_table.dart';
import 'daos/province_dao.dart';
import 'daos/place_dao.dart';
import 'daos/sync_dao.dart';
import 'daos/media_cache_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    ProvincesTable,
    LocationsTable,
    PlacesTable,
    SubPlacesTable,
    SubItemsTable,
    JourneysTable,
    NewsTable,
    MediaCacheTable,
    SyncMetaTable,
  ],
  daos: [
    ProvinceDao,
    PlaceDao,
    SyncDao,
    MediaCacheDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations go here
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'toursapp.db'));
    return NativeDatabase.createInBackground(file);
  });
}
