import 'package:flutter/material.dart';

import 'design.dart';
import 'motion.dart';
import 'materials.dart';
import 'keyboard.dart';

/// Shared visual tokens. Components never define their own corner radii.
abstract final class SoftTokens {
  static const background = Color(0xFFEEF0F2);
  static const ink = Color(0xFF17191C);
  static const muted = Color(0xFF737980);
  static const accent = Color(0xFF66D8EF);
  static const tint = Color(0xFFDDF6FA);
  static const fontFamily = 'packages/luma_ui/HarmonyOSSans';
  static const monoFontFamily = 'packages/luma_ui/JetBrainsMono';
  static const radius = SoftDesign.defaultRadius;
  static const insetRadius = radius;
  static const controlRadius = radius;
  static const space = 24.0;
  static const duration = Duration(milliseconds: 180);
  static ThemeData theme({
    String? fontFamily = SoftTokens.fontFamily,
    Color accentColor = accent,
    Brightness brightness = Brightness.light,
  }) => ThemeData(
    fontFamily: fontFamily,
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: brightness == Brightness.dark
        ? const Color(0xFF14191F)
        : background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: brightness,
      surface: brightness == Brightness.dark
          ? const Color(0xFF252E38)
          : background,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      backgroundColor: brightness == Brightness.dark
          ? const Color(0xFF252E38)
          : background,
      headerBackgroundColor: Color.lerp(
        brightness == Brightness.dark ? const Color(0xFF252E38) : Colors.white,
        accentColor,
        .24,
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      backgroundColor: brightness == Brightness.dark
          ? const Color(0xFF252E38)
          : background,
      dialBackgroundColor: Color.lerp(
        brightness == Brightness.dark ? const Color(0xFF252E38) : Colors.white,
        accentColor,
        .24,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: brightness == Brightness.dark
            ? const Color(0xFFF1F4F6)
            : ink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: brightness == Brightness.dark
          ? const Color(0xFF252E38)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(controlRadius),
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.dark ? const Color(0xFFF1F4F6) : ink,
        letterSpacing: -1,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.dark ? const Color(0xFFF1F4F6) : ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.dark ? const Color(0xFFF1F4F6) : ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: brightness == Brightness.dark ? const Color(0xFFADB8C3) : muted,
        height: 1.5,
      ),
    ),
  );
}

