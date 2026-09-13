import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// One tappable row inside a [SettingsSection] — icon, label, an optional
/// trailing value, and a chevron. Used for rows that open a picker/detail
/// (e.g. Language) rather than toggling in place.
class SettingsNavRow extends StatelessWidget {
  const SettingsNavRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary700),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(label, style: AppTypography.bodyEmphasis)),
              if (value != null) ...[
                Text(
                  value!,
                  style: AppTypography.body.copyWith(color: AppColors.ink600),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              if (onTap != null)
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.ink300,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
