import 'package:stoneecho/data/models/wallet.dart';

class WalletRepository {
  Future<Wallet> getWallet(String deviceUuid) => throw UnimplementedError();

  Future<bool> spendFlowers(String deviceUuid, int amount, String reason) =>
      throw UnimplementedError();

  Future<void> earnFlowers(String deviceUuid, int amount, String reason) =>
      throw UnimplementedError();
}
