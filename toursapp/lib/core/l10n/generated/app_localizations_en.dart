// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StoneEcho';

  @override
  String get appTagline => 'Tour Guide in Your Pocket';

  @override
  String get tabHome => 'Home';

  @override
  String get tabJourneys => 'Journeys';

  @override
  String get tabLibrary => 'Library';

  @override
  String get tabMore => 'More';

  @override
  String get tabScanQr => 'Scan QR';

  @override
  String get searchPlaceholder => 'Search destinations...';

  @override
  String flowerCount(int count) {
    return '$count Flowers';
  }

  @override
  String get statusDiscovered => 'Discovered';

  @override
  String get statusExplored => 'Explored';

  @override
  String get statusLocked => 'Locked';

  @override
  String get playAudio => 'Play Audio Guide';

  @override
  String get pauseAudio => 'Pause';

  @override
  String unlockContent(int cost) {
    return 'Unlock for $cost Flowers';
  }

  @override
  String distanceAway(String distance) {
    return '$distance away';
  }

  @override
  String checkinReward(int flowers) {
    return '+$flowers Check-in reward!';
  }

  @override
  String get tabStory => 'Story';

  @override
  String get tabInfo => 'Info';

  @override
  String get tabGallery => 'Gallery';

  @override
  String get tabReviews => 'Reviews';

  @override
  String get navigateHere => 'Navigate Here';

  @override
  String get relatedPlaces => 'Nearby Places';

  @override
  String get noPlacesNearby => 'No places nearby';

  @override
  String get noPlacesNearbyDesc =>
      'You\'re not near any landmarks yet. Check the map or scan a QR code.';

  @override
  String get offlineTitle => 'You\'re offline';

  @override
  String get offlineDesc => 'Download the offline pack while you have WiFi.';

  @override
  String get downloadOfflinePack => 'Download Offline Pack';

  @override
  String journeyStops(int count) {
    return '$count stops';
  }

  @override
  String journeyProgress(int visited, int total) {
    return '$visited/$total';
  }

  @override
  String get startJourney => 'Start Journey';

  @override
  String get continueJourney => 'Continue Journey';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get scanInstruction =>
      'Point camera at the QR code at any tourist location';

  @override
  String get recentScans => 'Recent Scans';

  @override
  String get enterCodeManually => 'Or enter code manually';

  @override
  String get myLibrary => 'My Library';

  @override
  String get library => 'Library';

  @override
  String get audioGuides => 'Audio Guides';

  @override
  String get articles => 'Articles';

  @override
  String get stories => 'Stories';

  @override
  String get saved => 'Saved';

  @override
  String get downloads => 'Downloads';

  @override
  String get recentlyPlayed => 'Recently Played';

  @override
  String get byLocation => 'By Location';

  @override
  String get offlineStorage => 'Offline Storage';

  @override
  String get mapTiles => 'Map Tiles';

  @override
  String get audioFiles => 'Audio Files';

  @override
  String get images => 'Images';

  @override
  String get offlinePackages => 'Offline Packages';

  @override
  String get noSavedPlaces => 'No Saved Places';

  @override
  String get noSavedPlacesDescription => 'Places you save will appear here';

  @override
  String get listenToArticle => 'Listen to Article';

  @override
  String get address => 'Address';

  @override
  String get phone => 'Phone';

  @override
  String get openingHours => 'Opening Hours';

  @override
  String get website => 'Website';

  @override
  String get description => 'Description';

  @override
  String get photos => 'Photos';

  @override
  String get call => 'Call';

  @override
  String get getDirections => 'Get Directions';

  @override
  String get localServices => 'Local Services';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get storage => 'Storage';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get resetApp => 'Reset App';

  @override
  String get resetAppConfirmation =>
      'Are you sure you want to reset the app? This will delete all your data.';

  @override
  String get reset => 'Reset';

  @override
  String get resetAllData => 'Reset All Data';

  @override
  String get uiLanguage => 'Display Language';

  @override
  String get uiLanguageDescription => 'Language used for app interface';

  @override
  String get contentLanguage => 'Content Language';

  @override
  String get contentLanguageDescription =>
      'Language for audio guides and articles';

  @override
  String get anonymousExplorer => 'Anonymous Explorer';

  @override
  String get placesVisited => 'Places Visited';

  @override
  String get audioPlayed => 'Audio Played';

  @override
  String get flowersEarned => 'Flowers Earned';

  @override
  String get journeysCompleted => 'Journeys Completed';

  @override
  String get mapTileCache => 'Map Tile Cache';

  @override
  String get clear => 'Clear';

  @override
  String get audioCache => 'Audio Cache';

  @override
  String get imageCache => 'Image Cache';

  @override
  String get clearAllCache => 'Clear All Cache';

  @override
  String get totalUsed => 'Total Used';

  @override
  String get clearAll => 'Clear All';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get settingsTitle => 'More';

  @override
  String get settingsLanguage => 'Language & Region';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsAudioLanguage => 'Audio Language';

  @override
  String get settingsOffline => 'Offline & Storage';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get onboardingTitle1 => 'Your Personal Tour Guide';

  @override
  String get onboardingBody1 =>
      'Arrive at any landmark in Ha Giang and automatically hear its story — in your language';

  @override
  String get onboardingTitle2 => 'Works Even on the Mountain Pass';

  @override
  String get onboardingBody2 =>
      'Download maps, audio guides, and travel info before you go. Everything works without internet.';

  @override
  String get onboardingTitle3 => 'Collect Stories as You Travel';

  @override
  String get onboardingBody3 =>
      'Earn flowers at each stop. Unlock hidden stories, local secrets, and premium audio guides.';

  @override
  String get onboardingTitle4 => 'Allow Location Access';

  @override
  String get onboardingBody4 =>
      'We use your location to automatically play audio guides when you arrive at landmarks.';

  @override
  String get enableGps => 'Enable GPS (Recommended)';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get share => 'Share';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get openMap => 'Open Map';
}
