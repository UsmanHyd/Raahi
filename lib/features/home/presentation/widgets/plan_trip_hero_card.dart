import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// The primary Home CTA: a full-bleed photo card, tinted with a bold
/// gradient scrim and finished with a soft colored glow, inviting the user
/// to plan a new trip.
class PlanTripHeroCard extends StatelessWidget {
  const PlanTripHeroCard({super.key, this.onTap});

  final VoidCallback? onTap;

  static const String _imageAsset = 'assets/home/hero_road.jpg';
  static const double _height = 210;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          borderRadius: AppRadius.sheetRadiusAll,
          boxShadow: AppShadows.glow(AppColors.primary500),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.sheetRadiusAll,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const DecoratedBox(
                      decoration: BoxDecoration(gradient: AppGradients.primary),
                    ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary700.withValues(alpha: 0.75),
                      AppColors.primary500.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.lg,
                left: AppSpacing.lg,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppGradients.sunset,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '🔥 Trending',
                    style: AppTypography.captionEmphasis.copyWith(
                      color: AppColors.surface0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Plan a new trip',
                      style: AppTypography.display.copyWith(
                        color: AppColors.surface0,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Custom itinerary for northern road trips',
                      style: AppTypography.body.copyWith(
                        color: AppColors.surface0.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface0,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Start planning',
                            style: AppTypography.buttonLabel.copyWith(
                              color: AppColors.primary700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(
                            LucideIcons.arrowRight,
                            color: AppColors.primary700,
                            size: 18,
                          ),
                        ],
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
