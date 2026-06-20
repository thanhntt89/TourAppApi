abstract final class ApiConstants {
  static const deviceUuidHeader = 'X-Device-UUID';
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);
  static const defaultPageSize = 20;

  // Endpoints
  static const deviceRegister = '/device/register';
  static const provinces = '/provinces';
  static const provincesDetect = '/provinces/detect';
  static const locations = '/locations';
  static const places = '/places';
  static const placesNearby = '/places/nearby';
  static const placesQr = '/places/qr';
  static const placesSearch = '/places/search';
  static const subPlaces = '/sub-places';
  static const journeys = '/journeys';
  static const stories = '/stories';
  static const news = '/news';
  static const userTrack = '/user/track';
  static const userCheckin = '/user/checkin';
  static const userUnlock = '/user/unlock';
  static const userHistory = '/user/history';
  static const userWallet = '/user/wallet';
  static const userShare = '/user/share';
  static const userReferralRedeem = '/user/referral/redeem';
  static const userJourneys = '/user/journeys';
  static const userFeatures = '/user/features';
  static const userDownloads = '/user/downloads';
  static const userPassport = '/user/passport';
  static const syncCheck = '/sync/check';
  static const syncPackage = '/sync/package';
  static const syncMedia = '/sync/media';
  static const comments = '/content';
  static const ratings = '/content';
}
