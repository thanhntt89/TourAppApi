// lib/data/database/tables/sub_places_table.dart
import 'package:drift/drift.dart';

class SubPlacesTable extends Table {
  @override String get tableName => 'sub_places';
  IntColumn get id => integer()();
  TextColumn get subPlaceIndex => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get featureImage => text().nullable()(); // JSON
  TextColumn get audioUrl => text().nullable()();
  RealColumn get audioDuration => real().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  IntColumn get placeId => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}
