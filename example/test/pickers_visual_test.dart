import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  testWidgets('custom field dialogs visual review', (tester) async {
    await (FontLoader(SoftTokens.fontFamily)..addFont(
          rootBundle.load(
            'packages/luma_ui/assets/fonts/HarmonyOS_Sans_SC_Regular.ttf',
          ),
        ))
        .load();
    await (FontLoader(SoftTokens.monoFontFamily)..addFont(
          rootBundle.load(
            'packages/luma_ui/assets/fonts/JetBrainsMono-Regular.ttf',
          ),
        ))
        .load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    tester.view.physicalSize = const Size(420, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final mode in Brightness.values) {
      for (final date in [true, false]) {
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: SoftTokens.theme(
              fontFamily: SoftTokens.fontFamily,
              brightness: mode,
            ),
            home: SoftDesign(
              child: Scaffold(
                body: Center(
                  child: date
                      ? SoftDateField(
                          value: DateTime(2026, 10, 10),
                          onChanged: (_) {},
                        )
                      : SoftTimeField(
                          value: const TimeOfDay(hour: 9, minute: 30),
                          onChanged: (_) {},
                        ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byType(SoftButton).first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(Overlay).first,
          matchesGoldenFile(
            '../../previews/${date ? 'date' : 'time'}-picker-${mode.name}.png',
          ),
        );
        await tester.tap(find.text('取消'));
        await tester.pumpAndSettle();
      }
    }
  });
}
