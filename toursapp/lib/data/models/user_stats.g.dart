// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
  placesVisited: (json['places_visited'] as num?)?.toInt() ?? 0,
  audioPlayed: (json['audio_played'] as num?)?.toInt() ?? 0,
  articlesRead: (json['articles_read'] as num?)?.toInt() ?? 0,
  journeysStarted: (json['journeys_started'] as num?)?.toInt() ?? 0,
  journeysCompleted: (json['journeys_completed'] as num?)?.toInt() ?? 0,
  totalCheckIns: (json['total_check_ins'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'places_visited': instance.placesVisited,
      'audio_played': instance.audioPlayed,
      'articles_read': instance.articlesRead,
      'journeys_started': instance.journeysStarted,
      'journeys_completed': instance.journeysCompleted,
      'total_check_ins': instance.totalCheckIns,
    };
