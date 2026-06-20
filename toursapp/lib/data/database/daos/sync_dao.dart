import 'package:drift/drift.dart';
import 'package:stoneecho/data/database/app_database.dart';
import 'package:stoneecho/data/database/tables/sync_queue_table.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.attachedDatabase);

  Future<List<SyncQueueData>> getPending() =>
      (select(syncQueue)..where((t) => t.status.equals('pending'))).get();

  Future<void> markSynced(int id) =>
      (update(syncQueue)..where((t) => t.id.equals(id)))
          .write(const SyncQueueCompanion(status: Value('synced')));

  Future<void> markFailed(int id) async {
    final row = await (select(syncQueue)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;

    final newRetries = row.retriesLeft - 1;
    final newStatus = newRetries <= 0 ? 'failed' : 'pending';

    await (update(syncQueue)..where((t) => t.id.equals(id))).write(
      SyncQueueCompanion(
        status: Value(newStatus),
        retriesLeft: Value(newRetries),
      ),
    );
  }

  Future<void> addToQueue(
    String endpoint,
    String method,
    String payload,
  ) async {
    await into(syncQueue).insert(
      SyncQueueCompanion.insert(
        endpoint: endpoint,
        method: method,
        payload: payload,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<int> clearSynced() =>
      (delete(syncQueue)..where((t) => t.status.equals('synced'))).go();
}
