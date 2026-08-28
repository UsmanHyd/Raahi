import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'glass_surface.dart';

/// A tappable [GlassSurface] pill — the glass equivalent of [PrimaryButton].
/// Use for CTAs on screens that use the glass design language.
class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.expand = false,
    this.tintColor = Colors.white,
    this.tintOpacity = 0.28,
    this.textColor = Colors.white,
    this.boxShadow,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? leading;
  final bool expand;
  final Color tintColor;
  final double tintOpacity;
  final Color textColor;
  final List<BoxShadow>? boxShadow;

  static const double _radius = 999;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_radius),
        child: GlassSurface(
          borderRadius: BorderRadius.circular(_radius),
          tintColor: tintColor,
          tintOpacity: tintOpacity,
          boxShadow: boxShadow,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: AppTypography.buttonLabel.copyWith(
                  color: textColor,
                  height: 22 / 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
