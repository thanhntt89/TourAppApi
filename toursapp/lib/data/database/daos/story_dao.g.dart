// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_dao.dart';

// ignore_for_file: type=lint
mixin _$StoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $StoriesTable get stories => attachedDatabase.stories;
  StoryDaoManager get managers => StoryDaoManager(this);
}

class StoryDaoManager {
  final _$StoryDaoMixin _db;
  StoryDaoManager(this._db);
  $$StoriesTableTableManager get stories =>
      $$StoriesTableTableManager(_db.attachedDatabase, _db.stories);
}
