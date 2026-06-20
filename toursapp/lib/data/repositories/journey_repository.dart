import 'package:stoneecho/data/models/journey.dart';
import 'package:stoneecho/data/models/journey_stop.dart';

class JourneyRepository {
  Future<List<Journey>> getAll() => throw UnimplementedError();

  Future<Journey?> getById(int id) => throw UnimplementedError();

  Future<List<JourneyStop>> getStops(int journeyId) => throw UnimplementedError();

  Future<List<Journey>> getPopular() => throw UnimplementedError();
}
