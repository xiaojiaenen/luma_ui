import 'package:flutter/material.dart';

import 'motion.dart';

/// Semantic roles can be overridden without changing the accent palette.
@immutable
class SoftSemanticColors {
  const SoftSemanticColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });
  final Color success, warning, error, info;
  static const light = SoftSemanticColors(
    success: Color(0xFF28704C),
    warning: Color(0xFF87520F),
    error: Color(0xFFB63E4B),
    info: Color(0xFF286775),
  );
  static const dark = SoftSemanticColors(
    success: Color(0xFF8DD6AC),
    warning: Color(0xFFF1C17C),
    error: Color(0xFFFFA3AD),
    info: Color(0xFF9DDDEA),
  );
}

enum SoftGradientPreset { none, lagoon, peach, lilac }

enum SoftTone {
  neutral,
  primary,
  secondary,
  tertiary,
  ai,
  success,
  warning,
  error,
  info,
}

/// Independent role colors, paired light/dark palettes and categorical data colors.
@immutable
class SoftRoleColors {
  const SoftRoleColors({
    required this.secondary,
    required this.tertiary,
    required this.ai,
    required this.chart,
  });
  final Color secondary, tertiary, ai;
  final List<Color> chart;
  static const light = SoftRoleColors(
    secondary: Color(0xFF487968),
    tertiary: Color(0xFF96602D),
    ai: Color(0xFF80619F),
    chart: [
      Color(0xFF687AD8),
      Color(0xFF487968),
      Color(0xFFB17A46),
      Color(0xFF9273B5),
      Color(0xFFBB6476),
      Color(0xFF42899B),
    ],
  );
  static const dark = SoftRoleColors(
    secondary: Color(0xFF9BC9B7),
    tertiary: Color(0xFFE4BC8F),
    ai: Color(0xFFC5ABE4),
    chart: [
      Color(0xFFAAB6FF),
      Color(0xFF9BC9B7),
      Color(0xFFE4BC8F),
      Color(0xFFC5ABE4),
      Color(0xFFE8A0B1),
      Color(0xFF8BC6D7),
    ],
  );
}

/// Component overrides inherit the global geometry unless explicitly changed.
@immutable
class SoftComponentStyles {
  const SoftComponentStyles({this.button, this.input});
  final ButtonStyle? button;
  final InputDecorationThemeData? input;
}

/// Shared geometry, theme defaults for components in this subtree.
class SoftDesign extends StatelessWidget {
  const SoftDesign({
    super.key,
    required this.child,
    Color? accent,
    double? radius,
    double? spacing,
    double? shadow,
    double? controlHeight,
    this.brightness,
    this.semanticColors,
    this.roleColors,
    SoftGradientPreset? cardGradient,
    SoftComponentStyles? styles,
    // Public parameter names remain stable; nullable fields distinguish inheritance.
    // ignore: prefer_initializing_formals
  }) : _cardGradient = cardGradient,
       // ignore: prefer_initializing_formals
       _styles = styles,
       // ignore: prefer_initializing_formals
       _accent = accent,
       _radius = radius,
       _spacing = spacing,
       _shadow = shadow,
       _controlHeight = controlHeight,
       assert(radius == null || radius >= 0),
       assert(spacing == null || spacing >= 0),
       assert(shadow == null || (shadow >= 0 && shadow <= 1)),
       assert(controlHeight == null || controlHeight >= 48);
  static const defaultAccent = Color(0xFF66D8EF);
  static const phi = 1.618033988749895;
  static const defaultRadius = 52 / (phi * phi);
  final Widget child;
  final Color? _accent;
  final double? _radius, _spacing, _shadow, _controlHeight;
  Color get accent => _accent ?? defaultAccent;
  double get radius => _radius ?? defaultRadius;
  double get spacing => _spacing ?? 24;
  double get shadow => _shadow ?? .085;
  double get controlHeight => _controlHeight ?? 52;
  final Brightness? brightness;
  final SoftSemanticColors? semanticColors;
  final SoftRoleColors? roleColors;
  final SoftGradientPreset? _cardGradient;
  final SoftComponentStyles? _styles;
  SoftGradientPreset get cardGradient =>
      _cardGradient ?? SoftGradientPreset.none;
  SoftComponentStyles get styles => _styles ?? const SoftComponentStyles();
  bool get isDark => brightness == Brightness.dark;
  double get insetRadius => radius;
  double get controlRadius => radius;
  Color get ink => isDark ? const Color(0xFFF1F4F6) : const Color(0xFF17191C);
  Color get onAccent =>
      accent.computeLuminance() > .179 ? Colors.black : Colors.white;
  Color get muted => isDark ? const Color(0xFFADB8C3) : const Color(0xFF5C646D);
  Color get background =>
      isDark ? const Color(0xFF14191F) : const Color(0xFFEEF0F2);
  Color get surface =>
      isDark ? const Color(0xFF252E38) : const Color(0xFFFCFCFD);
  Color get surfaceEnd =>
      isDark ? const Color(0xFF1D252E) : const Color(0xFFF0F1F3);

