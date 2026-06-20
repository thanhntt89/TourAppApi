class DownloadRepository {
  Future<void> downloadOfflinePackage(
    int locationId, {
    void Function(double progress)? onProgress,
  }) =>
      throw UnimplementedError();

  Future<void> deleteOfflinePackage(int locationId) => throw UnimplementedError();

  Future<int> getDownloadedSizeBytes() => throw UnimplementedError();
}
