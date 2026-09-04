import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// A circular tappable icon, e.g. a back button sitting on a photo or
/// gradient header. Defaults to a translucent white fill suited to dark
/// backgrounds — override [backgroundColor]/[iconColor] for light ones.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color(0x33FFFFFF),
    this.iconColor = Colors.white,
    this.size = 20,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, color: iconColor, size: size),
        ),
      ),
    );
  }
}
