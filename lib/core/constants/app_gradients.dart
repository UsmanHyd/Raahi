import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Reusable gradients built from the app's existing palette — for bolder,
/// more energetic accent surfaces (hero CTAs, selected chips) without
/// introducing new colors.
class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary500, AppColors.primary700],
  );

  static const LinearGradient sunset = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.accentAmber, AppColors.accentTerracotta],
  );
}
