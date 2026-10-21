import 'package:flutter/material.dart';

import '../models/health_record.dart';
import '../routes/app_routes.dart';
import '../services/dashboard_service.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

/// Async screen states for the dashboard records panel.
enum _DashboardStatus { loading, success, empty, error }

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
  final _dashboardService = const DashboardService();

  String? _savedName;

  _DashboardStatus _status = _DashboardStatus.loading;
  DashboardScenario _scenario = DashboardScenario.success;
  List<HealthRecord> _records = const [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _status = _DashboardStatus.loading;
      _errorMessage = null;
    });

    try {
      final records = await _dashboardService.fetchRecords(scenario: _scenario);
      if (!mounted) return;
      setState(() {
        _records = records;
        _status = records.isEmpty
            ? _DashboardStatus.empty
            : _DashboardStatus.success;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error is DashboardException
            ? error.message
            : 'Something went wrong while loading your records.';
        _status = _DashboardStatus.error;
      });
    }
  }

  void _previewScenario(DashboardScenario scenario) {
    if (_status == _DashboardStatus.loading) return;
    setState(() => _scenario = scenario);
    _loadRecords();
  }

  void _scheduleAppointment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Appointment scheduling arrives with the REST API in the next activity.',
        ),
      ),
    );
  }

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your tools',
                            style: TextStyle(
                              color: Color(0xFF17352E),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Three starting sections of the system.',
                            style: TextStyle(
                              color: Color(0xFF63716C),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      text: 'File a Report',
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.reportForm),
                    ),
                  ],
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
                    final activity = _ActivityCard(
                      status: _status,
                      scenario: _scenario,
                      records: _records,
                      errorMessage: _errorMessage,
                      onRetry: _loadRecords,
                      onPreview: _previewScenario,
                      onEmptyAction: _scheduleAppointment,
                    );

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
  const _ActivityCard({
    required this.status,
    required this.scenario,
    required this.records,
    required this.errorMessage,
    required this.onRetry,
    required this.onPreview,
    required this.onEmptyAction,
  });

  final _DashboardStatus status;
  final DashboardScenario scenario;
  final List<HealthRecord> records;
  final String? errorMessage;
  final VoidCallback onRetry;
  final ValueChanged<DashboardScenario> onPreview;
  final VoidCallback onEmptyAction;

  @override
  Widget build(BuildContext context) {
    final isLoading = status == _DashboardStatus.loading;

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
            'Your records',
            style: TextStyle(
              color: Color(0xFF17352E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Appointments and check-ups load here from the records service.',
            style: TextStyle(
              color: Color(0xFF63716C),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          _ScenarioPicker(
            selected: scenario,
            enabled: !isLoading,
            onSelected: onPreview,
          ),
          const SizedBox(height: 16),
          if (isLoading) const _LoadingState() else ...?_buildBody(),
        ],
      ),
    );
  }

  List<Widget>? _buildBody() {
    switch (status) {
      case _DashboardStatus.loading:
        return null;
      case _DashboardStatus.success:
        return [
          for (final record in records) ...[
            _RecordTile(record: record),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFFA34F32), size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Next step: open Appointments to plan your next clinic visit.',
                  style: TextStyle(
                    color: Color(0xFF63716C),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ];
      case _DashboardStatus.empty:
        return [
          const Icon(Icons.inbox_outlined, color: Color(0xFF94A29C), size: 26),
          const SizedBox(height: 10),
          const Text(
            'No records yet',
            style: TextStyle(
              color: Color(0xFF17352E),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'This is not an error — your account simply has no records to show '
            'yet. Your first check-up will appear here once it is logged.',
            style: TextStyle(
              color: Color(0xFF63716C),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          AppButton(text: 'Schedule first appointment', onPressed: onEmptyAction),
        ];
      case _DashboardStatus.error:
        return [
          const Row(
            children: [
              Icon(Icons.error_outline, color: Color(0xFFA34F32), size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Could not load your records',
                  style: TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            errorMessage ?? 'Unexpected error.',
            style: const TextStyle(
              color: Color(0xFF63716C),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          AppButton(text: 'Retry', onPressed: onRetry),
        ];
    }
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LinearProgressIndicator(
          minHeight: 4,
          color: Color(0xFF236B55),
          backgroundColor: Color(0xFFE1E8E2),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF236B55),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Loading your records...',
                style: TextStyle(
                  color: Color(0xFF17352E),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Your dashboard stays usable while records are fetched.',
          style: TextStyle(
            color: Color(0xFF63716C),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _ScenarioPicker extends StatelessWidget {
  const _ScenarioPicker({
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  final DashboardScenario selected;
  final bool enabled;
  final ValueChanged<DashboardScenario> onSelected;

  static const Map<DashboardScenario, String> _labels = {
    DashboardScenario.success: 'Success',
    DashboardScenario.empty: 'Empty',
    DashboardScenario.error: 'Error',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preview state (demo until the REST API is connected)',
          style: TextStyle(
            color: Color(0xFF94A29C),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final value in DashboardScenario.values)
              _ScenarioChip(
                label: _labels[value]!,
                selected: selected == value,
                onTap: enabled ? () => onSelected(value) : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _ScenarioChip extends StatelessWidget {
  const _ScenarioChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF236B55) : const Color(0xFFF1F5F1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0xFF236B55) : const Color(0xFFE1E8E2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF63716C),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final HealthRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE1E8E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.event_note_outlined,
            color: Color(0xFF236B55),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  record.note,
                  style: const TextStyle(
                    color: Color(0xFF63716C),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            record.date,
            style: const TextStyle(
              color: Color(0xFF94A29C),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
