// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Provinces)
const provincesProvider = ProvincesProvider._();

final class ProvincesProvider
    extends $AsyncNotifierProvider<Provinces, List<Province>> {
  const ProvincesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'provincesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$provincesHash();

  @$internal
  @override
  Provinces create() => Provinces();
}

String _$provincesHash() => r'327132a69741a28e0630852568f36d30791ce695';

abstract class _$Provinces extends $AsyncNotifier<List<Province>> {
  FutureOr<List<Province>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Province>>, List<Province>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Province>>, List<Province>>,
              AsyncValue<List<Province>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CurrentProvince)
const currentProvinceProvider = CurrentProvinceProvider._();

final class CurrentProvinceProvider
    extends $NotifierProvider<CurrentProvince, Province?> {
  const CurrentProvinceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProvinceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProvinceHash();

  @$internal
  @override
  CurrentProvince create() => CurrentProvince();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Province? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Province?>(value),
    );
  }
}

String _$currentProvinceHash() => r'fd902e450ef0f021ee82b3c624c886562ea1761c';

abstract class _$CurrentProvince extends $Notifier<Province?> {
  Province? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Province?, Province?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Province?, Province?>,
              Province?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(provinceDetect)
const provinceDetectProvider = ProvinceDetectProvider._();

final class ProvinceDetectProvider
    extends
        $FunctionalProvider<
          AsyncValue<Province?>,
          Province?,
          FutureOr<Province?>
        >
    with $FutureModifier<Province?>, $FutureProvider<Province?> {
  const ProvinceDetectProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'provinceDetectProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$provinceDetectHash();

  @$internal
  @override
  $FutureProviderElement<Province?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Province?> create(Ref ref) {
    return provinceDetect(ref);
  }
}

String _$provinceDetectHash() => r'29443a040e602d591ce09d316a94424946c0694a';
