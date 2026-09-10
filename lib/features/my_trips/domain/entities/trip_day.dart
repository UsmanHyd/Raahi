import 'trip_stop.dart';

/// One day of a [Trip]'s itinerary — a date and its ordered stops.
class TripDay {
  const TripDay({
    required this.dayNumber,
    required this.date,
    required this.stops,
  });

  final int dayNumber;
  final DateTime date;
  final List<TripStop> stops;
}
