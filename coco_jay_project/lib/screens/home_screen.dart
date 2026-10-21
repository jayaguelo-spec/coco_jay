import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class _Feature {
  const _Feature(this.icon, this.title, this.subtitle, this.tint);

  final IconData icon;
  final String title;
  final String subtitle;
  final Color tint;
}

const List<_Feature> _features = [
  _Feature(
    Icons.calendar_month_outlined,
    'Appointments',
    'Keep your clinic visits and schedules in order.',
    Color(0xFF236B55),
  ),
  _Feature(
    Icons.medical_services_outlined,
    'Check-up records',
    'Log visits, results, and notes from your doctor.',
    Color(0xFFA34F32),
  ),
  _Feature(
    Icons.notifications_outlined,
    'Reminders',
    'Never miss a check-up or due date.',
    Color(0xFF3F6690),
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  String? _savedName;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first.')),
      );
      return;
    }

    setState(() => _savedName = name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F2),
      appBar: AppBar(
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFDCEBE2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.spa_outlined,
                color: Color(0xFF236B55),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Prenatal Care System',
              style: TextStyle(
                color: Color(0xFF17352E),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFF236B55),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E8DF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        color: Color(0xFFA34F32),
                        size: 17,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'YOUR PRENATAL JOURNEY',
                        style: TextStyle(
                          color: Color(0xFF87432C),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _savedName == null
                      ? 'Welcome home.'
                      : 'Welcome, $_savedName.',
                  style: const TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 34,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your prenatal records, all in one place.',
                  style: TextStyle(
                    color: Color(0xFF63716C),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Your tools',
                  style: TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Three starting sections of the system.',
                  style: TextStyle(
                    color: Color(0xFF63716C),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = (constraints.maxWidth / 280)
                        .floor()
                        .clamp(1, 3);
                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: columns == 1 ? 1.6 : 1.25,
                      children: [
                        for (final feature in _features)
                          _FeatureCard(feature: feature),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 760;
                    final personalization = _PersonalizeCard(
                      savedName: _savedName,
                      controller: _nameController,
                      onSave: _saveName,
                    );
                    final activity = const _ActivityCard();

                    if (wide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: personalization),
                          const SizedBox(width: 16),
                          Expanded(child: activity),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        personalization,
                        const SizedBox(height: 16),
                        activity,
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E8E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: feature.tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(feature.icon, color: feature.tint, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            feature.title,
            style: const TextStyle(
              color: Color(0xFF17352E),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              feature.subtitle,
              style: const TextStyle(
                color: Color(0xFF63716C),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Coming soon',
              style: TextStyle(
                color: Color(0xFF63716C),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalizeCard extends StatelessWidget {
  const _PersonalizeCard({
    required this.savedName,
    required this.controller,
    required this.onSave,
  });

  final String? savedName;
  final TextEditingController controller;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E8E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Make yourself at home',
            style: TextStyle(
              color: Color(0xFF17352E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            savedName == null
                ? 'Add your name to personalize this space.'
                : 'This space now belongs to $savedName.',
            style: const TextStyle(
              color: Color(0xFF63716C),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          AppTextField(hintText: 'Your name', controller: controller),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(text: 'Save name', onPressed: onSave),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E8E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent activity',
            style: TextStyle(
              color: Color(0xFF17352E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Everything you save will show up here.',
            style: TextStyle(
              color: Color(0xFF63716C),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE1E8E2),
                style: BorderStyle.solid,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  color: Color(0xFF94A29C),
                  size: 26,
                ),
                SizedBox(height: 10),
                Text(
                  'Nothing here yet',
                  style: TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Saved notes and finished tasks will appear once the REST API is connected.',
                  style: TextStyle(
                    color: Color(0xFF63716C),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
