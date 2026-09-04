import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../screens/other_suggestions_screen.dart';

/// The static final card shown once every "Recommended" card has been
/// swiped away. Not swipeable — its button opens [OtherSuggestionsScreen].
class RecommendedEmptyStateCard extends StatelessWidget {
  const RecommendedEmptyStateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.explore_off_outlined,
            size: 40,
            color: AppColors.ink300,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "Not what you're looking for?",
            style: AppTypography.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "You've been through all our current picks.",
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'View other suggestions',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OtherSuggestionsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
