// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AudioTrack _$AudioTrackFromJson(Map<String, dynamic> json) => _AudioTrack(
  placeId: (json['place_id'] as num).toInt(),
  placeName: json['place_name'] as String,
  language: json['language'] as String,
  audioUrl: json['audio_url'] as String,
  duration: (json['duration'] as num).toInt(),
  isDownloaded: json['is_downloaded'] as bool? ?? false,
  localPath: json['local_path'] as String?,
  lastPlayedAt: json['last_played_at'] == null
      ? null
      : DateTime.parse(json['last_played_at'] as String),
);

Map<String, dynamic> _$AudioTrackToJson(_AudioTrack instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'place_name': instance.placeName,
      'language': instance.language,
      'audio_url': instance.audioUrl,
      'duration': instance.duration,
      'is_downloaded': instance.isDownloaded,
      'local_path': instance.localPath,
      'last_played_at': instance.lastPlayedAt?.toIso8601String(),
    };
