import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../widgets/share_trip_sheet.dart';
import 'offline_download_screen.dart';

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

/// The final screen of the whole trip-planning flow — opened from "Your
/// plan"'s "Confirm your trip". Built around a "stamped boarding pass"
/// moment: the checkmark badge slams in and draws itself stroke-by-stroke
/// with a confetti burst, then a ticket-style trip summary slides up.
/// "View my trip" pops back to that screen; the other two actions are
/// stubs, since there's no export/download pipeline to wire up yet.
class TripConfirmationScreen extends StatefulWidget {
  const TripConfirmationScreen({
    super.key,
    required this.destinationName,
    required this.dayCount,
    this.startingFrom = 'Home',
    this.dateRange,
  });

  final String startingFrom;
  final String destinationName;
  final int dayCount;
  final DateTimeRange? dateRange;

  @override
  State<TripConfirmationScreen> createState() => _TripConfirmationScreenState();
}

class _TripConfirmationScreenState extends State<TripConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _headerFade;
  late final Animation<double> _stampProgress;
  late final Animation<double> _ringProgress;
  late final Animation<double> _confettiProgress;
  late final Animation<double> _checkProgress;
  late final Animation<double> _ticketProgress;
  late final Animation<double> _buttonsFade;

  static final List<_ConfettiParticle> _particles = List.generate(10, (i) {
    const colors = [
      AppColors.surface0,
      AppColors.accentAmber,
      AppColors.primary100,
    ];
    final angle = (i / 10) * 2 * math.pi + (i.isEven ? 0.15 : -0.1);
    return _ConfettiParticle(
      angle: angle,
      distance: 46 + (i % 3) * 14,
      color: colors[i % colors.length],
      size: 3 + (i % 3).toDouble(),
    );
  });

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _headerFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.15, curve: Curves.easeOut),
    );
    _stampProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.45, curve: Curves.elasticOut),
    );
    _ringProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 0.60, curve: Curves.easeOut),
    );
    _confettiProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.32, 0.85, curve: Curves.easeOut),
    );
    _checkProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.38, 0.60, curve: Curves.easeOut),
    );
    _ticketProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
    );
    _buttonsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.82, 1, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _tripSummary {
    final range = widget.dateRange;
    final daysLabel =
        '${widget.dayCount} ${widget.dayCount == 1 ? 'day' : 'days'}';
    if (range == null) {
      return '${widget.destinationName} · $daysLabel';
    }
    final startLabel =
        '${_monthAbbreviations[range.start.month - 1]} ${range.start.day}';
    final endLabel =
        '${_monthAbbreviations[range.end.month - 1]} ${range.end.day}';
    return '${widget.destinationName} · $startLabel - $endLabel · $daysLabel';
  }

  void _downloadOffline() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OfflineDownloadScreen(
          startingFrom: widget.startingFrom,
          destinationName: widget.destinationName,
          dayCount: widget.dayCount,
        ),
      ),
    );
  }

  void _exportAndShare() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface50,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (context) => const ShareTripSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              FadeTransition(
                opacity: _headerFade,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xxxl,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                  ),
                  decoration: const BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(AppRadius.sheet),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StampBadge(
                          stampProgress: _stampProgress.value,
                          ringProgress: _ringProgress.value,
                          confettiProgress: _confettiProgress.value,
                          checkProgress: _checkProgress.value,
                          particles: _particles,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Your trip is ready!',
                          style: AppTypography.h1.copyWith(
                            color: AppColors.surface0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _tripSummary,
                          style: AppTypography.body.copyWith(
                            color: AppColors.surface0.withValues(alpha: 0.85),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, (1 - _ticketProgress.value) * 30),
                      child: Opacity(
                        opacity: _ticketProgress.value,
                        child: _TicketCard(
                          startingFrom: widget.startingFrom,
                          destinationName: widget.destinationName,
                          dayCount: widget.dayCount,
                          dateRange: widget.dateRange,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Opacity(
                      opacity: _ticketProgress.value,
                      child: Text(
                        '🎵 Cue the road trip playlist',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.ink600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Opacity(
                      opacity: _buttonsFade.value,
                      child: Column(
                        children: [
                          OutlinedButton.icon(
                            onPressed: _downloadOffline,
                            icon: const Icon(LucideIcons.download, size: 16),
                            label: const Text('Download for offline'),
                            style: _outlinedStyle,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          OutlinedButton.icon(
                            onPressed: _exportAndShare,
                            icon: const Icon(LucideIcons.share2, size: 16),
                            label: const Text('Export & share'),
                            style: _outlinedStyle,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: AppShadows.glow(AppColors.primary500),
                            ),
                            child: FilledButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary700,
                                foregroundColor: AppColors.surface0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.lg,
                                ),
                                shape: const StadiumBorder(),
                                textStyle: AppTypography.buttonLabel,
                              ),
                              child: const Text('View my trip'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static final ButtonStyle _outlinedStyle = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary700,
    side: const BorderSide(color: AppColors.primary700),
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    minimumSize: const Size(double.infinity, 0),
    shape: const StadiumBorder(),
    textStyle: AppTypography.buttonLabel,
  );
}

/// The "rubber stamp" moment: an expanding ring pulse, a confetti burst,
/// and a solid badge whose checkmark draws itself stroke-by-stroke.
class _StampBadge extends StatelessWidget {
  const _StampBadge({
    required this.stampProgress,
    required this.ringProgress,
    required this.confettiProgress,
    required this.checkProgress,
    required this.particles,
  });

  final double stampProgress;
  final double ringProgress;
  final double confettiProgress;
  final double checkProgress;
  final List<_ConfettiParticle> particles;

  @override
  Widget build(BuildContext context) {
    // elasticOut overshoots past 1.0 before settling — read that as a
    // slam-then-settle scale/rotation rather than a plain linear scale.
    final scale = 0.3 + stampProgress * 0.7;
    final rotation = (1 - stampProgress).clamp(0.0, 1.0) * -0.35;
    final opacity = stampProgress.clamp(0.0, 1.0);

    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(160, 160),
            painter: _RingPulsePainter(
              progress: ringProgress,
              color: AppColors.surface0,
            ),
          ),
          CustomPaint(
            size: const Size(160, 160),
            painter: _ConfettiPainter(
              progress: confettiProgress,
              particles: particles,
            ),
          ),
          Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.surface0.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: AppColors.surface0,
                        shape: BoxShape.circle,
                      ),
                      child: CustomPaint(
                        size: const Size(68, 68),
                        painter: _CheckmarkPainter(
                          progress: checkProgress,
                          color: AppColors.primary700,
                        ),
                      ),
                    ),
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

class _CheckmarkPainter extends CustomPainter {
  const _CheckmarkPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final path = Path()
      ..moveTo(size.width * 0.20, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.72)
      ..lineTo(size.width * 0.80, size.height * 0.30);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final metric = path.computeMetrics().first;
    final extracted = metric.extractPath(0, metric.length * progress);
    canvas.drawPath(extracted, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _RingPulsePainter extends CustomPainter {
  const _RingPulsePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide / 2) * (0.42 + progress * 0.58);
    final paint = Paint()
      ..color = color.withValues(alpha: (1 - progress) * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _RingPulsePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.angle,
    required this.distance,
    required this.color,
    required this.size,
  });

  final double angle;
  final double distance;
  final Color color;
  final double size;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.progress, required this.particles});

  final double progress;
  final List<_ConfettiParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final center = size.center(Offset.zero);
    final fade = progress > 0.55
        ? (1 - (progress - 0.55) / 0.45).clamp(0.0, 1.0)
        : 1.0;
    for (final particle in particles) {
      final dx = math.cos(particle.angle) * particle.distance * progress;
      final dy =
          math.sin(particle.angle) * particle.distance * progress +
          (progress * progress * 18);
      canvas.drawCircle(
        center + Offset(dx, dy),
        particle.size,
        Paint()..color = particle.color.withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// The boarding-pass-style trip summary: a From/To route row, a dashed
/// "perforation" with die-cut notches, then Depart/Return/Duration fields.
class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.startingFrom,
    required this.destinationName,
    required this.dayCount,
    this.dateRange,
  });

  final String startingFrom;
  final String destinationName;
  final int dayCount;
  final DateTimeRange? dateRange;

  @override
  Widget build(BuildContext context) {
    final range = dateRange;
    final departLabel = range == null
        ? '—'
        : '${_monthAbbreviations[range.start.month - 1]} ${range.start.day}';
    final returnLabel = range == null
        ? '—'
        : '${_monthAbbreviations[range.end.month - 1]} ${range.end.day}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: _RouteEndpoint(label: 'FROM', value: startingFrom),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: Row(
                      children: [
                        const Expanded(child: _DashedLine()),
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(
                          LucideIcons.car,
                          size: 14,
                          color: AppColors.primary700,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Expanded(child: _DashedLine()),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _RouteEndpoint(
                    label: 'TO',
                    value: destinationName,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: _DashedLine(),
                ),
                const Positioned(left: -10, child: _TicketNotch()),
                const Positioned(right: -10, child: _TicketNotch()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TicketField(label: 'DEPART', value: departLabel),
                _TicketField(label: 'RETURN', value: returnLabel),
                _TicketField(label: 'DURATION', value: '$dayCount days'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteEndpoint extends StatelessWidget {
  const _RouteEndpoint({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.ink300,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.bodyEmphasis,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }
}

class _TicketField extends StatelessWidget {
  const _TicketField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.ink300,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTypography.bodyEmphasis),
      ],
    );
  }
}

class _TicketNotch extends StatelessWidget {
  const _TicketNotch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: AppColors.surface50,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, 1.5),
          painter: const _DashPainter(),
        );
      },
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5;
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    var x = 0.0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) => false;
}
