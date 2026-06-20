import 'package:drift/drift.dart';
import 'package:stoneecho/data/database/app_database.dart';
import 'package:stoneecho/data/database/tables/journey_stops_table.dart';
import 'package:stoneecho/data/database/tables/journeys_table.dart';

part 'journey_dao.g.dart';

@DriftAccessor(tables: [Journeys, JourneyStops])
class JourneyDao extends DatabaseAccessor<AppDatabase>
    with _$JourneyDaoMixin {
  JourneyDao(super.attachedDatabase);

  Future<List<Journey>> getAll() => select(journeys).get();

  Future<Journey?> getById(int id) =>
      (select(journeys)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Journey>> getPopular() =>
      (select(journeys)..where((t) => t.isPopular.equals(true))).get();

  Future<List<JourneyStop>> getStops(int journeyId) =>
      (select(journeyStops)
            ..where((t) => t.journeyId.equals(journeyId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderNum)]))
          .get();

  Future<void> upsertAll(List<JourneysCompanion> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(journeys, entries);
    });
  }

  Future<void> upsertStops(List<JourneyStopsCompanion> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(journeyStops, entries);
    });
  }
}
