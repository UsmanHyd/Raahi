import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  // 0 2px 12px rgba(0,0,0,0.06) — the only elevation used anywhere in the app
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];
}
