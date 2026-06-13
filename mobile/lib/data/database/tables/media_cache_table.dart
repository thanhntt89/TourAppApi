// lib/data/database/tables/media_cache_table.dart
import 'package:drift/drift.dart';

class MediaCacheTable extends Table {
  @override String get tableName => 'media_cache';
  TextColumn get url => text()();         // Primary key — unique URL
  TextColumn get localPath => text()();   // Absolute path on device
  TextColumn get type => text()();        // 'image' | 'audio'
  TextColumn get relatedType => text().nullable()(); // 'place' | 'sub_place' | 'sub_item'
  IntColumn get relatedId => integer().nullable()();
  IntColumn get sizeBytes => integer().nullable()();
  TextColumn get checksum => text().nullable()();
  TextColumn get downloadedAt => text()();
  @override Set<Column> get primaryKey => {url};
}
