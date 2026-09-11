/// What kind of update a notification carries — presentation maps this to
/// an icon and color, kept out of the domain since those are Flutter
/// concerns.
enum NotificationCategory { weather, tripReminder, roadUpdate }

const _monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// A single notification shown on the Notifications screen.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  final String id;
  final NotificationCategory category;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    category: category,
    title: title,
    message: message,
    timestamp: timestamp,
    isRead: isRead ?? this.isRead,
  );

  /// A human "time ago" label, computed live from the current time so mock
  /// data never looks stale no matter when the app is opened.
  String get relativeTimeLabel {
    final difference = DateTime.now().difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
    }
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    }
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return days == 1 ? '1 day ago' : '$days days ago';
    }
    return '${_monthAbbreviations[timestamp.month - 1]} ${timestamp.day}';
  }
}
