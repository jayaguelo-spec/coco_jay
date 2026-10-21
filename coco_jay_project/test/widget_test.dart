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
  });
}
