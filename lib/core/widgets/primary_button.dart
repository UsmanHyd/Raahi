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
    this.backgroundColor = AppColors.primary700,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Full-width, for form screens. Defaults to false (content-sized), which
  /// is the shape used for inline CTAs like the onboarding "Next" button.
  final bool expand;

  /// Defaults to primary-700. Override only when a screen's design calls
  /// for a different fill (e.g. a dark/black CTA) — most screens should
  /// leave this at the default so the primary action stays visually
  /// consistent across the app.
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.4),
        foregroundColor: AppColors.surface0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
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
