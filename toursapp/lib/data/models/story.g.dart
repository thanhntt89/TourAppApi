// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Story _$StoryFromJson(Map<String, dynamic> json) => _Story(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  titleEn: json['title_en'] as String?,
  titleKo: json['title_ko'] as String?,
  content: json['content'] as String?,
  contentEn: json['content_en'] as String?,
  imageUrl: json['image_url'] as String?,
  readTimeMinutes: (json['read_time_minutes'] as num?)?.toInt(),
  relatedPlaceIds:
      (json['related_place_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$StoryToJson(_Story instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'title_en': instance.titleEn,
  'title_ko': instance.titleKo,
  'content': instance.content,
  'content_en': instance.contentEn,
  'image_url': instance.imageUrl,
  'read_time_minutes': instance.readTimeMinutes,
  'related_place_ids': instance.relatedPlaceIds,
};
