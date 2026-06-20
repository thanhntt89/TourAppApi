import 'package:freezed_annotation/freezed_annotation.dart';

part 'province.freezed.dart';
part 'province.g.dart';

@freezed
abstract class Province with _$Province {
  const factory Province({
    required int id,
    required String name,
    required double lat,
    required double lng,
    String? nameEn,
    String? nameKo,
    String? nameZh,
    String? description,
    String? descriptionEn,
    String? imageUrl,
    @Default(true) bool isActive,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}
