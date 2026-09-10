import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/trip.dart';
import 'trip_status_badge.dart';

/// The cover card for a single trip — reused for every trip on the My Trips
/// tab, so the list stays DRY as more trips are added. Cover photo up top,
/// a day-count badge floating on it, then a title/status row and a
/// date-range/traveler-count line underneath.
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onTap});

  final Trip trip;
  final VoidCallback onTap;

  static const double _imageHeight = 170;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = trip.status != TripStatus.completed;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        boxShadow: isUpcoming
            ? AppShadows.glow(AppColors.primary500)
            : AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: Material(
          color: AppColors.surface0,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: _imageHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        trip.coverImageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: const BoxDecoration(
                            gradient: AppGradients.primary,
                          ),
                          child: const Icon(
                            LucideIcons.mountain,
                            color: AppColors.surface0,
                            size: 40,
                          ),
                        ),
                      ),
                      Positioned(
                        top: AppSpacing.md,
                        left: AppSpacing.md,
                        child: _DurationBadge(nightCount: trip.nightCount),
                      ),
                    ],
                  ),
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
                            child: Text(
                              trip.title,
                              style: AppTypography.h2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          TripStatusBadge(status: trip.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.calendar,
                            size: 14,
                            color: AppColors.ink300,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            trip.dateRangeLabel,
                            style: AppTypography.caption,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(
                            LucideIcons.users,
                            size: 14,
                            color: AppColors.ink300,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            trip.travelerCountLabel,
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.nightCount});

  final int nightCount;

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
          const Icon(LucideIcons.clock, size: 14, color: AppColors.primary700),
          const SizedBox(width: AppSpacing.xs),
          Text(
            nightCount == 1 ? '1 night' : '$nightCount nights',
            style: AppTypography.captionEmphasis,
          ),
        ],
      ),
    );
  }
}
