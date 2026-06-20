import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:stoneecho/data/models/api_response.dart';
import 'package:stoneecho/data/models/journey.dart';
import 'package:stoneecho/data/models/location.dart';
import 'package:stoneecho/data/models/place.dart';
import 'package:stoneecho/data/models/province.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // ── Device ──────────────────────────────────────────────────────────
  @POST('/device/register')
  Future<ApiResponse<Map<String, dynamic>>> registerDevice(
    @Body() Map<String, dynamic> body,
  );

  // ── Provinces ───────────────────────────────────────────────────────
  @GET('/provinces')
  Future<ApiResponse<List<Province>>> getProvinces();

  @GET('/provinces/{id}')
  Future<ApiResponse<Province>> getProvince(@Path('id') int id);

  // ── Locations ───────────────────────────────────────────────────────
  @GET('/locations')
  Future<ApiResponse<List<Location>>> getLocations(
    @Query('province_id') int? provinceId,
  );

  @GET('/locations/{id}')
  Future<ApiResponse<Location>> getLocation(@Path('id') int id);

  // ── Places ──────────────────────────────────────────────────────────
  @GET('/places')
  Future<ApiResponse<List<Place>>> getPlaces(
    @Query('location_id') int? locationId,
  );

  @GET('/places/{id}')
  Future<ApiResponse<Place>> getPlace(@Path('id') int id);

  @GET('/places/nearby')
  Future<ApiResponse<List<Place>>> getNearbyPlaces(
    @Query('lat') double lat,
    @Query('lng') double lng,
    @Query('radius') double? radiusKm,
  );

  @GET('/places/qr/{code}')
  Future<ApiResponse<Place>> getPlaceByQr(@Path('code') String code);

  @GET('/places/search')
  Future<ApiResponse<List<Place>>> searchPlaces(
    @Query('q') String query,
  );

  // ── Journeys ────────────────────────────────────────────────────────
  @GET('/journeys')
  Future<ApiResponse<List<Journey>>> getJourneys();

  @GET('/journeys/{id}')
  Future<ApiResponse<Journey>> getJourney(@Path('id') int id);

  // ── Stories ─────────────────────────────────────────────────────────
  @GET('/stories')
  Future<ApiResponse<List<Map<String, dynamic>>>> getStories();

  @GET('/stories/{id}')
  Future<ApiResponse<Map<String, dynamic>>> getStory(@Path('id') int id);

  // ── News ────────────────────────────────────────────────────────────
  @GET('/news')
  Future<ApiResponse<List<Map<String, dynamic>>>> getNews(
    @Query('province_id') int? provinceId,
  );

  // ── User / Tracking ────────────────────────────────────────────────
  @POST('/user/track')
  Future<ApiResponse<void>> trackEvent(@Body() Map<String, dynamic> body);

  @POST('/user/checkin')
  Future<ApiResponse<Map<String, dynamic>>> checkin(
    @Body() Map<String, dynamic> body,
  );

  @POST('/user/unlock')
  Future<ApiResponse<Map<String, dynamic>>> unlockContent(
    @Body() Map<String, dynamic> body,
  );

  // ── Wallet ──────────────────────────────────────────────────────────
  @GET('/user/wallet')
  Future<ApiResponse<Map<String, dynamic>>> getWallet(
    @Query('device_uuid') String deviceUuid,
  );

  @GET('/user/history')
  Future<ApiResponse<List<Map<String, dynamic>>>> getHistory(
    @Query('device_uuid') String deviceUuid,
  );

  // ── Sync ────────────────────────────────────────────────────────────
  @GET('/sync/check')
  Future<ApiResponse<Map<String, dynamic>>> checkSync(
    @Query('last_synced_at') String? lastSyncedAt,
  );

  @GET('/sync/package/{id}')
  Future<ApiResponse<Map<String, dynamic>>> getSyncPackage(
    @Path('id') int id,
  );
}
