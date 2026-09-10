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

/// Opened from [TripConfirmationScreen]'s "Download for offline" — simulates
/// packaging the trip's route, itinerary and hotel info for offline access.
/// There's no real offline cache yet, so this just plays out the download
/// animation and hands control back once it reaches 100%.
class OfflineDownloadScreen extends StatefulWidget {
  const OfflineDownloadScreen({
    super.key,
    required this.startingFrom,
    required this.destinationName,
    required this.dayCount,
  });

  final String startingFrom;
  final String destinationName;
  final int dayCount;

  @override
  State<OfflineDownloadScreen> createState() => _OfflineDownloadScreenState();
}

class _OfflineDownloadScreenState extends State<OfflineDownloadScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _headerFade;
  late final Animation<double> _cardSlide;
  late final Animation<double> _downloadProgress;
  late final Animation<double> _doneFade;

  late final List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      '${widget.startingFrom} → ${widget.destinationName} route',
      '${widget.dayCount}-day itinerary details',
      'Stopover & hotel details',
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _headerFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.08, curve: Curves.easeOut),
    );
    _cardSlide = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.05, 0.22, curve: Curves.easeOut),
    );
    _downloadProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.95, curve: Curves.easeInOut),
    );
    _doneFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.9, 1, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _downloadProgress.value;
          final percent = (progress * 100).round();
          final isDone = percent >= 100;

          return Column(
            children: [
              FadeTransition(
                opacity: _headerFade,
                child: Container(
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
                          'Offline access',
                          style: AppTypography.h1.copyWith(
                            color: AppColors.surface0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    Transform.translate(
                      offset: Offset(0, (1 - _cardSlide.value) * 24),
                      child: Opacity(
                        opacity: _cardSlide.value,
                        child: _DownloadProgressCard(
                          percent: percent,
                          progress: progress,
                          isDone: isDone,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Transform.translate(
                      offset: Offset(0, (1 - _cardSlide.value) * 24),
                      child: Opacity(
                        opacity: _cardSlide.value,
                        child: _ChecklistCard(
                          items: _items,
                          progress: progress,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Opacity(
                    opacity: isDone ? _doneFade.value : 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: isDone
                            ? AppShadows.glow(AppColors.primary500)
                            : null,
                      ),
                      child: PrimaryButton(
                        label: isDone ? 'Done' : 'Downloading...',
                        expand: true,
                        onPressed: isDone
                            ? () => Navigator.of(context).maybePop()
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DownloadProgressCard extends StatelessWidget {
  const _DownloadProgressCard({
    required this.percent,
    required this.progress,
    required this.isDone,
  });

  final int percent;
  final double progress;
  final bool isDone;

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isDone ? 'Trip data downloaded' : 'Downloading trip data...',
                style: AppTypography.bodyEmphasis,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isDone
                    ? const Icon(
                        LucideIcons.circleCheck,
                        key: ValueKey('done'),
                        size: 20,
                        color: AppColors.primary700,
                      )
                    : Text(
                        '$percent%',
                        key: const ValueKey('percent'),
                        style: AppTypography.bodyEmphasis.copyWith(
                          color: AppColors.primary700,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(color: AppColors.surface100),
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppGradients.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.items, required this.progress});

  final List<String> items;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _ChecklistRow(
              label: items[i],
              isComplete: progress >= (i + 1) / items.length,
            ),
            if (i != items.length - 1)
              const Divider(color: AppColors.border, height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.label, required this.isComplete});

  final String label;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: isComplete ? 1 : 0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.85 + (value * 0.15),
                child: child,
              );
            },
            child: Icon(
              isComplete ? LucideIcons.circleCheck : LucideIcons.clock,
              size: 18,
              color: isComplete ? AppColors.primary700 : AppColors.ink300,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.body.copyWith(
                color: isComplete ? AppColors.ink900 : AppColors.ink300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
