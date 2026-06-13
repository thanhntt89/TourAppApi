// lib/data/database/tables/provinces_table.dart
import 'package:drift/drift.dart';

class ProvincesTable extends Table {
  @override String get tableName => 'provinces';
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get featureImage => text().nullable()(); // JSON
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  @override Set<Column> get primaryKey => {id};
}
