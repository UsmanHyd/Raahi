import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';

/// Top-of-Home row: avatar + "Hello {name}" + a notification bell that
/// pushes [NotificationsScreen].
class HomeProfileHeader extends StatelessWidget {
  const HomeProfileHeader({super.key});

  static const String _name = 'Ahmed';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary100,
          child: Icon(Icons.person, color: AppColors.primary700, size: 24),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text('Hello $_name!', style: AppTypography.h2),
        ),
        _NotificationBellButton(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
        ),
      ],
    );
  }
}

class _NotificationBellButton extends StatelessWidget {
  const _NotificationBellButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface0,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.ink900,
            size: 24,
          ),
        ),
      ),
    );
  }
}
