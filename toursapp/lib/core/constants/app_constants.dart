abstract final class AppConstants {
  static const appName = 'StoneEcho';
  static const appTagline = 'Tour Guide trong túi';

  // Gamification
  static const flowerEmoji = '🌸';
  static const checkinReward = 10;
  static const shareReward = 2;
  static const referrerReward = 5;
  static const refereeReward = 3;

  // GPS
  static const gpsDistanceFilterBrowse = 100.0;
  static const gpsDistanceFilterAutoplay = 200.0;
  static const gpsDistanceFilterBackground = 500.0;
  static const maxAutoplaySpeedKmh = 80.0;

  // Audio
  static const defaultAudioSpeed = 1.0;
  static const audioSkipSeconds = 15;

  // Content status
  static const statusDiscovered = 'discovered';
  static const statusExplored = 'explored';
  static const statusLocked = 'locked';

  // Languages
  static const supportedUiLanguages = ['vi', 'en', 'ko', 'zh'];
  static const supportedContentLanguages = ['vi', 'en', 'ko', 'zh'];
  static const defaultUiLanguage = 'vi';
  static const defaultContentLanguage = 'vi';
}
