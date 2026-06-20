import 'package:drift/drift.dart';

import 'package:stoneecho/data/database/tables/places_table.dart';

class SubPlaces extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get placeId => integer().references(Places, #id)();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get contentEn => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get orderNum => integer().withDefault(const Constant(0))();
}
