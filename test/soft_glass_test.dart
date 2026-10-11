import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  testWidgets('composer trims messages and ignores empty input', (
    tester,
  ) async {
    final messages = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: SoftTokens.theme(),
        home: Scaffold(body: SoftComposer(onSend: messages.add)),
      ),
    );
    await tester.tap(find.byTooltip('Send message'));
    expect(messages, isEmpty);
    await tester.enterText(find.byType(TextField), '  hello  ');
    await tester.tap(find.byTooltip('Send message'));
    expect(messages, ['hello']);
    expect(find.text('hello'), findsNothing);
  });
  testWidgets('segments dispatch selected index', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SoftSegmented(
            labels: const ['All', 'Active'],
            selected: 0,
            onChanged: (i) => selected = i,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Active'));
    expect(selected, 1);
  });
}
