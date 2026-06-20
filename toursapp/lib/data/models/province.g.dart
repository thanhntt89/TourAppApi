// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Province _$ProvinceFromJson(Map<String, dynamic> json) => _Province(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  nameEn: json['name_en'] as String?,
  nameKo: json['name_ko'] as String?,
  nameZh: json['name_zh'] as String?,
  description: json['description'] as String?,
  descriptionEn: json['description_en'] as String?,
  imageUrl: json['image_url'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$ProvinceToJson(_Province instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lng': instance.lng,
  'name_en': instance.nameEn,
  'name_ko': instance.nameKo,
  'name_zh': instance.nameZh,
  'description': instance.description,
  'description_en': instance.descriptionEn,
  'image_url': instance.imageUrl,
  'is_active': instance.isActive,
};
