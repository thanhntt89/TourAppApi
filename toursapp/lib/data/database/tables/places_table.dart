import 'package:drift/drift.dart';

import 'package:stoneecho/data/database/tables/locations_table.dart';

class Places extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get locationId => integer().references(Locations, #id)();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get nameKo => text().nullable()();
  TextColumn get nameZh => text().nullable()();
  TextColumn get slug => text()();
  TextColumn get description => text().nullable()();
  TextColumn get descriptionEn => text().nullable()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get audioUrlVi => text().nullable()();
  TextColumn get audioUrlEn => text().nullable()();
  TextColumn get audioUrlKo => text().nullable()();
  TextColumn get audioUrlZh => text().nullable()();
  IntColumn get audioDuration => integer().withDefault(const Constant(0))();
  TextColumn get category => text().nullable()();
  TextColumn get difficulty => text().nullable()();
  IntColumn get flowerCost => integer().withDefault(const Constant(5))();
  TextColumn get qrCode => text().nullable()();
  TextColumn get status => text().nullable()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}
