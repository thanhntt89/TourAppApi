import 'package:stoneecho/data/models/place.dart';

class PlaceRepository {
  Future<List<Place>> getByLocation(int locationId) => throw UnimplementedError();

  Future<Place?> getById(int id) => throw UnimplementedError();

  Future<List<Place>> getNearby(double lat, double lng, {double radiusKm = 10}) =>
      throw UnimplementedError();

  Future<Place?> getByQrCode(String code) => throw UnimplementedError();

  Future<List<Place>> search(String query) => throw UnimplementedError();
}
