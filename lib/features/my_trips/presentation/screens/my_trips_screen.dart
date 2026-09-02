import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';

/// Placeholder body for the "My trips" tab — the full trip list UI comes
/// in a later pass.
class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('My trips — coming soon', style: AppTypography.body),
      ),
    );
  }
}
