import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';
import 'package:luma_ui_example/palette.dart';
import 'package:luma_ui_example/refinements.dart';

void main() {
  testWidgets('custom color validation and AI stream finish', (tester) async {
    addTearDown(() => galleryAccent.value = SoftTokens.accent);
    tester.view.physicalSize = const Size(1280, 3000);
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
              child: RefinedComponents(),
            ),
          ),
        ),
      ),
    );
    final hex = find.byType(TextField).first;
    await tester.enterText(hex, 'nope');
    await tester.tap(find.text('应用'));
    await tester.pumpAndSettle();
    expect(find.text('请输入六位 HEX，例如 A8CDB8'), findsOneWidget);
    await tester.enterText(hex, '#C7B8E7');
    await tester.tap(find.text('应用'));
    await tester.pumpAndSettle();
    expect(galleryAccent.value, const Color(0xFFC7B8E7));
    await tester.tap(find.text('细化这套设计'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      tester.widget<SoftAIBubble>(find.byType(SoftAIBubble)).status,
      SoftAIStatus.thinking,
    );
    // Pump actual frames through the streaming and size transitions.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
    expect(
      tester.widget<SoftAIBubble>(find.byType(SoftAIBubble)).status,
      SoftAIStatus.complete,
    );
    expect(tester.takeException(), isNull);
  });
}
