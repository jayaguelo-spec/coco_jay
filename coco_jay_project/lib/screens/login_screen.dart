import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F2),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCEBE2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    color: Color(0xFF236B55),
                    size: 34,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Prenatal Care System',
                  style: TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your prenatal care companion, all in one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF63716C),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE1E8E2)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          color: Color(0xFF17352E),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sign in to continue to your space.',
                        style: TextStyle(
                          color: Color(0xFF63716C),
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const AppTextField(
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      const AppTextField(
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: 'Login',
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.home);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Prenatal Care System · IT 110 Semester Project',
                  style: TextStyle(
                    color: Color(0xFF94A29C),
                    fontSize: 12,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
