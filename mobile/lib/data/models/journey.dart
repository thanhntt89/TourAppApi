// lib/data/models/journey.dart — Preset journeys from /journeys

import 'package:freezed_annotation/freezed_annotation.dart';
import 'province.dart';

part 'journey.freezed.dart';
part 'journey.g.dart';

@freezed
class Journey with _$Journey {
  const factory Journey({
    required int id,
    @Default('preset') String type,
    required String name,
    String? description,
    @JsonKey(name: 'feature_image') FeatureImage? featureImage,
    @JsonKey(name: 'duration_days') @Default(1) int durationDays,
    @JsonKey(name: 'total_places') @Default(0) int totalPlaces,
    String? difficulty,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @Default([]) List<JourneyStop> stops,
  }) = _Journey;

  factory Journey.fromJson(Map<String, dynamic> json) =>
      _$JourneyFromJson(json);
}

@freezed
class JourneyStop with _$JourneyStop {
  const factory JourneyStop({
    @JsonKey(name: 'stop_order') required int stopOrder,
    @Default(1) int day,
    @JsonKey(name: 'duration_min') @Default(30) int durationMin,
    String? note,
    required JourneyStopPlace place,
  }) = _JourneyStop;

  factory JourneyStop.fromJson(Map<String, dynamic> json) =>
      _$JourneyStopFromJson(json);
}

@freezed
class JourneyStopPlace with _$JourneyStopPlace {
  const factory JourneyStopPlace({
    required int id,
    required String name,
    @JsonKey(name: 'lat') required double latitude,
    @JsonKey(name: 'lng') required double longitude,
  }) = _JourneyStopPlace;

  factory JourneyStopPlace.fromJson(Map<String, dynamic> json) =>
      _$JourneyStopPlaceFromJson(json);
}
