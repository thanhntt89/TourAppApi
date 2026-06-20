// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(journeys)
const journeysProvider = JourneysProvider._();

final class JourneysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Journey>>,
          List<Journey>,
          FutureOr<List<Journey>>
        >
    with $FutureModifier<List<Journey>>, $FutureProvider<List<Journey>> {
  const JourneysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeysHash();

  @$internal
  @override
  $FutureProviderElement<List<Journey>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Journey>> create(Ref ref) {
    return journeys(ref);
  }
}

String _$journeysHash() => r'e6cfaaa1f0386788d3ffa4b3794835f6fedb94b7';

@ProviderFor(journeyDetail)
const journeyDetailProvider = JourneyDetailFamily._();

final class JourneyDetailProvider
    extends $FunctionalProvider<AsyncValue<Journey>, Journey, FutureOr<Journey>>
    with $FutureModifier<Journey>, $FutureProvider<Journey> {
  const JourneyDetailProvider._({
    required JourneyDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'journeyDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$journeyDetailHash();

  @override
  String toString() {
    return r'journeyDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Journey> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Journey> create(Ref ref) {
    final argument = this.argument as int;
    return journeyDetail(ref, id: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JourneyDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$journeyDetailHash() => r'6fbf160f9c2f7ef31c7c225ea1399649d722f7ff';

final class JourneyDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Journey>, int> {
  const JourneyDetailFamily._()
    : super(
        retry: null,
        name: r'journeyDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JourneyDetailProvider call({required int id}) =>
      JourneyDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'journeyDetailProvider';
}

@ProviderFor(popularJourneys)
const popularJourneysProvider = PopularJourneysProvider._();

final class PopularJourneysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Journey>>,
          List<Journey>,
          FutureOr<List<Journey>>
        >
    with $FutureModifier<List<Journey>>, $FutureProvider<List<Journey>> {
  const PopularJourneysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularJourneysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularJourneysHash();

  @$internal
  @override
  $FutureProviderElement<List<Journey>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Journey>> create(Ref ref) {
    return popularJourneys(ref);
  }
}

String _$popularJourneysHash() => r'a013fafde46326a0136f83d2b33169557214296a';
