// lib/data/database/tables/sync_meta_table.dart
import 'package:drift/drift.dart';

class SyncMetaTable extends Table {
  @override String get tableName => 'sync_meta';
  IntColumn get provinceId => integer()(); // Primary key
  TextColumn get lang => text()();
  TextColumn get syncedAt => text()(); // ISO 8601
  IntColumn get syncVersion => integer()();

  @override Set<Column> get primaryKey => {provinceId};
}
