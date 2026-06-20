// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(places)
const placesProvider = PlacesFamily._();

final class PlacesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Place>>,
          List<Place>,
          FutureOr<List<Place>>
        >
    with $FutureModifier<List<Place>>, $FutureProvider<List<Place>> {
  const PlacesProvider._({
    required PlacesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'placesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$placesHash();

  @override
  String toString() {
    return r'placesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Place>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Place>> create(Ref ref) {
    final argument = this.argument as int;
    return places(ref, locationId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlacesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$placesHash() => r'be31fef298b46c9f93ce55d4ca917bd7fc0e56d9';

final class PlacesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Place>>, int> {
  const PlacesFamily._()
    : super(
        retry: null,
        name: r'placesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlacesProvider call({required int locationId}) =>
      PlacesProvider._(argument: locationId, from: this);

  @override
  String toString() => r'placesProvider';
}

@ProviderFor(placeDetail)
const placeDetailProvider = PlaceDetailFamily._();

final class PlaceDetailProvider
    extends $FunctionalProvider<AsyncValue<Place>, Place, FutureOr<Place>>
    with $FutureModifier<Place>, $FutureProvider<Place> {
  const PlaceDetailProvider._({
    required PlaceDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'placeDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$placeDetailHash();

  @override
  String toString() {
    return r'placeDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Place> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Place> create(Ref ref) {
    final argument = this.argument as int;
    return placeDetail(ref, id: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$placeDetailHash() => r'c2f292f65a2bfca4a3601765ee65ae689708cbc0';

final class PlaceDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Place>, int> {
  const PlaceDetailFamily._()
    : super(
        retry: null,
        name: r'placeDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlaceDetailProvider call({required int id}) =>
      PlaceDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'placeDetailProvider';
}

@ProviderFor(nearbyPlaces)
const nearbyPlacesProvider = NearbyPlacesProvider._();

final class NearbyPlacesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Place>>,
          List<Place>,
          FutureOr<List<Place>>
        >
    with $FutureModifier<List<Place>>, $FutureProvider<List<Place>> {
  const NearbyPlacesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbyPlacesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbyPlacesHash();

  @$internal
  @override
  $FutureProviderElement<List<Place>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Place>> create(Ref ref) {
    return nearbyPlaces(ref);
  }
}

String _$nearbyPlacesHash() => r'daffc91cd96704dae18025660241ade5348eeb90';

@ProviderFor(placeSearch)
const placeSearchProvider = PlaceSearchFamily._();

final class PlaceSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Place>>,
          List<Place>,
          FutureOr<List<Place>>
        >
    with $FutureModifier<List<Place>>, $FutureProvider<List<Place>> {
  const PlaceSearchProvider._({
    required PlaceSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'placeSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$placeSearchHash();

  @override
  String toString() {
    return r'placeSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Place>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Place>> create(Ref ref) {
    final argument = this.argument as String;
    return placeSearch(ref, query: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$placeSearchHash() => r'06c96346e6e33c9da17bb95099686a29b51a99a5';

final class PlaceSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Place>>, String> {
  const PlaceSearchFamily._()
    : super(
        retry: null,
        name: r'placeSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlaceSearchProvider call({required String query}) =>
      PlaceSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'placeSearchProvider';
}
