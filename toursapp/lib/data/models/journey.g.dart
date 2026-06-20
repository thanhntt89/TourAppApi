// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Journey _$JourneyFromJson(Map<String, dynamic> json) => _Journey(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  nameEn: json['name_en'] as String?,
  nameKo: json['name_ko'] as String?,
  nameZh: json['name_zh'] as String?,
  description: json['description'] as String?,
  descriptionEn: json['description_en'] as String?,
  imageUrl: json['image_url'] as String?,
  totalDistance: json['total_distance'] as String?,
  estimatedDays: json['estimated_days'] as String?,
  difficulty: json['difficulty'] as String?,
  isPopular: json['is_popular'] as bool? ?? false,
  stops:
      (json['stops'] as List<dynamic>?)
          ?.map((e) => JourneyStop.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$JourneyToJson(_Journey instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'name_en': instance.nameEn,
  'name_ko': instance.nameKo,
  'name_zh': instance.nameZh,
  'description': instance.description,
  'description_en': instance.descriptionEn,
  'image_url': instance.imageUrl,
  'total_distance': instance.totalDistance,
  'estimated_days': instance.estimatedDays,
  'difficulty': instance.difficulty,
  'is_popular': instance.isPopular,
  'stops': instance.stops.map((e) => e.toJson()).toList(),
};
