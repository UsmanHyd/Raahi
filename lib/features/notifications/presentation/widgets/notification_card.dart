import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/app_notification.dart';

/// One notification row — reused for every entry on the Notifications
/// screen. Unread notifications get a tinted background and a small dot;
/// the icon circle's fill inverts (white on a tinted card, tinted on a
/// white card) so it always stands out.
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  Color get _accentColor => switch (notification.category) {
    NotificationCategory.weather => AppColors.info,
    NotificationCategory.tripReminder => AppColors.primary700,
    NotificationCategory.roadUpdate => AppColors.accentAmber,
  };

  IconData get _icon => switch (notification.category) {
    NotificationCategory.weather => LucideIcons.cloudRain,
    NotificationCategory.tripReminder => LucideIcons.luggage,
    NotificationCategory.roadUpdate => LucideIcons.triangleAlert,
  };

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    final accent = _accentColor;

    return Material(
      color: unread ? accent.withValues(alpha: 0.1) : AppColors.surface0,
      borderRadius: AppRadius.cardRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: unread
                      ? AppColors.surface0
                      : accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  boxShadow: unread ? AppShadows.card : null,
                ),
                child: Icon(_icon, size: 18, color: accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.title, style: AppTypography.bodyEmphasis),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      notification.message,
                      style: AppTypography.body.copyWith(
                        color: AppColors.ink600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      notification.relativeTimeLabel,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.ink300,
                      ),
                    ),
                  ],
                ),
              ),
              if (unread) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.xs),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.info,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
