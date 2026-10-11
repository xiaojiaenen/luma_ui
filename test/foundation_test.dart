import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

Widget host(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: SoftTokens.theme(brightness: brightness),
      home: SoftDesign(child: Scaffold(body: child)),
    );

double contrast(Color a, Color b) {
  final x = a.computeLuminance(), y = b.computeLuminance();
  return ((x > y ? x : y) + .05) / ((x < y ? x : y) + .05);
}

void main() {
  test(
    'light and dark text and semantic roles meet 4.5 contrast on surfaces',
    () {
      for (final mode in Brightness.values) {
        final d = SoftDesign(brightness: mode, child: const SizedBox());
        for (final fg in [
          d.ink,
          d.muted,
          d.semantic.success,
          d.semantic.error,
          d.semantic.warning,
          d.semantic.info,
        ]) {
          for (final bg in [d.surface, d.background]) {
            expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
          }
        }
      }
      for (var value = 0; value <= 255; value++) {
        final d = SoftDesign(
          accent: Color.fromARGB(255, value, value, value),
          child: const SizedBox(),
        );
        expect(contrast(d.onAccent, d.accent), greaterThanOrEqualTo(4.5));
      }
    },
  );

  testWidgets(
    'keyboard skips unavailable actions and activates enabled button',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        host(
          Column(
            children: [
              const SoftButton(label: 'Disabled'),
              SoftButton(
                label: 'Loading',
                loading: true,
                onPressed: () => calls++,
              ),
              SoftButton(label: 'Ready', onPressed: () => calls++),
            ],
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(calls, 1);
      await tester.tap(find.text('Loading'));
      expect(calls, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('segmented arrows, Home and End follow reading direction', (
    tester,
  ) async {
    var selected = 1;
    await tester.pumpWidget(
      host(
        Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) => SoftSegmented(
              labels: const ['One', 'Two', 'Three'],
              selected: selected,
              onChanged: (v) => setState(() => selected = v),
            ),
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(selected, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pumpAndSettle();
    expect(selected, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pumpAndSettle();
    expect(selected, 0);
  });

  testWidgets('calendar keyboard clamps leap month and respects date bounds', (
    tester,
  ) async {
    DateTime? chosen;
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 440,
          child: SoftCalendar(
            month: DateTime(2024, 1),
            selected: DateTime(2024, 1, 31),
            maxDate: DateTime(2024, 2, 29),
            onSelected: (d) => chosen = d,
            onMonthChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
    await tester.pumpAndSettle();
    expect(chosen, DateTime(2024, 2, 29));
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    expect(chosen, DateTime(2024, 1, 31));
  });

  testWidgets(
    'table pagination, sorting and page selection preserve hidden rows',
    (tester) async {
      Set<int>? selection;
      int? page, column;
      await tester.pumpWidget(
        host(
          SoftTable(
            columns: const ['Name'],
            rows: const [
              ['A'],
              ['B'],
              ['C'],
            ],
            pageSize: 1,
            selectedRows: const {2},
            onSelectionChanged: (s) => selection = s,
            onPageChanged: (p) => page = p,
            onSort: (c, _) => column = c,
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsNothing);
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();
      expect(selection, {0, 2});
      await tester.tap(find.byTooltip('Next page'));
      expect(page, 2);
      await tester.tap(find.text('Name'));
      expect(column, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('table exposes loading, empty and retry states', (tester) async {
    await tester.pumpWidget(
      host(const SoftTable(columns: ['A'], rows: [], loading: true)),
    );
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.pumpWidget(host(const SoftTable(columns: ['A'], rows: [])));
    await tester.pumpAndSettle();
    expect(find.text('No rows'), findsOneWidget);
    var retried = false;
    await tester.pumpWidget(
      host(
        SoftTable(
          columns: const ['A'],
          rows: const [],
          errorText: 'Offline',
          onRetry: () => retried = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  testWidgets(
    'component overrides preserve inherited typography and geometry',
    (tester) async {
      late ThemeData theme;
      await tester.pumpWidget(
        MaterialApp(
          theme: SoftTokens.theme(fontFamily: 'ExampleFont'),
          home: SoftDesign(
            brightness: Brightness.dark,
            styles: SoftComponentStyles(
              button: FilledButton.styleFrom(backgroundColor: Colors.purple),
            ),
            child: Builder(
              builder: (context) {
                theme = Theme.of(context);
                return Scaffold(
                  body: SoftButton(label: 'Override', onPressed: () {}),
                );
              },
            ),
          ),
        ),
      );
      expect(theme.brightness, Brightness.dark);
      expect(theme.chipTheme.labelStyle!.fontFamily, 'ExampleFont');
      expect(
        tester
            .widget<FilledButton>(find.byType(FilledButton))
            .style!
            .backgroundColor!
            .resolve({}),
        Colors.purple,
      );
    },
  );
  testWidgets(
    'controlled select preserves focus across value updates and validates current value',
    (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final form = GlobalKey<FormState>();
      var value = 'a';
      late StateSetter update;
      await tester.pumpWidget(
        host(
          Form(
            key: form,
            child: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return SoftSelect<String>(
                  label: 'Choice',
                  items: const {'a': 'Alpha', 'b': 'Beta'},
                  value: value,
                  focusNode: node,
                  validator: (v) => v == 'b' ? 'Unavailable' : null,
                  onChanged: (v) => setState(() => value = v!),
                );
              },
            ),
          ),
        ),
      );
      node.requestFocus();
      await tester.pumpAndSettle();
      expect(
        tester.widget<InputDecorator>(find.byType(InputDecorator)).isFocused,
        isTrue,
      );
      update(() => value = 'b');
      await tester.pumpAndSettle();
      expect(node.hasFocus, isTrue);
      expect(find.text('Beta'), findsOneWidget);
      expect(form.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text('Unavailable'), findsOneWidget);
    },
  );

  testWidgets('reduce motion safely changes content height', (tester) async {
    var long = false;
    late StateSetter update;
    await tester.pumpWidget(
      host(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return SoftSurface(
                child: Text(
                  long ? List.filled(100, 'Content').join(' ') : 'Short',
                ),
              );
            },
          ),
        ),
      ),
    );
    update(() => long = true);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(AnimatedSize), findsNothing);
  });
  testWidgets('navigation supports capsule, continuous and uniform shapes', (
    tester,
  ) async {
    for (final corners in SoftNavigationCorners.values) {
      await tester.pumpWidget(
        host(SoftNavigation(corners: corners, selected: 0, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();
      final shell = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey('soft-nav-shell')),
      );
      final indicator = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey('soft-nav-indicator')),
      );
      final a = (shell.decoration as ShapeDecoration).shape;
      final b = (indicator.decoration as ShapeDecoration).shape;
      expect(a.runtimeType, b.runtimeType);
      expect(a, switch (corners) {
        SoftNavigationCorners.capsule => isA<StadiumBorder>(),
        SoftNavigationCorners.continuous => isA<RoundedSuperellipseBorder>(),
        SoftNavigationCorners.uniform => isA<RoundedRectangleBorder>(),
      });
    }
  });
}
