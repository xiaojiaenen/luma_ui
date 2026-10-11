import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  testWidgets('theme-only usage inherits accent without a design ancestor', (
    tester,
  ) async {
    late SoftDesign d;
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(accentColor: Colors.orange),
        home: Builder(
          builder: (context) {
            d = SoftDesign.of(context);
            return const Scaffold(body: SoftTextField(label: 'Email'));
          },
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(d.accent, Colors.orange);
  });
  testWidgets('default wrapper preserves theme-only accent configuration', (
    tester,
  ) async {
    late SoftDesign d;
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(accentColor: Colors.orange),
        home: const SoftDesign(child: SizedBox()).copyWith(
          child: Builder(
            builder: (context) {
              d = SoftDesign.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(d.accent, Colors.orange);
  });
  testWidgets('light input boundary has visible contrast against its fill', (
    tester,
  ) async {
    late InputDecorationThemeData input;
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(),
        home: SoftDesign(
          child: Builder(
            builder: (context) {
              input = Theme.of(context).inputDecorationTheme;
              return const Scaffold(body: SoftTextField(label: 'Email'));
            },
          ),
        ),
      ),
    );
    final stroke = input.enabledBorder!.borderSide.color;
    final background = input.fillColor!;
    final actual = Color.alphaBlend(stroke, background);
    final a = actual.computeLuminance(), b = background.computeLuminance();
    final contrast = (a > b ? a + .05 : b + .05) / (a > b ? b + .05 : a + .05);
    expect(contrast, greaterThanOrEqualTo(3));
  });

  testWidgets('theme geometry and styles survive an empty local wrapper', (
    tester,
  ) async {
    late SoftDesign d;
    const input = InputDecorationThemeData(filled: false);
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(
          radius: 14,
          cardGradient: SoftGradientPreset.peach,
          styles: const SoftComponentStyles(input: input),
        ),
        home: SoftDesign(
          child: Builder(
            builder: (context) {
              d = SoftDesign.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(d.radius, 14);
    expect(d.cardGradient, SoftGradientPreset.peach);
    expect(d.styles.input?.filled, false);
  });
  testWidgets(
    'localized composer submits with custom SVG-capable widget slot',
    (tester) async {
      String? sent;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SoftComposer(
              hintText: '写点什么',
              sendTooltip: '发送',
              sendIcon: const Text('↑'),
              onSend: (text) => sent = text,
            ),
          ),
        ),
      );
      expect(find.text('写点什么'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '  你好  ');
      await tester.tap(find.byTooltip('发送'));
      expect(sent, '你好');
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    },
  );
  testWidgets('theme overrides labels and every library icon renderer', (
    tester,
  ) async {
    var read = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(
          strings: const SoftStrings({
            'Mark as read': '标为已读',
            'Storage': '存储空间',
          }),
          icons: SoftIcons(
            builder: (context, icon, size, color) => const Text('自定义图标'),
          ),
        ),
        home: Scaffold(
          body: Column(
            children: [
              SoftNotificationCard(
                title: '消息',
                message: '内容',
                time: '现在',
                onRead: () => read = true,
              ),
              const SoftStorageCard(
                used: '1 GB',
                capacity: '2 GB',
                fraction: .5,
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('存储空间'), findsOneWidget);
    expect(find.text('自定义图标'), findsNWidgets(2));
    await tester.tap(find.text('标为已读'));
    expect(read, true);
  });

  testWidgets(
    'localized dynamic search and download messages keep their arguments',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SoftTokens.theme(
            strings: const SoftStrings({
              'No matches for {query}': '没有找到“{query}”',
              '{percent}% downloaded': '已下载 {percent}%',
              'Clear search': '清除搜索',
            }),
          ),
          home: const Scaffold(
            body: Column(
              children: [
                SoftEmptySearch(query: '日记'),
                SoftDownloadCard(name: '文件', progress: .42),
              ],
            ),
          ),
        ),
      );
      expect(find.text('没有找到“日记”'), findsOneWidget);
      expect(find.text('已下载 42%'), findsOneWidget);
      expect(find.text('清除搜索'), findsOneWidget);
    },
  );

  testWidgets(
    'navigation and thinking accessibility copy follows translation',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SoftTokens.theme(
            strings: const SoftStrings({
              'Home': '首页',
              'Create': '创建',
              'Thinking': '思考中',
            }),
          ),
          home: Scaffold(
            body: Column(
              children: [
                SoftNavigation(
                  style: SoftNavigationStyle.split,
                  selected: 0,
                  onChanged: (_) {},
                  onAction: () {},
                ),
                const SoftThinkingIndicator(),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byTooltip('首页'), findsOneWidget);
      expect(find.byTooltip('创建'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.label == '思考中',
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    },
  );
}
