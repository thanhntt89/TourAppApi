// lib/data/database/tables/sub_items_table.dart
import 'package:drift/drift.dart';

class SubItemsTable extends Table {
  @override String get tableName => 'sub_items';
  IntColumn get id => integer()();
  TextColumn get itemIndex => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get featureImage => text().nullable()(); // JSON
  TextColumn get gallery => text().nullable()(); // JSON array
  TextColumn get audioUrl => text().nullable()();
  IntColumn get subPlaceId => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}
