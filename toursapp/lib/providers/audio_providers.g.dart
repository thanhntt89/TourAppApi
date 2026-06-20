// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global audio player state — persists across screen navigation.
///
/// This is the most critical provider in the app. It manages a single
/// [AudioPlayer] instance and exposes playback controls to the UI layer.

@ProviderFor(AudioPlayerNotifier)
const audioPlayerProvider = AudioPlayerNotifierProvider._();

/// Global audio player state — persists across screen navigation.
///
/// This is the most critical provider in the app. It manages a single
/// [AudioPlayer] instance and exposes playback controls to the UI layer.
final class AudioPlayerNotifierProvider
    extends $NotifierProvider<AudioPlayerNotifier, AudioPlayerState> {
  /// Global audio player state — persists across screen navigation.
  ///
  /// This is the most critical provider in the app. It manages a single
  /// [AudioPlayer] instance and exposes playback controls to the UI layer.
  const AudioPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioPlayerNotifierHash();

  @$internal
  @override
  AudioPlayerNotifier create() => AudioPlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioPlayerState>(value),
    );
  }
}

String _$audioPlayerNotifierHash() =>
    r'6357d4752106ab7643cf301c13dddd51f479f2c3';

/// Global audio player state — persists across screen navigation.
///
/// This is the most critical provider in the app. It manages a single
/// [AudioPlayer] instance and exposes playback controls to the UI layer.

abstract class _$AudioPlayerNotifier extends $Notifier<AudioPlayerState> {
  AudioPlayerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AudioPlayerState, AudioPlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AudioPlayerState, AudioPlayerState>,
              AudioPlayerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
