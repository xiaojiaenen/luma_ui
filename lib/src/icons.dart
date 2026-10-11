import 'package:flutter/material.dart';

typedef SoftIconBuilder = Widget Function(
  BuildContext context,
  IconData icon,
  double? size,
  Color? color,
);

/// A renderer for replacing all Luma-owned icons with SVGs or custom widgets.
@immutable
class SoftIcons extends ThemeExtension<SoftIcons> {
  const SoftIcons({required this.builder});
  final SoftIconBuilder builder;
  @override
  SoftIcons copyWith({SoftIconBuilder? builder}) =>
      SoftIcons(builder: builder ?? this.builder);
  @override
  SoftIcons lerp(covariant SoftIcons? other, double t) =>
      t < .5 ? this : other ?? this;
}

class SoftIcon extends StatelessWidget {
  const SoftIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  });
  final IconData? icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final TextDirection? textDirection;
  @override
  Widget build(BuildContext context) {
    final renderer = Theme.of(context).extension<SoftIcons>();
    if (renderer == null || icon == null) {
      return Icon(
        icon,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
      );
    }
    final theme = IconTheme.of(context);
    return Semantics(
      label: semanticLabel,
      child: IconTheme.merge(
        data: IconThemeData(size: size, color: color),
        child: renderer.builder(
          context,
          icon!,
          size ?? theme.size,
          color ?? theme.color,
        ),
      ),
    );
  }
}
