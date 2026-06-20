import 'package:drift/drift.dart';

class Wallet extends Table {
  TextColumn get deviceUuid => text()();
  IntColumn get balance => integer().withDefault(const Constant(0))();
  IntColumn get totalEarned => integer().withDefault(const Constant(0))();
  IntColumn get totalSpent => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {deviceUuid};
}
