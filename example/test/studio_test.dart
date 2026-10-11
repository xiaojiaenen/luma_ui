import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';
import 'package:luma_ui_example/studio.dart';

void main() {
  for (final width in [320.0, 375.0, 414.0, 768.0, 1280.0]) {
    testWidgets('studio composer fits $width and exports live values', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: SoftTokens.theme(),
          home: const Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: ComponentStudio(),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('参数与组合'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(Slider).first, const Offset(30, 0));
      await tester.pumpAndSettle();
      final design = tester.widget<SoftDesign>(find.byType(SoftDesign).first);
      expect(design.radius, isNot(SoftDesign.defaultRadius));
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is SoftCodeBlock &&
              w.code.contains('radius: ${design.radius.toStringAsFixed(1)}'),
        ),
        findsOneWidget,
      );
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -1800),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
