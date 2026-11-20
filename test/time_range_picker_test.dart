import 'package:flutter_test/flutter_test.dart';
import 'package:time_range_picker_plus/time_range_picker_plus.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  for (final confirm in [true, false]) {
    testWidgets(
      'Material UI dialog ${confirm ? 'confirms' : 'cancels'} a range',
      (tester) async {
        TimeRange? result;
        var completed = false;
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [Locale('en'), Locale('it')],
            locale: const Locale('it'),
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: TextButton(
                    onPressed: () async {
                      result = await showTimeRangePicker(
                        context: context,
                        start: const TimeOfDay(hour: 9, minute: 0),
                        end: const TimeOfDay(hour: 12, minute: 0),
                      );
                      completed = true;
                    },
                    child: const Text('Open'),
                  ),
                );
              },
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.byType(TimeRangePicker), findsOneWidget);
        expect(tester.takeException(), isNull);
        final context = tester.element(find.byType(TimeRangePicker));
        final localizations = MaterialLocalizations.of(context);
        await tester.tap(
          find.text(
            confirm
                ? localizations.okButtonLabel
                : localizations.cancelButtonLabel,
          ),
        );
        await tester.pumpAndSettle();
        expect(completed, isTrue);
        if (confirm) {
          expect(result?.startTime, const TimeOfDay(hour: 9, minute: 0));
          expect(result?.endTime, const TimeOfDay(hour: 12, minute: 0));
        } else {
          expect(result, isNull);
        }
        expect(find.byType(TimeRangePicker), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
