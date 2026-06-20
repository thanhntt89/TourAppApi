import 'package:freezed_annotation/freezed_annotation.dart';

part 'province.freezed.dart';
part 'province.g.dart';

// feature_image can be a direct URL string or null for provinces
String? _provinceImageUrl(dynamic val) {
  if (val == null) return null;
  if (val is String) return val;
  if (val is Map) return val['url'] as String?;
  return null;
}

@freezed
abstract class Province with _$Province {
  const factory Province({
    required int id,
    required String name,
    @JsonKey(name: 'latitude') required double lat,
    @JsonKey(name: 'longitude') required double lng,
    @JsonKey(name: 'feature_image', fromJson: _provinceImageUrl)
    String? imageUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'total_locations') @Default(0) int totalLocations,
    @JsonKey(name: 'total_places') @Default(0) int totalPlaces,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'detection_radius_km') @Default(50) int detectionRadiusKm,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}
