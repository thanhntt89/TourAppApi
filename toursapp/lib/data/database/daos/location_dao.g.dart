// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_dao.dart';

// ignore_for_file: type=lint
mixin _$LocationDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProvincesTable get provinces => attachedDatabase.provinces;
  $LocationsTable get locations => attachedDatabase.locations;
  LocationDaoManager get managers => LocationDaoManager(this);
}

class LocationDaoManager {
  final _$LocationDaoMixin _db;
  LocationDaoManager(this._db);
  $$ProvincesTableTableManager get provinces =>
      $$ProvincesTableTableManager(_db.attachedDatabase, _db.provinces);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db.attachedDatabase, _db.locations);
}
