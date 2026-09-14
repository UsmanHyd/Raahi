import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_spacing.dart';
import 'recommended_empty_state_card.dart';
import 'recommended_place_card.dart';

/// The "Recommended" section's Tinder-style swipeable card stack.
///
/// Wraps [CardSwiper]: swiping (in any direction) discards the top card and
/// reveals the next one. Once every card has been swiped, [onEnd] flips
/// [_exhausted] and a static [RecommendedEmptyStateCard] is shown instead.
class RecommendedCardStack extends StatefulWidget {
  const RecommendedCardStack({super.key});

  static const List<RecommendedPlace> _places = [
    RecommendedPlace(
      imageAsset: 'assets/home/recommended_naltar_lake.jpg',
      name: 'Naltar Lake',
      location: 'Gilgit-Baltistan',
      rating: 4.8,
      price: r'From PKR 12,000',
      description:
          'A hidden gem tucked away in the Naltar Valley, famous for its '
          'three colorful lakes that shift shades with the light — a '
          'quieter alternative to the busier northern hotspots.',
      bestTimeToVisit: 'May – September',
      highlights: [
        PlaceHighlight(icon: LucideIcons.waves, label: 'Boating'),
        PlaceHighlight(icon: LucideIcons.camera, label: 'Photography'),
        PlaceHighlight(icon: LucideIcons.cableCar, label: 'Chairlift ride'),
        PlaceHighlight(icon: LucideIcons.tent, label: 'Camping'),
      ],
    ),
    RecommendedPlace(
      imageAsset: 'assets/home/recommended_deosai_plains.jpg',
      name: 'Deosai Plains',
      location: 'Skardu',
      rating: 4.9,
      price: r'From PKR 15,000',
      description:
          "One of the highest plateaus in the world, often called the "
          "'Land of Giants' — vast golden grasslands, wildflowers, and a "
          'chance to spot the Himalayan brown bear.',
      bestTimeToVisit: 'June – September',
      highlights: [
        PlaceHighlight(
          icon: LucideIcons.binoculars,
          label: 'Wildlife spotting',
        ),
        PlaceHighlight(icon: LucideIcons.tent, label: 'Camping'),
        PlaceHighlight(icon: LucideIcons.moonStar, label: 'Stargazing'),
        PlaceHighlight(icon: LucideIcons.footprints, label: 'Trekking'),
      ],
    ),
    RecommendedPlace(
      imageAsset: 'assets/home/recommended_attabad_lake.jpg',
      name: 'Attabad Lake',
      location: 'Hunza',
      rating: 4.7,
      price: r'From PKR 10,000',
      description:
          'A stunning turquoise lake formed after a 2010 landslide, now '
          "one of Hunza's most photographed spots — boat rides and "
          'zip-lining against a backdrop of towering peaks.',
      bestTimeToVisit: 'April – October',
      highlights: [
        PlaceHighlight(icon: LucideIcons.waves, label: 'Boating'),
        PlaceHighlight(icon: LucideIcons.cableCar, label: 'Zip-lining'),
        PlaceHighlight(icon: LucideIcons.camera, label: 'Photography'),
        PlaceHighlight(icon: LucideIcons.utensils, label: 'Lakeside dining'),
      ],
    ),
    RecommendedPlace(
      imageAsset: 'assets/home/recommended_khunjerab_pass.jpg',
      name: 'Khunjerab Pass',
      location: 'Khunjerab',
      rating: 4.6,
      price: r'From PKR 18,000',
      description:
          'The highest paved international border crossing in the world, '
          'connecting Pakistan to China — home to the Khunjerab National '
          'Park and its rare Marco Polo sheep and snow leopards.',
      bestTimeToVisit: 'May – September',
      highlights: [
        PlaceHighlight(
          icon: LucideIcons.binoculars,
          label: 'Wildlife spotting',
        ),
        PlaceHighlight(icon: LucideIcons.camera, label: 'Photography'),
        PlaceHighlight(icon: LucideIcons.flag, label: 'Border crossing views'),
        PlaceHighlight(icon: LucideIcons.route, label: 'High-altitude drive'),
      ],
    ),
  ];

  @override
  State<RecommendedCardStack> createState() => _RecommendedCardStackState();
}

class _RecommendedCardStackState extends State<RecommendedCardStack> {
  bool _exhausted = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370,
      child: _exhausted
          ? const RecommendedEmptyStateCard()
          : CardSwiper(
              cardsCount: RecommendedCardStack._places.length,
              isLoop: false,
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              onEnd: () => setState(() => _exhausted = true),
              cardBuilder: (context, index, horizontalOffset, verticalOffset) {
                return RecommendedPlaceCard(
                  place: RecommendedCardStack._places[index],
                );
              },
            ),
    );
  }
}

/// One highlight/activity chip shown on [PlaceDetailScreen] (e.g.
/// "Boating", "Photography").
class PlaceHighlight {
  const PlaceHighlight({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// A single recommended destination — shown as a swipeable card on Home
/// and, in full, on [PlaceDetailScreen].
class RecommendedPlace {
  const RecommendedPlace({
    required this.imageAsset,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.description,
    required this.bestTimeToVisit,
    required this.highlights,
  });

  final String imageAsset;
  final String name;
  final String location;
  final double rating;
  final String price;
  final String description;
  final String bestTimeToVisit;
  final List<PlaceHighlight> highlights;
}
