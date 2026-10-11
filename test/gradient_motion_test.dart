import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  test(
    'presets provide three colors in both themes and inherit through scopes',
    () {
      for (final mode in Brightness.values) {
        final d = SoftDesign(
          brightness: mode,
          cardGradient: SoftGradientPreset.lilac,
          child: const SizedBox(),
        );
        for (final preset in SoftGradientPreset.values.where(
          (p) => p != SoftGradientPreset.none,
        )) {
          expect((d.gradientFor(preset)! as LinearGradient).colors.length, 3);
        }
        expect(
          d.copyWith(child: const SizedBox()).cardGradient,
          SoftGradientPreset.lilac,
        );
        expect(d.gradientFor(SoftGradientPreset.none), isNull);
      }
    },
  );
  testWidgets(
    'interactive cards retain keyboard activation and nested controls',
    (tester) async {
      var cardCalls = 0, buttonCalls = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: SoftDesign(
            child: Scaffold(
              body: SoftSurface(
                onTap: () => cardCalls++,
                child: SoftButton(
                  label: 'Nested',
                  onPressed: () => buttonCalls++,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Nested'));
      expect(buttonCalls, 1);
      expect(cardCalls, 0);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(cardCalls, 1);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'hover and press keep layout stable and reduce motion skips transforms',
    (tester) async {
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      for (final reduced in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(disableAnimations: reduced),
              child: Scaffold(
                body: Center(
                  child: SoftPress(
                    child: SizedBox(
                      key: const ValueKey('target'),
                      width: 200,
                      height: 80,
                      child: FilledButton(
                        onPressed: () {},
                        child: const Text('Action'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await mouse.moveTo(Offset.zero);
        await tester.pumpAndSettle();
        final finder = find.byKey(const ValueKey('target'));
        final before = tester.getTopLeft(finder);
        final size = tester.getSize(finder);
        await mouse.moveTo(tester.getCenter(finder));
        await tester.pumpAndSettle();
        expect(tester.getSize(finder), size);
        expect(
          tester.getTopLeft(finder).dy,
          closeTo(before.dy - (reduced ? 0 : 1), .01),
        );
        await mouse.down(tester.getCenter(finder));
        await tester.pumpAndSettle();
        expect(tester.getSize(finder), size);
        if (reduced) expect(tester.getTopLeft(finder), before);
        await mouse.up();
        await tester.pumpAndSettle();
      }
    },
  );
}
