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

/// Shown after Add Places — a route overview between the trip's start and
/// destination, plus a suggested stopover timeline.
///
/// There's no mapping/routing SDK in this app yet, so the "map" is a
/// decorative illustration (a drawn dashed route between two pins), not a
/// real interactive map — adding one (e.g. google_maps_flutter) means new
/// platform config and API keys, which is a bigger call than this pass
/// warrants. The timeline's middle stopover is mocked content; only the
/// start/destination labels reflect what the user actually entered.
class RoutePreviewScreen extends StatelessWidget {
  const RoutePreviewScreen({
    super.key,
    required this.startingFrom,
    required this.destinationName,
  });

  final String startingFrom;
  final String destinationName;

  void _continueToHotels(BuildContext context) {
    // TODO: push the Hotels screen once it's built; for now this finishes
    // the trip-planning flow the same way Add Places used to.
    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your trip to $destinationName is underway!'),
        backgroundColor: AppColors.primary700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                _RouteTimeline(
                  startingFrom: startingFrom,
                  destinationName: destinationName,
                ),
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

class _RouteTimeline extends StatelessWidget {
  const _RouteTimeline({
    required this.startingFrom,
    required this.destinationName,
  });

  final String startingFrom;
  final String destinationName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineStop(
          caption: 'Starting point · 0 km',
          title: startingFrom,
          dotStyle: _DotStyle.start,
          isLast: false,
        ),
        _TimelineStop(
          caption: 'Stopover 1 · 240 km · 4h drive',
          title: 'Besham (rest stop)',
          dotStyle: _DotStyle.waypoint,
          isLast: false,
          detail: _StopDetailCard(
            imageAsset: 'assets/home/route_besham.jpg',
            caption: 'Perfect spot to stop for lunch by the Indus River',
          ),
        ),
        _TimelineStop(
          caption: 'Final destination · 385 km · 7h drive',
          title: '$destinationName (overnight stay)',
          dotStyle: _DotStyle.destination,
          isLast: true,
          detail: const _StopWarningCard(
            badge: 'JEEP REQUIRED',
            caption:
                'Road beyond this point towards lakes is unpaved and '
                'rugged.',
          ),
        ),
      ],
    );
  }
}

enum _DotStyle { start, waypoint, destination }

class _TimelineStop extends StatelessWidget {
  const _TimelineStop({
    required this.caption,
    required this.title,
    required this.dotStyle,
    required this.isLast,
    this.detail,
  });

  final String caption;
  final String title;
  final _DotStyle dotStyle;
  final bool isLast;
  final Widget? detail;

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
                _TimelineDot(style: dotStyle),
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
                    caption,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.ink600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(title, style: AppTypography.bodyEmphasis),
                  if (detail != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    detail!,
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

  final _DotStyle style;

  @override
  Widget build(BuildContext context) {
    final size = style == _DotStyle.destination ? 16.0 : 12.0;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: style == _DotStyle.start
              ? AppColors.surface0
              : AppColors.primary700,
          border: style == _DotStyle.start
              ? Border.all(color: AppColors.ink900, width: 2)
              : style == _DotStyle.destination
              ? Border.all(color: AppColors.primary100, width: 3)
              : null,
        ),
      ),
    );
  }
}

class _StopDetailCard extends StatelessWidget {
  const _StopDetailCard({required this.imageAsset, required this.caption});

  final String imageAsset;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            child: Image.asset(
              imageAsset,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(gradient: AppGradients.primary),
                child: const Icon(
                  LucideIcons.utensils,
                  color: AppColors.surface0,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              caption,
              style: AppTypography.caption.copyWith(color: AppColors.ink600),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopWarningCard extends StatelessWidget {
  const _StopWarningCard({required this.badge, required this.caption});

  final String badge;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                  badge,
                  style: AppTypography.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentTerracotta,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption,
            style: AppTypography.caption.copyWith(color: AppColors.ink600),
          ),
        ],
      ),
    );
  }
}
