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
import 'hotels_screen.dart';
import 'stopover_detail_screen.dart';

/// Shown after Add Places — a route overview between the trip's start and
/// destination, plus a suggested stopover timeline.
///
/// There's no mapping/routing SDK in this app yet, so the "map" is a
/// decorative illustration (a drawn dashed route between two pins), not a
/// real interactive map — adding one (e.g. google_maps_flutter) means new
/// platform config and API keys, which is a bigger call than this pass
/// warrants. The timeline's stopovers are mocked content; only the
/// start/destination labels reflect what the user actually entered.
class RoutePreviewScreen extends StatelessWidget {
  const RoutePreviewScreen({
    super.key,
    required this.startingFrom,
    required this.destinationName,
    this.dateRange,
  });

  final String startingFrom;
  final String destinationName;
  final DateTimeRange? dateRange;

  void _continueToHotels(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HotelsScreen(
          startingFrom: startingFrom,
          destinationName: destinationName,
          dateRange: dateRange,
        ),
      ),
    );
  }

  List<RouteStop> _buildStops() {
    return [
      RouteStop(
        caption: 'Starting point · 0 km',
        title: startingFrom,
        dotStyle: DotStyle.start,
      ),
      const RouteStop(
        caption: 'Stopover 1 · 240 km · 4h drive',
        title: 'Besham (rest stop)',
        dotStyle: DotStyle.waypoint,
        typeLabel: 'Rest stop',
        imageAsset: 'assets/home/route_besham.jpg',
        summary: 'Perfect spot to stop for lunch by the Indus River',
        description:
            'Besham sits right on the Indus, roughly halfway into the '
            'drive — a natural break point with riverside food stops '
            'and clean rest areas before the road starts climbing.',
      ),
      const RouteStop(
        caption: 'Stopover 2 · 320 km · 5.5h drive',
        title: 'Bahrain (scenic town)',
        dotStyle: DotStyle.waypoint,
        typeLabel: 'Scenic town',
        imageAsset: 'assets/home/route_bahrain.jpg',
        summary: 'Popular tourist market and roaring torrent views',
        description:
            'Bahrain overlooks the Swat River at its most dramatic — '
            'fast, loud rapids right beside the main bazaar. Worth a '
            'short stop even if you\'re not staying the night.',
      ),
      RouteStop(
        caption: 'Final destination · 385 km · 7h drive',
        title: '$destinationName (overnight stay)',
        dotStyle: DotStyle.destination,
        typeLabel: 'Overnight stay',
        imageAsset: 'assets/home/route_kalam.jpg',
        summary: 'Pine forests and the gateway to Swat\'s high lakes',
        description:
            'The road ends its paved stretch here — $destinationName is '
            'where most travelers base themselves before continuing on '
            'to the high-altitude lakes further up.',
        hazardBadge: 'Jeep required',
        hazardDescription:
            'Road beyond this point towards the lakes is unpaved and '
            'rugged — a 4x4 or local jeep service is needed, regular '
            'cars won\'t make it.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stops = _buildStops();

    return Scaffold(
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
                    'Your route',
                    style: AppTypography.h1.copyWith(color: AppColors.surface0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _RouteMapPreview(
                  startLabel: startingFrom,
                  endLabel: destinationName,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: AppRadius.chipRadius,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.car,
                        size: 18,
                        color: AppColors.primary700,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '385 km · ~7h drive time',
                        style: AppTypography.bodyEmphasis.copyWith(
                          color: AppColors.primary700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Planned road trip timeline', style: AppTypography.h2),
                const SizedBox(height: AppSpacing.md),
                for (var i = 0; i < stops.length; i++)
                  _TimelineStop(stop: stops[i], isLast: i == stops.length - 1),
              ],
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
                    label: 'Continue to hotels',
                    onPressed: () => _continueToHotels(context),
                    expand: true,
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

class _RouteMapPreview extends StatelessWidget {
  const _RouteMapPreview({required this.startLabel, required this.endLabel});

  final String startLabel;
  final String endLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RouteLinePainter(color: AppColors.primary700),
              ),
            ),
            Align(
              alignment: const Alignment(-0.7, 0.55),
              child: _MapPin(label: startLabel, filled: false),
            ),
            Align(
              alignment: const Alignment(0.7, -0.55),
              child: _MapPin(label: endLabel, filled: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteLinePainter extends CustomPainter {
  const _RouteLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.1,
        size.width * 0.85,
        size.height * 0.25,
      );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const dashWidth = 7.0;
    const dashSpace = 6.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RouteLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: filled ? AppGradients.primary : null,
        color: filled ? null : AppColors.surface0,
        borderRadius: BorderRadius.circular(999),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.mapPin,
            size: 14,
            color: filled ? AppColors.surface0 : AppColors.primary700,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.captionEmphasis.copyWith(
              color: filled ? AppColors.surface0 : AppColors.ink900,
            ),
          ),
        ],
      ),
    );
  }
}

enum DotStyle { start, waypoint, destination }

/// Everything the timeline row and the [StopoverDetailScreen] need for one
/// stop. [imageAsset]/[summary]/[description] are null for the plain
/// starting point, which has nothing worth a detail screen.
class RouteStop {
  const RouteStop({
    required this.caption,
    required this.title,
    required this.dotStyle,
    this.typeLabel,
    this.imageAsset,
    this.summary,
    this.description,
    this.hazardBadge,
    this.hazardDescription,
  });

  final String caption;
  final String title;
  final DotStyle dotStyle;
  final String? typeLabel;
  final String? imageAsset;
  final String? summary;
  final String? description;
  final String? hazardBadge;
  final String? hazardDescription;

  bool get hasDetail => imageAsset != null;
}

class _TimelineStop extends StatelessWidget {
  const _TimelineStop({required this.stop, required this.isLast});

  final RouteStop stop;
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
                _TimelineDot(style: stop.dotStyle),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: AppColors.border)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.caption,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.ink600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(stop.title, style: AppTypography.bodyEmphasis),
                  if (stop.hasDetail) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _StopSummaryCard(stop: stop),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.style});

  final DotStyle style;

  @override
  Widget build(BuildContext context) {
    final size = style == DotStyle.destination ? 16.0 : 12.0;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: style == DotStyle.start
              ? AppColors.surface0
              : AppColors.primary700,
          border: style == DotStyle.start
              ? Border.all(color: AppColors.ink900, width: 2)
              : style == DotStyle.destination
              ? Border.all(color: AppColors.primary100, width: 3)
              : null,
        ),
      ),
    );
  }
}

/// A stop's compact preview card in the timeline — image, one-line summary,
/// and a "Details" affordance. Tapping anywhere on it opens
/// [StopoverDetailScreen] for the full picture.
class _StopSummaryCard extends StatelessWidget {
  const _StopSummaryCard({required this.stop});

  final RouteStop stop;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface0,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        borderRadius: AppRadius.cardRadius,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => StopoverDetailScreen(stop: stop)),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    child: Image.asset(
                      stop.imageAsset!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          gradient: AppGradients.primary,
                        ),
                        child: const Icon(
                          LucideIcons.mountain,
                          color: AppColors.surface0,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      stop.summary!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.ink600,
                      ),
                    ),
                  ),
                ],
              ),
              if (stop.hazardBadge != null) ...[
                const SizedBox(height: AppSpacing.sm),
                _HazardBadge(label: stop.hazardBadge!),
              ],
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Details',
                    style: AppTypography.captionEmphasis.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 14,
                    color: AppColors.primary700,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HazardBadge extends StatelessWidget {
  const _HazardBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentAmber.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.triangleAlert,
            size: 12,
            color: AppColors.accentTerracotta,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.accentTerracotta,
            ),
          ),
        ],
      ),
    );
  }
}
