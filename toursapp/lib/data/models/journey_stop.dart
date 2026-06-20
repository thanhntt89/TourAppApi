import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_stop.freezed.dart';
part 'journey_stop.g.dart';

@freezed
abstract class JourneyStop with _$JourneyStop {
  const factory JourneyStop({
    required int id,
    required int journeyId,
    required int placeId,
    @Default(0) int orderNum,
    String? placeName,
    String? placeImageUrl,
    double? lat,
    double? lng,
    String? distanceFromPrev,
  }) = _JourneyStop;

  factory JourneyStop.fromJson(Map<String, dynamic> json) =>
      _$JourneyStopFromJson(json);
}
