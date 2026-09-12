import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// One row in the profile screen's menu card — icon, label, and an
/// optional trailing chevron. Reused so each row stays visually
/// consistent as more are added later.
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.ink900,
    this.showChevron = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyEmphasis.copyWith(color: color),
                ),
              ),
              if (showChevron)
                const Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: AppColors.ink300,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
