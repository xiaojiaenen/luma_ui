import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  test('code highlighting preserves source and distinguishes token types', () {
    const code = "final answer = 42; // comment\nString name = 'Glass';";
    final spans = const SoftCodeBlock(code: code).highlight(Colors.pink);
    expect(spans.map((s) => s.text).join(), code);
    expect(
      spans.map((s) => s.style?.color).whereType<Color>().toSet().length,
      greaterThanOrEqualTo(4),
    );
    expect(
      const SoftCodeBlock(
        code: code,
        language: 'text',
      ).highlight(Colors.pink).single.text,
      code,
    );
  });
  testWidgets('shared radius reaches surface, input and Material controls', (
    tester,
  ) async {
    late SoftDesign design;
    late ThemeData theme;
    await tester.pumpWidget(
      MaterialApp(
        home: SoftDesign(
          radius: 27,
          accent: Colors.pink,
          child: Builder(
            builder: (context) {
              design = SoftDesign.of(context);
              theme = Theme.of(context);
              return const Scaffold(body: SoftSurface(child: Text('Surface')));
            },
          ),
        ),
      ),
    );
    expect(design.radius, 27);
    expect(design.insetRadius, 27);
    expect(design.controlRadius, 27);
    expect(
      (theme.inputDecorationTheme.border as OutlineInputBorder).borderRadius,
      BorderRadius.circular(27),
    );
    expect(
      (theme.iconButtonTheme.style!.shape!.resolve({})!
              as RoundedRectangleBorder)
          .borderRadius,
      BorderRadius.circular(27),
    );
    expect(SoftDesign.defaultRadius, closeTo(19.862232585, .00001));
  });
  testWidgets('February leap day and date bounds dispatch correctly', (
    tester,
  ) async {
    DateTime? chosen, month;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 450,
            child: SoftCalendar(
              month: DateTime(2024, 2),
              minDate: DateTime(2024, 2, 20),
              onSelected: (d) => chosen = d,
              onMonthChanged: (d) => month = d,
            ),
          ),
        ),
      ),
    );
    expect(find.text('29'), findsOneWidget);
    expect(find.text('30'), findsNothing);
    await tester.tap(find.text('19'));
    expect(chosen, isNull);
    await tester.tap(find.text('29'));
    expect(chosen, DateTime(2024, 2, 29));
    await tester.tap(find.byTooltip('Next month'));
    expect(month, DateTime(2024, 3));
  });
  testWidgets('long messages and code retain bounded scrollable height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 224,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ChatBubble(message: List.filled(100, '很长的聊天内容').join()),
                  SoftCodeBlock(
                    code: List.filled(
                      100,
                      'final answer = 42; // example',
                    ).join('\n'),
                    maxHeight: 150,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(ChatBubble)).height, lessThan(330));
    expect(tester.getSize(find.byType(SoftCodeBlock)).height, lessThan(250));
    expect(tester.takeException(), isNull);
  });
  testWidgets('segmented hit regions and indicator align through selection', (
    tester,
  ) async {
    int selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 500,
            child: StatefulBuilder(
              builder: (context, update) => SoftTabs(
                labels: const ['组件目录', '参数与组合'],
                selected: selected,
                onChanged: (v) => update(() => selected = v),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('参数与组合'));
    await tester.pumpAndSettle();
    expect(selected, 1);
    final ink = find.descendant(
      of: find.byType(SoftSegmented),
      matching: find.byType(InkWell),
    );
    expect(tester.getSize(ink.first).height, 48);
    expect(tester.getSize(ink.last).height, 48);
    expect(tester.takeException(), isNull);
  });
}
