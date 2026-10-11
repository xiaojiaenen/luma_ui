import 'package:flutter/material.dart';

import 'palette.dart';

import 'package:flutter/services.dart';
import 'package:luma_ui/luma_ui.dart';

class ComponentStudio extends StatefulWidget {
  const ComponentStudio({super.key});
  @override
  State<ComponentStudio> createState() => _ComponentStudioState();
}

class _ComponentStudioState extends State<ComponentStudio> {
  double radius = SoftDesign.defaultRadius,
      spacing = 24,
      shadow = .085,
      height = 52,
      slider = 40;
  Color get accent => galleryAccent.value;
  bool checked = true,
      enabled = true,
      tinted = true,
      showAvatar = true,
      showTags = true,
      showButton = true,
      primary = true;
  String title = 'Make it yours',
      subtitle = 'Your next component starts here.',
      selection = 'design',
      radio = 'personal';
  int tab = 0, page = 1, step = 1;
  DateTime date = DateTime(2026, 10, 10);
  TimeOfDay time = const TimeOfDay(hour: 9, minute: 30);
  final form = GlobalKey<FormState>();
  String literal(String value) =>
      "'${value.replaceAll('\\', '\\\\').replaceAll("'", "\\'").replaceAll('\n', '\\n').replaceAll(r'$', r'\$')}'";
  String get generated =>
      '''SoftDesign(
  accent: Color(0x${accent.toARGB32().toRadixString(16).toUpperCase()}),
  radius: ${radius.toStringAsFixed(1)},
  spacing: ${spacing.toStringAsFixed(1)},
  shadow: ${shadow.toStringAsFixed(3)},
  controlHeight: ${height.toStringAsFixed(1)},
  child: SoftSurface(
    tinted: $tinted,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
${showAvatar ? "        SoftAvatar(label: 'You'),\n        SizedBox(height: 16),\n" : ''}        Text(${literal(title)}, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 8),
        Text(${literal(subtitle)}),
${showTags ? "        SizedBox(height: 16),\n        Wrap(spacing: 8, runSpacing: 8, children: [SoftTag('Custom'), SoftTag('Luma UI')]),\n" : ''}${showButton ? "        SizedBox(height: 24),\n        SoftButton(label: 'Continue', primary: $primary, onPressed: () {}),\n" : ''}      ],
    ),
  ),
)''';
  Widget card(String title, List<Widget> children) => SoftSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        ...children,
      ],
    ),
  );
  Widget gap() => const SizedBox(height: 16);
  @override
  Widget build(BuildContext context) => SoftDesign(
    accent: accent,
    radius: radius,
    spacing: spacing,
    shadow: shadow,
    controlHeight: height,
    child: Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Component studio',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text('常用组件 · 实时参数 · 自定义组合 · Flutter 代码'),
          const SizedBox(height: 24),
          SoftTabs(
            labels: const ['组件目录', '参数与组合'],
            selected: tab,
            onChanged: (v) => setState(() => tab = v),
          ),
          const SizedBox(height: 28),
          if (tab == 0)
            LayoutBuilder(
              builder: (context, box) {
                final count = box.maxWidth >= 1050
                    ? 3
                    : box.maxWidth >= 680
                    ? 2
                    : 1;
                final width = (box.maxWidth - (count - 1) * 24) / count;
                final cards = [
                  card('输入与表单', [
                    Form(
                      key: form,
                      child: Column(
                        children: [
                          SoftTextField(
                            label: 'Email',
                            hint: 'you@example.com',
                            prefixIcon: Icons.alternate_email,
                            validator: (v) =>
                                v != null && v.contains('@') ? null : '请输入有效邮箱',
                          ),
                          gap(),
                          const SoftTextField(
                            label: 'Password',
                            obscureText: true,
                          ),
                          gap(),
                          const SoftTextField(label: 'Notes', maxLines: 3),
                          gap(),
                          SoftButton(
                            label: 'Validate form',
                            primary: true,
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                showSoftToast(context, 'Form is valid');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    gap(),
                    SoftSelect<String>(
                      label: 'Workspace',
                      items: const {
                        'design': 'Design studio',
                        'engineering': 'Engineering',
                      },
                      value: selection,
                      onChanged: (v) => setState(() => selection = v!),
                    ),
                  ]),
                  card('选择与调节', [
                    SoftSwitch(
                      label: 'Notifications',
                      value: enabled,
                      onChanged: (v) => setState(() => enabled = v),
                    ),
                    SoftCheckbox(
                      label: 'Keep me updated',
                      value: checked,
                      onChanged: (v) => setState(() => checked = v!),
                    ),
                    SoftRadioGroup<String>(
                      items: const {'personal': 'Personal', 'team': 'Team'},
                      value: radio,
                      onChanged: (v) => setState(() => radio = v!),
                    ),
                    SoftSlider(
                      label: 'Volume',
                      value: slider,
                      onChanged: (v) => setState(() => slider = v),
                    ),
                    SoftDateField(
                      value: date,
                      onChanged: (v) => setState(() => date = v),
                    ),
                    gap(),
                    SoftTimeField(
                      value: time,
                      onChanged: (v) => setState(() => time = v),
                    ),
                  ]),
                  card('反馈与浮层', [
                    const SoftAlert(
                      title: 'Everything in sync',
                      message: 'A shared visual system for every detail.',
                      icon: Icons.check_circle_outline,
                    ),
                    gap(),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SoftButton(
                          label: 'Dialog',
                          onPressed: () => showSoftDialog(
                            context,
                            title: 'Save your changes?',
                            content: const Text('This is a preview dialog.'),
                            actions: [
                              Builder(
                                builder: (dialogContext) => SoftButton(
                                  label: 'Done',
                                  primary: true,
                                  onPressed: () => Navigator.pop(dialogContext),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SoftButton(
                          label: 'Bottom sheet',
                          onPressed: () => showSoftSheet(
                            context,
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('A little more space'),
                                SizedBox(height: 16),
                                Text(
                                  'Use this surface for contextual actions and details.',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SoftButton(
                          label: 'Toast',
                          onPressed: () =>
                              showSoftToast(context, 'Changes saved'),
                        ),
                        SoftTooltip(
                          message: 'Helpful context on hover or long press',
                          child: const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.help_outline),
                          ),
                        ),
                        SoftMenu(
                          items: const ['Duplicate', 'Archive'],
                          onSelected: (v) => showSoftToast(context, v),
                        ),
                      ],
                    ),
                    gap(),
                    const SoftProgress(value: .65),
                    gap(),
                    const SoftSkeleton(height: 16),
                    gap(),
                    const SoftSkeleton(width: 120, height: 16),
                  ]),
                  card('内容与身份', [
                    const Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SoftAvatar(label: 'Chloe'),
                        SoftAvatar(label: 'Alex'),
                        SoftBadge(
                          label: '3',
                          child: Icon(
                            Icons.notifications_none_rounded,
                            size: 28,
                          ),
                        ),
                        SoftTag('New'),
                      ],
                    ),
                    gap(),
                    SoftListTile(
                      title: 'Design workspace',
                      subtitle: 'Shared with your team',
                      leading: const SoftAvatar(label: 'D', size: 36),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => showSoftToast(context, 'Workspace selected'),
                    ),
                    const Divider(),
                    const SoftAccordion(
                      title: 'How does composition work?',
                      child: Text(
                        'Combine surfaces, text, tags and controls. Your component inherits the same theme automatically.',
                      ),
                    ),
                  ]),
                  card('导航与流程', [
                    SoftBreadcrumbs(
                      labels: const ['Library', 'Components', 'Details'],
                      onSelected: (i) =>
                          showSoftToast(context, 'Selected breadcrumb $i'),
                    ),
                    SoftSteps(
                      labels: const [
                        'Choose a component',
                        'Adjust parameters',
                        'Use in your app',
                      ],
                      current: step,
                      onSelected: (i) => setState(() => step = i),
                    ),
                    SoftPagination(
                      page: page,
                      pages: 5,
                      onChanged: (v) => setState(() => page = v),
                    ),
                  ]),
                  card('数据与列表', [
                    const Text('Example workspace data'),
                    gap(),
                    const SoftTable(
                      columns: ['Name', 'Role'],
                      rows: [
                        ['Chloe', 'Designer'],
                        ['Alex', 'Developer'],
                        ['Jamie', 'Editor'],
                      ],
                    ),
                    gap(),
                    const SoftAlert(
                      title: 'Responsive table',
                      message: 'Tables scroll within their own surface on small screens.',
                    ),
                  ]),
                ];
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: cards
                      .map((c) => SizedBox(width: width, child: c))
                      .toList(),
                );
              },
            )
          else
            LayoutBuilder(
              builder: (context, box) {
                final settings = card('统一参数', [
                  const Text('调整作用于本工作台的所有组件。所有矩形组件共用同一圆角。默认 52 / φ² ≈ 19.86。'),
                  gap(),
                  SoftSlider(
                    label: '圆角基准',
                    value: radius,
                    min: 8,
                    max: 48,
                    onChanged: (v) => setState(() => radius = v),
                  ),
                  SoftSlider(
                    label: '内边距',
                    value: spacing,
                    min: 12,
                    max: 32,
                    onChanged: (v) => setState(() => spacing = v),
                  ),
                  SoftSlider(
                    label: '阴影强度 %',
                    value: shadow * 100,
                    min: 0,
                    max: 20,
                    onChanged: (v) => setState(() => shadow = v / 100),
                  ),
                  SoftSlider(
                    label: '按钮高度',
                    value: height,
                    min: 48,
                    max: 64,
                    onChanged: (v) => setState(() => height = v),
                  ),
                  Wrap(
                    spacing: 12,
                    children: [
                      for (final c in [
                        SoftTokens.accent,
                        const Color(0xFFA8CDB8),
                        const Color(0xFFC7B8E7),
                        const Color(0xFFEFC3A4),
                      ])
                        IconButton(
                          tooltip: 'Accent ${c.toARGB32().toRadixString(16)}',
                          onPressed: () =>
                              setState(() => galleryAccent.value = c),
                          style: IconButton.styleFrom(backgroundColor: c),
                          icon: Icon(
                            accent == c ? Icons.check : Icons.circle_outlined,
                          ),
                        ),
                    ],
                  ),
                  gap(),
                  SoftButton(
                    label: 'Reset style',
                    onPressed: () => setState(() {
                      radius = SoftDesign.defaultRadius;
                      spacing = 24;
                      shadow = .085;
                      height = 52;
                      galleryAccent.value = SoftTokens.accent;
                    }),
                  ),
                ]);
                final composition = card('设计不存在的组件', [
                  const Text('组合基础零件，保持系统风格。编辑内容、开关区块，再复制可用的 Dart 代码。'),
                  gap(),
                  SoftTextField(
                    label: '标题',
                    onChanged: (v) => setState(() => title = v),
                  ),
                  gap(),
                  SoftTextField(
                    label: '描述',
                    onChanged: (v) => setState(() => subtitle = v),
                  ),
                  SoftSwitch(
                    label: 'Avatar',
                    value: showAvatar,
                    onChanged: (v) => setState(() => showAvatar = v),
                  ),
                  SoftSwitch(
                    label: 'Tags',
                    value: showTags,
                    onChanged: (v) => setState(() => showTags = v),
                  ),
                  SoftSwitch(
                    label: 'Action button',
                    value: showButton,
                    onChanged: (v) => setState(() => showButton = v),
                  ),
                  SoftSwitch(
                    label: 'Tinted surface',
                    value: tinted,
                    onChanged: (v) => setState(() => tinted = v),
                  ),
                  SoftSwitch(
                    label: 'Primary button',
                    value: primary,
                    onChanged: (v) => setState(() => primary = v),
                  ),
                ]);
                final preview = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SoftTag('LIVE PREVIEW'),
                    gap(),
                    SoftSurface(
                      tinted: tinted,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showAvatar) ...[
                            const SoftAvatar(label: 'You'),
                            gap(),
                          ],
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(subtitle),
                          if (showTags) ...[
                            gap(),
                            const Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [SoftTag('Custom'), SoftTag('Luma UI')],
                            ),
                          ],
                          if (showButton) ...[
                            const SizedBox(height: 24),
                            SoftButton(
                              label: 'Continue',
                              primary: primary,
                              onPressed: () =>
                                  showSoftToast(context, 'Your custom action'),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SoftButton(
                      label: 'Copy Flutter code',
                      icon: Icons.copy,
                      primary: true,
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: generated));
                        if (context.mounted) {
                          showSoftToast(context, 'Dart code copied');
                        }
                      },
                    ),
                    gap(),
                    SoftCodeBlock(code: generated),
                  ],
                );
                if (box.maxWidth < 900) {
                  return Column(
                    children: [
                      settings,
                      const SizedBox(height: 24),
                      composition,
                      const SizedBox(height: 24),
                      preview,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          settings,
                          const SizedBox(height: 24),
                          composition,
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
                    Expanded(child: preview),
                  ],
                );
              },
            ),
          const SizedBox(height: 32),
          const SoftAlert(
            title: '从组合到业务组件',
            message: '需要优惠券、订单卡、设备控制等新组件时：用 SoftSurface 做容器，组合基础组件，通过构造参数传数据、回调传行为。SoftDesign 负责统一视觉。当前组合器支持名片式结构；任意布局可在 Dart 中扩展。',
          ),
        ],
      ),
    ),
  );
}
