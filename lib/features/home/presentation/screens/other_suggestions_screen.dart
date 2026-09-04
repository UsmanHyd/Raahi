import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

/// Placeholder screen opened from the exhausted Recommended stack's
/// "View other suggestions" button — the full alternate-suggestions UI
/// comes in a later pass.
class OtherSuggestionsScreen extends StatelessWidget {
  const OtherSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      appBar: AppBar(title: const Text('Other suggestions')),
      body: const Center(
        child: Text(
          'Other suggestions — coming soon',
          style: AppTypography.body,
        ),
      ),
    );
  }
}
