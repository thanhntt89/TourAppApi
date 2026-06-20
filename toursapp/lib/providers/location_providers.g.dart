// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locations)
const locationsProvider = LocationsFamily._();

final class LocationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Location>>,
          List<Location>,
          FutureOr<List<Location>>
        >
    with $FutureModifier<List<Location>>, $FutureProvider<List<Location>> {
  const LocationsProvider._({
    required LocationsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'locationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$locationsHash();

  @override
  String toString() {
    return r'locationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Location>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Location>> create(Ref ref) {
    final argument = this.argument as int;
    return locations(ref, provinceId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$locationsHash() => r'ef61f5ac525b0666610374022792d8a741bba6ca';

final class LocationsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Location>>, int> {
  const LocationsFamily._()
    : super(
        retry: null,
        name: r'locationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LocationsProvider call({required int provinceId}) =>
      LocationsProvider._(argument: provinceId, from: this);

  @override
  String toString() => r'locationsProvider';
}

@ProviderFor(locationDetail)
const locationDetailProvider = LocationDetailFamily._();

final class LocationDetailProvider
    extends
        $FunctionalProvider<AsyncValue<Location>, Location, FutureOr<Location>>
    with $FutureModifier<Location>, $FutureProvider<Location> {
  const LocationDetailProvider._({
    required LocationDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'locationDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$locationDetailHash();

  @override
  String toString() {
    return r'locationDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Location> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Location> create(Ref ref) {
    final argument = this.argument as int;
    return locationDetail(ref, id: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$locationDetailHash() => r'6b18ab65668c6318b86db0438182ed1ad700dde3';

final class LocationDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Location>, int> {
  const LocationDetailFamily._()
    : super(
        retry: null,
        name: r'locationDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LocationDetailProvider call({required int id}) =>
      LocationDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'locationDetailProvider';
}
