// lib/data/database/daos/province_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/provinces_table.dart';

part 'province_dao.g.dart';

@DriftAccessor(tables: [ProvincesTable])
class ProvinceDao extends DatabaseAccessor<AppDatabase> with _$ProvinceDaoMixin {
  ProvinceDao(AppDatabase db) : super(db);

  Future<List<ProvinceData>> getAllProvinces() => select(provincesTable).get();

  Future<ProvinceData?> getProvinceById(int id) {
    return (select(provincesTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
