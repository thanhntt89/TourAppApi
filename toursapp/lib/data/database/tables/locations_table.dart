import 'package:drift/drift.dart';

import 'package:stoneecho/data/database/tables/provinces_table.dart';

class Locations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get provinceId => integer().references(Provinces, #id)();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get nameKo => text().nullable()();
  TextColumn get nameZh => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get orderNum => integer().withDefault(const Constant(0))();
  TextColumn get imageUrl => text().nullable()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}
