import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';
import 'package:luma_ui_example/catalog.dart';
import 'package:luma_ui_example/catalog_data.dart';

void main() {
  test('100+ entries match public widget inventory without duplicates', () {
    expect(componentSpecs.length, greaterThanOrEqualTo(100));
    expect(
      componentSpecs.map((s) => s.name).toSet().length,
      componentSpecs.length,
    );
    final names = <String>{};
    for (final file in Directory(
      '../lib/src',
    ).listSync().whereType<File>().where((f) => f.path.endsWith('.dart'))) {
      names.addAll(
        RegExp(r'class ([A-Z]\w+) extends (?:StatelessWidget|StatefulWidget)')
            .allMatches(file.readAsStringSync())
            .map((m) => m.group(1)!),
      );
    }
    names.remove('SoftDesign');
    expect(componentSpecs.map((s) => s.name).toSet(), names);
  });
  for (final brightness in Brightness.values) {
    for (final width in [224.0, 640.0]) {
      testWidgets(
        'every catalog widget fits $width $brightness with larger text',
        (tester) async {
          tester.view.physicalSize = const Size(900, 1200);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          for (final spec in componentSpecs) {
            await tester.pumpWidget(
              MaterialApp(
                theme: SoftTokens.theme(brightness: brightness),
                home: SoftDesign(
                  brightness: brightness,
                  child: MediaQuery(
                    data: MediaQueryData(
                      size: const Size(900, 1200),
                      disableAnimations: true,
                      textScaler: TextScaler.linear(width < 300 ? 1.3 : 1),
                    ),
                    child: Scaffold(
                      body: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: width,
                          height: 1000,
                          child: SingleChildScrollView(
                            child: CatalogPreview(
                              key: ValueKey(spec.name),
                              spec: spec,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pump(const Duration(milliseconds: 500));
            expect(tester.takeException(), isNull, reason: spec.name);
          }
        },
      );
    }
  }
}
