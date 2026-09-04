import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Placeholder detail screen opened from a recommended place's "See more"
/// button — the full itinerary/booking UI comes in a later pass.
class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.placeName});

  final String placeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      appBar: AppBar(title: Text(placeName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            '$placeName — full details coming soon',
            textAlign: TextAlign.center,
            style: AppTypography.body,
          ),
        ),
      ),
    );
  }
}
