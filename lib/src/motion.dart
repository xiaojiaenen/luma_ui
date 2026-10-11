import 'package:flutter/material.dart';

abstract final class SoftMotion {
  static const curve = Curves.easeOutCubic;

  /// Zero-duration AnimatedSize can re-dirty itself during layout. Bypass it.
  static Widget animateSize(
    BuildContext context, {
    required Widget child,
    required Duration duration,
    Curve curve = Curves.linear,
    AlignmentGeometry alignment = Alignment.center,
    Clip clipBehavior = Clip.hardEdge,
  }) => MediaQuery.disableAnimationsOf(context)
      ? child
      : AnimatedSize(
          duration: duration,
          curve: curve,
          alignment: alignment,
          clipBehavior: clipBehavior,
          child: child,
        );
  static Duration duration(BuildContext context, [int milliseconds = 220]) =>
      MediaQuery.disableAnimationsOf(context)
      ? Duration.zero
      : Duration(milliseconds: milliseconds);
}

/// A short entrance transition; changing [identity] replays it.
class SoftReveal extends StatelessWidget {
  const SoftReveal({super.key, required this.child, this.identity});
  final Widget child;
  final Object? identity;
  @override
  Widget build(BuildContext context) => MediaQuery.disableAnimationsOf(context)
      ? child
      : TweenAnimationBuilder<double>(
          key: ValueKey(identity),
          tween: Tween(begin: 0, end: 1),
          duration: SoftMotion.duration(context, 280),
          curve: SoftMotion.curve,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 8 * (1 - value)),
              child: child,
            ),
          ),
          child: child,
        );
}

/// Keeps native button focus, semantics and keyboard activation intact.
class SoftPress extends StatefulWidget {
  const SoftPress({
    super.key,
    required this.child,
    this.enabled = true,
    this.pressScale = .985,
    this.hoverLift = 1,
  });
  final Widget child;
  final bool enabled;
  final double pressScale, hoverLift;
  @override
  State<SoftPress> createState() => _SoftPressState();
}

class _SoftPressState extends State<SoftPress> {
  bool pressed = false, hovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hovered = true),
    onExit: (_) => setState(() {
      hovered = false;
      pressed = false;
    }),
    child: Listener(
      onPointerDown: widget.enabled
          ? (_) => setState(() => pressed = true)
          : null,
      onPointerUp: (_) => setState(() => pressed = false),
      onPointerCancel: (_) => setState(() => pressed = false),
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          end: !widget.enabled || MediaQuery.disableAnimationsOf(context)
              ? 0
              : pressed
              ? -1
              : hovered
              ? 1
              : 0,
        ),
        duration: SoftMotion.duration(context, pressed ? 100 : 200),
        curve: pressed ? Curves.easeOutCubic : Curves.easeOutQuart,
        builder: (context, value, child) => Transform.translate(
          offset: Offset(
            0,
            value > 0 ? -widget.hoverLift * value : -value * .5,
          ),
          child: Transform.scale(
            scale: value < 0 ? 1 + (1 - widget.pressScale) * value : 1,
            child: child,
          ),
        ),
        child: widget.child,
      ),
    ),
  );
}
