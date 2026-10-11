import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'design.dart';
import 'motion.dart';

/// Directional specular outline, like the reference images.
class SoftHighlight extends StatelessWidget {
  const SoftHighlight({super.key, required this.child, this.radius});
  final Widget child;
  final double? radius;
  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: _HighlightPainter(
      radius ?? SoftDesign.of(context).radius,
      SoftDesign.of(context).accent,
    ),
    child: child,
  );
}

class _HighlightPainter extends CustomPainter {
  _HighlightPainter(this.radius, this.accent);
  final double radius;
  final Color accent;
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = (Offset.zero & size).deflate(.75);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withValues(alpha: .35),
            Color.lerp(Colors.white, accent, .25)!,
            Colors.white.withValues(alpha: .8),
          ],
          stops: const [0, .45, .72, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_HighlightPainter old) =>
      radius != old.radius || accent != old.accent;
}

class SoftGlassSurface extends StatelessWidget {
  const SoftGlassSurface({
    super.key,
    required this.child,
    this.blur = 16,
    this.opacity = .55,
    this.padding = const EdgeInsets.all(24),
  }) : assert(blur >= 0),
       assert(opacity >= 0 && opacity <= 1);
  final Widget child;
  final double blur, opacity;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => SoftHighlight(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AnimatedContainer(
          duration: SoftMotion.duration(context),
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                SoftDesign.of(context).surface.withValues(alpha: opacity),
                SoftDesign.of(context).tint.withValues(alpha: opacity * .7),
              ],
            ),
          ),
          child: child,
        ),
      ),
    ),
  );
}
