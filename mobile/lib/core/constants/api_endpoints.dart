// lib/core/constants/api_endpoints.dart
//
// All API endpoint paths for toursapp/v1 REST API.
// Never hardcode path strings inline — always use these constants.
// Base URL comes from Env.apiBaseUrl + '/toursapp/v1'.

abstract class ApiEndpoints {
  // ── Namespace ──────────────────────────────────────────────────────────────
  static const String namespace = '/toursapp/v1';

  // ── Device ────────────────────────────────────────────────────────────────
  static const String deviceRegister = '/device/register';

  // ── Provinces ─────────────────────────────────────────────────────────────
  static const String provinces = '/provinces';
  static const String provincesDetect = '/provinces/detect';
  static String provinceDetail(int id) => '/provinces/$id';

  // ── Locations ─────────────────────────────────────────────────────────────
  static String provinceLocations(int provinceId) =>
      '/provinces/$provinceId/locations';
  static String locationDetail(int id) => '/locations/$id';

  // ── Places ────────────────────────────────────────────────────────────────
  static const String places = '/places';
  static const String placesNearby = '/places/nearby';
  static const String placesSearch = '/places/search';
  static String placeDetail(int id) => '/places/$id';
  static String placeQr(String code) => '/places/qr/$code';
  static String placeSubPlaces(int placeId) => '/places/$placeId/sub-places';

  // ── Sub-Places & Sub-Items ────────────────────────────────────────────────
  static String subPlaceDetail(int id) => '/sub-places/$id';
  static String subItemDetail(int id) => '/sub-items/$id';

  // ── Journeys (Preset) ─────────────────────────────────────────────────────
  static const String journeys = '/journeys';
  static String journeyDetail(int id) => '/journeys/$id';

  // ── Stories ───────────────────────────────────────────────────────────────
  static const String stories = '/stories';
  static String storyDetail(int id) => '/stories/$id';

  // ── News & Alerts ─────────────────────────────────────────────────────────
  static const String news = '/news';

  // ── User Actions (device-auth required) ───────────────────────────────────
  static const String userCheckin = '/user/checkin';
  static const String userHistory = '/user/history';
  static const String userWallet = '/user/wallet';
  static const String userShare = '/user/share';
  static const String userUnlock = '/user/unlock';
  static const String userReferralRedeem = '/user/referral/redeem';

  // ── User Journeys ─────────────────────────────────────────────────────────
  static const String userJourneys = '/user/journeys';
  static String userJourneyDetail(int id) => '/user/journeys/$id';

  // ── Engagement Tracking ───────────────────────────────────────────────────
  static const String userTrack = '/user/track';
  static String analyticsContent(int id) => '/analytics/content/$id';
  static const String analyticsTopContent = '/analytics/top-content';

  // ── Comments & Ratings ────────────────────────────────────────────────────
  static String contentComments(String type, int id) =>
      '/content/$type/$id/comments';
  static String contentComment(String type, int id, int cid) =>
      '/content/$type/$id/comments/$cid';
  static String contentRating(String type, int id) =>
      '/content/$type/$id/rating';
  static const String userUploadPhoto = '/user/upload-photo';

  // ── Downloads ─────────────────────────────────────────────────────────────
  static const String downloadsStart = '/user/downloads/start';
  static const String downloadsComplete = '/user/downloads/complete';
  static const String downloadsList = '/user/downloads';

  // ── Feature Access ────────────────────────────────────────────────────────
  static const String userFeatures = '/user/features';
  static String userFeatureDetail(String feature) => '/user/features/$feature';
  static String userFeatureUnlock(String feature) =>
      '/user/features/$feature/unlock';

  // ── Sync ──────────────────────────────────────────────────────────────────
  static const String syncCheck = '/sync/check';
  static String syncPackage(int provinceId) => '/sync/package/$provinceId';
  static String syncMedia(int provinceId) => '/sync/media/$provinceId';
}
