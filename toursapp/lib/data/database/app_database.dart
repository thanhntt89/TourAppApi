import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:stoneecho/data/database/daos/journey_dao.dart';
import 'package:stoneecho/data/database/daos/location_dao.dart';
import 'package:stoneecho/data/database/daos/place_dao.dart';
import 'package:stoneecho/data/database/daos/province_dao.dart';
import 'package:stoneecho/data/database/daos/story_dao.dart';
import 'package:stoneecho/data/database/daos/sync_dao.dart';
import 'package:stoneecho/data/database/tables/audio_cache_table.dart';
import 'package:stoneecho/data/database/tables/checkins_table.dart';
import 'package:stoneecho/data/database/tables/journey_stops_table.dart';
import 'package:stoneecho/data/database/tables/journeys_table.dart';
import 'package:stoneecho/data/database/tables/locations_table.dart';
import 'package:stoneecho/data/database/tables/news_table.dart';
import 'package:stoneecho/data/database/tables/places_table.dart';
import 'package:stoneecho/data/database/tables/provinces_table.dart';
import 'package:stoneecho/data/database/tables/services_table.dart';
import 'package:stoneecho/data/database/tables/stories_table.dart';
import 'package:stoneecho/data/database/tables/sub_places_table.dart';
import 'package:stoneecho/data/database/tables/sync_queue_table.dart';
import 'package:stoneecho/data/database/tables/wallet_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Provinces,
    Locations,
    Places,
    SubPlaces,
    Journeys,
    JourneyStops,
    Stories,
    News,
    Services,
    AudioCache,
    Wallet,
    Checkins,
    SyncQueue,
  ],
  daos: [
    ProvinceDao,
    LocationDao,
    PlaceDao,
    JourneyDao,
    StoryDao,
    SyncDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for testing with an in-memory database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // Future migrations go here.
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'toursapp.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
