import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// A bottom-sheet calendar for picking a trip's start/end dates.
///
/// Tap a day to set the start; tap another to set the end (order is
/// corrected automatically if the second tap lands before the first).
/// Tapping an already-selected start or end again clears just that one,
/// so it can be re-picked without starting over. Days between the two
/// selections are highlighted to show the range at a glance.
///
/// Returns the picked [DateTimeRange] via `Navigator.pop`, or null if
/// dismissed without completing a selection.
class TripCalendarSheet extends StatefulWidget {
  const TripCalendarSheet({super.key, this.initialRange});

  final DateTimeRange? initialRange;

  @override
  State<TripCalendarSheet> createState() => _TripCalendarSheetState();
}

class _TripCalendarSheetState extends State<TripCalendarSheet> {
  late DateTime _visibleMonth;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange?.start;
    _end = widget.initialRange?.end;
    final anchor = _start ?? DateTime.now();
    _visibleMonth = DateTime(anchor.year, anchor.month);
  }

  void _onDayTap(DateTime day) {
    setState(() {
      final start = _start;
      final end = _end;
      if (start != null && _isSameDay(day, start)) {
        _start = null;
      } else if (end != null && _isSameDay(day, end)) {
        _end = null;
      } else if (start == null && end == null) {
        _start = day;
      } else if (start != null && end == null) {
        if (day.isBefore(start)) {
          _end = start;
          _start = day;
        } else {
          _end = day;
        }
      } else if (start == null && end != null) {
        if (day.isAfter(end)) {
          _start = end;
          _end = day;
        } else {
          _start = day;
        }
      } else {
        _start = day;
        _end = null;
      }
    });
  }

  void _changeMonth(int delta) {
    setState(
      () => _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + delta,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = _start != null && _end != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select trip dates', style: AppTypography.h2),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x, color: AppColors.ink600),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(
                    LucideIcons.chevronLeft,
                    color: AppColors.ink600,
                  ),
                ),
                Text(
                  '${_monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                  style: AppTypography.bodyEmphasis,
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.ink600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                for (final label in _weekdayLabels)
                  Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.ink300,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            _CalendarMonthGrid(
              month: _visibleMonth,
              start: _start,
              end: _end,
              onDayTap: _onDayTap,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Apply dates',
              expand: true,
              onPressed: canConfirm
                  ? () => Navigator.of(
                      context,
                    ).pop(DateTimeRange(start: _start!, end: _end!))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarMonthGrid extends StatelessWidget {
  const _CalendarMonthGrid({
    required this.month,
    required this.start,
    required this.end,
    required this.onDayTap,
  });

  final DateTime month;
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = DateTime(month.year, month.month, 1).weekday % 7;
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leadingBlanks + daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        if (index < leadingBlanks) return const SizedBox.shrink();

        final day = DateTime(
          month.year,
          month.month,
          index - leadingBlanks + 1,
        );
        final isPast = day.isBefore(todayDateOnly);
        final isStart = start != null && _isSameDay(day, start!);
        final isEnd = end != null && _isSameDay(day, end!);
        final isInRange =
            start != null &&
            end != null &&
            day.isAfter(start!) &&
            day.isBefore(end!);

        return _CalendarDayCell(
          day: day,
          isStart: isStart,
          isEnd: isEnd,
          isInRange: isInRange,
          hasRangeStart: start != null,
          hasRangeEnd: end != null,
          isPast: isPast,
          onTap: isPast ? null : () => onDayTap(day),
        );
      },
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.isStart,
    required this.isEnd,
    required this.isInRange,
    required this.hasRangeStart,
    required this.hasRangeEnd,
    required this.isPast,
    required this.onTap,
  });

  final DateTime day;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final bool hasRangeStart;
  final bool hasRangeEnd;
  final bool isPast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEndpoint = isStart || isEnd;

    Widget connector = const SizedBox.shrink();
    if (isInRange) {
      connector = Container(color: AppColors.primary100);
    } else if (isStart && hasRangeEnd) {
      connector = Row(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(child: Container(color: AppColors.primary100)),
        ],
      );
    } else if (isEnd && hasRangeStart) {
      connector = Row(
        children: [
          Expanded(child: Container(color: AppColors.primary100)),
          const Expanded(child: SizedBox()),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Stack(
          children: [
            Positioned.fill(child: connector),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isEndpoint ? AppColors.primary700 : null,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: AppTypography.bodyEmphasis.copyWith(
                        color: isEndpoint
                            ? AppColors.surface0
                            : isPast
                            ? AppColors.ink300
                            : AppColors.ink900,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                    child: isEndpoint
                        ? Text(
                            isStart ? 'Start' : 'End',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              color: AppColors.primary700,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
