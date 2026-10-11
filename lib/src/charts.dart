import 'strings.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'design.dart';
import 'motion.dart';

abstract final class SoftChartPalette {
  static Color series(BuildContext context, int index) {
    final colors = SoftDesign.of(context).roles.chart;
    return colors.isEmpty
        ? SoftDesign.of(context).accent
        : colors[index % colors.length];
  }
}

enum _ChartKind { line, area, bar, donut, gauge, radar, scatter, heatmap }

class _Chart extends StatelessWidget {
  const _Chart(this.kind, this.values);
  final _ChartKind kind;
  final List<double> values;
  final double height = 160;
  @override
  Widget build(BuildContext context) {
    final data = values.where((v) => v.isFinite).toList();
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(child: Text(softText(context, 'No chart data'))),
      );
    }
    return Semantics(
      label: '${kind.name} chart: ${data.join(', ')}',
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: TweenAnimationBuilder<double>(
          key: ValueKey('${kind.name}:${data.join(',')}'),
          tween: Tween(begin: 0, end: 1),
          duration: SoftMotion.duration(context, 420),
          curve: SoftMotion.curve,
          builder: (context, t, _) => CustomPaint(
            painter: _ChartPainter(
              kind,
              data,
              SoftDesign.of(context).accent,
              t,
              SoftDesign.of(context).radius,
              SoftDesign.of(context).ink,
              SoftDesign.of(context).background,
              SoftDesign.of(context).roles.chart,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(
    this.kind,
    this.values,
    this.accent,
    this.t,
    this.radius,
    this.ink,
    this.background,
    this.palette,
  );
  final _ChartKind kind;
  final List<double> values;
  final Color accent, ink, background;
  final List<Color> palette;
  final double t, radius;
  @override
  void paint(Canvas canvas, Size size) {
    final max = values.fold<double>(1, (a, b) => math.max(a, b.abs()));
    final rect = (Offset.zero & size).deflate(12);
    final paint = Paint()..color = accent;
    final line = Paint()
      ..color = Color.lerp(accent, ink, .28)!
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final base = Paint()..color = background;
    final r = math.min(rect.width, rect.height) / 2 - 5;
    final center = rect.center;
    if (kind == _ChartKind.donut || kind == _ChartKind.gauge) {
      final sum = values.fold<double>(0, (a, b) => a + math.max(0, b));
      if (sum == 0) {
        canvas.drawCircle(
          center,
          r,
          base
            ..style = PaintingStyle.stroke
            ..strokeWidth = 14,
        );
        return;
      }
      final arc = Rect.fromCircle(center: center, radius: r);
      var angle = kind == _ChartKind.gauge ? math.pi : -math.pi / 2;
      canvas.drawArc(
        arc,
        angle,
        kind == _ChartKind.gauge ? math.pi : math.pi * 2,
        false,
        Paint()
          ..color = background
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14,
      );
      for (var i = 0; i < values.length; i++) {
        final sweep =
            math.max(0, values[i]) /
            sum *
            (kind == _ChartKind.gauge ? math.pi : math.pi * 2) *
            t;
        canvas.drawArc(
          arc,
          angle,
          math.max(0, sweep - .04),
          false,
          Paint()
            ..color = palette.isEmpty ? accent : palette[i % palette.length]
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 14,
        );
        angle += sweep;
      }
      return;
    }
    if (kind == _ChartKind.radar) {
      for (var ring = 1; ring <= 3; ring++) {
        canvas.drawCircle(
          center,
          r * ring / 3,
          Paint()
            ..color = background
            ..style = PaintingStyle.stroke,
        );
      }
      final path = Path();
      for (var i = 0; i < values.length; i++) {
        final angle = i * math.pi * 2 / values.length - math.pi / 2;
        final p =
            center +
            Offset(math.cos(angle), math.sin(angle)) *
                (r * values[i].abs() / max * t);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, Paint()..color = accent.withValues(alpha: .3));
      canvas.drawPath(path, line);
      return;
    }
    if (kind == _ChartKind.heatmap) {
      const columns = 7;
      final rows = (values.length / columns).ceil();
      final w = rect.width / columns, h = rect.height / rows;
      for (var i = 0; i < values.length; i++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              rect.left + (i % columns) * w + 2,
              rect.top + (i ~/ columns) * h + 2,
              w - 4,
              h - 4,
            ),
            Radius.circular(radius),
          ),
          Paint()
            ..color = accent.withValues(
              alpha: (.12 + .88 * values[i].abs() / max) * t,
            ),
        );
      }
      return;
    }
    for (var i = 0; i < 4; i++) {
      final y = rect.top + rect.height * i / 3;
      canvas.drawLine(
        Offset(rect.left, y),
        Offset(rect.right, y),
        Paint()
          ..color = background
          ..strokeWidth = 1,
      );
    }
    if (kind == _ChartKind.bar) {
      final w = rect.width / values.length;
      for (var i = 0; i < values.length; i++) {
        final h = values[i].abs() / max * rect.height * t;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              rect.left + i * w + w * .18,
              rect.bottom - h,
              w * .64,
              h,
            ),
            Radius.circular(radius),
          ),
          paint,
        );
      }
      return;
    }
    final points = List.generate(
      values.length,
      (i) => Offset(
        rect.left +
            (values.length == 1 ? .5 : i / (values.length - 1)) * rect.width,
        rect.bottom - values[i].abs() / max * rect.height * t,
      ),
    );
    if (kind == _ChartKind.scatter) {
      for (final p in points) {
        canvas.drawCircle(p, 4, paint);
      }
      return;
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1], b = points[i];
      path.cubicTo(
        (a.dx + b.dx) / 2,
        a.dy,
        (a.dx + b.dx) / 2,
        b.dy,
        b.dx,
        b.dy,
      );
    }
    if (kind == _ChartKind.area) {
      final fill = Path.from(path)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.left, rect.bottom)
        ..close();
      canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accent.withValues(alpha: .55),
              accent.withValues(alpha: .02),
            ],
          ).createShader(rect),
      );
    }
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.kind != kind ||
      old.values != values ||
      old.accent != accent ||
      old.palette != palette ||
      old.t != t ||
      old.radius != radius;
}

