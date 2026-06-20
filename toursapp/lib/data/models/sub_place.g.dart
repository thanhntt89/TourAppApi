// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubPlace _$SubPlaceFromJson(Map<String, dynamic> json) => _SubPlace(
  id: (json['id'] as num).toInt(),
  placeId: (json['place_id'] as num).toInt(),
  name: json['name'] as String,
  nameEn: json['name_en'] as String?,
  content: json['content'] as String?,
  contentEn: json['content_en'] as String?,
  imageUrl: json['image_url'] as String?,
  orderNum: (json['order_num'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SubPlaceToJson(_SubPlace instance) => <String, dynamic>{
  'id': instance.id,
  'place_id': instance.placeId,
  'name': instance.name,
  'name_en': instance.nameEn,
  'content': instance.content,
  'content_en': instance.contentEn,
  'image_url': instance.imageUrl,
  'order_num': instance.orderNum,
};
