// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceUuid)
const deviceUuidProvider = DeviceUuidProvider._();

final class DeviceUuidProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const DeviceUuidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceUuidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceUuidHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return deviceUuid(ref);
  }
}

String _$deviceUuidHash() => r'e3d50b0e3425e0b3cf1fa8c21307a13e9b26e0f3';
