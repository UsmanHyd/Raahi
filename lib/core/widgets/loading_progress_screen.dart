import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

/// A universal full-screen loading step — a circular progress ring that
/// advances through 25% / 50% / 75% / 100%, pausing briefly at each stop
/// with its own label, then calls [onFinished].
///
/// Generic and feature-agnostic (any flow that needs a "working on it..."
/// moment can push this), so it lives in `core/widgets/` rather than any
/// one feature — e.g.:
///
/// ```dart
/// Navigator.of(context).push(MaterialPageRoute(
///   builder: (_) => LoadingProgressScreen(
///     stepLabels: const [
///       'Confirming your dates...',
///       'Reserving your room...',
///       'Almost done...',
///       'Booked!',
///     ],
///     onFinished: () => Navigator.of(context).pushReplacement(...),
///   ),
/// ));
/// ```
class LoadingProgressScreen extends StatefulWidget {
  const LoadingProgressScreen({
    super.key,
    this.title = 'Just a moment',
    this.stepLabels = const [
      'Getting things ready...',
      'Almost there...',
      'Finishing up...',
      'Completed!',
    ],
    this.stepDuration = const Duration(milliseconds: 850),
    required this.onFinished,
  }) : assert(
         stepLabels.length == 4,
         'stepLabels must have exactly 4 entries, for the 25/50/75/100% stops',
       );

  /// Shown above the ring for the whole sequence.
  final String title;

  /// Exactly 4 labels, one per stop (25%, 50%, 75%, 100%).
  final List<String> stepLabels;

  /// How long the ring pauses at each stop before advancing to the next.
  final Duration stepDuration;

  /// Called once the sequence reaches 100% and briefly settles there.
  final VoidCallback onFinished;

  @override
  State<LoadingProgressScreen> createState() => _LoadingProgressScreenState();
}

class _LoadingProgressScreenState extends State<LoadingProgressScreen> {
  static const List<double> _stops = [0.25, 0.5, 0.75, 1];

  int _stepIndex = -1;

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  Future<void> _runSequence() async {
    for (var i = 0; i < _stops.length; i++) {
      await Future.delayed(widget.stepDuration);
      if (!mounted) return;
      setState(() => _stepIndex = i);
    }
    await Future.delayed(widget.stepDuration);
    if (!mounted) return;
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _stepIndex < 0 ? 0.0 : _stops[_stepIndex];
    final isComplete = _stepIndex == _stops.length - 1;
    final label = _stepIndex < 0
        ? widget.stepLabels.first
        : widget.stepLabels[_stepIndex];

    return Scaffold(
      backgroundColor: AppColors.primary700,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.primary),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: AppTypography.h2.copyWith(color: AppColors.surface0),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                _ProgressRing(progress: progress, isComplete: isComplete),
                const SizedBox(height: AppSpacing.xl),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    label,
                    key: ValueKey(label),
                    style: AppTypography.bodyEmphasis.copyWith(
                      color: AppColors.surface0.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                _StepDots(activeIndex: _stepIndex, count: _stops.length),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress, required this.isComplete});

  final double progress;
  final bool isComplete;

  static const double _size = 180;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return CustomPaint(
            painter: _RingPainter(
              progress: value,
              trackColor: AppColors.surface0.withValues(alpha: 0.2),
              progressColor: AppColors.surface0,
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: isComplete
                    ? const Icon(
                        LucideIcons.check,
                        key: ValueKey('check'),
                        color: AppColors.surface0,
                        size: 48,
                      )
                    : Text(
                        '${(value * 100).round()}%',
                        key: const ValueKey('percentage'),
                        style: AppTypography.display.copyWith(
                          color: AppColors.surface0,
                          fontSize: 32,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;

  static const double _strokeWidth = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - _strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.activeIndex, required this.count});

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i != 0) const SizedBox(width: AppSpacing.sm),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: i <= activeIndex ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i <= activeIndex
                  ? AppColors.surface0
                  : AppColors.surface0.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ],
    );
  }
}
