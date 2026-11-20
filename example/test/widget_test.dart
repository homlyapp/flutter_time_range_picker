import 'package:example/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_range_picker_plus/time_range_picker_plus.dart';

void main() {
  testWidgets('Example opens the Material UI picker', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Pure'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(Dialog), matching: find.byType(TimeRangePicker)), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.descendant(of: find.byType(Dialog), matching: find.text('Cancel')));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });
}
