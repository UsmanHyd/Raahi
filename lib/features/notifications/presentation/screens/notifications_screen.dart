import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../data/datasources/mock_notifications_data_source.dart';
import '../../domain/entities/app_notification.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_empty_state.dart';

/// Pushed from the bell icon on Home. Tapping a notification marks it
/// read; data is hardcoded and in-memory for this pass, same as the rest
/// of the app — it will move behind a provider once wired to real data.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<AppNotification> _notifications = buildMockNotifications();

  bool get _hasUnread => _notifications.any((n) => !n.isRead);

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index == -1) return;
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              showMarkAllAsRead: _hasUnread,
              onMarkAllAsRead: _markAllAsRead,
            ),
            Expanded(
              child: _notifications.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: NotificationsEmptyState(),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: _notifications.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () => _markAsRead(notification.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.showMarkAllAsRead,
    required this.onMarkAllAsRead,
  });

  final bool showMarkAllAsRead;
  final VoidCallback onMarkAllAsRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface0,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          CircleIconButton(
            icon: LucideIcons.arrowLeft,
            backgroundColor: AppColors.surface100,
            iconColor: AppColors.ink900,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text('Notifications', style: AppTypography.h1)),
          if (showMarkAllAsRead)
            GestureDetector(
              onTap: onMarkAllAsRead,
              child: Text(
                'Mark all as read',
                style: AppTypography.captionEmphasis.copyWith(
                  color: AppColors.primary700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
