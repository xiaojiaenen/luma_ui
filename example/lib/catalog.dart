import 'package:flutter/material.dart';
import 'package:luma_ui/luma_ui.dart';

import 'catalog_data.dart';
import 'palette.dart';

class CatalogPreview extends StatefulWidget {
  const CatalogPreview({super.key, required this.spec});
  final ComponentSpec spec;
  @override
  State<CatalogPreview> createState() => _CatalogPreviewState();
}

class _CatalogPreviewState extends State<CatalogPreview> {
  final data = DemoData();
  @override
  void dispose() {
    data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: data,
    builder: (context, _) => widget.spec.builder(context, data),
  );
}

class ComponentCatalog extends StatefulWidget {
  const ComponentCatalog({super.key});
  @override
  State<ComponentCatalog> createState() => _ComponentCatalogState();
}

class _ComponentCatalogState extends State<ComponentCatalog> {
  String query = '', category = '全部';
  int page = 1;
  List<ComponentSpec> get matches => componentSpecs
      .where(
        (s) =>
            (category == '全部' || s.category == category) &&
            ('${s.name} ${s.category}'.toLowerCase().contains(
              query.toLowerCase(),
            )),
      )
      .toList();
  void example(ComponentSpec spec) => showSoftDialog(
    context,
    title: spec.name,
    content: SizedBox(
      width: 620,
      child: SoftCodeBlock(code: spec.example, maxHeight: 340),
    ),
    actions: [
      Builder(
        builder: (dialog) =>
            SoftButton(label: '关闭', onPressed: () => Navigator.pop(dialog)),
      ),
    ],
  );
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Color>(
    valueListenable: galleryAccent,
    builder: (context, accent, _) => SoftDesign(
      accent: accent,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              '组件目录 · ${componentSpecs.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            backgroundColor: SoftDesign.of(context).background,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '一个轮廓，一套材质。',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: SoftDesign.of(context).ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '按独立 Widget 计数，含基础、图表、布局与业务组合。示例数据与操作不连接外部服务。',
                      ),
                      const SizedBox(height: 24),
                      SoftSearchField(
                        onChanged: (v) => setState(() {
                          query = v;
                          page = 1;
                        }),
                      ),
                      const SizedBox(height: 16),
                      SoftSelect<String>(
                        label: '分类',
                        value: category,
                        items: {
                          '全部': '全部 · ${componentSpecs.length}',
                          for (final c
                              in componentSpecs.map((s) => s.category).toSet())
                            c: c,
                        },
                        onChanged: (v) => setState(() {
                          category = v!;
                          page = 1;
                        }),
                      ),
                      const SizedBox(height: 16),
                      Text('${matches.length} 个组件 · 预览区限高，内部滚动'),
                      const SizedBox(height: 12),
                      if (matches.isEmpty)
                        SoftEmptySearch(
                          query: query,
                          onClear: () => setState(() {
                            query = '';
                            category = '全部';
                            page = 1;
                          }),
                        )
                      else ...[
                        SoftPagination(
                          page: page,
                          pages: (matches.length / 6).ceil(),
                          onChanged: (v) => setState(() => page = v),
                        ),
                        const SizedBox(height: 16),
                        SoftResponsiveGrid(
                          minItemWidth: 340,
                          gap: 24,
                          children: matches
                              .skip((page - 1) * 6)
                              .take(6)
                              .map(
                                (spec) => SoftReveal(
                                  identity: spec.name,
                                  child: SoftSurface(
                                    key: ValueKey(spec.name),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          spec.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          spec.category,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          height: 320,
                                          child: SingleChildScrollView(
                                            child: CatalogPreview(
                                              key: ValueKey(
                                                'preview-${spec.name}',
                                              ),
                                              spec: spec,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SoftButton(
                                          label: '查看高亮代码',
                                          icon: Icons.code_rounded,
                                          onPressed: () => example(spec),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
