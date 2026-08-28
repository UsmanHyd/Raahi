import 'dart:ui';

import 'package:flutter/material.dart';

/// The app's reusable "liquid glass" treatment: blur + translucent tint +
/// edge highlight + light sheen. Use this for any UI element that floats
/// over photographic or map content (chips, pills, floating bars) instead
/// of a flat translucent color.
///
/// Renders identically on Android and iOS — the blur is done by Flutter's
/// own renderer (Skia/Impeller) via [BackdropFilter], not a native platform
/// API, so there is nothing platform-specific about this effect.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.blurSigma = 16,
    this.tintColor = Colors.white,
    this.tintOpacity = 0.18,
    this.borderOpacity = 0.35,
    this.padding = EdgeInsets.zero,
    this.boxShadow,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigma;
  final Color tintColor;
  final double tintOpacity;
  final double borderOpacity;
  final EdgeInsetsGeometry padding;

  /// Optional drop shadow, drawn outside the blurred/clipped area. Leave
  /// null when the surface floats over a photo/map (the blur itself
  /// provides enough separation); set it when using glass over a flat
  /// background, where the tint alone may not read clearly.
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final glass = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tintColor.withValues(alpha: tintOpacity),
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
              width: 1,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.6],
              colors: [
                Colors.white.withValues(alpha: 0.22),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );

    if (boxShadow == null) return glass;
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: glass,
    );
  }
}
