// lib/data/database/daos/media_cache_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/media_cache_table.dart';

part 'media_cache_dao.g.dart';

@DriftAccessor(tables: [MediaCacheTable])
class MediaCacheDao extends DatabaseAccessor<AppDatabase> with _$MediaCacheDaoMixin {
  MediaCacheDao(AppDatabase db) : super(db);

  Future<MediaCacheData?> getMediaByUrl(String url) {
    return (select(mediaCacheTable)..where((t) => t.url.equals(url))).getSingleOrNull();
  }

  Future<void> insertMedia(MediaCacheCompanion entry) {
    return into(mediaCacheTable).insertOnConflictUpdate(entry);
  }
}
