import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Wraps [AudioPlayer] and [AudioService] for background-capable audio
/// playback.
class AudioPlayerService {
  AudioPlayerService() : _player = AudioPlayer();

  final AudioPlayer _player;

  // ── Streams ─────────────────────────────────────────────────────────

  /// The current playback position.
  Stream<Duration> get positionStream => _player.positionStream;

  /// The total duration of the loaded media.
  Stream<Duration?> get durationStream => _player.durationStream;

  /// The current [PlayerState] (playing, paused, buffering, etc.).
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// The buffered position.
  Stream<Duration> get bufferedPositionStream =>
      _player.bufferedPositionStream;

  /// Current playback speed.
  double get speed => _player.speed;

  /// Whether the player is currently playing.
  bool get isPlaying => _player.playing;

  // ── Controls ────────────────────────────────────────────────────────

  /// Loads and plays audio from [url].
  Future<void> play(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  /// Pauses playback.
  Future<void> pause() => _player.pause();

  /// Resumes playback after a pause.
  Future<void> resume() => _player.play();

  /// Seeks to the given [position].
  Future<void> seek(Duration position) => _player.seek(position);

  /// Sets the playback speed (e.g. 1.0, 1.5, 2.0).
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  /// Stops playback and resets position to the start.
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  /// Releases all resources held by the player.
  Future<void> dispose() => _player.dispose();
}

// ── AudioHandler for background playback ──────────────────────────────

/// A minimal [BaseAudioHandler] that delegates to [AudioPlayerService].
///
/// Register once via [AudioService.init] at app startup:
/// ```dart
/// final handler = await AudioService.init(
///   builder: () => StoneEchoAudioHandler(audioPlayerService),
///   config: const AudioServiceConfig(
///     androidNotificationChannelId: 'com.toursapp.audio',
///     androidNotificationChannelName: 'Audio Playback',
///     androidNotificationOngoing: true,
///   ),
/// );
/// ```
class StoneEchoAudioHandler extends BaseAudioHandler with SeekHandler {
  StoneEchoAudioHandler(this._service);

  final AudioPlayerService _service;

  @override
  Future<void> play() => _service.resume();

  @override
  Future<void> pause() => _service.pause();

  @override
  Future<void> seek(Duration position) => _service.seek(position);

  @override
  Future<void> stop() async {
    await _service.stop();
    await super.stop();
  }
}
