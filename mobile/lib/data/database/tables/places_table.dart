// lib/data/database/tables/places_table.dart
// Mirrors /sync/package places schema (api-design.md §10.2)

import 'package:drift/drift.dart';

class PlacesTable extends Table {
  @override
  String get tableName => 'places';

  IntColumn get id => integer()();
  IntColumn get placeOrderNumber => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get information => text().nullable()(); // Note: 'information' in sync, 'info' in online API
  TextColumn get article => text().nullable()();
  TextColumn get featureImage => text().nullable()(); // JSON: {url, width, height}
  TextColumn get gallery => text().nullable()(); // JSON array
  TextColumn get audioUrl => text().nullable()();
  RealColumn get audioDuration => real().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get geofenceRadius => integer().withDefault(const Constant(300))();
  TextColumn get qrCode => text().nullable()();
  IntColumn get checkinReward => integer().withDefault(const Constant(10))();
  IntColumn get articleCost => integer().withDefault(const Constant(5))();
  IntColumn get showArticleFree => integer().withDefault(const Constant(1))(); // 0/1
  IntColumn get showAudioFree => integer().withDefault(const Constant(1))(); // 0/1
  IntColumn get isFeatured => integer().withDefault(const Constant(0))(); // 0/1
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get locationId => integer().nullable()();
  IntColumn get provinceId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
