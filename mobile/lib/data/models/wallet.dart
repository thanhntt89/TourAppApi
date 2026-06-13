// lib/data/models/wallet.dart — Buckwheat Flower economy

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required int balance,
    @Default([]) List<WalletTransaction> transactions,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

@freezed
class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required int id,
    required int amount, // positive = earn, negative = spend
    required String type, // 'checkin' | 'share' | 'referral' | 'unlock' | 'achievement'
    String? description,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
}

@freezed
class CheckinResult with _$CheckinResult {
  const factory CheckinResult({
    @JsonKey(name: 'is_new') required bool isNew,
    @JsonKey(name: 'flowers_earned') required int flowersEarned,
    @JsonKey(name: 'new_balance') required int newBalance,
    @JsonKey(name: 'place_name') String? placeName,
  }) = _CheckinResult;

  factory CheckinResult.fromJson(Map<String, dynamic> json) =>
      _$CheckinResultFromJson(json);
}

@freezed
class UnlockResult with _$UnlockResult {
  const factory UnlockResult({
    @JsonKey(name: 'new_balance') required int newBalance,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'content_id') required int contentId,
  }) = _UnlockResult;

  factory UnlockResult.fromJson(Map<String, dynamic> json) =>
      _$UnlockResultFromJson(json);
}