class SoftLineChart extends StatelessWidget {
  const SoftLineChart({super.key, required this.values});
  final List<double> values;
  @override
  Widget build(BuildContext context) => _Chart(_ChartKind.line, values);
}

class SoftAreaChart extends StatelessWidget {
  const SoftAreaChart({super.key, required this.values});
  final List<double> values;
  @override
  Widget build(BuildContext context) => _Chart(_ChartKind.area, values);
}

class SoftBarChart extends StatelessWidget {
  const SoftBarChart({super.key, required this.values});
  final List<double> values;
  @override
  Widget build(BuildContext context) => _Chart(_ChartKind.bar, values);
}

class SoftDonutChart extends StatelessWidget {
  const SoftDonutChart({super.key, required this.values});
  final List<double> values;
  @override
  Widget build(BuildContext context) => _Chart(_ChartKind.donut, values);
}

class SoftGaugeChart extends StatelessWidget {
  const SoftGaugeChart({super.key, required this.value})
    : assert(value >= 0 && value <= 1);
  final double value;
  @override
  Widget build(BuildContext context) =>
      _Chart(_ChartKind.gauge, [value, 1 - value]);
}

class SoftRadarChart extends StatelessWidget {
  const SoftRadarChart({super.key, required this.values});
  final List<double> values;
  @override
  Widget build(BuildContext context) => _Chart(_ChartKind.radar, values);
}

class SoftScatterChart extends StatelessWidget {
  const SoftScatterChart({super.key, required this.values});
  final List<double> values;
  @override
  Widget build(BuildContext context) => _Chart(_ChartKind.scatter, values);
}

class SoftHeatmap extends StatelessWidget {
  const SoftHeatmap({super.key, required this.values});
  final List<double> values;
  @override
  Widget build(BuildContext context) => _Chart(_ChartKind.heatmap, values);
}

class SoftChartLegend extends StatelessWidget {
  const SoftChartLegend({super.key, required this.labels});
  final List<String> labels;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 16,
    runSpacing: 8,
    children: List.generate(
      labels.length,
      (i) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: SoftChartPalette.series(context, i),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              labels[i],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
}

class SoftComparisonBars extends StatelessWidget {
  const SoftComparisonBars({super.key, required this.values});
  final Map<String, double> values;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: values.entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text(
                    softText(context, e.key),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: e.value.clamp(0, 1)),
                    duration: SoftMotion.duration(context, 350),
                    builder: (context, v, _) => LinearProgressIndicator(
                      value: v,
                      color: SoftDesign.of(context).accent,
                      backgroundColor: SoftDesign.of(context).background,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(e.value * 100).round()}%',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}
