import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'StoneEcho'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Tour Guide in Your Pocket'**
  String get appTagline;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabJourneys.
  ///
  /// In en, this message translates to:
  /// **'Journeys'**
  String get tabJourneys;

  /// No description provided for @tabLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get tabLibrary;

  /// No description provided for @tabMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tabMore;

  /// No description provided for @tabScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get tabScanQr;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search destinations...'**
  String get searchPlaceholder;

  /// No description provided for @flowerCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Flowers'**
  String flowerCount(int count);

  /// No description provided for @statusDiscovered.
  ///
  /// In en, this message translates to:
  /// **'Discovered'**
  String get statusDiscovered;

  /// No description provided for @statusExplored.
  ///
  /// In en, this message translates to:
  /// **'Explored'**
  String get statusExplored;

  /// No description provided for @statusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get statusLocked;

  /// No description provided for @playAudio.
  ///
  /// In en, this message translates to:
  /// **'Play Audio Guide'**
  String get playAudio;

  /// No description provided for @pauseAudio.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseAudio;

  /// No description provided for @unlockContent.
  ///
  /// In en, this message translates to:
  /// **'Unlock for {cost} Flowers'**
  String unlockContent(int cost);

  /// No description provided for @distanceAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String distanceAway(String distance);

  /// No description provided for @checkinReward.
  ///
  /// In en, this message translates to:
  /// **'+{flowers} Check-in reward!'**
  String checkinReward(int flowers);

  /// No description provided for @tabStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get tabStory;

  /// No description provided for @tabInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get tabInfo;

  /// No description provided for @tabGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get tabGallery;

  /// No description provided for @tabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get tabReviews;

  /// No description provided for @navigateHere.
  ///
  /// In en, this message translates to:
  /// **'Navigate Here'**
  String get navigateHere;

  /// No description provided for @relatedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get relatedPlaces;

  /// No description provided for @noPlacesNearby.
  ///
  /// In en, this message translates to:
  /// **'No places nearby'**
  String get noPlacesNearby;

  /// No description provided for @noPlacesNearbyDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re not near any landmarks yet. Check the map or scan a QR code.'**
  String get noPlacesNearbyDesc;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get offlineTitle;

  /// No description provided for @offlineDesc.
  ///
  /// In en, this message translates to:
  /// **'Download the offline pack while you have WiFi.'**
  String get offlineDesc;

  /// No description provided for @downloadOfflinePack.
  ///
  /// In en, this message translates to:
  /// **'Download Offline Pack'**
  String get downloadOfflinePack;

  /// No description provided for @journeyStops.
  ///
  /// In en, this message translates to:
  /// **'{count} stops'**
  String journeyStops(int count);

  /// No description provided for @journeyProgress.
  ///
  /// In en, this message translates to:
  /// **'{visited}/{total}'**
  String journeyProgress(int visited, int total);

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Journey'**
  String get startJourney;

  /// No description provided for @continueJourney.
  ///
  /// In en, this message translates to:
  /// **'Continue Journey'**
  String get continueJourney;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @scanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point camera at the QR code at any tourist location'**
  String get scanInstruction;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// No description provided for @enterCodeManually.
  ///
  /// In en, this message translates to:
  /// **'Or enter code manually'**
  String get enterCodeManually;

  /// No description provided for @myLibrary.
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get myLibrary;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @audioGuides.
  ///
  /// In en, this message translates to:
  /// **'Audio Guides'**
  String get audioGuides;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get stories;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @recentlyPlayed.
  ///
  /// In en, this message translates to:
  /// **'Recently Played'**
  String get recentlyPlayed;

  /// No description provided for @byLocation.
  ///
  /// In en, this message translates to:
  /// **'By Location'**
  String get byLocation;

  /// No description provided for @offlineStorage.
  ///
  /// In en, this message translates to:
  /// **'Offline Storage'**
  String get offlineStorage;

  /// No description provided for @mapTiles.
  ///
  /// In en, this message translates to:
  /// **'Map Tiles'**
  String get mapTiles;

  /// No description provided for @audioFiles.
  ///
  /// In en, this message translates to:
  /// **'Audio Files'**
  String get audioFiles;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @offlinePackages.
  ///
  /// In en, this message translates to:
  /// **'Offline Packages'**
  String get offlinePackages;

  /// No description provided for @noSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'No Saved Places'**
  String get noSavedPlaces;

  /// No description provided for @noSavedPlacesDescription.
  ///
  /// In en, this message translates to:
  /// **'Places you save will appear here'**
  String get noSavedPlacesDescription;

  /// No description provided for @listenToArticle.
  ///
  /// In en, this message translates to:
  /// **'Listen to Article'**
  String get listenToArticle;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours'**
  String get openingHours;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @localServices.
  ///
  /// In en, this message translates to:
  /// **'Local Services'**
  String get localServices;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @resetApp.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get resetApp;

  /// No description provided for @resetAppConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the app? This will delete all your data.'**
  String get resetAppConfirmation;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetAllData;

  /// No description provided for @uiLanguage.
  ///
  /// In en, this message translates to:
  /// **'Display Language'**
  String get uiLanguage;

  /// No description provided for @uiLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Language used for app interface'**
  String get uiLanguageDescription;

  /// No description provided for @contentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Content Language'**
  String get contentLanguage;

  /// No description provided for @contentLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Language for audio guides and articles'**
  String get contentLanguageDescription;

  /// No description provided for @anonymousExplorer.
  ///
  /// In en, this message translates to:
  /// **'Anonymous Explorer'**
  String get anonymousExplorer;

  /// No description provided for @placesVisited.
  ///
  /// In en, this message translates to:
  /// **'Places Visited'**
  String get placesVisited;

  /// No description provided for @audioPlayed.
  ///
  /// In en, this message translates to:
  /// **'Audio Played'**
  String get audioPlayed;

  /// No description provided for @flowersEarned.
  ///
  /// In en, this message translates to:
  /// **'Flowers Earned'**
  String get flowersEarned;

  /// No description provided for @journeysCompleted.
  ///
  /// In en, this message translates to:
  /// **'Journeys Completed'**
  String get journeysCompleted;

  /// No description provided for @mapTileCache.
  ///
  /// In en, this message translates to:
  /// **'Map Tile Cache'**
  String get mapTileCache;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @audioCache.
  ///
  /// In en, this message translates to:
  /// **'Audio Cache'**
  String get audioCache;

  /// No description provided for @imageCache.
  ///
  /// In en, this message translates to:
  /// **'Image Cache'**
  String get imageCache;

  /// No description provided for @clearAllCache.
  ///
  /// In en, this message translates to:
  /// **'Clear All Cache'**
  String get clearAllCache;

  /// No description provided for @totalUsed.
  ///
  /// In en, this message translates to:
  /// **'Total Used'**
  String get totalUsed;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get settingsLanguage;

  /// No description provided for @settingsAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsAppLanguage;

  /// No description provided for @settingsAudioLanguage.
  ///
  /// In en, this message translates to:
  /// **'Audio Language'**
  String get settingsAudioLanguage;

  /// No description provided for @settingsOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline & Storage'**
  String get settingsOffline;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTerms;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Tour Guide'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Arrive at any landmark in Ha Giang and automatically hear its story — in your language'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Works Even on the Mountain Pass'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Download maps, audio guides, and travel info before you go. Everything works without internet.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Collect Stories as You Travel'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Earn flowers at each stop. Unlock hidden stories, local secrets, and premium audio guides.'**
  String get onboardingBody3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get onboardingTitle4;

  /// No description provided for @onboardingBody4.
  ///
  /// In en, this message translates to:
  /// **'We use your location to automatically play audio guides when you arrive at landmarks.'**
  String get onboardingBody4;

  /// No description provided for @enableGps.
  ///
  /// In en, this message translates to:
  /// **'Enable GPS (Recommended)'**
  String get enableGps;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @openMap.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get openMap;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
