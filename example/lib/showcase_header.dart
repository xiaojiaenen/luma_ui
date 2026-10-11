// Hallmark · pre-emit critique: P4 H4 E4 S4 R4 V4
// Existing pearl surfaces and geometry; editorial hierarchy with a live palette.
import 'package:flutter/material.dart';
import 'package:luma_ui/luma_ui.dart';

import 'catalog.dart';
import 'catalog_data.dart';
import 'palette.dart';

class ShowcaseHeader extends StatelessWidget {
  const ShowcaseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final d = SoftDesign.of(context);
    final type = Theme.of(context).textTheme;
    final introduction = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SOFT FOR EVERYDAY',
          style: type.labelSmall?.copyWith(
            letterSpacing: 2,
            color: d.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '柔和有形。\n鲜活有序。',
          style: type.headlineLarge?.copyWith(
            fontSize: 52,
            height: 1.2,
            letterSpacing: -1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '让界面有温度，也有自己的性格。\n从一颗按钮，到完整的日常体验。',
          style: type.bodyLarge?.copyWith(color: d.muted, height: 1.8),
        ),
        const SizedBox(height: 28),
        SoftButton(
          label: '探索 ${componentSpecs.length} 个组件',
          primary: true,
          icon: Icons.arrow_forward_rounded,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ComponentCatalog()),
          ),
        ),
        const SizedBox(height: 28),
        Text('换一种心情', style: type.labelMedium?.copyWith(color: d.muted)),
        const SizedBox(height: 10),
        ValueListenableBuilder<Color>(
          valueListenable: galleryAccent,
          builder: (context, accent, _) => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final choice in [
                (SoftTokens.accent, '冰蓝'),
                (d.roles.secondary, '鼠尾草'),
                (d.roles.tertiary, '暖杏'),
                (d.roles.ai, '灰紫'),
              ])
                Tooltip(
                  message: '${choice.$2}主题',
                  child: Semantics(
                    label: '${choice.$2}主题',
                    selected: accent == choice.$1,
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: IconButton(
                        onPressed: () => galleryAccent.value = choice.$1,
                        style: IconButton.styleFrom(
                          backgroundColor: d.surface,
                          side: BorderSide(
                            color: accent == choice.$1 ? d.ink : d.border,
                            width: accent == choice.$1 ? 2 : 1,
                          ),
                        ),
                        icon: Icon(Icons.circle, size: 22, color: choice.$1),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
    final composition = SoftSurface(
      gradientPreset: SoftGradientPreset.peach,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '留一点时间，\n给喜欢的事。',
                  style: type.headlineSmall?.copyWith(
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.wb_sunny_outlined, size: 36, color: d.roles.tertiary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '日常灵感 / 场景演示',
            style: type.labelMedium?.copyWith(color: d.muted),
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '28',
                        style: type.displayLarge?.copyWith(
                          fontSize: 76,
                          height: 1,
                          letterSpacing: -4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 8),
                        child: Text('°  晴朗', style: type.titleMedium),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Icon(Icons.north_east_rounded, color: d.roles.tertiary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: d.ink.withValues(alpha: .1)),
          const SizedBox(height: 18),
          for (final item in [
            (Icons.headphones_rounded, '听一首喜欢的歌', 'MUSIC', d.roles.ai),
            (Icons.eco_outlined, '出门走走，发现新鲜', 'EXPLORE', d.roles.secondary),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Icon(item.$1, color: item.$4, size: 22),
                  const SizedBox(width: 14),
                  Expanded(child: Text(item.$2, style: type.bodyMedium)),
                  Text(
                    item.$3,
                    style: type.labelSmall?.copyWith(
                      color: d.muted,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SoftButton(
            label: '开启今天',
            icon: Icons.play_arrow_rounded,
            tone: SoftTone.secondary,
            onPressed: () => showSoftToast(
              context,
              '慢慢来，也很好',
              description: '今天的灵感，从一件喜欢的小事开始。',
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 20,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.blur_on_rounded, size: 28, color: d.roles.secondary),
                const SizedBox(width: 12),
                Text(
                  'LUMA / UI',
                  style: type.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: galleryThemeMode,
              builder: (context, mode, _) => SoftButton(
                label: mode == ThemeMode.dark ? '浅色外观' : '深色外观',
                icon: mode == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                onPressed: () => galleryThemeMode.value = mode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, box) => box.maxWidth >= 850
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: introduction),
                    const SizedBox(width: 64),
                    Expanded(flex: 4, child: composition),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    introduction,
                    const SizedBox(height: 36),
                    composition,
                  ],
                ),
        ),
        const SizedBox(height: 44),
        Divider(color: d.ink.withValues(alpha: .09)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 28,
          runSpacing: 12,
          children: [
            for (final item in [
              (Icons.rounded_corner_rounded, '统一圆角'),
              (Icons.contrast_rounded, '亮暗外观'),
              (Icons.palette_outlined, '多角色配色'),
              (Icons.touch_app_outlined, '细腻交互'),
            ])
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.$1, size: 17, color: d.muted),
                  const SizedBox(width: 8),
                  Text(
                    item.$2,
                    style: type.labelMedium?.copyWith(color: d.muted),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 56),
      ],
    );
  }
}
