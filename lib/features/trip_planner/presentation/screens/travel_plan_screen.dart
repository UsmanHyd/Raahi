import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../widgets/add_stop_sheet.dart';

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

/// The finished trip plan — the payoff screen at the end of the whole
/// Plan Trip → Add Places → Route Preview → Hotels flow. Day 1 reuses the
/// same drive/stopover beats as [RoutePreviewScreen]'s mocked timeline;
/// later days are generic placeholder activities, since there's no real
/// day-by-day itinerary generation yet — only the trip's actual
/// start/destination/hotel/dates are real.
class TravelPlanScreen extends StatefulWidget {
  const TravelPlanScreen({
    super.key,
    required this.startingFrom,
    required this.destinationName,
    required this.hotelName,
    this.dateRange,
  });

  final String startingFrom;
  final String destinationName;
  final String hotelName;
  final DateTimeRange? dateRange;

  @override
  State<TravelPlanScreen> createState() => _TravelPlanScreenState();
}

class _TravelPlanScreenState extends State<TravelPlanScreen> {
  late final int _dayCount;
  late final List<List<_PlanActivity>> _days;
  int _selectedDay = 0;

  @override
  void initState() {
    super.initState();
    _dayCount = widget.dateRange == null
        ? 5
        : widget.dateRange!.end.difference(widget.dateRange!.start).inDays + 1;
    _days = List.generate(_dayCount, _buildDay);
  }

  List<_PlanActivity> _buildDay(int index) {
    final isFirstDay = index == 0;
    final isLastDay = index == _dayCount - 1 && _dayCount > 1;

    if (isFirstDay) {
      return [
        _PlanActivity(
          time: '09:00 AM',
          title: 'Depart ${widget.startingFrom}',
          subtitle: 'Starting point of your road trip',
          icon: LucideIcons.car,
        ),
        const _PlanActivity(
          time: '12:30 PM',
          title: 'Besham Rest Stop',
          subtitle: 'Lunch by the Indus River',
          icon: LucideIcons.utensils,
        ),
        _PlanActivity(
          time: '04:30 PM',
          title: 'Arrive ${widget.destinationName}',
          subtitle: 'Check-in at ${widget.hotelName}',
          icon: LucideIcons.bedDouble,
        ),
      ];
    }

    if (isLastDay) {
      return [
        _PlanActivity(
          time: '08:00 AM',
          title: 'Breakfast at ${widget.hotelName}',
          subtitle: 'Fuel up before the drive back',
          icon: LucideIcons.coffee,
        ),
        const _PlanActivity(
          time: '10:00 AM',
          title: 'Check-out',
          subtitle: 'Pack up and settle the room',
          icon: LucideIcons.bedDouble,
        ),
        _PlanActivity(
          time: '11:00 AM',
          title: 'Depart for ${widget.startingFrom}',
          subtitle: 'Head back the way you came',
          icon: LucideIcons.car,
        ),
      ];
    }

    return [
      _PlanActivity(
        time: '08:00 AM',
        title: 'Breakfast at ${widget.hotelName}',
        subtitle: 'Start the day fueled up',
        icon: LucideIcons.coffee,
      ),
      _PlanActivity(
        time: '10:00 AM',
        title: 'Explore ${widget.destinationName}',
        subtitle: 'Local sights and viewpoints',
        icon: LucideIcons.mountain,
      ),
      const _PlanActivity(
        time: '01:00 PM',
        title: 'Local lunch spot',
        subtitle: 'Try regional specialties',
        icon: LucideIcons.utensils,
      ),
      _PlanActivity(
        time: '07:00 PM',
        title: 'Free evening',
        subtitle: 'Relax at ${widget.hotelName}',
        icon: LucideIcons.moon,
      ),
    ];
  }

  DateTime? _dateForDay(int index) {
    final range = widget.dateRange;
    if (range == null) return null;
    return range.start.add(Duration(days: index));
  }

