import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Personalized greeting + headline shown at the top of the Home screen.
class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good morning, Ahmed', style: AppTypography.caption),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Where is the road taking you next?',
          style: AppTypography.display,
        ),
      ],
    );
  }
}
