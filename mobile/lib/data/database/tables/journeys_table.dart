// lib/data/database/tables/journeys_table.dart
import 'package:drift/drift.dart';

class JourneysTable extends Table {
  @override String get tableName => 'journeys';
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get featureImage => text().nullable()(); // JSON
  IntColumn get durationDays => integer().withDefault(const Constant(1))();
  TextColumn get difficulty => text().nullable()();
  TextColumn get stops => text().nullable()(); // JSON array of stop objects
  IntColumn get isFeatured => integer().withDefault(const Constant(0))();
  IntColumn get provinceId => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}
