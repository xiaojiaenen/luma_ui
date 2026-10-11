import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';
import 'package:luma_ui_example/showcase_header.dart';

void main() {
  testWidgets('header narrow layout', (tester) async {
    tester.view.physicalSize = const Size(320, 2000);
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
              child: ShowcaseHeader(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  });
  testWidgets('showcase header visual review', (tester) async {
    await (FontLoader(SoftTokens.fontFamily)..addFont(
          rootBundle.load(
            'packages/luma_ui/assets/fonts/HarmonyOS_Sans_SC_Regular.ttf',
          ),
        ))
        .load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    tester.view.physicalSize = const Size(1440, 2100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(fontFamily: SoftTokens.fontFamily),
        home: RepaintBoundary(
          key: const ValueKey('showcase'),
          child: Row(
            children: [
              for (final mode in [Brightness.light, Brightness.dark])
                Expanded(
                  child: SoftDesign(
                    brightness: mode,
                    child: const Scaffold(
                      body: Padding(
                        padding: EdgeInsets.all(28),
                        child: ShowcaseHeader(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('showcase')),
      matchesGoldenFile('../../previews/showcase-header.png'),
    );
  });
}
