// lib/data/models/place.dart
//
// Maps to both:
//  - GET /places/{id} (full detail)
//  - GET /places (compact list — some fields null)

import 'package:freezed_annotation/freezed_annotation.dart';
import 'province.dart';

part 'place.freezed.dart';
part 'place.g.dart';

/// Full place detail (from GET /places/{id}).
@freezed
class Place with _$Place {
  const factory Place({
    required int id,
    required String name,
    /// Short description / tagline.
    String? info,
    /// Full article (HTML or markdown). Only in detail response.
    String? article,
    @JsonKey(name: 'feature_image') FeatureImage? featureImage,
    @Default([]) List<FeatureImage> gallery,
    /// Audio guide (localized).
    AudioTrack? audio,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'geofence_radius') @Default(300) int geofenceRadius,
    @JsonKey(name: 'qr_code') String? qrCode,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'show_article_free') @Default(true) bool showArticleFree,
    @JsonKey(name: 'show_audio_free') @Default(true) bool showAudioFree,
    @JsonKey(name: 'article_offline') @Default(false) bool articleOffline,
    @JsonKey(name: 'audio_offline') @Default(false) bool audioOffline,
    @JsonKey(name: 'article_cost') @Default(5) int articleCost,
    @JsonKey(name: 'checkin_reward') @Default(10) int checkinReward,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'order_number') int? orderNumber,
    @JsonKey(name: 'hierarchical_index') String? hierarchicalIndex,
    @JsonKey(name: 'sub_places_count') @Default(0) int subPlacesCount,
    @JsonKey(name: 'allow_comments') @Default(true) bool allowComments,
    @JsonKey(name: 'allow_ratings') @Default(true) bool allowRatings,
    @JsonKey(name: 'user_status') UserPlaceStatus? userStatus,
    /// Parent location (only in detail).
    PlaceLocation? location,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

/// Compact place from /places/nearby response.
@freezed
class PlaceNearby with _$PlaceNearby {
  const factory PlaceNearby({
    required int id,
    required String name,
    @JsonKey(name: 'feature_image') FeatureImage? featureImage,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'distance_meters') @Default(0) double distanceMeters,
    @JsonKey(name: 'geofence_radius') @Default(300) int geofenceRadius,
    @JsonKey(name: 'is_within_geofence') @Default(false) bool isWithinGeofence,
    @JsonKey(name: 'has_audio') @Default(false) bool hasAudio,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _PlaceNearby;

  factory PlaceNearby.fromJson(Map<String, dynamic> json) =>
      _$PlaceNearbyFromJson(json);
}

@freezed
class AudioTrack with _$AudioTrack {
  const factory AudioTrack({
    required String url,
    int? size,
    double? duration,
  }) = _AudioTrack;

  factory AudioTrack.fromJson(Map<String, dynamic> json) =>
      _$AudioTrackFromJson(json);
}

@freezed
class UserPlaceStatus with _$UserPlaceStatus {
  const factory UserPlaceStatus({
    @JsonKey(name: 'is_checked_in') @Default(false) bool isCheckedIn,
    @JsonKey(name: 'is_article_unlocked') @Default(false) bool isArticleUnlocked,
    @JsonKey(name: 'is_audio_unlocked') @Default(false) bool isAudioUnlocked,
  }) = _UserPlaceStatus;

  factory UserPlaceStatus.fromJson(Map<String, dynamic> json) =>
      _$UserPlaceStatusFromJson(json);
}

@freezed
class PlaceLocation with _$PlaceLocation {
  const factory PlaceLocation({
    required int id,
    int? number,
    required String name,
  }) = _PlaceLocation;

  factory PlaceLocation.fromJson(Map<String, dynamic> json) =>
      _$PlaceLocationFromJson(json);
}
