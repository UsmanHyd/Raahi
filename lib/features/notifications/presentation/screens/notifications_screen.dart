import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';

/// Placeholder body for the "Notifications" tab — the full notifications
/// UI comes in a later pass.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('Notifications — coming soon', style: AppTypography.body),
      ),
    );
  }
}
