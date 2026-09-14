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
import '../../../trip_planner/presentation/screens/plan_trip_screen.dart';
import '../widgets/recommended_card_stack.dart';

/// Opened from a recommended place card's "See more" button — the
/// destination's full details plus a CTA that feeds straight into the
/// real trip-planning flow, pre-filled with this place as the destination.
class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final RecommendedPlace place;

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  bool _isFavorite = false;

  void _planTripHere() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlanTripScreen(initialDestination: widget.place.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _HeroImage(
                  place: place,
                  isFavorite: _isFavorite,
                  onToggleFavorite: () =>
                      setState(() => _isFavorite = !_isFavorite),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(place.name, style: AppTypography.h1),
                          ),
                          const Icon(
                            LucideIcons.star,
                            size: 18,
                            color: AppColors.accentAmber,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            place.rating.toStringAsFixed(1),
                            style: AppTypography.bodyEmphasis,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.mapPin,
                            size: 14,
                            color: AppColors.ink300,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            place.location,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.ink600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        place.price,
                        style: AppTypography.h2.copyWith(
                          color: AppColors.accentTerracotta,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.lg),
                      Text('About', style: AppTypography.bodyEmphasis),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        place.description,
                        style: AppTypography.body.copyWith(
                          color: AppColors.ink600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Things to do', style: AppTypography.bodyEmphasis),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final highlight in place.highlights)
                            _HighlightChip(highlight: highlight),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.lg),
                      _InfoRow(
                        icon: LucideIcons.calendarDays,
                        label: 'Best time to visit',
                        value: place.bestTimeToVisit,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _InfoRow(
                        icon: LucideIcons.mapPin,
                        label: 'Location',
                        value: place.location,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(color: AppColors.surface0),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: AppShadows.glow(AppColors.primary500),
                  ),
                  child: PrimaryButton(
                    label: 'Plan a trip here',
                    onPressed: _planTripHere,
                    expand: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({
    required this.place,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final RecommendedPlace place;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  static const double _height = 280;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            place.imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.primary),
              child: Icon(
                LucideIcons.mountain,
                color: AppColors.surface0,
                size: 48,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Colors.transparent],
                stops: [0, 0.3],
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.lg,
            child: SafeArea(
              bottom: false,
              child: CircleIconButton(
                icon: LucideIcons.arrowLeft,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.lg,
            child: SafeArea(
              bottom: false,
              child: CircleIconButton(
                icon: LucideIcons.heart,
                iconColor: isFavorite
                    ? AppColors.accentTerracotta
                    : Colors.white,
                onTap: onToggleFavorite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({required this.highlight});

  final PlaceHighlight highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: AppRadius.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(highlight.icon, size: 15, color: AppColors.primary700),
          const SizedBox(width: AppSpacing.xs),
          Text(
            highlight.label,
            style: AppTypography.captionEmphasis.copyWith(
              color: AppColors.primary700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primary100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.primary700),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.captionEmphasis.copyWith(
                  color: AppColors.ink600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(value, style: AppTypography.bodyEmphasis),
            ],
          ),
        ),
      ],
    );
  }
}
