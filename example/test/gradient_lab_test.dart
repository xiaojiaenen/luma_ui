import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';
import 'package:luma_ui_example/gradient_lab.dart';

void main() {
  testWidgets('gradient cards animate selection and direction', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const SoftDesign(
          child: Scaffold(body: SingleChildScrollView(child: GradientLab())),
        ),
      ),
    );
    await tester.tap(find.text('暖霞 · 杏桃与灰紫'));
    await tester.pumpAndSettle();
    expect(find.textContaining('当前选中：暖霞'), findsOneWidget);
    await tester.tap(find.text('改变渐变方向'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('gradient visual review light and dark', (tester) async {
    await (FontLoader(SoftTokens.fontFamily)..addFont(
          rootBundle.load(
            'packages/luma_ui/assets/fonts/HarmonyOS_Sans_SC_Regular.ttf',
          ),
        ))
        .load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    tester.view.physicalSize = const Size(1320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(fontFamily: SoftTokens.fontFamily),
        home: RepaintBoundary(
          key: const ValueKey('gradients'),
          child: Row(
            children: [
              for (final mode in [Brightness.light, Brightness.dark])
                Expanded(
                  child: SoftDesign(
                    brightness: mode,
                    child: const Scaffold(
                      body: Padding(
                        padding: EdgeInsets.all(28),
                        child: GradientLab(),
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
      find.byKey(const ValueKey('gradients')),
      matchesGoldenFile('../../previews/gradients-motion.png'),
    );
  });
}
