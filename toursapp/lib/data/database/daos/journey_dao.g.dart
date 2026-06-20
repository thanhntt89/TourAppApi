// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_dao.dart';

// ignore_for_file: type=lint
mixin _$JourneyDaoMixin on DatabaseAccessor<AppDatabase> {
  $JourneysTable get journeys => attachedDatabase.journeys;
  $ProvincesTable get provinces => attachedDatabase.provinces;
  $LocationsTable get locations => attachedDatabase.locations;
  $PlacesTable get places => attachedDatabase.places;
  $JourneyStopsTable get journeyStops => attachedDatabase.journeyStops;
  JourneyDaoManager get managers => JourneyDaoManager(this);
}

class JourneyDaoManager {
  final _$JourneyDaoMixin _db;
  JourneyDaoManager(this._db);
  $$JourneysTableTableManager get journeys =>
      $$JourneysTableTableManager(_db.attachedDatabase, _db.journeys);
  $$ProvincesTableTableManager get provinces =>
      $$ProvincesTableTableManager(_db.attachedDatabase, _db.provinces);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db.attachedDatabase, _db.locations);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db.attachedDatabase, _db.places);
  $$JourneyStopsTableTableManager get journeyStops =>
      $$JourneyStopsTableTableManager(_db.attachedDatabase, _db.journeyStops);
}
