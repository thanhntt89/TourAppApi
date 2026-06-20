// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'StoneEcho';

  @override
  String get appTagline => '口袋里的导游';

  @override
  String get tabHome => '探索';

  @override
  String get tabJourneys => '行程';

  @override
  String get tabLibrary => '图书馆';

  @override
  String get tabMore => '更多';

  @override
  String get tabScanQr => '扫码';

  @override
  String get searchPlaceholder => '搜索目的地...';

  @override
  String flowerCount(int count) {
    return '$count朵花';
  }

  @override
  String get statusDiscovered => '已发现';

  @override
  String get statusExplored => '已探索';

  @override
  String get statusLocked => '已锁定';

  @override
  String get playAudio => '播放语音导览';

  @override
  String get pauseAudio => '暂停';

  @override
  String unlockContent(int cost) {
    return '用$cost朵花解锁';
  }

  @override
  String distanceAway(String distance) {
    return '距离$distance';
  }

  @override
  String checkinReward(int flowers) {
    return '+$flowers 签到奖励！';
  }

  @override
  String get tabStory => '故事';

  @override
  String get tabInfo => '信息';

  @override
  String get tabGallery => '图库';

  @override
  String get tabReviews => '评价';

  @override
  String get navigateHere => '导航到这里';

  @override
  String get relatedPlaces => '附近地点';

  @override
  String get noPlacesNearby => '附近没有地点';

  @override
  String get noPlacesNearbyDesc => '您还没有靠近任何地标。查看地图或扫描QR码。';

  @override
  String get offlineTitle => '您已离线';

  @override
  String get offlineDesc => '有WiFi时请下载离线包。';

  @override
  String get downloadOfflinePack => '下载离线包';

  @override
  String journeyStops(int count) {
    return '$count个站点';
  }

  @override
  String journeyProgress(int visited, int total) {
    return '$visited/$total';
  }

  @override
  String get startJourney => '开始行程';

  @override
  String get continueJourney => '继续行程';

  @override
  String get scanQrCode => '扫描QR码';

  @override
  String get scanInstruction => '将相机对准旅游景点的QR码';

  @override
  String get recentScans => '最近扫描';

  @override
  String get enterCodeManually => '或手动输入代码';

  @override
  String get myLibrary => '我的图书馆';

  @override
  String get library => '图书馆';

  @override
  String get audioGuides => '语音导览';

  @override
  String get articles => '文章';

  @override
  String get stories => '故事';

  @override
  String get saved => '已保存';

  @override
  String get downloads => '下载';

  @override
  String get recentlyPlayed => '最近播放';

  @override
  String get byLocation => '按地点';

  @override
  String get offlineStorage => '离线存储';

  @override
  String get mapTiles => '地图瓦片';

  @override
  String get audioFiles => '音频文件';

  @override
  String get images => '图片';

  @override
  String get offlinePackages => '离线包';

  @override
  String get noSavedPlaces => '没有收藏的地点';

  @override
  String get noSavedPlacesDescription => '您收藏的地点将显示在这里';

  @override
  String get listenToArticle => '听文章';

  @override
  String get address => '地址';

  @override
  String get phone => '电话';

  @override
  String get openingHours => '营业时间';

  @override
  String get website => '网站';

  @override
  String get description => '描述';

  @override
  String get photos => '照片';

  @override
  String get call => '拨打';

  @override
  String get getDirections => '获取路线';

  @override
  String get localServices => '本地服务';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get appearance => '外观';

  @override
  String get storage => '存储';

  @override
  String get about => '关于';

  @override
  String get appVersion => '应用版本';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get contactUs => '联系我们';

  @override
  String get resetApp => '重置应用';

  @override
  String get resetAppConfirmation => '确定要重置应用吗？这将删除所有数据。';

  @override
  String get reset => '重置';

  @override
  String get resetAllData => '删除所有数据';

  @override
  String get uiLanguage => '显示语言';

  @override
  String get uiLanguageDescription => '应用界面语言';

  @override
  String get contentLanguage => '内容语言';

  @override
  String get contentLanguageDescription => '音频导览和文章的语言';

  @override
  String get anonymousExplorer => '匿名探索者';

  @override
  String get placesVisited => '已访问地点';

  @override
  String get audioPlayed => '已播放音频';

  @override
  String get flowersEarned => '获得的花朵';

  @override
  String get journeysCompleted => '完成的旅程';

  @override
  String get mapTileCache => '地图缓存';

  @override
  String get clear => '清除';

  @override
  String get audioCache => '音频缓存';

  @override
  String get imageCache => '图片缓存';

  @override
  String get clearAllCache => '清除所有缓存';

  @override
  String get totalUsed => '总使用量';

  @override
  String get clearAll => '全部清除';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get system => '系统';

  @override
  String get settingsTitle => '更多';

  @override
  String get settingsLanguage => '语言与地区';

  @override
  String get settingsAppLanguage => '应用语言';

  @override
  String get settingsAudioLanguage => '音频语言';

  @override
  String get settingsOffline => '离线与存储';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsPrivacy => '隐私政策';

  @override
  String get settingsTerms => '使用条款';

  @override
  String get onboardingTitle1 => '您的私人导游';

  @override
  String get onboardingBody1 => '到达河江的任何地标，自动听到它的故事——用您的语言';

  @override
  String get onboardingTitle2 => '山路上也能使用';

  @override
  String get onboardingBody2 => '出发前下载地图和语音导览。一切都可以离线使用。';

  @override
  String get onboardingTitle3 => '旅途中收集故事';

  @override
  String get onboardingBody3 => '在每个站点获得花朵。解锁隐藏故事和高级语音导览。';

  @override
  String get onboardingTitle4 => '允许位置访问';

  @override
  String get onboardingBody4 => '我们使用您的位置在您到达地标时自动播放语音导览。';

  @override
  String get enableGps => '启用GPS（推荐）';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get getStarted => '开始';

  @override
  String get next => '下一步';

  @override
  String get retry => '重试';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get close => '关闭';

  @override
  String get share => '分享';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get openMap => '打开地图';
}
