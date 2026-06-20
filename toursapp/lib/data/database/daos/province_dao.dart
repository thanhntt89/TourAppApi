import 'package:drift/drift.dart';
import 'package:stoneecho/data/database/app_database.dart';
import 'package:stoneecho/data/database/tables/provinces_table.dart';

part 'province_dao.g.dart';

@DriftAccessor(tables: [Provinces])
class ProvinceDao extends DatabaseAccessor<AppDatabase>
    with _$ProvinceDaoMixin {
  ProvinceDao(super.attachedDatabase);

  Future<List<Province>> getAll() => select(provinces).get();

  Future<Province?> getById(int id) =>
      (select(provinces)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Province>> getActive() =>
      (select(provinces)..where((t) => t.isActive.equals(true))).get();

  Future<void> upsertAll(List<ProvincesCompanion> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(provinces, entries);
    });
  }
}
