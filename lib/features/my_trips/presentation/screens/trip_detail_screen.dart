import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/trip.dart';
import '../widgets/trip_day_selector.dart';
import '../widgets/trip_stop_card.dart';

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
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

/// Opened by tapping a trip card — the trip's cover photo, summary, and a
/// day-by-day itinerary. Each day's stops can carry notes and photo/video
/// memories (in-memory only — nothing persists past this screen yet), and a
/// day can be marked complete once its stops are done.
class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key, required this.trip});

  final Trip trip;

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  int _selectedDayIndex = 0;
  final Set<int> _completedDays = {};

  void _completeDay(int dayNumber) {
    setState(() => _completedDays.add(dayNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Day $dayNumber marked as complete'),
        backgroundColor: AppColors.primary700,
      ),
    );
  }

  String _dayDateLabel(DateTime date) =>
      '${_weekdayNames[date.weekday - 1]}, '
      '${_monthAbbreviations[date.month - 1]} ${date.day}';

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final itinerary = trip.itinerary;
    final selectedDay = itinerary.isEmpty ? null : itinerary[_selectedDayIndex];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface50,
        body: SafeArea(
          child: Column(
            children: [
              _Header(title: trip.title),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _CoverImage(trip: trip),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trip.title, style: AppTypography.h1),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${trip.dateRangeLabel} · ${itinerary.length} '
                            '${itinerary.length == 1 ? 'day' : 'days'} · '
                            '${trip.travelerCountLabel}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.ink600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: AppSpacing.xl),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Trip itinerary', style: AppTypography.h2),
                              if (trip.status != TripStatus.completed)
                                const _LockedBadge(),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (selectedDay == null)
                            Text(
                              "This trip doesn't have an itinerary yet.",
                              style: AppTypography.caption,
                            )
                          else ...[
                            TripDaySelector(
                              dayCount: itinerary.length,
                              selectedIndex: _selectedDayIndex,
                              completedDays: _completedDays,
                              onSelect: (index) =>
                                  setState(() => _selectedDayIndex = index),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              _dayDateLabel(selectedDay.date),
                              style: AppTypography.captionEmphasis.copyWith(
                                color: AppColors.ink600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            for (final stop in selectedDay.stops) ...[
                              TripStopCard(stop: stop),
                              const SizedBox(height: AppSpacing.lg),
                            ],
                            _CompleteDayButton(
                              completed: _completedDays.contains(
                                selectedDay.dayNumber,
                              ),
                              onComplete: () =>
                                  _completeDay(selectedDay.dayNumber),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xxxl),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface0,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          CircleIconButton(
            icon: LucideIcons.arrowLeft,
            backgroundColor: AppColors.surface100,
            iconColor: AppColors.ink900,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: AppTypography.h1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.trip});

  final Trip trip;

  static const double _height = 190;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: double.infinity,
      child: Image.asset(
        trip.coverImageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const DecoratedBox(
          decoration: BoxDecoration(gradient: AppGradients.primary),
          child: Icon(
            LucideIcons.mountain,
            color: AppColors.surface0,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class _LockedBadge extends StatelessWidget {
  const _LockedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: AppRadius.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.lock, size: 12, color: AppColors.primary700),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Locked',
            style: AppTypography.captionEmphasis.copyWith(
              color: AppColors.primary700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompleteDayButton extends StatelessWidget {
  const _CompleteDayButton({required this.completed, required this.onComplete});

  final bool completed;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.primary100,
          borderRadius: AppRadius.chipRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.circleCheck,
              size: 18,
              color: AppColors.primary700,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Day completed',
              style: AppTypography.buttonLabel.copyWith(
                color: AppColors.primary700,
              ),
            ),
          ],
        ),
      );
    }

    return PrimaryButton(
      label: 'Mark day as complete',
      onPressed: onComplete,
      expand: true,
    );
  }
}
