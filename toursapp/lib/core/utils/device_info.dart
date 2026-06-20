import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'device_info.g.dart';

const _deviceUuidKey = 'device_uuid';

@riverpod
Future<String> deviceUuid(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  var uuid = prefs.getString(_deviceUuidKey);
  if (uuid == null) {
    uuid = const Uuid().v4();
    await prefs.setString(_deviceUuidKey, uuid);
  }
  return uuid;
}

String shortDeviceId(String uuid) {
  return uuid.substring(0, 4).toUpperCase();
}
