import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

/// Standard labeled text field: a label above a surface-0 input. Use this
/// for every form field instead of a bare [TextFormField].
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.labelStyle,
    this.borderRadius = AppRadius.input,
    this.showBorder = true,
    this.boxShadow,
  });

  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  /// Defaults to the 13/Semibold ink-900 label style. Override for screens
  /// whose design calls for a lighter/regular-weight label.
  final TextStyle? labelStyle;

  /// Defaults to [AppRadius.input] (12). Override for screens whose design
  /// calls for a fully-rounded pill field instead.
  final double borderRadius;

  /// Defaults to true (hairline border per the design system). Set false
  /// for a borderless field that relies on [boxShadow] for separation
  /// instead.
  final bool showBorder;

  /// Optional drop shadow, useful when [showBorder] is false and the field
  /// needs to visually lift off its background some other way.
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: showBorder
          ? const BorderSide(color: AppColors.border)
          : BorderSide.none,
    );

    final field = TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTypography.body,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.body.copyWith(color: AppColors.ink300),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surface0,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.primary500),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              AppTypography.captionEmphasis.copyWith(color: AppColors.ink900),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (boxShadow == null)
          field
        else
          Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: boxShadow,
            ),
            child: field,
          ),
      ],
    );
  }
}
