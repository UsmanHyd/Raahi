import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';

/// Placeholder body for the "Settings" tab — the full settings UI comes in
/// a later pass.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('Settings — coming soon', style: AppTypography.body),
      ),
    );
  }
}
