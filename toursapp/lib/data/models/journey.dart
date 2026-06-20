import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:stoneecho/data/models/journey_stop.dart';

part 'journey.freezed.dart';
part 'journey.g.dart';

@freezed
abstract class Journey with _$Journey {
  const factory Journey({
    required int id,
    required String name,
    String? nameEn,
    String? nameKo,
    String? nameZh,
    String? description,
    String? descriptionEn,
    String? imageUrl,
    String? totalDistance,
    String? estimatedDays,
    String? difficulty,
    @Default(false) bool isPopular,
    @Default([]) List<JourneyStop> stops,
  }) = _Journey;

  factory Journey.fromJson(Map<String, dynamic> json) =>
      _$JourneyFromJson(json);
}
