// lib/data/database/tables/news_table.dart
import 'package:drift/drift.dart';

class NewsTable extends Table {
  @override String get tableName => 'news';
  IntColumn get id => integer()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get content => text().nullable()();
  TextColumn get icon => text().nullable()();
  IntColumn get isPinned => integer().withDefault(const Constant(0))();
  TextColumn get startDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  TextColumn get createdAt => text()();
  IntColumn get provinceId => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}
