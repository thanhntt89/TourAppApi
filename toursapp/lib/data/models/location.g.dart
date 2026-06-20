// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  id: (json['id'] as num).toInt(),
  provinceId: (json['province_id'] as num).toInt(),
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  nameEn: json['name_en'] as String?,
  nameKo: json['name_ko'] as String?,
  nameZh: json['name_zh'] as String?,
  description: json['description'] as String?,
  orderNum: (json['order_num'] as num?)?.toInt() ?? 0,
  imageUrl: json['image_url'] as String?,
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'id': instance.id,
  'province_id': instance.provinceId,
  'name': instance.name,
  'lat': instance.lat,
  'lng': instance.lng,
  'name_en': instance.nameEn,
  'name_ko': instance.nameKo,
  'name_zh': instance.nameZh,
  'description': instance.description,
  'order_num': instance.orderNum,
  'image_url': instance.imageUrl,
};
