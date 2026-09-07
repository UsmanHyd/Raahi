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
import 'route_preview_screen.dart' show RouteStop;

/// The full picture for one stop on the route — opened by tapping a
/// stopover/destination's "Details" card on [RoutePreviewScreen]. The
/// starting point never links here since it has nothing to detail.
class StopoverDetailScreen extends StatelessWidget {
  const StopoverDetailScreen({super.key, required this.stop});

  final RouteStop stop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _HeroImage(stop: stop),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.route,
                            size: 16,
                            color: AppColors.ink600,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            stop.caption,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.ink600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'About this stop',
                        style: AppTypography.captionEmphasis.copyWith(
                          color: AppColors.ink600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        stop.description ?? stop.summary ?? '',
                        style: AppTypography.body,
                      ),
                      if (stop.hazardBadge != null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _HazardCard(
                          badge: stop.hazardBadge!,
                          description: stop.hazardDescription ?? '',
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      const _GoodToKnowCard(),
                    ],
                  ),
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
                child: PrimaryButton(
                  label: 'Back to route',
                  onPressed: () => Navigator.of(context).maybePop(),
                  expand: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.stop});

  final RouteStop stop;

  static const double _height = 260;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            stop.imageAsset!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.primary),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC000000)],
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.lg,
            child: SafeArea(
              bottom: false,
              child: CircleIconButton(
                icon: LucideIcons.arrowLeft,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (stop.typeLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppGradients.sunset,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      stop.typeLabel!,
                      style: AppTypography.captionEmphasis.copyWith(
                        color: AppColors.surface0,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  stop.title,
                  style: AppTypography.display.copyWith(
                    color: AppColors.surface0,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HazardCard extends StatelessWidget {
  const _HazardCard({required this.badge, required this.description});

  final String badge;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.accentAmber.withValues(alpha: 0.12),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.accentAmber.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.triangleAlert,
                size: 18,
                color: AppColors.accentTerracotta,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                badge,
                style: AppTypography.bodyEmphasis.copyWith(
                  color: AppColors.accentTerracotta,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: AppTypography.body.copyWith(color: AppColors.ink600),
          ),
        ],
      ),
    );
  }
}

class _GoodToKnowCard extends StatelessWidget {
  const _GoodToKnowCard();

  static const List<_Tip> _tips = [
    _Tip(
      icon: LucideIcons.fuel,
      text:
          'Fuel up before this stop — options thin out further along the route.',
    ),
    _Tip(
      icon: LucideIcons.signal,
      text: 'Cell signal can be weak or unavailable beyond here.',
    ),
    _Tip(
      icon: LucideIcons.camera,
      text: 'Golden hour light here is worth timing your drive around.',
    ),
  ];

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
          Text('Good to know', style: AppTypography.bodyEmphasis),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < _tips.length; i++) ...[
            if (i != 0) const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_tips[i].icon, size: 16, color: AppColors.primary700),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _tips[i].text,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.ink600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Tip {
  const _Tip({required this.icon, required this.text});

  final IconData icon;
  final String text;
}
