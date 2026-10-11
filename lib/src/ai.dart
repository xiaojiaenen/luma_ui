import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'components.dart';
import 'controls.dart';
import 'design.dart';
import 'motion.dart';

enum SoftAIStatus { thinking, streaming, complete, error }

class SoftAIBubble extends StatelessWidget {
  const SoftAIBubble({
    super.key,
    this.gradient,
    this.gradientPreset = SoftGradientPreset.lilac,
    required this.text,
    this.status = SoftAIStatus.complete,
    this.model = 'Studio assistant',
    this.onCopy,
    this.onRetry,
    this.onStop,
  });
  final String text, model;
  final SoftAIStatus status;
  final VoidCallback? onCopy, onRetry, onStop;
  final Gradient? gradient;
  final SoftGradientPreset gradientPreset;
  @override
  Widget build(BuildContext context) => SoftReveal(
    child: SoftSurface(
      tone: SoftTone.ai,
      gradientPreset: gradientPreset,
      gradient: gradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: SoftDesign.of(context).surface,
                  borderRadius: BorderRadius.circular(
                    SoftDesign.of(context).controlRadius,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: SoftDesign.of(context).roles.ai,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  model,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              if (status == SoftAIStatus.complete)
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16,
                  color: SoftDesign.of(context).muted,
                ),
            ],
          ),
          const SizedBox(height: 20),
          SoftMotion.animateSize(
            context,
            duration: SoftMotion.duration(context, 240),
            curve: SoftMotion.curve,
            alignment: Alignment.topLeft,
            child: AnimatedSwitcher(
              duration: SoftMotion.duration(context),
              child: status == SoftAIStatus.thinking
                  ? const SoftThinkingIndicator(key: ValueKey('thinking'))
                  : Column(
                      key: ValueKey(
                        status == SoftAIStatus.error ? 'error' : 'answer',
                      ),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 280),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              text,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.8,
                                color: SoftDesign.of(context).ink,
                              ),
                            ),
                          ),
                        ),
                        if (status == SoftAIStatus.streaming) ...[
                          const SizedBox(height: 12),
                          SoftProgress(value: null),
                        ],
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  switch (status) {
                    SoftAIStatus.thinking => '正在理解你的想法',
                    SoftAIStatus.streaming => '正在生成…',
                    SoftAIStatus.complete => 'AI 生成内容 · 请核对',
                    SoftAIStatus.error => '生成失败，请重试',
                  },
                  style: TextStyle(
                    fontSize: 11,
                    color: SoftDesign.of(context).muted,
                  ),
                ),
              ),
              if ((status == SoftAIStatus.thinking ||
                      status == SoftAIStatus.streaming) &&
                  onStop != null)
                IconButton(
                  tooltip: 'Stop generation',
                  onPressed: onStop,
                  icon: const Icon(Icons.stop_circle_outlined, size: 20),
                ),
              if (status == SoftAIStatus.complete && onCopy != null)
                IconButton(
                  tooltip: 'Copy response',
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded, size: 18),
                ),
              if ((status == SoftAIStatus.complete ||
                      status == SoftAIStatus.error) &&
                  onRetry != null)
                IconButton(
                  tooltip: 'Regenerate response',
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

class SoftThinkingIndicator extends StatefulWidget {
  const SoftThinkingIndicator({super.key, this.label = 'Thinking'});
  final String label;
  @override
  State<SoftThinkingIndicator> createState() => _SoftThinkingIndicatorState();
}

class _SoftThinkingIndicatorState extends State<SoftThinkingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      controller.stop();
    } else {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.label,
    liveRegion: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) => Row(
            children: List.generate(
              3,
              (i) => Opacity(
                opacity:
                    (.35 +
                    .65 *
                        (math.sin(controller.value * math.pi * 2 - i * .9) +
                            1) /
                        2),
                child: Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: SoftDesign.of(context).ink,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.label,
          style: TextStyle(fontSize: 13, color: SoftDesign.of(context).muted),
        ),
      ],
    ),
  );
}

class SoftPromptCard extends StatelessWidget {
  const SoftPromptCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    this.icon = Icons.auto_awesome_outlined,
  });
  final String title, description;
  final VoidCallback onTap;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SoftPress(
    child: Material(
      color: SoftDesign.of(context).surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SoftDesign.of(context).insetRadius),
        side: BorderSide(color: SoftDesign.of(context).border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SoftDesign.of(context).insetRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: SoftDesign.of(context).muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_outward_rounded, size: 16),
            ],
          ),
        ),
      ),
    ),
  );
}
