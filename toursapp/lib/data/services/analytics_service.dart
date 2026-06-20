import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:stoneecho/data/services/api_service.dart';

/// Combines Firebase Analytics (for standard metrics) with the WordPress
/// REST API (for content-specific tracking).
class AnalyticsService {
  AnalyticsService({
    required FirebaseAnalytics firebaseAnalytics,
    required ApiService apiService,
  })  : _fa = firebaseAnalytics,
        _api = apiService;

  final FirebaseAnalytics _fa;
  final ApiService _api;

  /// Offline event buffer — flushed when connectivity is restored.
  final List<Map<String, dynamic>> _offlineQueue = [];

  // ── Firebase Analytics ──────────────────────────────────────────────

  /// Logs a screen view event.
  Future<void> logScreenView(String screenName) async {
    await _fa.logScreenView(screenName: screenName);
  }

  /// Logs a generic named event with optional parameters.
  Future<void> logEvent(
    String name, {
    Map<String, Object>? params,
  }) async {
    await _fa.logEvent(name: name, parameters: params);
  }

  // ── WordPress API tracking ─────────────────────────────────────────

  /// Tracks a content interaction (view, complete, share, etc.).
  Future<void> trackContentEvent({
    required String type,
    required int contentId,
    Map<String, dynamic>? data,
  }) async {
    final payload = <String, dynamic>{
      'event_type': type,
      'content_id': contentId,
      if (data != null) ...data,
    };

    try {
      await _api.trackEvent(payload);
    } catch (_) {
      _offlineQueue.add(payload);
    }
  }

  /// Convenience wrapper for audio-play tracking.
  Future<void> trackAudioPlay(int placeId, String language) async {
    await logEvent('audio_play', params: {
      'place_id': placeId,
      'language': language,
    });

    await trackContentEvent(
      type: 'audio_play',
      contentId: placeId,
      data: {'language': language},
    );
  }

  /// Convenience wrapper for check-in tracking.
  Future<void> trackCheckin(int placeId, String method) async {
    await logEvent('checkin', params: {
      'place_id': placeId,
      'method': method,
    });

    await trackContentEvent(
      type: 'checkin',
      contentId: placeId,
      data: {'method': method},
    );
  }

  // ── Offline queue management ────────────────────────────────────────

  /// Flushes buffered offline events to the server.
  ///
  /// Call this when connectivity is restored.
  Future<void> flushOfflineEvents() async {
    final pending = List<Map<String, dynamic>>.from(_offlineQueue);
    _offlineQueue.clear();

    for (final event in pending) {
      try {
        await _api.trackEvent(event);
      } catch (_) {
        // Re-queue if still offline.
        _offlineQueue.add(event);
      }
    }
  }

  /// Number of events waiting to be sent.
  int get pendingEventCount => _offlineQueue.length;
}
