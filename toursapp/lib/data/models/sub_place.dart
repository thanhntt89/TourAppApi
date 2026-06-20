import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_place.freezed.dart';
part 'sub_place.g.dart';

@freezed
abstract class SubPlace with _$SubPlace {
  const factory SubPlace({
    required int id,
    required int placeId,
    required String name,
    String? nameEn,
    String? content,
    String? contentEn,
    String? imageUrl,
    @Default(0) int orderNum,
  }) = _SubPlace;

  factory SubPlace.fromJson(Map<String, dynamic> json) =>
      _$SubPlaceFromJson(json);
}
