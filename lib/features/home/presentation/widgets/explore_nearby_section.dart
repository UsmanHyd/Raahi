import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../screens/place_detail_screen.dart';
import 'destination_card.dart';
import 'recommended_card_stack.dart';

/// The "Explore Nearby" section: a row of selectable category chips above a
/// horizontally-scrolling list of [DestinationCard]s for the selected
/// category. Tapping a card opens [PlaceDetailScreen] — the same detail
/// screen (and "Plan a trip here" CTA) used by the "Recommended" stack, so
/// both surfaces lead somewhere real instead of a dead end. All hardcoded
/// for this UI-first pass.
class ExploreNearbySection extends StatefulWidget {
  const ExploreNearbySection({super.key});

  static const List<_ExploreCategory> _categories = [
    _ExploreCategory(
      label: 'For You',
      glowColor: AppColors.primary500,
      destinations: [
        _NearbyDestination(
          tagline: 'Alpine forests & rivers',
          place: RecommendedPlace(
            imageAsset: 'assets/home/destination_swat_valley.jpg',
            name: 'Swat Valley',
            location: 'Khyber Pakhtunkhwa',
            rating: 4.7,
            price: r'From PKR 8,000',
            description:
                "Known as the 'Switzerland of Pakistan' — pine-covered "
                'slopes, the Swat River winding through green valleys, and '
                'charming hill towns like Kalam and Mingora.',
            bestTimeToVisit: 'April – October',
            highlights: [
              PlaceHighlight(icon: LucideIcons.footprints, label: 'Hiking'),
              PlaceHighlight(icon: LucideIcons.waves, label: 'River rafting'),
              PlaceHighlight(icon: LucideIcons.camera, label: 'Photography'),
              PlaceHighlight(
                icon: LucideIcons.utensils,
                label: 'Local cuisine',
              ),
            ],
          ),
        ),
        _NearbyDestination(
          tagline: 'Nanga Parbat basecamp',
          place: RecommendedPlace(
            imageAsset: 'assets/home/destination_fairy_meadows.jpg',
            name: 'Fairy Meadows',
            location: 'Gilgit-Baltistan',
            rating: 4.9,
            price: r'From PKR 20,000',
            description:
                'A lush green meadow at the base of Nanga Parbat, the '
                "world's ninth-highest peak — reached by jeep and a scenic "
                "trek, with unmatched views of the 'Killer Mountain'.",
            bestTimeToVisit: 'June – September',
            highlights: [
              PlaceHighlight(icon: LucideIcons.footprints, label: 'Trekking'),
              PlaceHighlight(icon: LucideIcons.tent, label: 'Camping'),
              PlaceHighlight(
                icon: LucideIcons.mountain,
                label: 'Mountain views',
              ),
              PlaceHighlight(icon: LucideIcons.camera, label: 'Photography'),
            ],
          ),
        ),
      ],
    ),
    _ExploreCategory(
      label: 'Lakes',
      glowColor: AppColors.accentAmber,
      destinations: [
        _NearbyDestination(
          tagline: 'Glacial lake, Kaghan',
          place: RecommendedPlace(
            imageAsset: 'assets/home/destination_saif_ul_malook.jpg',
            name: 'Saif-ul-Malook',
            location: 'Kaghan Valley',
            rating: 4.8,
            price: r'From PKR 9,000',
            description:
                'A glacial lake framed by dramatic peaks, steeped in '
                'folklore about a prince and a fairy — reachable by jeep '
                'from Naran, best visited at sunrise for still, '
                'mirror-like waters.',
            bestTimeToVisit: 'May – September',
            highlights: [
              PlaceHighlight(icon: LucideIcons.waves, label: 'Boating'),
              PlaceHighlight(icon: LucideIcons.camera, label: 'Photography'),
              PlaceHighlight(icon: LucideIcons.footprints, label: 'Hiking'),
              PlaceHighlight(icon: LucideIcons.utensils, label: 'Picnic spots'),
            ],
          ),
        ),
        _NearbyDestination(
          tagline: 'Turquoise waters, Hunza',
          place: RecommendedPlace(
            imageAsset: 'assets/home/destination_attabad_lake.jpg',
            name: 'Attabad Lake',
            location: 'Hunza',
            rating: 4.7,
            price: r'From PKR 10,000',
            description:
                'A striking turquoise lake formed after a 2010 landslide, '
                "now one of Hunza's most photographed spots — boat rides "
                'and lakeside cafes against a backdrop of towering peaks.',
            bestTimeToVisit: 'April – October',
            highlights: [
              PlaceHighlight(icon: LucideIcons.waves, label: 'Boating'),
              PlaceHighlight(icon: LucideIcons.camera, label: 'Photography'),
              PlaceHighlight(
                icon: LucideIcons.utensils,
                label: 'Lakeside dining',
              ),
              PlaceHighlight(icon: LucideIcons.cableCar, label: 'Zip-lining'),
            ],
          ),
        ),
      ],
    ),
    _ExploreCategory(
      label: 'Mountains',
      glowColor: AppColors.accentTerracotta,
      destinations: [
        _NearbyDestination(
          tagline: 'Nanga Parbat basecamp',
          place: RecommendedPlace(
            imageAsset: 'assets/home/destination_fairy_meadows.jpg',
            name: 'Fairy Meadows',
            location: 'Gilgit-Baltistan',
            rating: 4.9,
            price: r'From PKR 20,000',
            description:
                'A lush green meadow at the base of Nanga Parbat, the '
                "world's ninth-highest peak — reached by jeep and a scenic "
                "trek, with unmatched views of the 'Killer Mountain'.",
            bestTimeToVisit: 'June – September',
            highlights: [
              PlaceHighlight(icon: LucideIcons.footprints, label: 'Trekking'),
              PlaceHighlight(icon: LucideIcons.tent, label: 'Camping'),
              PlaceHighlight(
                icon: LucideIcons.mountain,
                label: 'Mountain views',
              ),
              PlaceHighlight(icon: LucideIcons.camera, label: 'Photography'),
            ],
          ),
        ),
        _NearbyDestination(
          tagline: 'Land of giants',
          place: RecommendedPlace(
            imageAsset: 'assets/home/destination_deosai.jpg',
            name: 'Deosai Plains',
            location: 'Skardu',
            rating: 4.9,
            price: r'From PKR 15,000',
            description:
                'One of the highest plateaus in the world — vast golden '
                'grasslands, wildflowers, and a chance to spot the '
                'Himalayan brown bear in its natural habitat.',
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
        ),
      ],
    ),
  ];

  @override
  State<ExploreNearbySection> createState() => _ExploreNearbySectionState();
}

class _ExploreNearbySectionState extends State<ExploreNearbySection> {
  int _selectedIndex = 0;

