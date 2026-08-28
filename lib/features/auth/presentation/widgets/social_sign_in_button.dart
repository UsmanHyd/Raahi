import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Outlined "`<provider>`" button: brand logo + label, pill-radius per the
/// button component pattern. Meant to sit side-by-side with its counterpart
/// inside a [Row] of [Expanded] children.
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.logoAsset,
    required this.label,
    required this.onPressed,
  });

  final String logoAsset;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface0,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(logoAsset, width: 20, height: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.buttonLabel.copyWith(
              color: AppColors.ink900,
              height: 22 / 15,
            ),
          ),
        ],
      ),
    );
  }
}
