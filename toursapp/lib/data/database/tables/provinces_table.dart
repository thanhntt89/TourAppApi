import 'package:drift/drift.dart';

class Provinces extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get nameKo => text().nullable()();
  TextColumn get nameZh => text().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}
