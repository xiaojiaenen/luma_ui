import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luma_ui/luma_ui.dart';

import 'palette.dart';

class RefinedComponents extends StatefulWidget {
  const RefinedComponents({super.key});
  @override
  State<RefinedComponents> createState() => _RefinedComponentsState();
}

class _RefinedComponentsState extends State<RefinedComponents> {
  final hex = TextEditingController();
  String? colorError;
  int dock = 0, capsule = 0, split = 0;
  SoftAIStatus status = SoftAIStatus.complete;
  String prompt = '帮我设计一套更克制、更统一的 UI。';
  String answer = '从一个安静的界面开始。\n\n使用统一的圆角、留白和材质，把视觉重点留给内容。交互只在需要时轻轻回应。';
  Timer? timer;
  void generate() {
    timer?.cancel();
    setState(() {
      status = SoftAIStatus.thinking;
      answer = '';
    });
    const response =
        '建议从这三点细化组件：\n\n① 轮廓一致：选中态沿用容器的内轮廓。\n② 动效克制：用短距离位移与淡入表达状态变化。\n③ 颜色有节制：中性表面承载内容，主题色只强调操作。';
    var ticks = 0;
    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      ticks++;
      if (ticks < 8) {
        return;
      }
      final length = ((ticks - 7) * 7).clamp(0, response.length);
      setState(() {
        status = length == response.length
            ? SoftAIStatus.complete
            : SoftAIStatus.streaming;
        answer = response.substring(0, length);
      });
      if (status == SoftAIStatus.complete) {
        t.cancel();
      }
    });
  }

  void stop() {
    timer?.cancel();
    setState(() {
      status = SoftAIStatus.complete;
      if (answer.isEmpty) {
        answer = '已停止生成。';
      }
    });
  }

  void applyHex() {
    final input = hex.text.trim().replaceFirst('#', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(input)) {
      setState(() => colorError = '请输入六位 HEX，例如 A8CDB8');
      return;
    }
    galleryAccent.value = Color(0xFF000000 | int.parse(input, radix: 16));
    setState(() => colorError = null);
  }

  @override
  void dispose() {
    timer?.cancel();
    hex.dispose();
    super.dispose();
  }

  Widget heading(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            height: 1.6,
            color: SoftDesign.of(context).muted,
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SoftSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading('同一种质感，换一种心情', '主题色可修改，作用于整页组件。珍珠白保持安静，颜色留给重点。'),
            ValueListenableBuilder<Color>(
              valueListenable: galleryAccent,
              builder: (context, color, _) => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final entry in const <String, Color>{
                    '冰蓝': SoftTokens.accent,
                    '鼠尾草': Color(0xFFA8CDB8),
                    '薰衣草': Color(0xFFC7B8E7),
                    '杏桃': Color(0xFFEFC3A4),
                    '玫瑰': Color(0xFFE4B6C4),
                  }.entries)
                    ChoiceChip(
                      label: Text(entry.key),
                      selected: color == entry.value,
                      onSelected: (_) {
                        galleryAccent.value = entry.value;
                        hex.text = entry.value
                            .toARGB32()
                            .toRadixString(16)
                            .substring(2)
                            .toUpperCase();
                      },
                      selectedColor: entry.value.withValues(alpha: .4),
                      backgroundColor: SoftDesign.of(context).surface,
                      side: BorderSide(color: SoftDesign.of(context).border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          SoftDesign.of(context).controlRadius,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hex,
                    maxLength: 7,
                    onSubmitted: (_) => applyHex(),
                    decoration: InputDecoration(
                      labelText: '自定义主题色',
                      hintText: '#A8CDB8',
                      errorText: colorError,
                      counterText: '',
                      filled: true,
                      fillColor: SoftDesign.of(context).surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          SoftDesign.of(context).controlRadius,
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SoftButton(label: '应用', onPressed: applyHex),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      LayoutBuilder(
        builder: (context, box) {
          final navs = SoftSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heading('Navigation, in three forms', '内轮廓与外轮廓同心，选中背景平滑滑动。'),
                const SoftTag('01 / CLASSIC DOCK'),
                const SizedBox(height: 16),
                SoftNavigation(
                  selected: dock,
                  onChanged: (i) => setState(() => dock = i),
                ),
                const SizedBox(height: 28),
                const SoftTag('02 / ICON CAPSULE'),
                const SizedBox(height: 16),
                SoftNavigation(
                  style: SoftNavigationStyle.capsule,
                  selected: capsule,
                  onChanged: (i) => setState(() => capsule = i),
                ),
                const SizedBox(height: 28),
                const SoftTag('03 / SPLIT ACTION'),
                const SizedBox(height: 16),
                SoftNavigation(
                  style: SoftNavigationStyle.split,
                  items: const [
                    SoftNavItem(
                      'Home',
                      Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                    ),
                    SoftNavItem('Search', Icons.search_rounded),
                    SoftNavItem(
                      'Saved',
                      Icons.bookmark_border_rounded,
                      selectedIcon: Icons.bookmark_rounded,
                    ),
                  ],
                  selected: split,
                  onChanged: (i) => setState(() => split = i),
                  onAction: () => showSoftToast(
                    context,
                    '准备开始新的创作',
                    description: '右侧独立按钮承载主要操作。',
                    tone: SoftToastTone.info,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '布局、图标、文字与独立操作都可通过参数配置。',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
          final ai = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading(
                'A softer kind of intelligence',
                'AI 专用组件 · 演示流式文本，不连接模型服务',
              ),
              ChatBubble(message: prompt, outgoing: true),
              SoftAIBubble(
                text: answer,
                status: status,
                onStop: stop,
                onRetry: generate,
                onCopy: () async {
                  await Clipboard.setData(ClipboardData(text: answer));
                  if (context.mounted) {
                    showSoftToast(
                      context,
                      '回答已复制',
                      description: '可以粘贴到你的设计笔记。',
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              SoftPromptCard(
                title: '细化这套设计',
                description: '体验思考、流式生成与完成状态',
                onTap: generate,
              ),
              const SizedBox(height: 12),
              SoftComposer(
                onSend: (text) {
                  setState(() => prompt = text);
                  generate();
                },
              ),
            ],
          );
          if (box.maxWidth < 760) {
            return Column(children: [navs, const SizedBox(height: 28), ai]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: navs),
              const SizedBox(width: 28),
              Expanded(child: ai),
            ],
          );
        },
      ),
      const SizedBox(height: 28),
      SoftSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading(
              'A little feedback. Beautifully delivered.',
              '轻量浮层、柔和状态色与清晰层级。淡入、滑入，支持关闭和后续操作。',
            ),
            LayoutBuilder(
              builder: (context, box) => Wrap(
                spacing: 20,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: box.maxWidth >= 760
                        ? (box.maxWidth - 20) / 2
                        : box.maxWidth,
                    child: const SoftToast(
                      message: '设计已保存',
                      description: '所有细节都已妥善保留。',
                    ),
                  ),
                  SizedBox(
                    width: box.maxWidth >= 760
                        ? (box.maxWidth - 20) / 2
                        : box.maxWidth,
                    child: const SoftToast(
                      message: '助手已准备就绪',
                      description: '让灵感从这里开始。',
                      tone: SoftToastTone.info,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SoftButton(
                  label: '成功提示',
                  onPressed: () => showSoftToast(
                    context,
                    '设计已保存',
                    description: '你的组件配置已更新。',
                  ),
                ),
                SoftButton(
                  label: '操作提示',
                  onPressed: () => showSoftToast(
                    context,
                    '组件已归档',
                    description: '需要时可以恢复。',
                    actionLabel: '撤销操作',
                    onAction: () => showSoftToast(context, '已恢复组件'),
                  ),
                ),
                SoftButton(
                  label: '提醒',
                  onPressed: () => showSoftToast(
                    context,
                    '还有内容没有填写',
                    description: '检查后即可继续。',
                    tone: SoftToastTone.warning,
                  ),
                ),
                SoftButton(
                  label: '错误提示',
                  onPressed: () => showSoftToast(
                    context,
                    '连接暂时中断',
                    description: '请稍后重试。',
                    tone: SoftToastTone.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 52),
    ],
  );
}
