import 'package:drift/drift.dart';
import 'package:stoneecho/data/database/app_database.dart';
import 'package:stoneecho/data/database/tables/stories_table.dart';

part 'story_dao.g.dart';

@DriftAccessor(tables: [Stories])
class StoryDao extends DatabaseAccessor<AppDatabase> with _$StoryDaoMixin {
  StoryDao(super.attachedDatabase);

  Future<List<Story>> getAll() => select(stories).get();

  Future<Story?> getById(int id) =>
      (select(stories)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Stories don't have a direct placeId FK in the table, so this is a
  /// placeholder for a future junction-table query. Currently returns empty.
  Future<List<Story>> getByPlaceId(int placeId) async {
    // TODO(stories): implement when place-story relation table is added.
    return <Story>[];
  }

  Future<void> upsertAll(List<StoriesCompanion> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(stories, entries);
    });
  }
}
