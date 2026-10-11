import 'package:flutter/material.dart';

import 'components.dart';
import 'design.dart';
import 'motion.dart';

class SoftResponsiveGrid extends StatelessWidget {
  const SoftResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 240,
    this.gap = 16,
  });
  final List<Widget> children;
  final double minItemWidth, gap;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final n = ((box.maxWidth + gap) / (minItemWidth + gap)).floor().clamp(
        1,
        6,
      );
      final w = (box.maxWidth - gap * (n - 1)) / n;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: children.map((c) => SizedBox(width: w, child: c)).toList(),
      );
    },
  );
}

class SoftSplitLayout extends StatelessWidget {
  const SoftSplitLayout({
    super.key,
    required this.leading,
    required this.trailing,
    this.breakpoint = 640,
  });
  final Widget leading, trailing;
  final double breakpoint;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => box.maxWidth < breakpoint
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [leading, const SizedBox(height: 16), trailing],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: leading),
              const SizedBox(width: 16),
              Expanded(child: trailing),
            ],
          ),
  );
}

class SoftSidebarLayout extends StatelessWidget {
  const SoftSidebarLayout({
    super.key,
    required this.sidebar,
    required this.content,
  });
  final Widget sidebar, content;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, b) => b.maxWidth < 720
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [sidebar, const SizedBox(height: 16), content],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 200, child: sidebar),
              const SizedBox(width: 24),
              Expanded(child: content),
            ],
          ),
  );
}

class SoftWrapLayout extends StatelessWidget {
  const SoftWrapLayout({super.key, required this.children, this.spacing = 12});
  final List<Widget> children;
  final double spacing;
  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: spacing, runSpacing: spacing, children: children);
}

class SoftScrollPanel extends StatelessWidget {
  const SoftScrollPanel({super.key, required this.child, this.height = 240});
  final Widget child;
  final double height;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: SingleChildScrollView(child: child),
  );
}

class SoftAspectCard extends StatelessWidget {
  const SoftAspectCard({
    super.key,
    required this.child,
    this.ratio = 1.61803398875,
  });
  final Widget child;
  final double ratio;
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: ratio,
    child: SoftSurface(child: Center(child: child)),
  );
}

class SoftMasonryLayout extends StatelessWidget {
  const SoftMasonryLayout({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, b) {
      final n = b.maxWidth < 480 ? 1 : 2;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var col = 0; col < n; col++) ...[
            if (col > 0) const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  for (var i = col; i < children.length; i += n)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: children[i],
                    ),
                ],
              ),
            ),
          ],
        ],
      );
    },
  );
}

class SoftSection extends StatelessWidget {
  const SoftSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
  });
  final String title;
  final String? description;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      if (description != null) ...[
        const SizedBox(height: 6),
        Text(description!, maxLines: 3, overflow: TextOverflow.ellipsis),
      ],
      const SizedBox(height: 20),
      child,
    ],
  );
}

class SoftToolbar extends StatelessWidget {
  const SoftToolbar({super.key, required this.actions});
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => SoftSurface(
    padding: const EdgeInsets.all(8),
    child: Wrap(spacing: 8, runSpacing: 8, children: actions),
  );
}

class SoftPageHeader extends StatelessWidget {
  const SoftPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });
  final String title, subtitle;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => SoftSplitLayout(
    breakpoint: 600,
    leading: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(subtitle, maxLines: 3, overflow: TextOverflow.ellipsis),
      ],
    ),
    trailing: Wrap(spacing: 8, runSpacing: 8, children: actions),
  );
}

class SoftBottomActions extends StatelessWidget {
  const SoftBottomActions({
    super.key,
    required this.primary,
    required this.secondary,
  });
  final Widget primary, secondary;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: SoftSurface(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: secondary),
          const SizedBox(width: 12),
          Expanded(child: primary),
        ],
      ),
    ),
  );
}

class SoftDetailRows extends StatelessWidget {
  const SoftDetailRows({super.key, required this.values});
  final Map<String, String> values;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: values.entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    e.key,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: SoftDesign.of(context).muted),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    e.value,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: SoftDesign.of(context).ink),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}

class SoftTimeline extends StatelessWidget {
  const SoftTimeline({super.key, required this.events});
  final Map<String, String> events;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: events.entries
        .map(
          (e) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SoftDesign.of(context).accent,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 54,
                    color: SoftDesign.of(context).background,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.key,
                      style: TextStyle(
                        fontSize: 11,
                        color: SoftDesign.of(context).muted,
                      ),
                    ),
                    Text(e.value, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        )
        .toList(),
  );
}

class SoftExpandablePanel extends StatelessWidget {
  const SoftExpandablePanel({
    super.key,
    required this.expanded,
    required this.child,
  });
  final bool expanded;
  final Widget child;
  @override
  Widget build(BuildContext context) => MediaQuery.disableAnimationsOf(context)
      ? (expanded ? child : const SizedBox.shrink())
      : AnimatedSize(
          duration: SoftMotion.duration(context),
          curve: SoftMotion.curve,
          alignment: Alignment.topLeft,
          child: expanded ? child : const SizedBox.shrink(),
        );
}

class SoftSafeText extends StatelessWidget {
  const SoftSafeText(this.text, {super.key, this.maxLines = 2, this.style});
  final String text;
  final int maxLines;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) => Text(
    text,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: style,
  );
}
