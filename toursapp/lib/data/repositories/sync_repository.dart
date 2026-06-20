class SyncRepository {
  Future<void> flushPendingQueue() => throw UnimplementedError();

  Future<void> addToQueue(String endpoint, Map<String, dynamic> payload) =>
      throw UnimplementedError();

  Future<int> getPendingCount() => throw UnimplementedError();
}
