import 'package:drift/drift.dart';

import 'package:stoneecho/data/database/tables/provinces_table.dart';

class News extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get titleEn => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get contentEn => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('news'))();
  IntColumn get provinceId => integer().nullable().references(Provinces, #id)();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
