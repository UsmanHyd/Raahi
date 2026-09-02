import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';

/// Placeholder body for the "Profile" tab — the full profile UI comes in a
/// later pass.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('Profile — coming soon', style: AppTypography.body),
      ),
    );
  }
}
