import 'package:stoneecho/data/models/audio_track.dart';

class AudioRepository {
  Future<AudioTrack?> getTrack(int placeId, String language) => throw UnimplementedError();

  Future<void> cacheTrack(int placeId, String language, String url) => throw UnimplementedError();

  Future<void> deleteCache(int placeId, String language) => throw UnimplementedError();

  Future<int> getCacheSizeBytes() => throw UnimplementedError();
}
