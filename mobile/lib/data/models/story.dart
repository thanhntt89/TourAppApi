// lib/data/models/story.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'province.dart';
import 'place.dart';

part 'story.freezed.dart';
part 'story.g.dart';

enum StoryType {
  legend, history, culture, folk, mystery, nature, other;

  static StoryType fromString(String s) =>
      StoryType.values.firstWhere((e) => e.name == s, orElse: () => StoryType.other);
}

@freezed
class Story with _$Story {
  const factory Story({
    required int id,
    required String type,
    required String name,
    String? summary,
    /// Full content (HTML). Only in detail response.
    String? content,
    @JsonKey(name: 'feature_image') FeatureImage? featureImage,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'allow_comments') @Default(true) bool allowComments,
    @JsonKey(name: 'allow_ratings') @Default(true) bool allowRatings,
    @JsonKey(name: 'enable_tracking') @Default(true) bool enableTracking,
    /// Audio (only in detail response).
    AudioTrack? audio,
    @JsonKey(name: 'article') StoryPaywall? articlePaywall,
    @JsonKey(name: 'audio_info') StoryAudioPaywall? audioPaywall,
    @Default([]) @JsonKey(name: 'related_places') List<StoryRelatedPlace> relatedPlaces,
    @Default([]) @JsonKey(name: 'related_provinces') List<StoryRelatedProvince> relatedProvinces,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

@freezed
class StoryPaywall with _$StoryPaywall {
  const factory StoryPaywall({
    @JsonKey(name: 'is_free') @Default(true) bool isFree,
    @Default(5) int cost,
  }) = _StoryPaywall;

  factory StoryPaywall.fromJson(Map<String, dynamic> json) =>
      _$StoryPaywallFromJson(json);
}

@freezed
class StoryAudioPaywall with _$StoryAudioPaywall {
  const factory StoryAudioPaywall({
    @JsonKey(name: 'is_free') @Default(true) bool isFree,
    @Default(5) int cost,
    double? duration,
  }) = _StoryAudioPaywall;

  factory StoryAudioPaywall.fromJson(Map<String, dynamic> json) =>
      _$StoryAudioPaywallFromJson(json);
}

@freezed
class StoryRelatedPlace with _$StoryRelatedPlace {
  const factory StoryRelatedPlace({
    required int id,
    required String name,
    @JsonKey(name: 'feature_image') FeatureImage? featureImage,
  }) = _StoryRelatedPlace;

  factory StoryRelatedPlace.fromJson(Map<String, dynamic> json) =>
      _$StoryRelatedPlaceFromJson(json);
}

@freezed
class StoryRelatedProvince with _$StoryRelatedProvince {
  const factory StoryRelatedProvince({
    required int id,
    required String name,
  }) = _StoryRelatedProvince;

  factory StoryRelatedProvince.fromJson(Map<String, dynamic> json) =>
      _$StoryRelatedProvinceFromJson(json);
}
