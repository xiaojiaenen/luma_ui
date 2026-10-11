import 'strings.dart';
import 'icons.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'components.dart';
import 'design.dart';
import 'motion.dart';

enum SoftToastTone { success, info, warning, error }

class SoftToast extends StatelessWidget {
  const SoftToast({
    super.key,
    required this.message,
    this.description,
    this.tone = SoftToastTone.success,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
  });
  final String message;
  final String? description, actionLabel;
  final SoftToastTone tone;
  final VoidCallback? onDismiss, onAction;
  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      SoftToastTone.success => SoftDesign.of(context).semantic.success,
      SoftToastTone.info => SoftDesign.of(context).semantic.info,
      SoftToastTone.warning => SoftDesign.of(context).semantic.warning,
      SoftToastTone.error => SoftDesign.of(context).semantic.error,
    };
    final icon = switch (tone) {
      SoftToastTone.success => Icons.check_rounded,
      SoftToastTone.info => Icons.auto_awesome_outlined,
      SoftToastTone.warning => Icons.priority_high_rounded,
      SoftToastTone.error => Icons.close_rounded,
    };
    return Semantics(
      liveRegion: true,
      child: SoftReveal(
        child: SoftSurface(
          inset: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(
                    SoftDesign.of(context).controlRadius,
                  ),
                ),
                child: SoftIcon(
                  icon,
                  color: tone == SoftToastTone.info
                      ? SoftDesign.of(context).ink
                      : color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SoftDesign.of(context).ink,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: SoftDesign.of(context).muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (actionLabel != null && onAction != null)
                      TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: SoftDesign.of(context).ink,
                        ),
                        child: Text(actionLabel!),
                      ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  tooltip: softText(context, 'Dismiss notification'),
                  icon: const SoftIcon(Icons.close_rounded, size: 16),
                  style: IconButton.styleFrom(
                    foregroundColor: SoftDesign.of(context).muted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSoftToast(
  BuildContext context,
  String message, {
  String? description,
  SoftToastTone tone = SoftToastTone.success,
  Duration duration = const Duration(seconds: 4),
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  final design = SoftDesign.of(context);
  final margin = math.max(16.0, (MediaQuery.sizeOf(context).width - 460) / 2);
  messenger.hideCurrentSnackBar();
  return messenger.showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: EdgeInsets.fromLTRB(margin, 0, margin, 20),
      content: SoftDesign(
        accent: design.accent,
        radius: design.radius,
        spacing: design.spacing,
        shadow: design.shadow,
        controlHeight: design.controlHeight,
        child: SoftToast(
          message: message,
          description: description,
          tone: tone,
          actionLabel: actionLabel,
          onAction: onAction == null
              ? null
              : () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
          onDismiss: messenger.hideCurrentSnackBar,
        ),
      ),
    ),
    snackBarAnimationStyle: AnimationStyle(
      duration: SoftMotion.duration(context, 260),
      reverseDuration: SoftMotion.duration(context, 180),
    ),
  );
}
