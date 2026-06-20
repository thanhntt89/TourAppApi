// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Province _$ProvinceFromJson(Map<String, dynamic> json) => _Province(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  lat: (json['latitude'] as num).toDouble(),
  lng: (json['longitude'] as num).toDouble(),
  imageUrl: _provinceImageUrl(json['feature_image']),
  isActive: json['is_active'] as bool? ?? true,
  totalLocations: (json['total_locations'] as num?)?.toInt() ?? 0,
  totalPlaces: (json['total_places'] as num?)?.toInt() ?? 0,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  detectionRadiusKm: (json['detection_radius_km'] as num?)?.toInt() ?? 50,
);

Map<String, dynamic> _$ProvinceToJson(_Province instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.lat,
  'longitude': instance.lng,
  'feature_image': instance.imageUrl,
  'is_active': instance.isActive,
  'total_locations': instance.totalLocations,
  'total_places': instance.totalPlaces,
  'sort_order': instance.sortOrder,
  'detection_radius_km': instance.detectionRadiusKm,
};
