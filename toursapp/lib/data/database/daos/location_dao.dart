import 'package:drift/drift.dart';
import 'package:stoneecho/data/database/app_database.dart';
import 'package:stoneecho/data/database/tables/locations_table.dart';

part 'location_dao.g.dart';

@DriftAccessor(tables: [Locations])
class LocationDao extends DatabaseAccessor<AppDatabase>
    with _$LocationDaoMixin {
  LocationDao(super.attachedDatabase);

  Future<List<Location>> getByProvince(int provinceId) =>
      (select(locations)
            ..where((t) => t.provinceId.equals(provinceId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderNum)]))
          .get();

  Future<Location?> getById(int id) =>
      (select(locations)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertAll(List<LocationsCompanion> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(locations, entries);
    });
  }
}
