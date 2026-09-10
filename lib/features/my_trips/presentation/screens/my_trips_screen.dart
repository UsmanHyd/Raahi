import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/datasources/mock_trips_data_source.dart';
import '../../domain/entities/trip.dart';
import '../widgets/my_trips_empty_state.dart';
import '../widgets/trip_card.dart';
import 'trip_detail_screen.dart';

/// The My Trips tab body: a stats strip, then trips grouped into "Upcoming"
/// and "Past" sections. Rendered inside [AppShell]'s Scaffold, so it has no
/// Scaffold or bottom nav of its own.
///
/// Data comes from [mockTrips] for this UI-first pass, same as every other
/// screen in the app — it will move behind a provider once the feature is
/// wired to real data.
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  static final List<Trip> _trips = mockTrips;

  late final AnimationController _controller;

  List<Trip> get _upcomingTrips =>
      _trips.where((trip) => trip.status != TripStatus.completed).toList();

  List<Trip> get _pastTrips =>
      _trips.where((trip) => trip.status == TripStatus.completed).toList();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openTrip(Trip trip) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip)));
  }

  Widget _animatedCard(Trip trip, int index) {
    final start = (index / _trips.length) * 0.6;
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        start.clamp(0, 1),
        (start + 0.4).clamp(0, 1),
        curve: Curves.easeOutCubic,
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, (1 - animation.value) * 28),
          child: child,
        ),
      ),
      child: TripCard(trip: trip, onTap: () => _openTrip(trip)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _upcomingTrips;
    final past = _pastTrips;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        children: [
          Text('My trips', style: AppTypography.display),
          const SizedBox(height: AppSpacing.lg),
          _TripsStatsStrip(
            totalCount: _trips.length,
            upcomingCount: upcoming.length,
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (_trips.isEmpty)
            const MyTripsEmptyState()
          else ...[
            if (upcoming.isNotEmpty) ...[
              const SectionHeader(title: 'Upcoming'),
              const SizedBox(height: AppSpacing.md),
              for (var i = 0; i < upcoming.length; i++) ...[
                _animatedCard(upcoming[i], _trips.indexOf(upcoming[i])),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
            if (past.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              const SectionHeader(title: 'Past'),
              const SizedBox(height: AppSpacing.md),
              for (var i = 0; i < past.length; i++) ...[
                _animatedCard(past[i], _trips.indexOf(past[i])),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

/// A "N trips · N upcoming" pill shown under the screen title.
class _TripsStatsStrip extends StatelessWidget {
  const _TripsStatsStrip({
    required this.totalCount,
    required this.upcomingCount,
  });

  final int totalCount;
  final int upcomingCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: AppRadius.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.luggage,
            size: 16,
            color: AppColors.primary700,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            totalCount == 1 ? '1 trip' : '$totalCount trips',
            style: AppTypography.captionEmphasis.copyWith(
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 1,
            height: 14,
            color: AppColors.primary700.withValues(alpha: 0.3),
          ),
          const SizedBox(width: AppSpacing.md),
          const Icon(
            LucideIcons.planeTakeoff,
            size: 16,
            color: AppColors.primary700,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            upcomingCount == 1 ? '1 upcoming' : '$upcomingCount upcoming',
            style: AppTypography.captionEmphasis.copyWith(
              color: AppColors.primary700,
            ),
          ),
        ],
      ),
    );
  }
}
