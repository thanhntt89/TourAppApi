import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required String deviceUuid,
    @Default(0) int balance,
    @Default(0) int totalEarned,
    @Default(0) int totalSpent,
  }) = _Wallet;
}

@freezed
abstract class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required int id,
    required String type,
    required int amount,
    required DateTime createdAt,
    String? description,
  }) = _WalletTransaction;
}
