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
}
