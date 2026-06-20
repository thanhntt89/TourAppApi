// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province_dao.dart';

// ignore_for_file: type=lint
mixin _$ProvinceDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProvincesTable get provinces => attachedDatabase.provinces;
  ProvinceDaoManager get managers => ProvinceDaoManager(this);
}

class ProvinceDaoManager {
  final _$ProvinceDaoMixin _db;
  ProvinceDaoManager(this._db);
  $$ProvincesTableTableManager get provinces =>
      $$ProvincesTableTableManager(_db.attachedDatabase, _db.provinces);
}
