import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/trip_calendar_sheet.dart';
import 'add_places_screen.dart';

const _monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// The trip-planning form opened from Home's "Plan a new trip" card.
///
/// All fields are hardcoded/local state for this UI-first pass — no
/// backend to submit to yet, so "Plan my trip" and the location fields are
/// TODOs. The date range picker is real (a custom calendar, not the stock
/// Material one — see [TripCalendarSheet]) since it costs nothing extra to
/// wire up properly.
class PlanTripScreen extends StatefulWidget {
  const PlanTripScreen({super.key});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  static const List<String> _budgetLevels = ['Budget', 'Mid-range', 'Premium'];

  final _startingFromController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTimeRange? _dateRange;
  int _travelerCount = 2;
  int _budgetIndex = 1;

  @override
  void dispose() {
    _startingFromController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (context) => TripCalendarSheet(initialRange: _dateRange),
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  void _incrementTravelers() => setState(() => _travelerCount++);

  void _decrementTravelers() {
    if (_travelerCount > 1) setState(() => _travelerCount--);
  }

  void _planTrip() {
    final destination = _destinationController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddPlacesScreen(
          destinationName: destination.isEmpty
              ? 'your destination'
              : destination,
          dateRange: _dateRange,
        ),
      ),
    );
  }

  String get _formattedDateRange {
    final range = _dateRange;
    if (range == null) return 'Select trip dates';
    final start = range.start;
    final end = range.end;
    final startLabel = '${_monthAbbreviations[start.month - 1]} ${start.day}';
    final endLabel = '${_monthAbbreviations[end.month - 1]} ${end.day}';
    return '$startLabel - $endLabel';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface50,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              decoration: const BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.sheet),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: LucideIcons.arrowLeft,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Plan your trip',
                      style: AppTypography.h1.copyWith(
                        color: AppColors.surface0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - AppSpacing.lg * 2,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TripFormCard(
                            children: [
                              _EditableFieldRow(
                                icon: LucideIcons.circleDot,
                                label: 'Starting from',
                                controller: _startingFromController,
                              ),
                              const Divider(
                                height: AppSpacing.xxl,
                                color: AppColors.border,
                              ),
                              _EditableFieldRow(
                                icon: LucideIcons.navigation,
                                label: 'Destination',
                                controller: _destinationController,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _TripFormCard(
                            children: [
                              _FormFieldRow(
                                icon: LucideIcons.calendar,
                                label: 'TRIP DATES',
                                value: _formattedDateRange,
                                isPlaceholder: _dateRange == null,
                                onTap: _pickDateRange,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _TripFormCard(
                            children: [
                              _TravelerStepper(
                                count: _travelerCount,
                                onIncrement: _incrementTravelers,
                                onDecrement: _decrementTravelers,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _TripFormCard(
                            children: [
                              Text(
                                'TRAVEL BUDGET LEVEL',
                                style: AppTypography.captionEmphasis.copyWith(
                                  color: AppColors.ink600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _BudgetLevelSelector(
                                levels: _budgetLevels,
                                selectedIndex: _budgetIndex,
                                onChanged: (index) =>
                                    setState(() => _budgetIndex = index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface0,
                boxShadow: AppShadows.card,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: SafeArea(
                  top: false,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: AppShadows.glow(AppColors.primary500),
                    ),
                    child: PrimaryButton(
                      label: 'Plan my trip',
                      onPressed: _planTrip,
                      expand: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripFormCard extends StatelessWidget {
  const _TripFormCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// A free-text input for Starting From / Destination. [label] doubles as
/// the field's only visible content when empty and unfocused; on focus it
/// shrinks and floats to the top while a green outline box appears around
/// the whole field — Material's built-in floating-label animation, so no
/// hand-rolled animation code is needed for it.
class _EditableFieldRow extends StatelessWidget {
  const _EditableFieldRow({
    required this.icon,
    required this.label,
    required this.controller,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide.none,
    );

    return TextField(
      controller: controller,
      style: AppTypography.bodyEmphasis,
      cursorColor: AppColors.primary700,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodyEmphasis.copyWith(
          color: AppColors.ink600,
        ),
        floatingLabelStyle: AppTypography.captionEmphasis.copyWith(
          color: AppColors.primary700,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: AppColors.primary700),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        border: outline,
        enabledBorder: outline,
        focusedBorder: outline.copyWith(
          borderSide: const BorderSide(color: AppColors.primary700, width: 1.5),
        ),
      ),
    );
  }
}

class _FormFieldRow extends StatelessWidget {
  const _FormFieldRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  /// True when [value] is hint copy rather than a real selection (e.g. no
  /// location/date picked yet) — renders muted instead of bold ink-900.
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary700),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.captionEmphasis.copyWith(
                    color: AppColors.ink600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: isPlaceholder
                      ? AppTypography.body.copyWith(color: AppColors.ink300)
                      : AppTypography.bodyEmphasis,
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: AppColors.ink300),
        ],
      ),
    );
  }
}

class _TravelerStepper extends StatelessWidget {
  const _TravelerStepper({
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Travelers', style: AppTypography.bodyEmphasis),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Number of people on road trip',
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
        _StepperButton(
          icon: LucideIcons.minus,
          onTap: onDecrement,
          filled: false,
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$count',
            textAlign: TextAlign.center,
            style: AppTypography.bodyEmphasis,
          ),
        ),
        _StepperButton(
          icon: LucideIcons.plus,
          onTap: onIncrement,
          filled: true,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: filled ? AppGradients.primary : null,
            color: filled ? null : AppColors.surface0,
            shape: BoxShape.circle,
            border: filled ? null : Border.all(color: AppColors.border),
          ),
          child: Icon(
            icon,
            size: 16,
            color: filled ? AppColors.surface0 : AppColors.ink600,
          ),
        ),
      ),
    );
  }
}

class _BudgetLevelSelector extends StatelessWidget {
  const _BudgetLevelSelector({
    required this.levels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> levels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface50,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          for (var i = 0; i < levels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    gradient: i == selectedIndex ? AppGradients.primary : null,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: i == selectedIndex
                        ? AppShadows.glow(AppColors.primary500)
                        : null,
                  ),
                  child: Text(
                    levels[i],
                    textAlign: TextAlign.center,
                    style: AppTypography.captionEmphasis.copyWith(
                      color: i == selectedIndex
                          ? AppColors.surface0
                          : AppColors.ink600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
