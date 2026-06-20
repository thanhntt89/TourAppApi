import 'package:drift/drift.dart';

class Journeys extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get nameKo => text().nullable()();
  TextColumn get nameZh => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get descriptionEn => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get totalDistance => text().nullable()();
  TextColumn get estimatedDays => text().nullable()();
  TextColumn get difficulty => text().nullable()();
  BoolColumn get isPopular => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}
