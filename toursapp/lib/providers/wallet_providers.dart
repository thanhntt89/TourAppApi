import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/wallet.dart';

part 'wallet_providers.g.dart';

@riverpod
class WalletNotifier extends _$WalletNotifier {
  @override
  Future<WalletState> build() async {
    final dio = ref.watch(dioProvider);
    final response = await dio.get<Map<String, dynamic>>(
      ApiConstants.userWallet,
    );
    final data = response.data!;
    final walletData = data['data'] as Map<String, dynamic>;
    final wallet = Wallet(
      deviceUuid: walletData['device_uuid'] as String? ?? '',
      balance: walletData['balance'] as int? ?? 0,
      totalEarned: walletData['total_earned'] as int? ?? 0,
      totalSpent: walletData['total_spent'] as int? ?? 0,
    );

    // Fetch transactions
    final txResponse = await dio.get<Map<String, dynamic>>(
      '${ApiConstants.userWallet}/transactions',
    );
    final txData = txResponse.data!;
    final transactions = (txData['data'] as List).map((e) {
      final m = e as Map<String, dynamic>;
      return WalletTransaction(
        id: m['id'] as int,
        type: m['type'] as String,
        amount: m['amount'] as int,
        description: m['description'] as String?,
        createdAt: DateTime.parse(m['created_at'] as String),
      );
    }).toList();

    return WalletState(wallet: wallet, transactions: transactions);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

/// Unlock premium content (audio, story, etc.) by spending flowers.
@riverpod
Future<bool> unlockContent(
  Ref ref, {
  required String type,
  required int id,
}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.post<Map<String, dynamic>>(
    ApiConstants.userUnlock,
    data: {'type': type, 'content_id': id},
  );
  final data = response.data!;
  final success = data['success'] as bool? ?? false;

  if (success) {
    // Refresh wallet after spending
    ref.invalidate(walletProvider);
  }

  return success;
}

class WalletState {
  const WalletState({
    required this.wallet,
    this.transactions = const [],
  });

  final Wallet wallet;
  final List<WalletTransaction> transactions;

  int get balance => wallet.balance;
}
