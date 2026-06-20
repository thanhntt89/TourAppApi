import 'package:drift/drift.dart';

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get endpoint => text()();
  TextColumn get method => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  IntColumn get retriesLeft => integer().withDefault(const Constant(3))();
}