  void _openPlace(BuildContext context, RecommendedPlace place) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place)));
  }

  @override
  Widget build(BuildContext context) {
    final category = ExploreNearbySection._categories[_selectedIndex];
    final destinations = category.destinations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ExploreNearbySection._categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final category = ExploreNearbySection._categories[index];
              final selected = index == _selectedIndex;
              return _CategoryChip(
                label: category.label,
                selected: selected,
                onTap: () => setState(() => _selectedIndex = index),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return SizedBox(
                width: 160,
                child: GestureDetector(
                  onTap: () => _openPlace(context, destination.place),
                  child: DestinationCard(
                    imageAsset: destination.place.imageAsset,
                    name: destination.place.name,
                    subtitle: destination.tagline,
                    glowColor: category.glowColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: selected ? AppShadows.glow(AppColors.primary500) : null,
      ),
      child: Material(
        color: selected ? null : AppColors.surface0,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              gradient: selected ? AppGradients.primary : null,
              borderRadius: BorderRadius.circular(999),
              border: selected ? null : Border.all(color: AppColors.border),
            ),
            child: Text(
              label,
              style: AppTypography.captionEmphasis.copyWith(
                color: selected ? AppColors.surface0 : AppColors.ink600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreCategory {
  const _ExploreCategory({
    required this.label,
    required this.glowColor,
    required this.destinations,
  });

  final String label;
  final Color glowColor;
  final List<_NearbyDestination> destinations;
}

/// Pairs a punchy display tagline (shown on the compact [DestinationCard])
/// with the full [RecommendedPlace] data needed by [PlaceDetailScreen].
class _NearbyDestination {
  const _NearbyDestination({required this.tagline, required this.place});

  final String tagline;
  final RecommendedPlace place;
}
