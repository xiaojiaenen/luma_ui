import 'strings.dart';
import 'icons.dart';

import 'package:flutter/material.dart';

import 'design.dart';
import 'motion.dart';
import 'keyboard.dart';

enum SoftNavigationStyle { dock, capsule, split }

enum SoftNavigationCorners { capsule, continuous, uniform }

class SoftNavItem {
  const SoftNavItem(this.label, this.icon, {this.selectedIcon});
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
}

/// Outer bar and selection share the same corner family.
class SoftNavigation extends StatelessWidget {
  const SoftNavigation({
    super.key,
    required this.selected,
    required this.onChanged,
    this.style = SoftNavigationStyle.dock,
    this.corners = SoftNavigationCorners.capsule,
    this.cornerRadius,
    this.onAction,
    this.actionIcon = Icons.add_rounded,
    this.actionLabel = 'Create',
    this.items = const [
      SoftNavItem(
        'Home',
        Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      SoftNavItem(
        'Chat',
        Icons.chat_bubble_outline_rounded,
        selectedIcon: Icons.chat_bubble_rounded,
      ),
      SoftNavItem(
        'Team',
        Icons.people_outline,
        selectedIcon: Icons.people_rounded,
      ),
      SoftNavItem('Tasks', Icons.task_alt_rounded),
    ],
  });
  final int selected;
  final ValueChanged<int> onChanged;
  final SoftNavigationStyle style;
  final SoftNavigationCorners corners;
  final double? cornerRadius;
  final List<SoftNavItem> items;
  final VoidCallback? onAction;
  final IconData actionIcon;
  final String actionLabel;
  @override
  Widget build(BuildContext context) {
    assert(items.length >= 2 && items.length <= 5);
    assert(selected >= 0 && selected < items.length);
    final design = SoftDesign.of(context);
    final compact = style == SoftNavigationStyle.capsule;
    final outerRadius = cornerRadius ?? design.radius;
    const inset = 6.0;
    final innerRadius = outerRadius;
    final height = compact ? 60.0 : 76.0;
    OutlinedBorder shape(double radius, {BorderSide side = BorderSide.none}) =>
        switch (corners) {
          SoftNavigationCorners.capsule => StadiumBorder(side: side),
          SoftNavigationCorners.continuous => RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(radius),
            side: side,
          ),
          SoftNavigationCorners.uniform => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: side,
          ),
        };
    final bar = Focus(
      canRequestFocus: false,
      onKeyEvent: (_, event) =>
          softSelectionKey(context, event, selected, items.length, onChanged),
      child: AnimatedContainer(
        key: const ValueKey('soft-nav-shell'),
        duration: SoftMotion.duration(context),
        decoration: ShapeDecoration(
          color: design.surface,
          shape: shape(
            outerRadius,
            side: BorderSide(color: design.border.withValues(alpha: .65)),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: design.isDark ? .15 : .05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(inset),
        child: LayoutBuilder(
          builder: (context, box) {
            return SizedBox(
              height: height - inset * 2,
              child: Stack(
                children: [
                  AnimatedPositionedDirectional(
                    duration: SoftMotion.duration(context, 300),
                    curve: SoftMotion.curve,
                    start: selected * box.maxWidth / items.length,
                    top: 0,
                    bottom: 0,
                    width: box.maxWidth / items.length,
                    child: AnimatedContainer(
                      key: const ValueKey('soft-nav-indicator'),
                      duration: SoftMotion.duration(context),
                      decoration: ShapeDecoration(
                        color: design.tint,
                        shape: shape(innerRadius),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(items.length, (i) {
                      return Expanded(
                        child: Semantics(
                          selected: selected == i,
                          child: Tooltip(
                            message: softText(context, items[i].label),
                            child: TextButton(
                              onPressed: () => onChanged(i),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(48, 48),
                                foregroundColor: SoftDesign.of(context).ink,
                                shape: shape(innerRadius),
                              ),
                              child: AnimatedDefaultTextStyle(
                                duration: SoftMotion.duration(context),
                                style: Theme.of(context).textTheme.labelSmall!
                                    .copyWith(
                                      fontSize: 11,
                                      color: selected == i
                                          ? SoftDesign.of(context).ink
                                          : SoftDesign.of(context).muted,
                                      fontWeight: selected == i
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedScale(
                                      scale: selected == i ? 1.08 : 1,
                                      duration: SoftMotion.duration(context),
                                      child: SoftIcon(
                                        selected == i
                                            ? items[i].selectedIcon ??
                                                  items[i].icon
                                            : items[i].icon,
                                        size: 22,
                                        color: selected == i
                                            ? SoftDesign.of(context).ink
                                            : SoftDesign.of(context).muted,
                                      ),
                                    ),
                                    if (!compact) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        softText(context, items[i].label),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    if (style != SoftNavigationStyle.split) {
      return bar;
    }
    return Row(
      children: [
        Expanded(child: bar),
        const SizedBox(width: 8),
        SoftPress(
          enabled: onAction != null,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Material(
              color: design.tint,
              shape: shape(
                outerRadius,
                side: BorderSide(color: design.border, width: 1.5),
              ),
              child: InkWell(
                onTap: onAction,
                customBorder: shape(outerRadius),
                child: Semantics(
                  button: true,
                  label: softText(context, actionLabel),
                  enabled: onAction != null,
                  child: Tooltip(
                    message: softText(context, actionLabel),
                    child: SoftIcon(
                      actionIcon,
                      color: onAction == null
                          ? SoftDesign.of(context).muted
                          : SoftDesign.of(context).ink,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
