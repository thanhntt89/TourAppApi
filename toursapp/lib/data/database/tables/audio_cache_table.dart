import 'package:drift/drift.dart';

import 'package:stoneecho/data/database/tables/places_table.dart';

class AudioCache extends Table {
  IntColumn get placeId => integer().references(Places, #id)();
  TextColumn get language => text()();
  TextColumn get audioUrl => text()();
  TextColumn get localPath => text()();
  IntColumn get fileSize => integer().withDefault(const Constant(0))();
  DateTimeColumn get downloadedAt => dateTime()();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {placeId, language};
}
