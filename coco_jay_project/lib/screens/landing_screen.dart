import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class _FeatureCardData {
  const _FeatureCardData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

const List<_FeatureCardData> _features = [
  _FeatureCardData(
    icon: Icons.calendar_month_outlined,
    title: 'Pregnancy Tracking',
    description: "Monitor your baby's growth.",
  ),
  _FeatureCardData(
    icon: Icons.calendar_month_outlined,
    title: 'Appointments',
    description: 'Manage your check-ups.',
  ),
  _FeatureCardData(
    icon: Icons.add_box_outlined,
    title: 'Health Records',
    description: 'Access your health information.',
  ),
];

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const Color _primaryGreen = Color(0xFF135431);

  void _onNavTap(BuildContext context, String item) {
    if (item == 'Home') {
      return;
    } else if (item == 'Login') {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$item feature coming soon.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopNavBar(context),
            const SizedBox(height: 50),
            _buildHero(context),
            const SizedBox(height: 48),
            _buildFeatureCards(context),
            const SizedBox(height: 60),
            _buildFooter(),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context) {
    final navItems = [
      'Home',
      'Appointments',
      'Health Tips',
      'Contact',
      'Login',
    ];

    return Container(
      width: double.infinity,
      color: _primaryGreen,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 768;

              final title = const Text(
                'Prenatal Care System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              );

              final navLinks = Wrap(
                spacing: 24,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: navItems.map((item) {
                  final isHome = item == 'Home';
                  return InkWell(
                    onTap: () => _onNavTap(context, item),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isHome) ...[
                            const SizedBox(height: 3),
                            Container(
                              height: 2,
                              width: 44,
                              color: Colors.white,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );

              if (isWide) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    title,
                    Flexible(child: navLinks),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 12),
                  navLinks,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Prenatal Care System',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _primaryGreen,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Track your pregnancy, appointments, and health information.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.dashboard,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'View Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 820;

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCard(_features[0])),
                    const SizedBox(width: 24),
                    Expanded(child: _buildCard(_features[1])),
                    const SizedBox(width: 24),
                    Expanded(child: _buildCard(_features[2])),
                  ],
                );
              }

              return Column(
                children: [
                  _buildCard(_features[0]),
                  const SizedBox(height: 20),
                  _buildCard(_features[1]),
                  const SizedBox(height: 20),
                  _buildCard(_features[2]),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(_FeatureCardData feature) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD1D5DB),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            feature.icon,
            size: 46,
            color: Colors.black87,
          ),
          const SizedBox(height: 18),
          Text(
            feature.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Text(
      '© 2025 Prenatal Care System',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF4B5563),
        fontSize: 14,
      ),
    );
  }
}
