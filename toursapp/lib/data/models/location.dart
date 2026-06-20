import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
abstract class Location with _$Location {
  const factory Location({
    required int id,
    required int provinceId,
    required String name,
    required double lat,
    required double lng,
    String? nameEn,
    String? nameKo,
    String? nameZh,
    String? description,
    @Default(0) int orderNum,
    String? imageUrl,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
