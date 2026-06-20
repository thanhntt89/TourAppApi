import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Thin wrapper around connectivity_plus used by repositories.
class ConnectivityService {
  const ConnectivityService();

  Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  Stream<bool> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged.map(
            (results) => results.any((r) => r != ConnectivityResult.none),
          );
}

@riverpod
Stream<bool> connectivityStream(Ref ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    return results.any(
      (r) => r != ConnectivityResult.none,
    );
  });
}

@riverpod
Future<bool> isOnline(Ref ref) async {
  final results = await Connectivity().checkConnectivity();
  return results.any((r) => r != ConnectivityResult.none);
}
