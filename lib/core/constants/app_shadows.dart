import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  // 0 2px 12px rgba(0,0,0,0.06) — the only neutral elevation in the app
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 2)),
  ];

  /// A soft colored glow, used for bolder accent surfaces (hero CTAs,
  /// selected chips) instead of the neutral [card] shadow.
  static List<BoxShadow> glow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.35),
      blurRadius: 24,
      spreadRadius: 1,
      offset: const Offset(0, 8),
    ),
  ];
}