  /// Visible control boundary, separate from the decorative white highlight.
  Color get controlBorder =>
      isDark ? const Color(0xFF8B9AAB) : const Color(0xFF828A95);
  Color get border => isDark ? const Color(0xFF536171) : Colors.white;
  SoftRoleColors get roles =>
      roleColors ?? (isDark ? SoftRoleColors.dark : SoftRoleColors.light);
  Color color(SoftTone tone) => switch (tone) {
    SoftTone.neutral => muted,
    SoftTone.primary =>
      isDark ? Color.lerp(accent, Colors.white, .35)! : accent,
    SoftTone.secondary => roles.secondary,
    SoftTone.tertiary => roles.tertiary,
    SoftTone.ai => roles.ai,
    SoftTone.success => semantic.success,
    SoftTone.warning => semantic.warning,
    SoftTone.error => semantic.error,
    SoftTone.info => semantic.info,
  };
  Color container(SoftTone tone) => tone == SoftTone.neutral
      ? surface
      : Color.lerp(surface, color(tone), isDark ? .14 : .24)!;
  Gradient? gradientFor(SoftGradientPreset preset) {
    final tones = switch (preset) {
      SoftGradientPreset.none => <SoftTone>[],
      SoftGradientPreset.lagoon => [
        SoftTone.secondary,
        SoftTone.primary,
        SoftTone.secondary,
      ],
      SoftGradientPreset.peach => [
        SoftTone.tertiary,
        SoftTone.neutral,
        SoftTone.ai,
      ],
      SoftGradientPreset.lilac => [
        SoftTone.ai,
        SoftTone.primary,
        SoftTone.tertiary,
      ],
    };
    if (tones.isEmpty) return null;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: tones.map(container).toList(),
      stops: const [0, .48, 1],
    );
  }

  Color get tint => container(SoftTone.primary);
  SoftSemanticColors get semantic =>
      semanticColors ??
      (isDark ? SoftSemanticColors.dark : SoftSemanticColors.light);
  SoftDesign copyWith({required Widget child}) => SoftDesign(
    accent: _accent,
    radius: _radius,
    spacing: _spacing,
    shadow: _shadow,
    controlHeight: _controlHeight,
    brightness: brightness,
    semanticColors: semanticColors,
    roleColors: roleColors,
    cardGradient: _cardGradient,
    styles: _styles,
    child: child,
  );
  static SoftDesign of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SoftDesignScope>()?.design ??
      fromTheme(Theme.of(context));

  static SoftDesign fromTheme(ThemeData theme) =>
      theme.extension<SoftThemeData>()?.design ??
      SoftDesign(
        accent: theme.colorScheme.primary,
        brightness: theme.brightness,
        child: const SizedBox(),
      );
  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final inherited = fromTheme(base);
    final d = SoftDesign(
      accent: _accent ?? inherited.accent,
      radius: _radius ?? inherited.radius,
      spacing: _spacing ?? inherited.spacing,
      shadow: _shadow ?? inherited.shadow,
      controlHeight: _controlHeight ?? inherited.controlHeight,
      brightness: brightness ?? base.brightness,
      semanticColors: semanticColors ?? inherited.semanticColors,
      roleColors: roleColors ?? inherited.roleColors,
      cardGradient: _cardGradient ?? inherited.cardGradient,
      styles: _styles ?? inherited.styles,
      child: child,
    );
    return _SoftDesignScope(
      design: d,
      child: AnimatedTheme(
        data: applyToTheme(base, d),
        duration: SoftMotion.duration(context, 260),
        curve: SoftMotion.curve,
        child: child,
      ),
    );
  }

  /// Builds Material and Luma styles from the same resolved design.
  static ThemeData applyToTheme(ThemeData base, SoftDesign d) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(d.radius),
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(d.radius),
      borderSide: BorderSide(color: d.controlBorder, width: 1.5),
    );
    final scheme =
        ColorScheme.fromSeed(
          seedColor: d.accent,
          brightness: d.brightness!,
          surface: d.surface,
        ).copyWith(
          primary: d.accent,
          onPrimary: d.onAccent,
          onSurface: d.ink,
          error: d.semantic.error,
          secondary: d.roles.secondary,
          tertiary: d.roles.tertiary,
          secondaryContainer: d.container(SoftTone.secondary),
          tertiaryContainer: d.container(SoftTone.tertiary),
          onSecondaryContainer: d.ink,
          onTertiaryContainer: d.ink,
        );
    final input = InputDecorationThemeData(
      filled: true,
      fillColor: d.surface,
      labelStyle: base.textTheme.bodyMedium?.copyWith(color: d.muted),
      hintStyle: base.textTheme.bodyMedium?.copyWith(color: d.muted),
      border: border,
      enabledBorder: border,
      disabledBorder: border.copyWith(
        borderSide: BorderSide(
          color: d.controlBorder.withValues(alpha: .4),
          width: 1.5,
        ),
      ),
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(color: d.semantic.error, width: 1.5),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(color: d.semantic.error, width: 1.5),
      ),
    );
    return base.copyWith(
      extensions: [
        ...base.extensions.values.where((e) => e is! SoftThemeData),
        SoftThemeData(d),
      ],
      brightness: d.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: d.background,
      textTheme: base.textTheme.apply(bodyColor: d.ink, displayColor: d.ink),
      iconTheme: IconThemeData(color: d.ink),
      textButtonTheme: TextButtonThemeData(
        style:
            TextButton.styleFrom(
              foregroundColor: d.ink,
              minimumSize: const Size(48, 48),
              shape: shape,
            ).copyWith(
              side: WidgetStateProperty.resolveWith(
                (s) => s.contains(WidgetState.focused)
                    ? BorderSide(color: scheme.primary, width: 2)
                    : BorderSide.none,
              ),
            ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style:
            IconButton.styleFrom(
              shape: shape,
              minimumSize: const Size(48, 48),
              foregroundColor: d.ink,
            ).copyWith(
              side: WidgetStateProperty.resolveWith(
                (s) => s.contains(WidgetState.focused)
                    ? BorderSide(color: scheme.primary, width: 2)
                    : BorderSide.none,
              ),
            ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: shape,
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: shape,
        selectedColor: d.tint,
        backgroundColor: d.surface,
        labelStyle: base.textTheme.labelLarge?.copyWith(color: d.ink),
        side: BorderSide(color: d.border),
      ),
      inputDecorationTheme: d.styles.input ?? input,
      dialogTheme: base.dialogTheme.copyWith(
        shape: shape,
        backgroundColor: d.surface,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(color: d.ink),
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(color: d.ink),
      ),
      popupMenuTheme: base.popupMenuTheme.copyWith(
        shape: shape,
        color: d.surface,
        textStyle: TextStyle(color: d.ink),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: d.ink,
          borderRadius: BorderRadius.circular(d.radius),
        ),
        textStyle: TextStyle(color: d.surface),
      ),
      datePickerTheme: base.datePickerTheme.copyWith(
        shape: shape,
        backgroundColor: d.surface,
        headerBackgroundColor: d.tint,
      ),
      timePickerTheme: base.timePickerTheme.copyWith(
        shape: shape,
        backgroundColor: d.surface,
        dialBackgroundColor: d.tint,
      ),
      dividerColor: d.border.withValues(alpha: .5),
    );
  }
}

