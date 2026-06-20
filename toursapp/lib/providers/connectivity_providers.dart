import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_providers.g.dart';

/// Stream-based connectivity provider.
/// Emits `true` when online, `false` when offline.
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) {
  final connectivity = Connectivity();

  return connectivity.onConnectivityChanged.map((results) {
    return results.any((r) => r != ConnectivityResult.none);
  });
}
