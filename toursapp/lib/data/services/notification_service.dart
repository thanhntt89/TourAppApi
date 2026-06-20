/// Stub service for local notifications (proximity alerts, reminders).
///
/// Will be fleshed out when `flutter_local_notifications` is integrated.
class NotificationService {
  /// Initializes the notification channel / permission request.
  Future<void> init() async {
    // TODO: initialize flutter_local_notifications plugin.
  }

  /// Shows a proximity alert when the user is near a point of interest.
  Future<void> showProximityAlert({
    required int placeId,
    required String title,
    required String body,
  }) async {
    // TODO: fire a local notification.
  }

  /// Schedules a reminder notification at [scheduledTime].
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // TODO: schedule local notification.
  }

  /// Cancels a previously scheduled notification by [id].
  Future<void> cancel(int id) async {
    // TODO: cancel notification.
  }

  /// Cancels all pending notifications.
  Future<void> cancelAll() async {
    // TODO: cancel all.
  }
}
