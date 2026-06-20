// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Checkin _$CheckinFromJson(Map<String, dynamic> json) => _Checkin(
  id: (json['id'] as num).toInt(),
  placeId: (json['place_id'] as num).toInt(),
  method: json['method'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  placeName: json['place_name'] as String?,
  flowersEarned: (json['flowers_earned'] as num?)?.toInt() ?? 0,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CheckinToJson(_Checkin instance) => <String, dynamic>{
  'id': instance.id,
  'place_id': instance.placeId,
  'method': instance.method,
  'created_at': instance.createdAt.toIso8601String(),
  'place_name': instance.placeName,
  'flowers_earned': instance.flowersEarned,
  'lat': instance.lat,
  'lng': instance.lng,
};
