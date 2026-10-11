import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  testWidgets('split navigation dispatches selection and independent action', (
    tester,
  ) async {
    var selected = 0;
    var actions = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SoftDesign(
            radius: 32,
            child: SizedBox(
              width: 224,
              child: StatefulBuilder(
                builder: (context, update) => SoftNavigation(
                  style: SoftNavigationStyle.split,
                  selected: selected,
                  items: const [
                    SoftNavItem('Home', Icons.home),
                    SoftNavItem('Search', Icons.search),
                    SoftNavItem('Saved', Icons.bookmark),
                  ],
                  onChanged: (i) => update(() => selected = i),
                  onAction: () => actions++,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();
    expect(selected, 2);
    final indicator = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('soft-nav-indicator')),
    );
    expect(
      (indicator.decoration as ShapeDecoration).shape,
      isA<StadiumBorder>(),
    );
    await tester.tap(find.byTooltip('Create'));
    expect(actions, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('toast presents an action and closes without duplicate action', (
    tester,
  ) async {
    var actions = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showSoftToast(
                context,
                'Saved',
                description: 'A softer notification',
                actionLabel: 'Undo',
                onAction: () => actions++,
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();
    expect(find.text('A softer notification'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(actions, 1);
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('AI thinking respects reduced motion and exposes stop action', (
    tester,
  ) async {
    var stopped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: SoftAIBubble(
              text: '',
              status: SoftAIStatus.thinking,
              onStop: () => stopped = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Thinking'), findsOneWidget);
    await tester.tap(find.byTooltip('Stop generation'));
    await tester.pumpAndSettle();
    expect(stopped, isTrue);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
