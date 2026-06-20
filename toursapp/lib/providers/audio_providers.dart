import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/data/models/audio_track.dart';

part 'audio_providers.g.dart';

/// Global audio player state — persists across screen navigation.
///
/// This is the most critical provider in the app. It manages a single
/// [AudioPlayer] instance and exposes playback controls to the UI layer.
@Riverpod(keepAlive: true)
class AudioPlayerNotifier extends _$AudioPlayerNotifier {
  late final AudioPlayer _player;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  AudioPlayerState build() {
    _player = AudioPlayer();
    _listenToPlayer();

    ref.onDispose(() {
      _positionSub?.cancel();
      _durationSub?.cancel();
      _playerStateSub?.cancel();
      _player.dispose();
    });

    return const AudioPlayerState();
  }

  void _listenToPlayer() {
    _positionSub = _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    _durationSub = _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });

    _playerStateSub = _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      state = state.copyWith(
        isPlaying: isPlaying,
        isLoading: processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering,
      );

      // Auto-stop when track completes
      if (processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false);
        _player
          ..seek(Duration.zero)
          ..pause();
      }
    });
  }

  /// Start playing a new audio track.
  Future<void> play(AudioTrack track) async {
    state = state.copyWith(
      currentTrack: track,
      isLoading: true,
      position: Duration.zero,
      duration: Duration.zero,
    );

    try {
      // Use local path if downloaded, otherwise stream from URL
      final source = track.isDownloaded && track.localPath != null
          ? track.localPath!
          : track.audioUrl;

      if (track.isDownloaded && track.localPath != null) {
        await _player.setFilePath(source);
      } else {
        await _player.setUrl(source);
      }

      await _player.setSpeed(state.speed);
      await _player.play();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Pause the current track.
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback of the current track.
  Future<void> resume() async {
    await _player.play();
  }

  /// Seek to a specific position.
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Set playback speed (e.g. 0.5, 1.0, 1.5, 2.0).
  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    await _player.setSpeed(speed);
  }

  /// Switch audio language by loading a different audio track for the same
  /// place. The caller is responsible for constructing the correct [AudioTrack]
  /// with the new language's URL.
  Future<void> setLanguage(String languageCode) async {
    // This is a convenience alias — the actual URL switching happens at the
    // place detail level. The UI should call play() with the new AudioTrack
    // built for the requested language. We keep this method for the API
    // contract and for future smart-language-switching logic.
    final current = state.currentTrack;
    if (current == null) return;

    // Create a new track with updated language (caller provides full track)
    // For now, just update the language marker in state.
    state = state.copyWith(
      currentTrack: current.copyWith(language: languageCode),
    );
  }

  /// Stop playback and clear current track.
  Future<void> stop() async {
    await _player.stop();
    state = const AudioPlayerState();
  }
}

/// Immutable state for the audio player.
class AudioPlayerState {
  const AudioPlayerState({
    this.currentTrack,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
    this.isLoading = false,
  });

  final AudioTrack? currentTrack;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final double speed;
  final bool isLoading;

  bool get hasTrack => currentTrack != null;

  double get progress {
    if (duration.inMilliseconds == 0) return 0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  AudioPlayerState copyWith({
    AudioTrack? currentTrack,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    double? speed,
    bool? isLoading,
  }) {
    return AudioPlayerState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      isLoading: isLoading ?? this.isLoading,
    );
  }

}