class SoftSurface extends StatelessWidget {
  const SoftSurface({
    super.key,
    required this.child,
    this.tinted = false,
    this.inset = false,
    this.padding,
    this.radius,
    this.tone = SoftTone.neutral,
    this.gradient,
    this.gradientPreset,
    this.onTap,
    this.selected = false,
    this.focusNode,
    this.semanticLabel,
  });
  final Widget child;
  final bool tinted, inset;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final SoftTone tone;
  final Gradient? gradient;
  final SoftGradientPreset? gradientPreset;
  final VoidCallback? onTap;
  final bool selected;
  final FocusNode? focusNode;
  final String? semanticLabel;
  @override
  Widget build(BuildContext context) {
    final d = SoftDesign.of(context);
    final result = SoftHighlight(
      radius: radius,
      child: AnimatedContainer(
        duration: SoftMotion.duration(context, 280),
        curve: SoftMotion.curve,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            radius ?? (inset ? d.insetRadius : d.radius),
          ),
          border: Border.all(
            color: selected ? d.accent : d.border.withValues(alpha: .95),
            width: 1.5,
          ),
          gradient:
              gradient ??
              d.gradientFor(gradientPreset ?? d.cardGradient) ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  d.surface,
                  tone != SoftTone.neutral
                      ? d.container(tone)
                      : tinted
                      ? d.tint
                      : d.surfaceEnd,
                ],
              ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF747F8B).withValues(alpha: d.shadow),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: d.border.withValues(alpha: d.isDark ? .05 : .75),
              blurRadius: 10,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            focusNode: focusNode,
            canRequestFocus: onTap != null,
            borderRadius: BorderRadius.circular(radius ?? d.radius),
            hoverColor: d.ink.withValues(alpha: .035),
            focusColor: d.tint.withValues(alpha: .6),
            splashColor: d.accent.withValues(alpha: .1),
            highlightColor: d.ink.withValues(alpha: .025),
            child: Padding(
              padding: padding ?? EdgeInsets.all(d.spacing),
              child: SoftMotion.animateSize(
                context,
                duration: SoftMotion.duration(context, 260),
                alignment: Alignment.topLeft,
                clipBehavior: Clip.none,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
    return Semantics(
      selected: onTap != null || selected ? selected : null,
      label: semanticLabel,
      child: onTap == null ? result : SoftPress(child: result),
    );
  }
}

class SoftButton extends StatelessWidget {
  const SoftButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.primary = false,
    this.tone = SoftTone.primary,
    this.loading = false,
    this.selected = false,
    this.error = false,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.semanticLabel,
    this.style,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool primary, loading, selected, error, autofocus;
  final SoftTone tone;
  final FocusNode? focusNode;
  final WidgetStatesController? statesController;
  final String? semanticLabel;
  final ButtonStyle? style;
  @override
  Widget build(BuildContext context) {
    final d = SoftDesign.of(context);
    final buttonColor = tone == SoftTone.primary ? d.ink : d.color(tone);
    final foreground = primary
        ? (tone == SoftTone.primary
              ? d.surface
              : buttonColor.computeLuminance() > .179
              ? Colors.black
              : Colors.white)
        : d.ink;
    final defaults =
        FilledButton.styleFrom(
          minimumSize: Size(48, d.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(d.radius),
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return d.surfaceEnd;
            return primary
                ? buttonColor
                : selected
                ? d.container(tone)
                : d.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled) && !loading
                ? d.muted
                : foreground,
          ),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => foreground.withValues(
              alpha: states.contains(WidgetState.pressed)
                  ? .14
                  : states.contains(WidgetState.hovered)
                  ? .07
                  : .0,
            ),
          ),
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(WidgetState.focused)
                  ? Theme.of(context).colorScheme.primary
                  : error
                  ? d.semantic.error
                  : selected
                  ? d.accent
                  : d.border,
              width: 2,
            ),
          ),
        );
    final buttonStyle = (style ?? const ButtonStyle()).merge(
      (d.styles.button ?? const ButtonStyle()).merge(defaults),
    );
    return Semantics(
      button: true,
      selected: selected,
      enabled: onPressed != null && !loading,
      label: semanticLabel,
      liveRegion: loading,
      child: SoftPress(
        enabled: onPressed != null && !loading,
        child: FilledButton(
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          onPressed: loading ? null : onPressed,
          style: buttonStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading) ...[
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    value: MediaQuery.disableAnimationsOf(context) ? 1 : null,
                    strokeWidth: 2,
                    color: d.muted,
                    semanticsLabel: 'Loading',
                  ),
                ),
                const SizedBox(width: 8),
              ] else if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SoftTag extends StatelessWidget {
  const SoftTag(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    decoration: BoxDecoration(
      color: SoftDesign.of(context).surface,
      borderRadius: BorderRadius.circular(SoftDesign.of(context).controlRadius),
    ),
    child: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12, color: SoftDesign.of(context).muted),
    ),
  );
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    this.gradient,
    this.gradientPreset = SoftGradientPreset.lagoon,
    required this.name,
    required this.role,
    required this.tags,
    this.avatar,
    this.onContact,
    this.onBookmark,
    this.bookmarked = false,
  });
  final String name, role;
  final List<String> tags;
  final ImageProvider? avatar;
  final VoidCallback? onContact, onBookmark;
  final bool bookmarked;
  final Gradient? gradient;
  final SoftGradientPreset gradientPreset;
  @override
  Widget build(BuildContext context) => SoftSurface(
    tone: SoftTone.secondary,
    gradientPreset: gradientPreset,
    gradient: gradient,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: SoftDesign.of(context).roles.secondary
                  .withValues(alpha: .3),
              backgroundImage: avatar,
              child: avatar == null
                  ? Icon(
                      Icons.person_outline_rounded,
                      size: 32,
                      color: SoftDesign.of(context).ink,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: SoftTag('AVAILABLE'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(role, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map(SoftTag.new).toList(),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: SoftButton(label: 'Get in touch', onPressed: onContact),
            ),
            const SizedBox(width: 12),
            IconButton.filledTonal(
              onPressed: onBookmark,
              tooltip: bookmarked ? 'Remove bookmark' : 'Bookmark',
              style: IconButton.styleFrom(
                backgroundColor: SoftDesign.of(context).surface,
                minimumSize: const Size(52, 52),
              ),
              icon: Icon(
                bookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class SoftSegmented extends StatelessWidget {
  const SoftSegmented({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    assert(labels.isNotEmpty);
    assert(selected >= 0 && selected < labels.length);
    final radius = SoftDesign.of(context).controlRadius;
    final inner = radius;
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (_, event) =>
          softSelectionKey(context, event, selected, labels.length, onChanged),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: SoftDesign.of(context).background,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: LayoutBuilder(
          builder: (context, box) => SizedBox(
            height: 48,
            child: Stack(
              children: [
                AnimatedPositionedDirectional(
                  duration: SoftMotion.duration(context, 260),
                  curve: SoftMotion.curve,
                  start: selected * box.maxWidth / labels.length,
                  top: 0,
                  bottom: 0,
                  width: box.maxWidth / labels.length,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: SoftDesign.of(context).surface,
                      borderRadius: BorderRadius.circular(inner),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: List.generate(
                    labels.length,
                    (i) => Expanded(
                      child: Semantics(
                        selected: selected == i,
                        child: SizedBox(
                          height: 48,
                          child: TextButton(
                            onPressed: () => onChanged(i),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              minimumSize: const Size(48, 48),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(inner),
                              ),
                            ),
                            child: Text(
                              labels[i],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: selected == i
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: SoftDesign.of(context).ink,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.values,
    required this.selected,
    required this.onChanged,
  });
  final String title, value;
  final List<double> values;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftSegmented(
          labels: const ['All', 'Active', 'Enrolled'],
          selected: selected,
          onChanged: onChanged,
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text(
                    'Overview · demo data',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: AnimatedSwitcher(
                duration: SoftMotion.duration(context),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    key: ValueKey(value),
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Semantics(
          label: '$title trend: ${values.join(', ')}',
          child: SizedBox(
            height: 120,
            width: double.infinity,
            child: SoftReveal(
              identity: values.join(","),
              child: CustomPaint(
                painter: _TrendPainter(
                  values,
                  SoftDesign.of(context).accent,
                  SoftDesign.of(context).ink,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: Text('Jan', maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              child: Text('Mar', maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              child: Text('May', maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              child: Text('Jul', maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ],
    ),
  );
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.values, this.accent, this.ink);
  final Color accent, ink;
  final List<double> values;
  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) {
      return;
    }
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max == min ? 1 : max - min;
    final points = List.generate(
      values.length,
      (i) => Offset(
        i * size.width / (values.length - 1),
        size.height * .85 - (values[i] - min) / range * size.height * .65,
      ),
    );
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1], b = points[i];
      line.cubicTo(
        (a.dx + b.dx) / 2,
        a.dy,
        (a.dx + b.dx) / 2,
        b.dy,
        b.dx,
        b.dy,
      );
    }
    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final colors = [
      accent.withValues(alpha: .12),
      accent.withValues(alpha: .55),
    ];
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(colors: colors)
            .createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..shader = LinearGradient(
          colors: [accent, Color.lerp(accent, ink, .4)!],
        ).createShader(Offset.zero & size)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.accent != accent;
}

class UploadCard extends StatelessWidget {
  const UploadCard({
    super.key,
    this.fileName,
    this.progress = 0,
    this.onSelect,
    this.onCancel,
  }) : assert(progress >= 0 && progress <= 1);
  final String? fileName;
  final double progress;
  final VoidCallback? onSelect, onCancel;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: SoftDesign.of(context).tint,
          child: Icon(
            Icons.cloud_upload_outlined,
            color: SoftDesign.of(context).ink,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          fileName == null
              ? 'A little space for your files'
              : 'Your file is on its way',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Text('Choose a file to get started', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        if (fileName != null) ...[
          Row(
            children: [
              const Icon(Icons.description_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fileName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('${(progress * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              SoftDesign.of(context).controlRadius,
            ),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              color: SoftDesign.of(context).accent,
              backgroundColor: SoftDesign.of(context).background,
            ),
          ),
          const SizedBox(height: 24),
        ],
        Row(
          children: [
            if (onCancel != null) ...[
              Expanded(
                child: SoftButton(label: 'Cancel', onPressed: onCancel),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: SoftButton(
                label: fileName == null ? 'Choose file' : 'Choose another',
                primary: true,
                onPressed: onSelect,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, this.outgoing = false});
  final String message;
  final bool outgoing;
  @override
  Widget build(BuildContext context) => SoftReveal(
    identity: message,
    child: Align(
      alignment: outgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: .88,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: outgoing
                ? SoftDesign.of(context).tint
                : SoftDesign.of(context).surface,
            borderRadius: BorderRadius.circular(
              SoftDesign.of(context).controlRadius,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: SingleChildScrollView(
              child: Text(
                message,
                style: TextStyle(
                  color: SoftDesign.of(context).ink,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class SoftComposer extends StatefulWidget {
  const SoftComposer({super.key, required this.onSend});
  final ValueChanged<String> onSend;
  @override
  State<SoftComposer> createState() => _SoftComposerState();
}

class _SoftComposerState extends State<SoftComposer> {
  final controller = TextEditingController();
  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    widget.onSend(text);
    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: TextField(
          controller: controller,
          onSubmitted: (_) => send(),
          textInputAction: TextInputAction.send,
          decoration: InputDecoration(
            hintText: 'Write a message…',
            filled: true,
            fillColor: SoftDesign.of(context).surface,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                SoftDesign.of(context).controlRadius,
              ),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      IconButton.filled(
        onPressed: send,
        tooltip: 'Send message',
        style: IconButton.styleFrom(
          backgroundColor: SoftDesign.of(context).accent,
          foregroundColor: SoftDesign.of(context).ink,
          minimumSize: const Size(48, 48),
        ),
        icon: const Icon(Icons.arrow_upward_rounded),
      ),
    ],
  );
}

class SoftEmptyState extends StatelessWidget {
  const SoftEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.onAction,
    this.actionLabel = 'Set up now',
  });
  final String title, description, actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      children: [
        const SizedBox(height: 12),
        CircleAvatar(
          radius: 36,
          backgroundColor: SoftDesign.of(context).tint,
          child: Icon(
            Icons.notifications_none_rounded,
            size: 36,
            color: SoftDesign.of(context).ink,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SoftButton(label: actionLabel, onPressed: onAction),
        const SizedBox(height: 12),
      ],
    ),
  );
}
