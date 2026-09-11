import '../../domain/entities/app_notification.dart';

/// Hardcoded notification list — no backend yet, same as every other
/// screen in the app. Timestamps are built relative to "now" so
/// [AppNotification.relativeTimeLabel] always reads correctly.
List<AppNotification> buildMockNotifications() {
  final now = DateTime.now();
  return [
    AppNotification(
      id: 'weather-alert-kalam',
      category: NotificationCategory.weather,
      title: 'Weather alert',
      message:
          'Rain expected in Kalam on Jun 22. Pack warm layers and '
          'waterproof jackets.',
      timestamp: now.subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: 'trip-reminder-swat',
      category: NotificationCategory.tripReminder,
      title: 'Trip reminder',
      message:
          'Your Swat Valley trip starts in 3 days. Complete offline map '
          'pre-caching.',
      timestamp: now.subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: 'road-update-karakoram',
      category: NotificationCategory.roadUpdate,
      title: 'Road update',
      message:
          'Karakoram Highway partially closed near Besham. Expect delay '
          'on alternative bypass.',
      timestamp: now.subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];
}
