// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WalletNotifier)
const walletProvider = WalletNotifierProvider._();

final class WalletNotifierProvider
    extends $AsyncNotifierProvider<WalletNotifier, WalletState> {
  const WalletNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletNotifierHash();

  @$internal
  @override
  WalletNotifier create() => WalletNotifier();
}

String _$walletNotifierHash() => r'8d0d31edbd87e96401e96adda5c984b1c28e5f2b';

abstract class _$WalletNotifier extends $AsyncNotifier<WalletState> {
  FutureOr<WalletState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<WalletState>, WalletState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WalletState>, WalletState>,
              AsyncValue<WalletState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Unlock premium content (audio, story, etc.) by spending flowers.

@ProviderFor(unlockContent)
const unlockContentProvider = UnlockContentFamily._();

/// Unlock premium content (audio, story, etc.) by spending flowers.

final class UnlockContentProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Unlock premium content (audio, story, etc.) by spending flowers.
  const UnlockContentProvider._({
    required UnlockContentFamily super.from,
    required ({String type, int id}) super.argument,
  }) : super(
         retry: null,
         name: r'unlockContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unlockContentHash();

  @override
  String toString() {
    return r'unlockContentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({String type, int id});
    return unlockContent(ref, type: argument.type, id: argument.id);
  }

  @override
  bool operator ==(Object other) {
    return other is UnlockContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unlockContentHash() => r'dee655c212981d0c29525143cc72ae3f70dfdb70';

/// Unlock premium content (audio, story, etc.) by spending flowers.

final class UnlockContentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, ({String type, int id})> {
  const UnlockContentFamily._()
    : super(
        retry: null,
        name: r'unlockContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Unlock premium content (audio, story, etc.) by spending flowers.

  UnlockContentProvider call({required String type, required int id}) =>
      UnlockContentProvider._(argument: (type: type, id: id), from: this);

  @override
  String toString() => r'unlockContentProvider';
}
