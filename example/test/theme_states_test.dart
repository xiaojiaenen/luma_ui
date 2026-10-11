import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';
import 'package:luma_ui_example/state_lab.dart';

void main() {
  testWidgets('dark theme state gallery visual review', (tester) async {
    await (FontLoader(SoftTokens.fontFamily)..addFont(
          rootBundle.load(
            'packages/luma_ui/assets/fonts/HarmonyOS_Sans_SC_Regular.ttf',
          ),
        ))
        .load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    tester.view.physicalSize = const Size(1080, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(
          fontFamily: SoftTokens.fontFamily,
          brightness: Brightness.dark,
        ),
        home: const SoftDesign(
          child: RepaintBoundary(
            key: ValueKey('dark-states'),
            child: Scaffold(
              body: Padding(padding: EdgeInsets.all(32), child: StateLab()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('dark-states')),
      matchesGoldenFile('../../previews/dark-states.png'),
    );
  });
}
