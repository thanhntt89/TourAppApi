// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceProvider _$ServiceProviderFromJson(Map<String, dynamic> json) =>
    _ServiceProvider(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      nameEn: json['name_en'] as String?,
      description: json['description'] as String?,
      descriptionEn: json['description_en'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      imageUrl: json['image_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      priceRange: json['price_range'] as String?,
    );

Map<String, dynamic> _$ServiceProviderToJson(_ServiceProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'lat': instance.lat,
      'lng': instance.lng,
      'name_en': instance.nameEn,
      'description': instance.description,
      'description_en': instance.descriptionEn,
      'address': instance.address,
      'phone': instance.phone,
      'website': instance.website,
      'image_url': instance.imageUrl,
      'rating': instance.rating,
      'price_range': instance.priceRange,
    };
