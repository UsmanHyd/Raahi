import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/Onboarding/presentation/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raahi',
      theme: AppTheme.light,
      home: const OnboardingScreen(),
    );
  }
}
