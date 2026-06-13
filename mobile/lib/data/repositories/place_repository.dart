// lib/data/repositories/place_repository.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/utils/geo_utils.dart';
import '../http/api_client.dart';
import '../database/app_database.dart';
import '../database/daos/place_dao.dart';
import '../models/place.dart';

abstract class PlaceRepository {
  Future<List<PlaceNearby>> getNearbyPlaces({
    required double lat,
    required double lng,
    required int radiusMeters,
    required String lang,
  });

  Future<Place?> getPlaceDetail(int id, {required String lang});
}

class PlaceRepositoryImpl implements PlaceRepository {
  final ApiClient _api;
  final PlaceDao _dao;
  // TODO: Inject ConnectivityService to check real online status
  // final ConnectivityService _connectivity;

  PlaceRepositoryImpl(this._api, this._dao);

  @override
  Future<List<PlaceNearby>> getNearbyPlaces({
    required double lat,
    required double lng,
    required int radiusMeters,
    required String lang,
  }) async {
    try {
      // 1. Try Online
      final response = await _api.dio.get(
        ApiEndpoints.placesNearby,
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'radius': radiusMeters,
          'lang': lang,
        },
      );
      final List data = response.data;
      return data.map((json) => PlaceNearby.fromJson(json)).toList();
    } catch (e) {
      // 2. Fallback to Offline
      // Fetch all places, then filter by distance manually using Haversine
      // In production, we should only fetch places for the current province
      final offlinePlaces = await _dao.getPlaces(1); // Hardcoded province 1 for now

      final List<PlaceNearby> nearby = [];
      for (final p in offlinePlaces) {
        final distance = GeoUtils.distanceMeters(lat, lng, p.latitude, p.longitude);
        if (distance <= radiusMeters) {
          FeatureImage? featureImg;
          if (p.featureImage != null) {
            featureImg = FeatureImage.fromJson(jsonDecode(p.featureImage!));
          }

          nearby.add(PlaceNearby(
            id: p.id,
            name: p.name,
            featureImage: featureImg,
            latitude: p.latitude,
            longitude: p.longitude,
            distanceMeters: distance,
            geofenceRadius: p.geofenceRadius,
            isWithinGeofence: distance <= p.geofenceRadius,
            hasAudio: p.audioUrl != null,
            isFeatured: p.isFeatured == 1,
            sortOrder: p.sortOrder,
          ));
        }
      }

      nearby.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
      return nearby.take(20).toList();
    }
  }

  @override
  Future<Place?> getPlaceDetail(int id, {required String lang}) async {
    try {
      // 1. Try Online
      final response = await _api.dio.get(
        ApiEndpoints.placeDetail(id),
        queryParameters: {'lang': lang},
      );
      return Place.fromJson(response.data);
    } catch (e) {
      // 2. Fallback to Offline
      final p = await _dao.getPlaceById(id);
      if (p == null) return null;

      FeatureImage? featureImg;
      if (p.featureImage != null) {
        featureImg = FeatureImage.fromJson(jsonDecode(p.featureImage!));
      }

      AudioTrack? audio;
      if (p.audioUrl != null) {
        audio = AudioTrack(
          url: p.audioUrl!, // Offline path will be resolved later by AudioService
          duration: p.audioDuration,
        );
      }

      return Place(
        id: p.id,
        name: p.name,
        info: p.information,
        article: p.article,
        featureImage: featureImg,
        audio: audio,
        latitude: p.latitude,
        longitude: p.longitude,
        geofenceRadius: p.geofenceRadius,
        qrCode: p.qrCode,
        isFeatured: p.isFeatured == 1,
        showArticleFree: p.showArticleFree == 1,
        showAudioFree: p.showAudioFree == 1,
        articleCost: p.articleCost,
        checkinReward: p.checkinReward,
        sortOrder: p.sortOrder,
        orderNumber: p.placeOrderNumber,
      );
    }
  }
}
