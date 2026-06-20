import 'package:stoneecho/data/models/checkin.dart';

class CheckinRepository {
  Future<Checkin> checkIn(int placeId, double lat, double lng) => throw UnimplementedError();

  Future<bool> hasCheckedIn(int placeId, String deviceUuid) => throw UnimplementedError();

  Future<List<Checkin>> getHistory(String deviceUuid) => throw UnimplementedError();
}
