import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// One selectable option in a [SettingsSegmentedControl].
class SegmentOption<T> {
  const SegmentOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// A pill-shaped segmented control (e.g. "km / miles", "Light / Dark /
/// System") — a track on [AppColors.surface100] with the selected segment
/// raised on a white chip.
class SettingsSegmentedControl<T> extends StatelessWidget {
  const SettingsSegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<SegmentOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: AppRadius.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in options)
            GestureDetector(
              onTap: () => onChanged(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: option.value == selected
                      ? AppColors.surface0
                      : Colors.transparent,
                  borderRadius: AppRadius.chipRadius,
                  boxShadow: option.value == selected ? AppShadows.card : null,
                ),
                child: Text(
                  option.label,
                  style: AppTypography.captionEmphasis.copyWith(
                    color: option.value == selected
                        ? AppColors.primary700
                        : AppColors.ink600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
