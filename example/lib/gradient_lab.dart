import 'package:flutter/material.dart';
import 'package:luma_ui/luma_ui.dart';

class GradientLab extends StatefulWidget {
  const GradientLab({super.key});
  @override
  State<GradientLab> createState() => _GradientLabState();
}

class _GradientLabState extends State<GradientLab> {
  int selected = 0;
  bool reverse = false;
  @override
  Widget build(BuildContext context) {
    final d = SoftDesign.of(context);
    final presets = [
      SoftGradientPreset.lagoon,
      SoftGradientPreset.peach,
      SoftGradientPreset.lilac,
    ];
    const names = ['青屿 · 青绿与冰蓝', '暖霞 · 杏桃与灰紫', '暮色 · 灰紫与暖杏'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Color in motion / 渐变与反馈',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text('保留原来的轮廓与高光。悬停轻抬，按下轻收，点击卡片切换选中状态。'),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SoftButton(
              label: '改变渐变方向',
              icon: Icons.swap_horiz_rounded,
              onPressed: () => setState(() => reverse = !reverse),
            ),
            SoftButton(
              label: '查看反馈',
              icon: Icons.check_rounded,
              onPressed: () => showSoftToast(
                context,
                '已保存渐变配置',
                description: '演示反馈，未写入持久化存储',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SoftResponsiveGrid(
          minItemWidth: 240,
          children: [
            for (var i = 0; i < presets.length; i++)
              SoftSurface(
                semanticLabel: names[i],
                selected: selected == i,
                onTap: () => setState(() => selected = i),
                gradient: LinearGradient(
                  begin: reverse ? Alignment.bottomRight : Alignment.topLeft,
                  end: reverse ? Alignment.topLeft : Alignment.bottomRight,
                  colors: (d.gradientFor(presets[i])! as LinearGradient).colors,
                  stops: const [0, .48, 1],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '0${i + 1}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: AnimatedSwitcher(
                            duration: SoftMotion.duration(context, 180),
                            child: Icon(
                              selected == i
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              key: ValueKey(selected == i),
                              size: 22,
                              color: d.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      names[i],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('三色渐变 · 支持亮暗主题'),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        SoftSurface(
          inset: true,
          child: AnimatedSwitcher(
            duration: SoftMotion.duration(context, 220),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, .025),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: SizedBox(
              key: ValueKey(selected),
              width: double.infinity,
              child: Text('当前选中：${names[selected]}。内容切换淡入，容器位置保持稳定。'),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
