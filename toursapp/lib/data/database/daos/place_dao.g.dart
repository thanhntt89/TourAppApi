// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_dao.dart';

// ignore_for_file: type=lint
mixin _$PlaceDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProvincesTable get provinces => attachedDatabase.provinces;
  $LocationsTable get locations => attachedDatabase.locations;
  $PlacesTable get places => attachedDatabase.places;
  PlaceDaoManager get managers => PlaceDaoManager(this);
}

class PlaceDaoManager {
  final _$PlaceDaoMixin _db;
  PlaceDaoManager(this._db);
  $$ProvincesTableTableManager get provinces =>
      $$ProvincesTableTableManager(_db.attachedDatabase, _db.provinces);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db.attachedDatabase, _db.locations);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db.attachedDatabase, _db.places);
}
