import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/login_screen.dart';
import '../screens/report_form_screen.dart';

class AppRoutes {
  // Approved Activity 6 flow: login gate first, then the landing page,
  // and the member dashboard behind it.
  static const String login = '/';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String reportForm = '/report';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.login: (_) => const LoginScreen(),
  AppRoutes.home: (_) => const LandingScreen(),
  AppRoutes.dashboard: (_) => const HomeScreen(),
  AppRoutes.reportForm: (_) => const ReportFormScreen(),
};
