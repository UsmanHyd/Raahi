/// The kind of stop/activity — presentation maps this to an icon, kept out
/// of the domain layer since icons are a Flutter concern.
enum StopType { drive, food, lodging, sightseeing, activity }

/// A single stop or activity within a [TripDay]'s itinerary — e.g.
/// "Islamabad to Swat" or "Mingora stop".
class TripStop {
  const TripStop({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
  });

  final String id;
  final String title;
  final String subtitle;
  final String time;
  final StopType type;
}
