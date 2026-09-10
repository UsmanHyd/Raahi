import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../domain/entities/trip.dart';

/// The "Confirmed" / "Ongoing" / "Completed" pill shown on a [TripCard] and
/// on [TripDetailScreen]'s hero header — filled with a status color instead
/// of the app's usual neutral badge, so a trip's state reads at a glance.
class TripStatusBadge extends StatelessWidget {
  const TripStatusBadge({super.key, required this.status});

  final TripStatus status;

  Color get _color => switch (status) {
    TripStatus.confirmed => AppColors.primary700,
    TripStatus.ongoing => AppColors.accentAmber,
    TripStatus.completed => AppColors.ink600,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: AppRadius.chipRadius,
        boxShadow: AppShadows.glow(_color),
      ),
      child: Text(
        status.label,
        style: AppTypography.captionEmphasis.copyWith(
          color: AppColors.surface0,
        ),
      ),
    );
  }
}
