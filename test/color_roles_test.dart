import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  test(
    'role colors are independent of brand changes and survive theme copies',
    () {
      for (final mode in Brightness.values) {
        final a = SoftDesign(
          brightness: mode,
          accent: Colors.red,
          child: const SizedBox(),
        );
        final b = SoftDesign(
          brightness: mode,
          accent: Colors.blue,
          child: const SizedBox(),
        );
        expect(a.roles.secondary, b.roles.secondary);
        expect(a.roles.chart, b.roles.chart);
        expect(a.roles.chart.toSet().length, 6);
        expect(
          a.container(SoftTone.primary),
          isNot(b.container(SoftTone.primary)),
        );
        final copy = a.copyWith(child: const SizedBox());
        expect(copy.roles.chart, a.roles.chart);
        expect(copy.brightness, mode);
      }
    },
  );
  testWidgets('custom colors survive nested layout', (tester) async {
    late SoftDesign current;
    const roles = SoftRoleColors(
      secondary: Colors.teal,
      tertiary: Colors.orange,
      ai: Colors.purple,
      chart: [Colors.red, Colors.green],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: SoftDesign(
          roleColors: roles,
          child: Scaffold(
            body: Column(
              children: [
                Builder(
                  builder: (context) {
                    current = SoftDesign.of(context);
                    return const Text('Scoped');
                  },
                ),
                const Text('Peer'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(current.roles, same(roles));
    expect(tester.takeException(), isNull);
  });
}
