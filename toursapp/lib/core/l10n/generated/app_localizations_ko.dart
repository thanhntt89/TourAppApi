// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'StoneEcho';

  @override
  String get appTagline => '주머니 속 투어 가이드';

  @override
  String get tabHome => '탐색';

  @override
  String get tabJourneys => '여행';

  @override
  String get tabLibrary => '라이브러리';

  @override
  String get tabMore => '더보기';

  @override
  String get tabScanQr => 'QR 스캔';

  @override
  String get searchPlaceholder => '목적지 검색...';

  @override
  String flowerCount(int count) {
    return '$count송이';
  }

  @override
  String get statusDiscovered => '발견됨';

  @override
  String get statusExplored => '탐험완료';

  @override
  String get statusLocked => '잠김';

  @override
  String get playAudio => '오디오 가이드 재생';

  @override
  String get pauseAudio => '일시정지';

  @override
  String unlockContent(int cost) {
    return '$cost송이로 잠금해제';
  }

  @override
  String distanceAway(String distance) {
    return '$distance 거리';
  }

  @override
  String checkinReward(int flowers) {
    return '+$flowers 체크인 보상!';
  }

  @override
  String get tabStory => '이야기';

  @override
  String get tabInfo => '정보';

  @override
  String get tabGallery => '갤러리';

  @override
  String get tabReviews => '리뷰';

  @override
  String get navigateHere => '길찾기';

  @override
  String get relatedPlaces => '근처 장소';

  @override
  String get noPlacesNearby => '근처에 장소가 없습니다';

  @override
  String get noPlacesNearbyDesc => '아직 근처에 랜드마크가 없습니다. 지도를 확인하거나 QR 코드를 스캔하세요.';

  @override
  String get offlineTitle => '오프라인 상태';

  @override
  String get offlineDesc => 'WiFi가 있을 때 오프라인 팩을 다운로드하세요.';

  @override
  String get downloadOfflinePack => '오프라인 팩 다운로드';

  @override
  String journeyStops(int count) {
    return '$count개 정거장';
  }

  @override
  String journeyProgress(int visited, int total) {
    return '$visited/$total';
  }

  @override
  String get startJourney => '여행 시작';

  @override
  String get continueJourney => '여행 계속';

  @override
  String get scanQrCode => 'QR 코드 스캔';

  @override
  String get scanInstruction => '관광지의 QR 코드에 카메라를 가리키세요';

  @override
  String get recentScans => '최근 스캔';

  @override
  String get enterCodeManually => '코드 직접 입력';

  @override
  String get myLibrary => '내 라이브러리';

  @override
  String get library => '라이브러리';

  @override
  String get audioGuides => '오디오 가이드';

  @override
  String get articles => '기사';

  @override
  String get stories => '이야기';

  @override
  String get saved => '저장됨';

  @override
  String get downloads => '다운로드';

  @override
  String get recentlyPlayed => '최근 재생';

  @override
  String get byLocation => '위치별';

  @override
  String get offlineStorage => '오프라인 저장소';

  @override
  String get mapTiles => '지도 타일';

  @override
  String get audioFiles => '오디오 파일';

  @override
  String get images => '이미지';

  @override
  String get offlinePackages => '오프라인 패키지';

  @override
  String get noSavedPlaces => '저장된 장소 없음';

  @override
  String get noSavedPlacesDescription => '저장한 장소가 여기에 표시됩니다';

  @override
  String get listenToArticle => '기사 듣기';

  @override
  String get address => '주소';

  @override
  String get phone => '전화';

  @override
  String get openingHours => '운영 시간';

  @override
  String get website => '웹사이트';

  @override
  String get description => '설명';

  @override
  String get photos => '사진';

  @override
  String get call => '전화하기';

  @override
  String get getDirections => '길 안내';

  @override
  String get localServices => '지역 서비스';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get appearance => '외관';

  @override
  String get storage => '저장공간';

  @override
  String get about => '정보';

  @override
  String get appVersion => '앱 버전';

  @override
  String get termsOfService => '이용약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get contactUs => '문의하기';

  @override
  String get resetApp => '앱 초기화';

  @override
  String get resetAppConfirmation => '앱을 초기화하시겠습니까? 모든 데이터가 삭제됩니다.';

  @override
  String get reset => '초기화';

  @override
  String get resetAllData => '모든 데이터 삭제';

  @override
  String get uiLanguage => '표시 언어';

  @override
  String get uiLanguageDescription => '앱 인터페이스 언어';

  @override
  String get contentLanguage => '콘텐츠 언어';

  @override
  String get contentLanguageDescription => '오디오 가이드 및 기사 언어';

  @override
  String get anonymousExplorer => '익명 탐험가';

  @override
  String get placesVisited => '방문한 장소';

  @override
  String get audioPlayed => '재생된 오디오';

  @override
  String get flowersEarned => '획득한 꽃';

  @override
  String get journeysCompleted => '완료된 여정';

  @override
  String get mapTileCache => '지도 캐시';

  @override
  String get clear => '지우기';

  @override
  String get audioCache => '오디오 캐시';

  @override
  String get imageCache => '이미지 캐시';

  @override
  String get clearAllCache => '모든 캐시 지우기';

  @override
  String get totalUsed => '총 사용량';

  @override
  String get clearAll => '모두 지우기';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String get system => '시스템';

  @override
  String get settingsTitle => '더보기';

  @override
  String get settingsLanguage => '언어 및 지역';

  @override
  String get settingsAppLanguage => '앱 언어';

  @override
  String get settingsAudioLanguage => '오디오 언어';

  @override
  String get settingsOffline => '오프라인 및 저장소';

  @override
  String get settingsAppearance => '외관';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsNotifications => '알림';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsPrivacy => '개인정보 처리방침';

  @override
  String get settingsTerms => '이용약관';

  @override
  String get onboardingTitle1 => '개인 투어 가이드';

  @override
  String get onboardingBody1 => '하장의 어떤 랜드마크에 도착하면 자동으로 이야기를 들려줍니다 — 당신의 언어로';

  @override
  String get onboardingTitle2 => '산길에서도 작동합니다';

  @override
  String get onboardingBody2 =>
      '출발 전에 지도와 오디오 가이드를 다운로드하세요. 인터넷 없이도 모든 것이 작동합니다.';

  @override
  String get onboardingTitle3 => '여행하며 이야기를 수집하세요';

  @override
  String get onboardingBody3 =>
      '각 정거장에서 꽃을 받으세요. 숨겨진 이야기와 프리미엄 오디오 가이드를 잠금해제하세요.';

  @override
  String get onboardingTitle4 => '위치 접근 허용';

  @override
  String get onboardingBody4 => '랜드마크에 도착하면 자동으로 오디오 가이드를 재생하기 위해 위치를 사용합니다.';

  @override
  String get enableGps => 'GPS 활성화 (권장)';

  @override
  String get skipForNow => '건너뛰기';

  @override
  String get getStarted => '시작하기';

  @override
  String get next => '다음';

  @override
  String get retry => '다시 시도';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get close => '닫기';

  @override
  String get share => '공유';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get openMap => '지도 열기';
}
