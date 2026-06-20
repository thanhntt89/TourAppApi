import 'package:drift/drift.dart';

class Stories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get titleEn => text().nullable()();
  TextColumn get titleKo => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get contentEn => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get readTimeMinutes => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}
