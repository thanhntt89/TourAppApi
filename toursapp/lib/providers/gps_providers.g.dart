// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of the user's current GPS position.
/// Updates based on AppConstants.gpsDistanceFilterBrowse.

@ProviderFor(currentPosition)
const currentPositionProvider = CurrentPositionProvider._();

/// Stream of the user's current GPS position.
/// Updates based on AppConstants.gpsDistanceFilterBrowse.

final class CurrentPositionProvider
    extends
        $FunctionalProvider<AsyncValue<Position>, Position, Stream<Position>>
    with $FutureModifier<Position>, $StreamProvider<Position> {
  /// Stream of the user's current GPS position.
  /// Updates based on AppConstants.gpsDistanceFilterBrowse.
  const CurrentPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPositionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPositionHash();

  @$internal
  @override
  $StreamProviderElement<Position> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Position> create(Ref ref) {
    return currentPosition(ref);
  }
}

String _$currentPositionHash() => r'01aae52aa8126688c0071e85b1af3a1689ad1b69';

/// Current GPS permission status.

@ProviderFor(gpsPermission)
const gpsPermissionProvider = GpsPermissionProvider._();

/// Current GPS permission status.

final class GpsPermissionProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocationPermission>,
          LocationPermission,
          FutureOr<LocationPermission>
        >
    with
        $FutureModifier<LocationPermission>,
        $FutureProvider<LocationPermission> {
  /// Current GPS permission status.
  const GpsPermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsPermissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsPermissionHash();

  @$internal
  @override
  $FutureProviderElement<LocationPermission> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocationPermission> create(Ref ref) {
    return gpsPermission(ref);
  }
}

String _$gpsPermissionHash() => r'fe68b6f2397076f5816ed637fd813e9f7dafb365';

/// Request GPS permission from the user.

@ProviderFor(requestGpsPermission)
const requestGpsPermissionProvider = RequestGpsPermissionProvider._();

/// Request GPS permission from the user.

final class RequestGpsPermissionProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocationPermission>,
          LocationPermission,
          FutureOr<LocationPermission>
        >
    with
        $FutureModifier<LocationPermission>,
        $FutureProvider<LocationPermission> {
  /// Request GPS permission from the user.
  const RequestGpsPermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestGpsPermissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestGpsPermissionHash();

  @$internal
  @override
  $FutureProviderElement<LocationPermission> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocationPermission> create(Ref ref) {
    return requestGpsPermission(ref);
  }
}

String _$requestGpsPermissionHash() =>
    r'fb6893c3867b780b121758959dcfc88d9fc2fdb5';

/// Detects nearby places using the API, sorted by distance from current position.

@ProviderFor(nearbyDetection)
const nearbyDetectionProvider = NearbyDetectionProvider._();

/// Detects nearby places using the API, sorted by distance from current position.

final class NearbyDetectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NearbyPlace>>,
          List<NearbyPlace>,
          FutureOr<List<NearbyPlace>>
        >
    with
        $FutureModifier<List<NearbyPlace>>,
        $FutureProvider<List<NearbyPlace>> {
  /// Detects nearby places using the API, sorted by distance from current position.
  const NearbyDetectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbyDetectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbyDetectionHash();

  @$internal
  @override
  $FutureProviderElement<List<NearbyPlace>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NearbyPlace>> create(Ref ref) {
    return nearbyDetection(ref);
  }
}

String _$nearbyDetectionHash() => r'eab163239c64e40e03797708cc8d7f2a04f62ef4';
