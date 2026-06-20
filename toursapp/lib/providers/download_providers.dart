import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';

part 'download_providers.g.dart';

/// Tracks download progress for offline content packages.
/// Key = package identifier (e.g. "province_1"), value = progress 0.0..1.0.
@Riverpod(keepAlive: true)
class DownloadProgress extends _$DownloadProgress {
  @override
  Map<String, double> build() {
    return {};
  }

  void updateProgress(String packageId, double progress) {
    state = {...state, packageId: progress};
  }

  void complete(String packageId) {
    state = Map<String, double>.from(state)..remove(packageId);
  }

  void clearAll() {
    state = {};
  }

  bool isDownloading(String packageId) {
    return state.containsKey(packageId);
  }
}

/// Manages offline content packages (province data, audio files, maps).
@riverpod
class OfflinePackage extends _$OfflinePackage {
  @override
  Future<List<OfflinePackageInfo>> build() async {
    final dio = ref.watch(dioProvider);
    final response = await dio.get<Map<String, dynamic>>(
      ApiConstants.syncPackage,
    );
    final data = response.data!;
    return (data['data'] as List)
        .map((e) => OfflinePackageInfo.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> download(String packageId) async {
    final progress = ref.read(downloadProgressProvider.notifier)
      ..updateProgress(packageId, 0);

    try {
      final dio = ref.read(dioProvider);
      await dio.download(
        '${ApiConstants.syncPackage}/$packageId',
        // Path will be resolved by a download service in the real implementation
        '/tmp/$packageId.zip',
        onReceiveProgress: (received, total) {
          if (total > 0) {
            progress.updateProgress(packageId, received / total);
          }
        },
      );
      progress.complete(packageId);
      ref.invalidateSelf();
    } catch (e) {
      progress.complete(packageId);
      rethrow;
    }
  }
}

/// Simple data class for offline package metadata.
class OfflinePackageInfo {
  const OfflinePackageInfo({
    required this.id,
    required this.name,
    required this.sizeBytes,
    required this.isDownloaded,
    this.downloadedAt,
  });

  factory OfflinePackageInfo.fromMap(Map<String, dynamic> map) {
    return OfflinePackageInfo(
      id: map['id'] as String,
      name: map['name'] as String,
      sizeBytes: map['size_bytes'] as int? ?? 0,
      isDownloaded: map['is_downloaded'] as bool? ?? false,
      downloadedAt: map['downloaded_at'] != null
          ? DateTime.parse(map['downloaded_at'] as String)
          : null,
    );
  }

  final String id;
  final String name;
  final int sizeBytes;
  final bool isDownloaded;
  final DateTime? downloadedAt;

  String get sizeFormatted {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
