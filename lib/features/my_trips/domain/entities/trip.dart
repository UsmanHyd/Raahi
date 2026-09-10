import 'trip_day.dart';

/// Where a trip currently stands — drives which section ("Upcoming" or
/// "Past") it's grouped under and how [TripCard] badges it.
enum TripStatus { confirmed, ongoing, completed }

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

/// A saved trip shown on the My Trips tab. Plain entity — no JSON/Flutter
/// dependencies, per the domain layer rules.
class Trip {
  const Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImageAsset,
    required this.startDate,
    required this.endDate,
    required this.travelerCount,
    required this.status,
    this.itinerary = const [],
  });

  final String id;
  final String title;
  final String description;
  final String coverImageAsset;
  final DateTime startDate;
  final DateTime endDate;
  final int travelerCount;
  final TripStatus status;
  final List<TripDay> itinerary;

  int get nightCount => endDate.difference(startDate).inDays;

  String get dateRangeLabel {
    final startMonth = _monthAbbreviations[startDate.month - 1];
    if (startDate.month == endDate.month) {
      return '$startMonth ${startDate.day}-${endDate.day}';
    }
    final endMonth = _monthAbbreviations[endDate.month - 1];
    return '$startMonth ${startDate.day} - $endMonth ${endDate.day}';
  }

  String get travelerCountLabel =>
      travelerCount == 1 ? '1 traveler' : '$travelerCount travelers';
}

extension TripStatusLabel on TripStatus {
  String get label => switch (this) {
    TripStatus.confirmed => 'Confirmed',
    TripStatus.ongoing => 'Ongoing',
    TripStatus.completed => 'Completed',
  };
}
