import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Horizontal "Day 1 / Day 2 / …" pill tabs for browsing a trip's
/// itinerary — same gradient-pill idiom as travel_plan_screen's day tabs.
/// A small check mark overlays any day already marked complete.
class TripDaySelector extends StatelessWidget {
  const TripDaySelector({
    super.key,
    required this.dayCount,
    required this.selectedIndex,
    required this.completedDays,
    required this.onSelect,
  });

  final int dayCount;
  final int selectedIndex;
  final Set<int> completedDays;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dayCount,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final dayNumber = index + 1;
          return _DayTab(
            label: 'Day $dayNumber',
            selected: index == selectedIndex,
            completed: completedDays.contains(dayNumber),
            onTap: () => onSelect(index),
          );
        },
      ),
    );
  }
}

class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.label,
    required this.selected,
    required this.completed,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? AppGradients.primary : null,
          color: selected ? null : AppColors.surface0,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected ? AppShadows.glow(AppColors.primary500) : null,
          border: selected ? null : Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (completed) ...[
              Icon(
                LucideIcons.circleCheck,
                size: 14,
                color: selected ? AppColors.surface0 : AppColors.primary700,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTypography.captionEmphasis.copyWith(
                color: selected ? AppColors.surface0 : AppColors.ink600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
