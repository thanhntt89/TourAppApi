// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks download progress for offline content packages.
/// Key = package identifier (e.g. "province_1"), value = progress 0.0..1.0.

@ProviderFor(DownloadProgress)
const downloadProgressProvider = DownloadProgressProvider._();

/// Tracks download progress for offline content packages.
/// Key = package identifier (e.g. "province_1"), value = progress 0.0..1.0.
final class DownloadProgressProvider
    extends $NotifierProvider<DownloadProgress, Map<String, double>> {
  /// Tracks download progress for offline content packages.
  /// Key = package identifier (e.g. "province_1"), value = progress 0.0..1.0.
  const DownloadProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadProgressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadProgressHash();

  @$internal
  @override
  DownloadProgress create() => DownloadProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, double>>(value),
    );
  }
}

String _$downloadProgressHash() => r'ce4150573c5674b13ca48d53470ce178f3ad6995';

/// Tracks download progress for offline content packages.
/// Key = package identifier (e.g. "province_1"), value = progress 0.0..1.0.

abstract class _$DownloadProgress extends $Notifier<Map<String, double>> {
  Map<String, double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, double>, Map<String, double>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, double>, Map<String, double>>,
              Map<String, double>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Manages offline content packages (province data, audio files, maps).

@ProviderFor(OfflinePackage)
const offlinePackageProvider = OfflinePackageProvider._();

/// Manages offline content packages (province data, audio files, maps).
final class OfflinePackageProvider
    extends $AsyncNotifierProvider<OfflinePackage, List<OfflinePackageInfo>> {
  /// Manages offline content packages (province data, audio files, maps).
  const OfflinePackageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlinePackageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlinePackageHash();

  @$internal
  @override
  OfflinePackage create() => OfflinePackage();
}

String _$offlinePackageHash() => r'02a7625f0082c0a95467dff44216237c7a2d4fcf';

/// Manages offline content packages (province data, audio files, maps).

abstract class _$OfflinePackage
    extends $AsyncNotifier<List<OfflinePackageInfo>> {
  FutureOr<List<OfflinePackageInfo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<OfflinePackageInfo>>,
              List<OfflinePackageInfo>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<OfflinePackageInfo>>,
                List<OfflinePackageInfo>
              >,
              AsyncValue<List<OfflinePackageInfo>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
