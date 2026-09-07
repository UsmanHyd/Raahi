import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// One nearby place suggested in [AddStopSheet], returned via
/// `Navigator.pop` when the user taps its "+" button.
class NearbyPlace {
  const NearbyPlace({
    required this.imageAsset,
    required this.name,
    required this.distanceLabel,
  });

  final String imageAsset;
  final String name;
  final String distanceLabel;
}

/// A draggable "Add a stop" sheet — opens at 40% of the screen height,
/// drags freely up to 75% and 100% (snapping to whichever is nearest on
/// release), and dismisses itself if dragged more than a little below 40%.
///
/// Show it with `showModalBottomSheet` using `isScrollControlled: true` and
/// `backgroundColor: Colors.transparent` — this widget draws its own
/// rounded background, so the modal's default one would just show through
/// the corners otherwise.
class AddStopSheet extends StatefulWidget {
  const AddStopSheet({super.key, required this.nearbyToLabel});

  /// The place name shown in each suggestion's "X km from {this}" caption.
  final String nearbyToLabel;

  static const double initialSize = 0.4;
  static const double midSize = 0.75;
  static const double maxSize = 1.0;
  static const double minSize = 0.25;

  @override
  State<AddStopSheet> createState() => _AddStopSheetState();
}

class _AddStopSheetState extends State<AddStopSheet> {
  final _sheetController = DraggableScrollableController();
  final _searchController = TextEditingController();
  String _query = '';
  bool _isClosing = false;

  static const List<NearbyPlace> _allPlaces = [
    NearbyPlace(
      imageAsset: 'assets/home/stop_ushu_forest.jpg',
      name: 'Ushu Forest',
      distanceLabel: '8.5 km',
    ),
    NearbyPlace(
      imageAsset: 'assets/home/stop_mahodand_lake.jpg',
      name: 'Mahodand Lake',
      distanceLabel: '24.0 km',
    ),
    NearbyPlace(
      imageAsset: 'assets/home/stop_kalam_bazaar.jpg',
      name: 'Kalam Bazaar',
      distanceLabel: '5.2 km',
    ),
  ];

  List<NearbyPlace> get _filteredPlaces {
    if (_query.isEmpty) return _allPlaces;
    final query = _query.toLowerCase();
    return _allPlaces
        .where((place) => place.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_handleSizeChanged);
  }

  void _handleSizeChanged() {
    if (_isClosing) return;
    // A little below the 40% resting point means "the user is dragging
    // this away" — dismiss rather than let it settle somewhere odd.
    if (_sheetController.size < AddStopSheet.initialSize - 0.08) {
      _isClosing = true;
      Navigator.of(context).maybePop();
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_handleSizeChanged);
    _sheetController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: AddStopSheet.initialSize,
      minChildSize: AddStopSheet.minSize,
      maxChildSize: AddStopSheet.maxSize,
      snap: true,
      snapSizes: const [AddStopSheet.initialSize, AddStopSheet.midSize],
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface50,
            borderRadius: AppRadius.sheetRadius,
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text('Add a stop', style: AppTypography.h1),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Discover places near ${widget.nearbyToLabel}',
                style: AppTypography.body.copyWith(color: AppColors.ink600),
              ),
              const SizedBox(height: AppSpacing.lg),
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
                    hintText: 'Search for a place...',
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
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  const Icon(
                    LucideIcons.sparkles,
                    size: 15,
                    color: AppColors.primary700,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'RECOMMENDED PLACES NEARBY',
                    style: AppTypography.captionEmphasis.copyWith(
                      color: AppColors.ink600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (_filteredPlaces.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
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
                for (final place in _filteredPlaces) ...[
                  _NearbyPlaceCard(
                    place: place,
                    nearbyToLabel: widget.nearbyToLabel,
                    onAdd: () => Navigator.of(context).pop(place),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        );
      },
    );
  }
}

class _NearbyPlaceCard extends StatelessWidget {
  const _NearbyPlaceCard({
    required this.place,
    required this.nearbyToLabel,
    required this.onAdd,
  });

  final NearbyPlace place;
  final String nearbyToLabel;
  final VoidCallback onAdd;

  static const double _height = 120;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              place.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(gradient: AppGradients.primary),
                child: const Icon(
                  LucideIcons.mountain,
                  color: AppColors.surface0,
                  size: 32,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xD9000000)],
                  stops: [0.3, 1],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    place.name,
                    style: AppTypography.bodyEmphasis.copyWith(
                      color: AppColors.surface0,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.mapPin,
                        size: 12,
                        color: AppColors.surface0,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${place.distanceLabel} from $nearbyToLabel',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.surface0.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onAdd,
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.glow(AppColors.primary500),
                    ),
                    child: const Icon(
                      LucideIcons.plus,
                      size: 16,
                      color: AppColors.surface0,
                    ),
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
