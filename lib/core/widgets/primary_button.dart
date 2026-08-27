import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

/// The app's single primary CTA style — fully rounded pill, primary-700 fill,
/// white 15/Semibold label. Reuse this everywhere a primary action button is
/// needed instead of styling FilledButton/ElevatedButton per screen.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Full-width, for form screens. Defaults to false (content-sized), which
  /// is the shape used for inline CTAs like the onboarding "Next" button.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary700,
        foregroundColor: AppColors.surface0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: const StadiumBorder(),
        textStyle: AppTypography.buttonLabel,
      ),
      child: Text(label),
    );

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
