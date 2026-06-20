import 'package:drift/drift.dart';

import 'package:stoneecho/data/database/tables/journeys_table.dart';
import 'package:stoneecho/data/database/tables/places_table.dart';

class JourneyStops extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get journeyId => integer().references(Journeys, #id)();
  IntColumn get placeId => integer().references(Places, #id)();
  IntColumn get orderNum => integer().withDefault(const Constant(0))();
  TextColumn get placeName => text().nullable()();
  TextColumn get placeImageUrl => text().nullable()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get distanceFromPrev => text().nullable()();
}
