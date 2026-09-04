import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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

  static const List<_RecommendedPlace> _places = [
    _RecommendedPlace(
      imageAsset: 'assets/home/recommended_naltar_lake.jpg',
      name: 'Naltar Lake',
      location: 'Gilgit-Baltistan',
      rating: 4.8,
      price: r'From PKR 12,000',
    ),
    _RecommendedPlace(
      imageAsset: 'assets/home/recommended_deosai_plains.jpg',
      name: 'Deosai Plains',
      location: 'Skardu',
      rating: 4.9,
      price: r'From PKR 15,000',
    ),
    _RecommendedPlace(
      imageAsset: 'assets/home/recommended_attabad_lake.jpg',
      name: 'Attabad Lake',
      location: 'Hunza',
      rating: 4.7,
      price: r'From PKR 10,000',
    ),
    _RecommendedPlace(
      imageAsset: 'assets/home/recommended_khunjerab_pass.jpg',
      name: 'Khunjerab Pass',
      location: 'Khunjerab',
      rating: 4.6,
      price: r'From PKR 18,000',
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
              cardBuilder:
                  (context, index, horizontalOffset, verticalOffset) {
                final place = RecommendedCardStack._places[index];
                return RecommendedPlaceCard(
                  imageAsset: place.imageAsset,
                  name: place.name,
                  location: place.location,
                  rating: place.rating,
                  price: place.price,
                );
              },
            ),
    );
  }
}

class _RecommendedPlace {
  const _RecommendedPlace({
    required this.imageAsset,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
  });

  final String imageAsset;
  final String name;
  final String location;
  final double rating;
  final String price;
}
