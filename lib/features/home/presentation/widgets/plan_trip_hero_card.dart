import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// The primary Home CTA: a photo card inviting the user to plan a new trip.
class PlanTripHeroCard extends StatelessWidget {
  const PlanTripHeroCard({super.key, this.onTap});

  final VoidCallback? onTap;

  static const String _imageAsset = 'assets/home/hero_road.jpg';
  static const double _imageHeight = 150;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface0,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.cardRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                _imageAsset,
                height: _imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: _imageHeight,
                  width: double.infinity,
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
                    size: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Plan a new trip', style: AppTypography.h2),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Custom itinerary for northern road trips',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primary700,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.surface0,
                        size: 18,
                      ),
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
