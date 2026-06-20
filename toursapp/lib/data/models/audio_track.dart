import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_track.freezed.dart';
part 'audio_track.g.dart';

@freezed
abstract class AudioTrack with _$AudioTrack {
  const factory AudioTrack({
    required int placeId,
    required String placeName,
    required String language,
    required String audioUrl,
    required int duration,
    @Default(false) bool isDownloaded,
    String? localPath,
    DateTime? lastPlayedAt,
  }) = _AudioTrack;

  factory AudioTrack.fromJson(Map<String, dynamic> json) =>
      _$AudioTrackFromJson(json);
}
