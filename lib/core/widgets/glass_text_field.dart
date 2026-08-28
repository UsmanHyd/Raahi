import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'glass_surface.dart';

/// The glass equivalent of [AppTextField] — same label treatment, but the
/// input sits inside a [GlassSurface] instead of a flat bordered box. Use
/// on screens that use the glass design language.
class GlassTextField extends StatelessWidget {
  const GlassTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionEmphasis.copyWith(
            color: AppColors.ink900,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GlassSurface(
          borderRadius: BorderRadius.circular(AppRadius.input),
          tintOpacity: 0.55,
          boxShadow: AppShadows.card,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppTypography.body,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.body.copyWith(color: AppColors.ink300),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
