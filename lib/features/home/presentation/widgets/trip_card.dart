import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// A single trip shown in the horizontally-scrolling "Recent trips" list.
class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.imageAsset,
    required this.name,
    required this.dateRangeLabel,
    required this.travelerCount,
  });

  final String imageAsset;
  final String name;
  final String dateRangeLabel;
  final int travelerCount;

  static const double _width = 160;
  static const double _imageHeight = 90;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface0,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.cardRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imageAsset,
                height: _imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: _imageHeight,
                  width: double.infinity,
                  color: AppColors.primary100,
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.primary700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.bodyEmphasis,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$dateRangeLabel · $travelerCount travelers',
                      style: AppTypography.caption,
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
