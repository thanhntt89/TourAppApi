// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsAlert _$NewsAlertFromJson(Map<String, dynamic> json) => _NewsAlert(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  provinceId: (json['province_id'] as num).toInt(),
  publishedAt: DateTime.parse(json['published_at'] as String),
  titleEn: json['title_en'] as String?,
  content: json['content'] as String?,
  contentEn: json['content_en'] as String?,
  type: json['type'] as String? ?? 'news',
  imageUrl: json['image_url'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$NewsAlertToJson(_NewsAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'province_id': instance.provinceId,
      'published_at': instance.publishedAt.toIso8601String(),
      'title_en': instance.titleEn,
      'content': instance.content,
      'content_en': instance.contentEn,
      'type': instance.type,
      'image_url': instance.imageUrl,
      'is_active': instance.isActive,
    };
