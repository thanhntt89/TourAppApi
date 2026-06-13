// lib/data/database/tables/locations_table.dart
import 'package:drift/drift.dart';

class LocationsTable extends Table {
  @override String get tableName => 'locations';
  IntColumn get id => integer()();
  IntColumn get locationNumber => integer().nullable()(); // 'location_number' in sync vs 'number' online
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get featureImage => text().nullable()(); // JSON
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  IntColumn get provinceId => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}
