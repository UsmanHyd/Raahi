import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../screens/place_detail_screen.dart';

/// A single card in the "Recommended" swipeable stack.
///
/// Tapping the card reveals a "See more" button (rather than navigating
/// immediately); tapping that button opens [PlaceDetailScreen]. This tap
/// handling is independent of the card-swiper's own drag gesture, so
/// swipe-to-dismiss keeps working normally.
class RecommendedPlaceCard extends StatefulWidget {
  const RecommendedPlaceCard({
    super.key,
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

  @override
  State<RecommendedPlaceCard> createState() => _RecommendedPlaceCardState();
}

class _RecommendedPlaceCardState extends State<RecommendedPlaceCard> {
  bool _revealed = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.cardRadius,
      child: GestureDetector(
        onTap: () => setState(() => _revealed = !_revealed),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              widget.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary500, AppColors.primary700],
                  ),
                ),
                child: const Icon(
                  Icons.terrain_outlined,
                  color: AppColors.surface0,
                  size: 48,
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.lg,
              left: AppSpacing.lg,
              child: _RatingBadge(rating: widget.rating),
            ),
            Positioned(
              top: AppSpacing.lg,
              right: AppSpacing.lg,
              child: _FavoriteButton(
                isFavorite: _isFavorite,
                onTap: () => setState(() => _isFavorite = !_isFavorite),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xxxl,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.name,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.surface0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      widget.location,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.surface0.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.price,
                          style: AppTypography.bodyEmphasis.copyWith(
                            color: AppColors.surface0,
                          ),
                        ),
                        AnimatedSlide(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          offset: _revealed ? Offset.zero : const Offset(0, 0.6),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 220),
                            opacity: _revealed ? 1 : 0,
                            child: IgnorePointer(
                              ignoring: !_revealed,
                              child: FilledButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PlaceDetailScreen(placeName: widget.name),
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary700,
                                  foregroundColor: AppColors.surface0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg,
                                    vertical: AppSpacing.sm,
                                  ),
                                  shape: const StadiumBorder(),
                                  textStyle: AppTypography.buttonLabel,
                                ),
                                child: const Text('See more'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface0.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.accentAmber, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Text(rating.toStringAsFixed(1), style: AppTypography.captionEmphasis),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface0.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.accentTerracotta : AppColors.ink600,
            size: 18,
          ),
        ),
      ),
    );
  }
}
