import 'package:drift/drift.dart';

class Checkins extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get placeId => integer()();
  TextColumn get placeName => text()();
  TextColumn get method => text()();
  IntColumn get flowersEarned => integer().withDefault(const Constant(0))();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
}
