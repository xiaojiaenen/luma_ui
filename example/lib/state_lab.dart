import 'package:flutter/material.dart';
import 'package:luma_ui/luma_ui.dart';

/// Explicit states for visual review; focus/hover/pressed are forced only here.
class StateLab extends StatefulWidget {
  const StateLab({super.key});
  @override
  State<StateLab> createState() => _StateLabState();
}

class _StateLabState extends State<StateLab> {
  final hover = WidgetStatesController({WidgetState.hovered});
  final focus = WidgetStatesController({WidgetState.focused});
  final pressed = WidgetStatesController({WidgetState.pressed});
  @override
  void dispose() {
    hover.dispose();
    focus.dispose();
    pressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 32),
      Text(
        'State & accessibility lab',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 8),
      const Text(
        'Tab 移动焦点，Enter / Space 激活；分段控件支持左右方向键。加载阻止重复提交，错误与选中状态有明确描边。',
      ),
      const SizedBox(height: 20),
      MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: SoftResponsiveGrid(
          minItemWidth: 230,
          children: [
            SoftButton(label: 'Default · 默认', onPressed: () {}),
            SoftButton(
              label: 'Hover · 悬停',
              statesController: hover,
              onPressed: () {},
            ),
            SoftButton(
              label: 'Focus · 聚焦',
              statesController: focus,
              onPressed: () {},
            ),
            SoftButton(
              label: 'Pressed · 按下',
              statesController: pressed,
              onPressed: () {},
            ),
            const SoftButton(label: 'Disabled · 禁用'),
            SoftButton(label: 'Loading · 加载', loading: true, onPressed: () {}),
            SoftButton(label: 'Error · 错误', error: true, onPressed: () {}),
            SoftButton(
              label: 'Selected · 选中',
              selected: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      const SoftResponsiveGrid(
        minItemWidth: 230,
        children: [
          SoftTextField(label: '正常输入', helperText: 'Tab 聚焦，输入文字'),
          SoftTextField(label: '校验错误', errorText: '请输入有效内容'),
          SoftTextField(label: '禁用输入', enabled: false),
          SoftTextField(label: '只读输入', readOnly: true, hint: '只读也允许复制'),
        ],
      ),
      const SizedBox(height: 40),
    ],
  );
}
