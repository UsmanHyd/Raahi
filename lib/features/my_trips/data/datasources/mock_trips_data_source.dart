import '../../domain/entities/trip.dart';
import '../../domain/entities/trip_day.dart';
import '../../domain/entities/trip_stop.dart';

/// Hardcoded trip list for the My Trips tab — no backend yet, same as every
/// other screen in the app. Kept in its own file (rather than inline in
/// [MyTripsScreen]) purely to keep that screen file under the project's
/// line-count limit; this still isn't a real datasource abstraction since
/// there's nothing behind it to swap out yet.
final List<Trip> mockTrips = [
  Trip(
    id: 'swat-valley',
    title: 'Swat Valley adventure',
    description:
        'A scenic road trip through pine forests, glacial rivers and '
        'mountain meadows — the Switzerland of Pakistan.',
    coverImageAsset: 'assets/home/destination_swat_valley.jpg',
    startDate: DateTime(2026, 6, 20),
    endDate: DateTime(2026, 6, 24),
    travelerCount: 3,
    status: TripStatus.confirmed,
    itinerary: [
      TripDay(
        dayNumber: 1,
        date: DateTime(2026, 6, 20),
        stops: const [
          TripStop(
            id: 'swat-d1-s1',
            title: 'Islamabad to Swat',
            subtitle: 'Start morning drive, check in Kalam Forest Lodge',
            time: '08:00 AM',
            type: StopType.drive,
          ),
          TripStop(
            id: 'swat-d1-s2',
            title: 'Mingora stop',
            subtitle: 'Lunch break and a walk through the local bazaar',
            time: '01:00 PM',
            type: StopType.food,
          ),
          TripStop(
            id: 'swat-d1-s3',
            title: 'Kalam Forest Lodge',
            subtitle: 'Check-in and evening rest',
            time: '05:00 PM',
            type: StopType.lodging,
          ),
        ],
      ),
      TripDay(
        dayNumber: 2,
        date: DateTime(2026, 6, 21),
        stops: const [
          TripStop(
            id: 'swat-d2-s1',
            title: 'Explore Kalam Valley',
            subtitle: 'Ushu forest and Mahodand lake excursion',
            time: '09:00 AM',
            type: StopType.sightseeing,
          ),
          TripStop(
            id: 'swat-d2-s2',
            title: 'Mahodand Lake',
            subtitle: 'Jeep ride and a lakeside picnic',
            time: '12:00 PM',
            type: StopType.activity,
          ),
          TripStop(
            id: 'swat-d2-s3',
            title: 'Local dinner',
            subtitle: 'Traditional Swati cuisine at the lodge',
            time: '07:00 PM',
            type: StopType.food,
          ),
        ],
      ),
      TripDay(
        dayNumber: 3,
        date: DateTime(2026, 6, 22),
        stops: const [
          TripStop(
            id: 'swat-d3-s1',
            title: 'Malam Jabba',
            subtitle: 'Chairlift ride and mountain views',
            time: '09:00 AM',
            type: StopType.activity,
          ),
          TripStop(
            id: 'swat-d3-s2',
            title: 'Fizagat Park',
            subtitle: 'Riverside relaxation and photography',
            time: '02:00 PM',
            type: StopType.sightseeing,
          ),
        ],
      ),
      TripDay(
        dayNumber: 4,
        date: DateTime(2026, 6, 23),
        stops: const [
          TripStop(
            id: 'swat-d4-s1',
            title: 'Marghazar Valley',
            subtitle: 'Visit the White Palace (Sufed Mahal)',
            time: '10:00 AM',
            type: StopType.sightseeing,
          ),
          TripStop(
            id: 'swat-d4-s2',
            title: 'Free evening',
            subtitle: 'Relax at Kalam Forest Lodge',
            time: '06:00 PM',
            type: StopType.activity,
          ),
        ],
      ),
      TripDay(
        dayNumber: 5,
        date: DateTime(2026, 6, 24),
        stops: const [
          TripStop(
            id: 'swat-d5-s1',
            title: 'Check-out',
            subtitle: 'Pack up and settle the room',
            time: '09:00 AM',
            type: StopType.lodging,
          ),
          TripStop(
            id: 'swat-d5-s2',
            title: 'Swat to Islamabad',
            subtitle: 'Head back the way you came',
            time: '11:00 AM',
            type: StopType.drive,
          ),
        ],
      ),
    ],
  ),
  Trip(
    id: 'hunza-valley',
    title: 'Hunza Valley escape',
    description:
        'Snow-capped peaks, terraced orchards and centuries-old forts '
        'along the Karakoram Highway.',
    coverImageAsset: 'assets/home/trip_hunza_valley.jpg',
    startDate: DateTime(2026, 8, 12),
    endDate: DateTime(2026, 8, 15),
    travelerCount: 2,
    status: TripStatus.confirmed,
    itinerary: [
      TripDay(
        dayNumber: 1,
        date: DateTime(2026, 8, 12),
        stops: const [
          TripStop(
            id: 'hunza-d1-s1',
            title: 'Islamabad to Hunza',
            subtitle: 'Scenic drive along the Karakoram Highway',
            time: '06:00 AM',
            type: StopType.drive,
          ),
          TripStop(
            id: 'hunza-d1-s2',
            title: 'Rakaposhi Viewpoint',
            subtitle: 'Photo stop with panoramic peak views',
            time: '02:00 PM',
            type: StopType.sightseeing,
          ),
        ],
      ),
      TripDay(
        dayNumber: 2,
        date: DateTime(2026, 8, 13),
        stops: const [
          TripStop(
            id: 'hunza-d2-s1',
            title: 'Explore Karimabad',
            subtitle: 'Visit Baltit Fort and the local bazaar',
            time: '09:00 AM',
            type: StopType.sightseeing,
          ),
          TripStop(
            id: 'hunza-d2-s2',
            title: 'Altit Fort',
            subtitle: 'Guided tour of the centuries-old fort',
            time: '01:00 PM',
            type: StopType.activity,
          ),
        ],
      ),
      TripDay(
        dayNumber: 3,
        date: DateTime(2026, 8, 14),
        stops: const [
          TripStop(
            id: 'hunza-d3-s1',
            title: 'Attabad Lake',
            subtitle: 'Boating on the turquoise lake',
            time: '10:00 AM',
            type: StopType.activity,
          ),
          TripStop(
            id: 'hunza-d3-s2',
            title: 'Khunjerab Pass',
            subtitle: 'Day trip toward the China border',
            time: '01:00 PM',
            type: StopType.sightseeing,
          ),
        ],
      ),
      TripDay(
        dayNumber: 4,
        date: DateTime(2026, 8, 15),
        stops: const [
          TripStop(
            id: 'hunza-d4-s1',
            title: 'Check-out',
            subtitle: 'Pack up and prepare for departure',
            time: '09:00 AM',
            type: StopType.lodging,
          ),
          TripStop(
            id: 'hunza-d4-s2',
            title: 'Hunza to Islamabad',
            subtitle: 'Return drive along the highway',
            time: '11:00 AM',
            type: StopType.drive,
          ),
        ],
      ),
    ],
  ),
  Trip(
    id: 'naran-kaghan',
    title: 'Naran Kaghan gateway',
    description:
        'Turquoise lakes and alpine trails through one of the north\'s '
        'most beloved valleys.',
    coverImageAsset: 'assets/home/trip_naran_kaghan.jpg',
    startDate: DateTime(2026, 5, 4),
    endDate: DateTime(2026, 5, 8),
    travelerCount: 4,
    status: TripStatus.completed,
    itinerary: [
      TripDay(
        dayNumber: 1,
        date: DateTime(2026, 5, 4),
        stops: const [
          TripStop(
            id: 'naran-d1-s1',
            title: 'Islamabad to Naran',
            subtitle: 'Drive through the Kaghan Valley',
            time: '07:00 AM',
            type: StopType.drive,
          ),
          TripStop(
            id: 'naran-d1-s2',
            title: 'Kaghan town stop',
            subtitle: 'Lunch break and a walk through the local market',
            time: '01:00 PM',
            type: StopType.food,
          ),
        ],
      ),
      TripDay(
        dayNumber: 2,
        date: DateTime(2026, 5, 5),
        stops: const [
          TripStop(
            id: 'naran-d2-s1',
            title: 'Saif-ul-Malook Lake',
            subtitle: 'Jeep ride to the alpine lake',
            time: '08:00 AM',
            type: StopType.activity,
          ),
          TripStop(
            id: 'naran-d2-s2',
            title: 'Lakeside picnic',
            subtitle: 'Relax by the turquoise waters',
            time: '12:00 PM',
            type: StopType.sightseeing,
          ),
        ],
      ),
      TripDay(
        dayNumber: 3,
        date: DateTime(2026, 5, 6),
        stops: const [
          TripStop(
            id: 'naran-d3-s1',
            title: 'Babusar Top',
            subtitle: 'Drive to the scenic mountain pass',
            time: '08:00 AM',
            type: StopType.sightseeing,
          ),
          TripStop(
            id: 'naran-d3-s2',
            title: 'Local trout lunch',
            subtitle: 'Fresh trout at a riverside restaurant',
            time: '01:00 PM',
            type: StopType.food,
          ),
        ],
      ),
      TripDay(
        dayNumber: 4,
        date: DateTime(2026, 5, 7),
        stops: const [
          TripStop(
            id: 'naran-d4-s1',
            title: 'Shogran & Siri Paye',
            subtitle: 'Chairlift ride and a meadow trek',
            time: '09:00 AM',
            type: StopType.activity,
          ),
          TripStop(
            id: 'naran-d4-s2',
            title: 'Free evening',
            subtitle: 'Relax at the hotel',
            time: '06:00 PM',
            type: StopType.activity,
          ),
        ],
      ),
      TripDay(
        dayNumber: 5,
        date: DateTime(2026, 5, 8),
        stops: const [
          TripStop(
            id: 'naran-d5-s1',
            title: 'Check-out',
            subtitle: 'Pack up and settle the room',
            time: '09:00 AM',
            type: StopType.lodging,
          ),
          TripStop(
            id: 'naran-d5-s2',
            title: 'Naran to Islamabad',
            subtitle: 'Head back the way you came',
            time: '11:00 AM',
            type: StopType.drive,
          ),
        ],
      ),
    ],
  ),
];
