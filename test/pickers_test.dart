import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  testWidgets('date dialog preserves theme, cancels and commits selection', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    DateTime? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(),
        home: SoftDesign(
          brightness: Brightness.dark,
          accent: Colors.purple,
          child: Scaffold(
            body: SoftDateField(
              value: DateTime(2026, 10, 10),
              onChanged: (value) => result = value,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(SoftDateField));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsNothing);
    expect(find.byType(SoftCalendar), findsOneWidget);
    final calendar = tester.element(find.byType(SoftCalendar));
    expect(SoftDesign.of(calendar).isDark, isTrue);
    expect(SoftDesign.of(calendar).accent, Colors.purple);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(result, isNull);
    await tester.tap(find.byType(SoftDateField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15'));
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(result, DateTime(2026, 10, 15));
    expect(tester.takeException(), isNull);
  });
  testWidgets('time dialog rolls over and only commits on confirm', (
    tester,
  ) async {
    TimeOfDay? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SoftTimeField(
            value: const TimeOfDay(hour: 23, minute: 59),
            onChanged: (value) => result = value,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(SoftTimeField));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsNothing);
    await tester.tap(find.byTooltip('增加小时'));
    await tester.tap(find.byTooltip('增加分钟'));
    await tester.pumpAndSettle();
    expect(result, isNull);
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(result, const TimeOfDay(hour: 0, minute: 0));
    expect(tester.takeException(), isNull);
  });
}
