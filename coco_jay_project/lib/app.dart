import 'package:flutter/material.dart';

import 'constants/app_constants.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF236B55),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F6F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F6F2),
          foregroundColor: Color(0xFF17352E),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF236B55),
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      initialRoute: AppRoutes.login,
      routes: appRoutes,
    );
  }
}
