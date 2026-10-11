import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  testWidgets('capture component review', (tester) async {
    final font = FontLoader(SoftTokens.fontFamily)
      ..addFont(
        Future.value(
          ByteData.sublistView(
            File('assets/fonts/HarmonyOS_Sans_SC_Regular.ttf')
                .readAsBytesSync(),
          ),
        ),
      );
    await font.load();
    final mono = FontLoader(SoftTokens.monoFontFamily)
      ..addFont(
        Future.value(
          ByteData.sublistView(
            File('assets/fonts/JetBrainsMono-Regular.ttf').readAsBytesSync(),
          ),
        ),
      );
    await mono.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    tester.view.physicalSize = const Size(1200, 1440);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(fontFamily: SoftTokens.fontFamily),
        home: SoftDesign(
          child: RepaintBoundary(
            key: const ValueKey('capture'),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Luma UI / 125 components',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text('同一圆角 · 高光边框 · 主题联动 · 适当动效'),
                    const SizedBox(height: 24),
                    SoftTabs(
                      labels: const ['组件目录', '参数与组合'],
                      selected: 0,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SoftCalendar(
                            month: DateTime(2026, 10),
                            selected: DateTime(2026, 10, 11),
                            onMonthChanged: (_) {},
                            onSelected: (_) {},
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: SoftSurface(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Colorful details',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text('独立色调 · 统一圆角与高光'),
                                const SizedBox(height: 24),
                                const Wrap(
                                  spacing: 12,
                                  children: [
                                    SoftTag('Sage'),
                                    SoftTag('Apricot'),
                                    SoftTag('Lilac'),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const SoftCodeBlock(
                                  code: "SoftSurface(\n  gradientPreset: SoftGradientPreset.lilac,\n  child: content,\n)",
                                  maxHeight: 180,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SoftWeatherCard(
                            city: 'Calicut, Kerala',
                            temperature: '28°',
                            condition: 'Pretty sunny',
                            humidity: '72%',
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: SoftFlightTicket(
                            from: 'SFO',
                            to: 'JFK',
                            departure: '9:25 PM',
                            arrival: '2:15 AM',
                            gate: 'B16',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const SoftSurface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Color with a purpose',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SoftAreaChart(values: [2, 4, 3, 7, 6, 9]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('capture')),
      matchesGoldenFile('../previews/component-library.png'),
    );
  });
}
