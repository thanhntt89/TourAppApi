import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int placesVisited,
    @Default(0) int audioPlayed,
    @Default(0) int articlesRead,
    @Default(0) int journeysStarted,
    @Default(0) int journeysCompleted,
    @Default(0) int totalCheckIns,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
