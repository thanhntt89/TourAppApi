// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Place _$PlaceFromJson(Map<String, dynamic> json) => _Place(
  id: (json['id'] as num).toInt(),
  locationId: (json['location_id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  nameEn: json['name_en'] as String?,
  nameKo: json['name_ko'] as String?,
  nameZh: json['name_zh'] as String?,
  description: json['description'] as String?,
  descriptionEn: json['description_en'] as String?,
  imageUrl: json['image_url'] as String?,
  galleryUrls:
      (json['gallery_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  audioUrlVi: json['audio_url_vi'] as String?,
  audioUrlEn: json['audio_url_en'] as String?,
  audioUrlKo: json['audio_url_ko'] as String?,
  audioUrlZh: json['audio_url_zh'] as String?,
  audioDuration: (json['audio_duration'] as num?)?.toInt() ?? 0,
  category: json['category'] as String?,
  difficulty: json['difficulty'] as String?,
  openingHours: json['opening_hours'] as String?,
  entranceFee: json['entrance_fee'] as String?,
  tips: json['tips'] as String?,
  tipsEn: json['tips_en'] as String?,
  flowerCost: (json['flower_cost'] as num?)?.toInt() ?? 5,
  qrCode: json['qr_code'] as String?,
  status: json['status'] as String?,
  visitDuration: json['visit_duration'] as String?,
);

Map<String, dynamic> _$PlaceToJson(_Place instance) => <String, dynamic>{
  'id': instance.id,
  'location_id': instance.locationId,
  'name': instance.name,
  'slug': instance.slug,
  'lat': instance.lat,
  'lng': instance.lng,
  'name_en': instance.nameEn,
  'name_ko': instance.nameKo,
  'name_zh': instance.nameZh,
  'description': instance.description,
  'description_en': instance.descriptionEn,
  'image_url': instance.imageUrl,
  'gallery_urls': instance.galleryUrls,
  'audio_url_vi': instance.audioUrlVi,
  'audio_url_en': instance.audioUrlEn,
  'audio_url_ko': instance.audioUrlKo,
  'audio_url_zh': instance.audioUrlZh,
  'audio_duration': instance.audioDuration,
  'category': instance.category,
  'difficulty': instance.difficulty,
  'opening_hours': instance.openingHours,
  'entrance_fee': instance.entranceFee,
  'tips': instance.tips,
  'tips_en': instance.tipsEn,
  'flower_cost': instance.flowerCost,
  'qr_code': instance.qrCode,
  'status': instance.status,
  'visit_duration': instance.visitDuration,
};
