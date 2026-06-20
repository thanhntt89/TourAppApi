// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JourneyStop _$JourneyStopFromJson(Map<String, dynamic> json) => _JourneyStop(
  id: (json['id'] as num).toInt(),
  journeyId: (json['journey_id'] as num).toInt(),
  placeId: (json['place_id'] as num).toInt(),
  orderNum: (json['order_num'] as num?)?.toInt() ?? 0,
  placeName: json['place_name'] as String?,
  placeImageUrl: json['place_image_url'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  distanceFromPrev: json['distance_from_prev'] as String?,
);

Map<String, dynamic> _$JourneyStopToJson(_JourneyStop instance) =>
    <String, dynamic>{
      'id': instance.id,
      'journey_id': instance.journeyId,
      'place_id': instance.placeId,
      'order_num': instance.orderNum,
      'place_name': instance.placeName,
      'place_image_url': instance.placeImageUrl,
      'lat': instance.lat,
      'lng': instance.lng,
      'distance_from_prev': instance.distanceFromPrev,
    };
