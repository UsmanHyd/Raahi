import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/primary_button.dart';
import 'route_preview_screen.dart';

const _fullMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Shown after "Plan my trip" — lets the user pick which suggested places
/// to include, on top of the starting/destination/dates already chosen.
///
/// The suggestion list is hardcoded (no backend yet), but the search field
/// filters it for real — that's pure local-list filtering, so it costs
/// nothing to make it actually work rather than leaving it a stub.
class AddPlacesScreen extends StatefulWidget {
  const AddPlacesScreen({
    super.key,
    required this.startingFrom,
    required this.destinationName,
    this.dateRange,
  });

  final String startingFrom;
  final String destinationName;
  final DateTimeRange? dateRange;

  @override
  State<AddPlacesScreen> createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends State<AddPlacesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  final List<_SuggestedPlace> _places = [
    _SuggestedPlace(
      imageAsset: 'assets/home/place_malam_jabba.jpg',
      name: 'Malam Jabba',
      subtitle: 'Ski resort & peaks',
      selected: true,
    ),
    _SuggestedPlace(
      imageAsset: 'assets/home/place_fizagat_park.jpg',
      name: 'Fizagat Park',
      subtitle: 'Riverside gardens',
      selected: true,
    ),
    _SuggestedPlace(
      imageAsset: 'assets/home/place_mingora_bazaar.jpg',
      name: 'Mingora Bazaar',
      subtitle: 'Local craft market',
      selected: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _tripLengthDays {
    final range = widget.dateRange;
    if (range == null) return 5;
    return range.end.difference(range.start).inDays + 1;
  }

  String get _monthLabel {
    final range = widget.dateRange;
    if (range == null) return 'your travel dates';
    return _fullMonthNames[range.start.month - 1];
  }

  List<_SuggestedPlace> get _filteredPlaces {
    if (_query.isEmpty) return _places;
    final query = _query.toLowerCase();
    return _places
        .where(
          (place) =>
              place.name.toLowerCase().contains(query) ||
              place.subtitle.toLowerCase().contains(query),
        )
        .toList();
  }

  void _togglePlace(_SuggestedPlace place) {
    setState(() => place.selected = !place.selected);
  }

  void _finishPlanning() {
    // TODO: send the selected places to the trip repository once the
    // backend is in place — for now both Skip and Continue move on to the
    // same route preview.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoutePreviewScreen(
          startingFrom: widget.startingFrom,
          destinationName: widget.destinationName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _places.where((place) => place.selected).length;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface50,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              decoration: const BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.sheet),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: LucideIcons.arrowLeft,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Must-visit places',
                      style: AppTypography.h1.copyWith(
                        color: AppColors.surface0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface0,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: AppShadows.card,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      style: AppTypography.body,
                      decoration: InputDecoration(
                        hintText: 'Search additional places...',
                        hintStyle: AppTypography.body.copyWith(
                          color: AppColors.ink300,
                        ),
                        prefixIcon: const Icon(
                          LucideIcons.search,
                          color: AppColors.ink300,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.surface0,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.leaf,
                        size: 16,
                        color: AppColors.primary700,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Based on ${widget.destinationName} road '
                          'conditions in $_monthLabel',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Suggested for your $_tripLengthDays-day trip',
                    style: AppTypography.h2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_filteredPlaces.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xl,
                      ),
                      child: Center(
                        child: Text(
                          'No places match your search',
                          style: AppTypography.body.copyWith(
                            color: AppColors.ink300,
                          ),
                        ),
                      ),
                    )
                  else
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.85,
                      children: [
                        for (final place in _filteredPlaces)
                          _PlaceSuggestionCard(
                            place: place,
                            onTap: () => _togglePlace(place),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface0,
                boxShadow: AppShadows.card,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _finishPlanning,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            'Skip, let Raahi decide',
                            style: AppTypography.bodyEmphasis.copyWith(
                              color: AppColors.primary700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: AppShadows.glow(AppColors.primary500),
                        ),
                        child: PrimaryButton(
                          label: selectedCount == 0
                              ? 'Continue'
                              : 'Continue with $selectedCount '
                                    '${selectedCount == 1 ? 'place' : 'places'}',
                          onPressed: _finishPlanning,
                          expand: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestedPlace {
  _SuggestedPlace({
    required this.imageAsset,
    required this.name,
    required this.subtitle,
    required this.selected,
  });

  final String imageAsset;
  final String name;
  final String subtitle;
  bool selected;
}

class _PlaceSuggestionCard extends StatelessWidget {
  const _PlaceSuggestionCard({required this.place, required this.onTap});

  final _SuggestedPlace place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.card,
          border: place.selected
              ? Border.all(color: AppColors.primary700, width: 2)
              : null,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.cardRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                place.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const DecoratedBox(
                      decoration: BoxDecoration(gradient: AppGradients.primary),
                    ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xB3000000)],
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 180),
                  scale: place.selected ? 1 : 0.85,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: place.selected
                          ? AppColors.primary700
                          : AppColors.surface0.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.check,
                      size: 16,
                      color: place.selected
                          ? AppColors.surface0
                          : AppColors.ink300,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      place.name,
                      style: AppTypography.bodyEmphasis.copyWith(
                        color: AppColors.surface0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      place.subtitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.surface0.withValues(alpha: 0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
