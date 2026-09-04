import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import 'destination_card.dart';

/// The "Explore Nearby" section: a row of selectable category chips above a
/// horizontally-scrolling list of [DestinationCard]s for the selected
/// category. All hardcoded for this UI-first pass.
class ExploreNearbySection extends StatefulWidget {
  const ExploreNearbySection({super.key});

  static const List<_ExploreCategory> _categories = [
    _ExploreCategory(
      label: 'For You',
      glowColor: AppColors.primary500,
      destinations: [
        _Destination(
          imageAsset: 'assets/home/destination_swat_valley.jpg',
          name: 'Swat Valley',
          subtitle: 'Alpine forests & rivers',
        ),
        _Destination(
          imageAsset: 'assets/home/destination_fairy_meadows.jpg',
          name: 'Fairy Meadows',
          subtitle: 'Nanga Parbat basecamp',
        ),
      ],
    ),
    _ExploreCategory(
      label: 'Lakes',
      glowColor: AppColors.accentAmber,
      destinations: [
        _Destination(
          imageAsset: 'assets/home/destination_saif_ul_malook.jpg',
          name: 'Saif-ul-Malook',
          subtitle: 'Glacial lake, Kaghan',
        ),
        _Destination(
          imageAsset: 'assets/home/destination_attabad_lake.jpg',
          name: 'Attabad Lake',
          subtitle: 'Turquoise waters, Hunza',
        ),
      ],
    ),
    _ExploreCategory(
      label: 'Mountains',
      glowColor: AppColors.accentTerracotta,
      destinations: [
        _Destination(
          imageAsset: 'assets/home/destination_fairy_meadows.jpg',
          name: 'Fairy Meadows',
          subtitle: 'Nanga Parbat basecamp',
        ),
        _Destination(
          imageAsset: 'assets/home/destination_deosai.jpg',
          name: 'Deosai Plains',
          subtitle: 'Land of giants',
        ),
      ],
    ),
  ];

  @override
  State<ExploreNearbySection> createState() => _ExploreNearbySectionState();
}

class _ExploreNearbySectionState extends State<ExploreNearbySection> {
  int _selectedIndex = 0;

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
                child: DestinationCard(
                  imageAsset: destination.imageAsset,
                  name: destination.name,
                  subtitle: destination.subtitle,
                  glowColor: category.glowColor,
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
  final List<_Destination> destinations;
}

class _Destination {
  const _Destination({
    required this.imageAsset,
    required this.name,
    required this.subtitle,
  });

  final String imageAsset;
  final String name;
  final String subtitle;
}