  Future<void> _addActivity() async {
    final place = await showModalBottomSheet<NearbyPlace>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddStopSheet(nearbyToLabel: widget.destinationName),
    );
    if (place == null) return;
    setState(
      () => _days[_selectedDay].add(
        _PlanActivity(
          time: 'Anytime',
          title: place.name,
          subtitle: '${place.distanceLabel} from ${widget.destinationName}',
          icon: LucideIcons.mapPin,
        ),
      ),
    );
  }

  void _shareItinerary() {
    // TODO: build a real share/export once there's a share_plus dependency
    // to flag and add — for now this just confirms the tap registered.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing your plan isn\'t available yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = _dateForDay(_selectedDay);

    return Scaffold(
      backgroundColor: AppColors.surface50,
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        backgroundColor: AppColors.primary700,
        child: const Icon(LucideIcons.plus, color: AppColors.surface0),
      ),
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
                  Expanded(
                    child: Text(
                      'Your plan',
                      style: AppTypography.h1.copyWith(
                        color: AppColors.surface0,
                      ),
                    ),
                  ),
                  CircleIconButton(
                    icon: LucideIcons.share2,
                    onTap: _shareItinerary,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _TripOverviewCard(
                  startingFrom: widget.startingFrom,
                  destinationName: widget.destinationName,
                  hotelName: widget.hotelName,
                  dayCount: _dayCount,
                  dateRange: widget.dateRange,
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dayCount,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) => _DayTab(
                      label: 'Day ${index + 1}',
                      selected: index == _selectedDay,
                      onTap: () => setState(() => _selectedDay = index),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  date == null
                      ? 'Day ${_selectedDay + 1}'
                      : '${_weekdayNames[date.weekday - 1]}, '
                                '${_monthAbbreviations[date.month - 1]} ${date.day}'
                            .toUpperCase(),
                  style: AppTypography.captionEmphasis.copyWith(
                    color: AppColors.ink600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _DayTimeline(activities: _days[_selectedDay]),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripOverviewCard extends StatelessWidget {
  const _TripOverviewCard({
    required this.startingFrom,
    required this.destinationName,
    required this.hotelName,
    required this.dayCount,
    this.dateRange,
  });

  final String startingFrom;
  final String destinationName;
  final String hotelName;
  final int dayCount;
  final DateTimeRange? dateRange;

  @override
  Widget build(BuildContext context) {
    final range = dateRange;
    final dateLabel = range == null
        ? '$dayCount days'
        : '${_monthAbbreviations[range.start.month - 1]} ${range.start.day} '
              '- ${_monthAbbreviations[range.end.month - 1]} ${range.end.day}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.glow(AppColors.primary500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.route,
                size: 18,
                color: AppColors.surface0,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '$startingFrom → $destinationName',
                  style: AppTypography.bodyEmphasis.copyWith(
                    color: AppColors.surface0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _OverviewChip(icon: LucideIcons.calendar, label: dateLabel),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _OverviewChip(
                  icon: LucideIcons.bedDouble,
                  label: hotelName,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewChip extends StatelessWidget {
  const _OverviewChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface0.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.surface0),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              style: AppTypography.caption.copyWith(color: AppColors.surface0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
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
        child: Text(
          label,
          style: AppTypography.captionEmphasis.copyWith(
            color: selected ? AppColors.surface0 : AppColors.ink600,
          ),
        ),
      ),
    );
  }
}

class _DayTimeline extends StatelessWidget {
  const _DayTimeline({required this.activities});

  final List<_PlanActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < activities.length; i++)
          _ActivityRow(
            activity: activities[i],
            isLast: i == activities.length - 1,
          ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity, required this.isLast});

  final _PlanActivity activity;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.xs),
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.primary700,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: AppColors.border)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface0,
                  borderRadius: AppRadius.cardRadius,
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        activity.icon,
                        size: 18,
                        color: AppColors.primary700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.time,
                            style: AppTypography.captionEmphasis.copyWith(
                              color: AppColors.primary700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            activity.title,
                            style: AppTypography.bodyEmphasis,
                          ),
                          Text(
                            activity.subtitle,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.ink600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanActivity {
  const _PlanActivity({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String time;
  final String title;
  final String subtitle;
  final IconData icon;
}
