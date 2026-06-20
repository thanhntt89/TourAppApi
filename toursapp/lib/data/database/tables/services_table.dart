import 'package:drift/drift.dart';

@DataClassName('ServiceEntry')
class Services extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get descriptionEn => text().nullable()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  RealColumn get rating => real().nullable()();
  TextColumn get priceRange => text().nullable()();
}
