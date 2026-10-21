// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coco_jay_project/app.dart';

void main() {
  testWidgets('Login opens the landing page and the dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(
      find.text('Track your pregnancy, appointments, and health information.'),
      findsOneWidget,
    );
    expect(find.text('View Dashboard'), findsOneWidget);

    final dashboardButton = find.widgetWithText(
      ElevatedButton,
      'View Dashboard',
    );
    await tester.ensureVisible(dashboardButton);
    await tester.tap(dashboardButton);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Save name'), findsOneWidget);
    expect(find.text('Prenatal Care System'), findsWidgets);

    // Flush the dashboard's simulated network delay.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('Prenatal check-up'), findsOneWidget);
  });

  testWidgets('Dashboard renders loading, success, empty, and error states', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'View Dashboard'));
    // Step through the route transition; pumpAndSettle would pump past the
    // loading state because the progress indicator keeps animating.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Loading: progress shown while records are fetched.
    expect(find.text('Loading your records...'), findsOneWidget);

    // Success: sample records plus a next step.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('Prenatal check-up'), findsOneWidget);
    expect(
      find.text(
        'Next step: open Appointments to plan your next clinic visit.',
      ),
      findsOneWidget,
    );

    // Empty: explanation plus an action, not an error.
    await tester.ensureVisible(find.text('Empty'));
    await tester.tap(find.text('Empty'));
    await tester.pump();
    expect(find.text('Loading your records...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('No records yet'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Schedule first appointment'),
      findsOneWidget,
    );

    // Error: reason plus Retry.
    await tester.ensureVisible(find.text('Error'));
    await tester.tap(find.text('Error'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('Could not load your records'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);

    // Retry re-enters the loading state.
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Retry'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
    await tester.pump();
    expect(find.text('Loading your records...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  });

  testWidgets('Report form validates input and renders async states', (
    WidgetTester tester,
  ) async {
    // Tall viewport so the whole report form fits on screen and taps never
    // land on clipped widgets.
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'View Dashboard'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'File a Report'),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'File a Report'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Loading state of the My reports panel.
    expect(find.text('Loading your reports...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    // Empty state: nothing filed yet, plus an action.
    expect(find.text('No reports yet'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Start a report'),
      findsOneWidget,
    );

    // Validation blocks an empty submit.
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Submit report'),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit report'));
    await tester.pump();
    expect(find.text('Please enter your full name.'), findsOneWidget);
    expect(find.text('Please enter your email address.'), findsOneWidget);
    expect(find.text('Please choose a report type.'), findsOneWidget);

    // Fill the form and submit through the Appointment channel.
    await tester.enterText(find.byType(TextFormField).at(0), 'Maria Santos');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'maria@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'Move my check-up',
    );
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'I would like to move my next check-up to a later day this week.',
    );
    await tester.ensureVisible(find.text('Appointment'));
    await tester.pump();
    await tester.tap(find.text('Appointment'));

    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Submit report'),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit report'));
    await tester.pump();

    // Loading state while submitting.
    expect(find.text('Submitting report...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    // Success state with a reference number, and the list leaves empty.
    expect(find.text('Report received'), findsOneWidget);
    expect(find.textContaining('RPT-000'), findsWidgets);

    // The Other channel fails, showing the error state.
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'File another report'),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'File another report'));
    await tester.pump();

    await tester.ensureVisible(find.text('Other'));
    await tester.pump();
    await tester.tap(find.text('Other'));
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'Other concern',
    );
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'Something that needs the Other channel which is under maintenance now.',
    );
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Submit report'),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit report'));
    await tester.pump();
    expect(find.text('Submitting report...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Could not submit your report'), findsOneWidget);
    expect(find.textContaining('under maintenance'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
  });
}
