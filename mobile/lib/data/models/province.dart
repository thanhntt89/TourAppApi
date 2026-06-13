// lib/data/models/province.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'province.freezed.dart';
part 'province.g.dart';

@freezed
class Province with _$Province {
  const factory Province({
    required int id,
    required String name,
    String? description,
    @JsonKey(name: 'feature_image') FeatureImage? featureImage,
    @Default([]) @JsonKey(name: 'banner_images') List<FeatureImage> bannerImages,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'distance_km') double? distanceKm,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}

@freezed
class FeatureImage with _$FeatureImage {
  const factory FeatureImage({
    required String url,
    int? width,
    int? height,
    String? alt,
    String? caption,
  }) = _FeatureImage;

  factory FeatureImage.fromJson(Map<String, dynamic> json) =>
      _$FeatureImageFromJson(json);
}