class _SoftDesignScope extends InheritedWidget {
  const _SoftDesignScope({required this.design, required super.child});
  final SoftDesign design;
  @override
  bool updateShouldNotify(_SoftDesignScope old) =>
      design.accent != old.design.accent ||
      design.radius != old.design.radius ||
      design.spacing != old.design.spacing ||
      design.shadow != old.design.shadow ||
      design.controlHeight != old.design.controlHeight ||
      design.brightness != old.design.brightness ||
      design.semanticColors != old.design.semanticColors ||
      design.styles != old.design.styles ||
      design.roleColors != old.design.roleColors ||
      design.cardGradient != old.design.cardGradient;
}

/// Theme extension shared by Material widgets and Luma components.
@immutable
class SoftThemeData extends ThemeExtension<SoftThemeData> {
  const SoftThemeData(this.design);
  final SoftDesign design;
  @override
  SoftThemeData copyWith({SoftDesign? design}) =>
      SoftThemeData(design ?? this.design);
  @override
  SoftThemeData lerp(covariant SoftThemeData? other, double t) {
    if (other == null) return this;
    final a = design, b = other.design;
    return SoftThemeData(
      SoftDesign(
        accent: Color.lerp(a.accent, b.accent, t),
        radius: a.radius + (b.radius - a.radius) * t,
        spacing: a.spacing + (b.spacing - a.spacing) * t,
        shadow: a.shadow + (b.shadow - a.shadow) * t,
        controlHeight:
            a.controlHeight + (b.controlHeight - a.controlHeight) * t,
        brightness: t < .5 ? a.brightness : b.brightness,
        semanticColors: t < .5 ? a.semanticColors : b.semanticColors,
        roleColors: t < .5 ? a.roleColors : b.roleColors,
        cardGradient: t < .5 ? a.cardGradient : b.cardGradient,
        styles: t < .5 ? a.styles : b.styles,
        child: const SizedBox(),
      ),
    );
  }
}
