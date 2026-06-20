// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'StoneEcho';

  @override
  String get appTagline => 'Tour Guide trong túi';

  @override
  String get tabHome => 'Khám phá';

  @override
  String get tabJourneys => 'Hành trình';

  @override
  String get tabLibrary => 'Thư viện';

  @override
  String get tabMore => 'Thêm';

  @override
  String get tabScanQr => 'Quét QR';

  @override
  String get searchPlaceholder => 'Tìm kiếm điểm đến...';

  @override
  String flowerCount(int count) {
    return '$count Hoa';
  }

  @override
  String get statusDiscovered => 'Đã đến';

  @override
  String get statusExplored => 'Đã khám phá';

  @override
  String get statusLocked => 'Chưa mở';

  @override
  String get playAudio => 'Nghe Audio Guide';

  @override
  String get pauseAudio => 'Tạm dừng';

  @override
  String unlockContent(int cost) {
    return 'Mở khóa với $cost Hoa';
  }

  @override
  String distanceAway(String distance) {
    return 'cách $distance';
  }

  @override
  String checkinReward(int flowers) {
    return '+$flowers Thưởng check-in!';
  }

  @override
  String get tabStory => 'Câu chuyện';

  @override
  String get tabInfo => 'Thông tin';

  @override
  String get tabGallery => 'Hình ảnh';

  @override
  String get tabReviews => 'Đánh giá';

  @override
  String get navigateHere => 'Chỉ đường';

  @override
  String get relatedPlaces => 'Gần đây';

  @override
  String get noPlacesNearby => 'Chưa có điểm nào gần đây';

  @override
  String get noPlacesNearbyDesc => 'Bạn chưa ở gần địa điểm nào. Xem bản đồ hoặc quét QR.';

  @override
  String get offlineTitle => 'Không có mạng';

  @override
  String get offlineDesc => 'Tải gói offline khi có WiFi.';

  @override
  String get downloadOfflinePack => 'Tải gói Offline';

  @override
  String journeyStops(int count) {
    return '$count điểm dừng';
  }

  @override
  String journeyProgress(int visited, int total) {
    return '$visited/$total';
  }

  @override
  String get startJourney => 'Bắt đầu hành trình';

  @override
  String get continueJourney => 'Tiếp tục hành trình';

  @override
  String get scanQrCode => 'Quét mã QR';

  @override
  String get scanInstruction => 'Hướng camera vào mã QR tại điểm du lịch';

  @override
  String get recentScans => 'Quét gần đây';

  @override
  String get enterCodeManually => 'Hoặc nhập mã thủ công';

  @override
  String get myLibrary => 'Thư viện của tôi';

  @override
  String get library => 'Thư Viện';

  @override
  String get audioGuides => 'Audio Guide';

  @override
  String get articles => 'Bài viết';

  @override
  String get stories => 'Câu chuyện';

  @override
  String get saved => 'Đã lưu';

  @override
  String get downloads => 'Tải xuống';

  @override
  String get recentlyPlayed => 'Nghe gần đây';

  @override
  String get byLocation => 'Theo Địa Điểm';

  @override
  String get offlineStorage => 'Lưu Trữ Ngoại Tuyến';

  @override
  String get mapTiles => 'Bộ Nhớ Bản Đồ';

  @override
  String get audioFiles => 'Tệp Âm Thanh';

  @override
  String get images => 'Hình Ảnh';

  @override
  String get offlinePackages => 'Gói Ngoại Tuyến';

  @override
  String get noSavedPlaces => 'Chưa Lưu Địa Điểm';

  @override
  String get noSavedPlacesDescription => 'Các địa điểm bạn lưu sẽ xuất hiện ở đây';

  @override
  String get listenToArticle => 'Nghe Bài Viết';

  @override
  String get address => 'Địa Chỉ';

  @override
  String get phone => 'Điện Thoại';

  @override
  String get openingHours => 'Giờ Mở Cửa';

  @override
  String get website => 'Website';

  @override
  String get description => 'Mô Tả';

  @override
  String get photos => 'Ảnh';

  @override
  String get call => 'Gọi';

  @override
  String get getDirections => 'Chỉ Đường';

  @override
  String get localServices => 'Dịch Vụ Địa Phương';

  @override
  String get settings => 'Cài Đặt';

  @override
  String get language => 'Ngôn Ngữ';

  @override
  String get appearance => 'Giao Diện';

  @override
  String get storage => 'Bộ Nhớ';

  @override
  String get about => 'Giới Thiệu';

  @override
  String get appVersion => 'Phiên Bản';

  @override
  String get termsOfService => 'Điều Khoản Sử Dụng';

  @override
  String get privacyPolicy => 'Chính Sách Bảo Mật';

  @override
  String get contactUs => 'Liên Hệ';

  @override
  String get resetApp => 'Đặt Lại Ứng Dụng';

  @override
  String get resetAppConfirmation => 'Bạn có chắc muốn đặt lại? Tất cả dữ liệu sẽ bị xóa.';

  @override
  String get reset => 'Đặt Lại';

  @override
  String get resetAllData => 'Xóa Tất Cả Dữ Liệu';

  @override
  String get uiLanguage => 'Ngôn Ngữ Hiển Thị';

  @override
  String get uiLanguageDescription => 'Ngôn ngữ dùng cho giao diện ứng dụng';

  @override
  String get contentLanguage => 'Ngôn Ngữ Nội Dung';

  @override
  String get contentLanguageDescription => 'Ngôn ngữ cho hướng dẫn âm thanh và bài viết';

  @override
  String get anonymousExplorer => 'Khám Phá Ẩn Danh';

  @override
  String get placesVisited => 'Địa Điểm Đã Thăm';

  @override
  String get audioPlayed => 'Âm Thanh Đã Nghe';

  @override
  String get flowersEarned => 'Hoa Đã Nhận';

  @override
  String get journeysCompleted => 'Hành Trình Hoàn Thành';

  @override
  String get mapTileCache => 'Bộ Nhớ Đệm Bản Đồ';

  @override
  String get clear => 'Xóa';

  @override
  String get audioCache => 'Bộ Nhớ Đệm Âm Thanh';

  @override
  String get imageCache => 'Bộ Nhớ Đệm Ảnh';

  @override
  String get clearAllCache => 'Xóa Tất Cả Bộ Nhớ Đệm';

  @override
  String get totalUsed => 'Tổng Đã Dùng';

  @override
  String get clearAll => 'Xóa Tất Cả';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get system => 'Hệ Thống';

  @override
  String get settingsTitle => 'Thêm';

  @override
  String get settingsLanguage => 'Ngôn ngữ & Khu vực';

  @override
  String get settingsAppLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get settingsAudioLanguage => 'Ngôn ngữ Audio';

  @override
  String get settingsOffline => 'Offline & Bộ nhớ';

  @override
  String get settingsAppearance => 'Giao diện';

  @override
  String get settingsTheme => 'Chủ đề';

  @override
  String get settingsNotifications => 'Thông báo';

  @override
  String get settingsAbout => 'Giới thiệu';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get settingsPrivacy => 'Chính sách bảo mật';

  @override
  String get settingsTerms => 'Điều khoản sử dụng';

  @override
  String get onboardingTitle1 => 'Hướng dẫn viên cá nhân';

  @override
  String get onboardingBody1 => 'Đến bất kỳ danh thắng nào ở Hà Giang và tự động nghe câu chuyện — bằng ngôn ngữ của bạn';

  @override
  String get onboardingTitle2 => 'Hoạt động cả trên đèo';

  @override
  String get onboardingBody2 => 'Tải bản đồ, audio guide trước khi đi. Mọi thứ hoạt động không cần internet.';

  @override
  String get onboardingTitle3 => 'Thu thập câu chuyện';

  @override
  String get onboardingBody3 => 'Nhận hoa tại mỗi điểm. Mở khóa câu chuyện ẩn và audio guide đặc biệt.';

  @override
  String get onboardingTitle4 => 'Cho phép truy cập vị trí';

  @override
  String get onboardingBody4 => 'Chúng tôi dùng vị trí để tự động phát audio khi bạn đến điểm tham quan.';

  @override
  String get enableGps => 'Bật GPS (Khuyến nghị)';

  @override
  String get skipForNow => 'Bỏ qua';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get next => 'Tiếp';

  @override
  String get retry => 'Thử lại';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get close => 'Đóng';

  @override
  String get share => 'Chia sẻ';

  @override
  String get save => 'Lưu';

  @override
  String get delete => 'Xóa';

  @override
  String get openMap => 'Mở bản đồ';
}
