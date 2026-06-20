import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/providers/app_providers.dart';

final _newsDetailProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, id) async {
  final dio = ref.watch(dioProvider);
  final lang = ref.watch(appLangProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.newsDetail}/$id',
    queryParameters: {'lang': lang},
  );
  return response.data!['data'] as Map<String, dynamic>;
});

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({required this.newsId, super.key});
  final int newsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(_newsDetailProvider(newsId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.deepBrown,
        elevation: 0,
      ),
      backgroundColor: AppColors.cream,
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                const SizedBox(height: 12),
                Text(
                  e is DioException ? 'Could not load news.' : '$e',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        data: (news) {
          final title = (news['title'] as String?) ?? '';
          final content = (news['content'] as String?) ?? '';
          final type = (news['type'] as String?) ?? 'news';
          final startDate = news['start_date'] as String?;
          final endDate = news['end_date'] as String?;
          final isPinned = (news['is_pinned'] as bool?) ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type badge + pin
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _typeColor(type).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: TextStyle(
                          color: _typeColor(type),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isPinned) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.push_pin, size: 16, color: Colors.orange),
                    ],
                    const Spacer(),
                    if (startDate != null)
                      Text(
                        _formatDateRange(startDate, endDate),
                        style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepBrown,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Content
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _typeColor(String type) {
    return switch (type) {
      'warning' => Colors.orange,
      'alert' => Colors.red,
      'event' => AppColors.forestGreen,
      _ => Colors.blue,
    };
  }

  String _formatDateRange(String start, String? end) {
    if (end == null || end.isEmpty) return start;
    return '$start → $end';
  }
}
