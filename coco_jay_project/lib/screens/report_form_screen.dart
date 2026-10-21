import 'package:flutter/material.dart';

import '../models/report_entry.dart';
import '../services/report_service.dart';
import '../widgets/app_button.dart';

/// Async states of the "My reports" panel on the report form screen.
enum _ReportsStatus { loading, success, empty }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formSectionKey = GlobalKey();
  final _service = ReportService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();

  String? _category;
  bool _attemptedSubmit = false;

  bool _submitting = false;
  ReportEntry? _submitted;
  String? _submitError;

  _ReportsStatus _reportsStatus = _ReportsStatus.loading;
  List<ReportEntry> _myReports = const [];

  @override
  void initState() {
    super.initState();
    _loadMyReports();
  }

  Future<void> _loadMyReports() async {
    setState(() => _reportsStatus = _ReportsStatus.loading);
    final reports = await _service.fetchMyReports();
    if (!mounted) return;
    setState(() {
      _myReports = reports;
      _reportsStatus = reports.isEmpty
          ? _ReportsStatus.empty
          : _ReportsStatus.success;
    });
  }

  Future<void> _submit() async {
    setState(() => _attemptedSubmit = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    try {
      final entry = await _service.submitReport(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        title: _titleController.text.trim(),
        category: _category!,
        details: _detailsController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _submitted = entry;
        _submitting = false;
        _myReports = [entry, ..._myReports];
        _reportsStatus = _ReportsStatus.success;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitError = error is ReportException
            ? error.message
            : 'Something went wrong while submitting your report.';
      });
    }
  }

  void _fileAnother() {
    setState(() {
      _submitted = null;
      _submitError = null;
      _category = null;
      _attemptedSubmit = false;
      _titleController.clear();
      _detailsController.clear();
    });
    _formKey.currentState?.reset();
  }

  void _editSubmittedReport() {
    setState(() {
      _submitted = null;
      _submitError = null;
    });
  }

  void _focusForm() {
    Scrollable.ensureVisible(
      _formSectionKey.currentContext ?? context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = (value ?? '').trim();
    if (name.isEmpty) return 'Please enter your full name.';
    if (name.length < 3) return 'Name looks too short.';
    return null;
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Please enter your email address.';
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!valid.hasMatch(email)) return 'Please enter a valid email address.';
    return null;
  }

  String? _validateTitle(String? value) {
    final title = (value ?? '').trim();
    if (title.isEmpty) return 'Please add a short title.';
    if (title.length < 5) return 'Title needs at least 5 characters.';
    return null;
  }

  String? _validateDetails(String? value) {
    final details = (value ?? '').trim();
    if (details.isEmpty) return 'Please describe your concern.';
    if (details.length < 20) {
      return 'Please describe your concern (at least 20 characters).';
    }
    return null;
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
              'File a Report',
              style: TextStyle(
                color: Color(0xFF17352E),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
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
                        Icons.report_gmailerrorred_outlined,
                        color: Color(0xFFA34F32),
                        size: 17,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'REPORT A CONCERN',
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
                const Text(
                  'Tell us what you need help with.',
                  style: TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 30,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your report goes to your community health worker. '
                  'All fields marked required must be completed.',
                  style: TextStyle(
                    color: Color(0xFF63716C),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 26),
                KeyedSubtree(
                  key: _formSectionKey,
                  child: _buildSubmitSection(),
                ),
                const SizedBox(height: 24),
                _ReportsCard(
                  status: _reportsStatus,
                  reports: _myReports,
                  onStartAction: _focusForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitSection() {
    if (_submitting) return const _SubmittingPanel();
    if (_submitted != null) {
      return _SuccessPanel(entry: _submitted!, onFileAnother: _fileAnother);
    }
    if (_submitError != null) {
      return _ErrorPanel(
        message: _submitError!,
        onRetry: _submit,
        onEdit: _editSubmittedReport,
      );
    }
    return _ReportForm(
      formKey: _formKey,
      nameController: _nameController,
      emailController: _emailController,
      titleController: _titleController,
      detailsController: _detailsController,
      category: _category,
      showCategoryError: _attemptedSubmit && _category == null,
      onCategoryChanged: (value) => setState(() => _category = value),
      onSubmit: _submit,
      validateName: _validateName,
      validateEmail: _validateEmail,
      validateTitle: _validateTitle,
      validateDetails: _validateDetails,
    );
  }
}

class _ReportForm extends StatelessWidget {
  const _ReportForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.titleController,
    required this.detailsController,
    required this.category,
    required this.showCategoryError,
    required this.onCategoryChanged,
    required this.onSubmit,
    required this.validateName,
    required this.validateEmail,
    required this.validateTitle,
    required this.validateDetails,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController titleController;
  final TextEditingController detailsController;
  final String? category;
  final bool showCategoryError;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onSubmit;
  final FormFieldValidator<String> validateName;
  final FormFieldValidator<String> validateEmail;
  final FormFieldValidator<String> validateTitle;
  final FormFieldValidator<String> validateDetails;

  static const _fieldDecoration = InputDecoration(
    border: OutlineInputBorder(),
    filled: true,
    fillColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E8E2)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report details',
              style: TextStyle(
                color: Color(0xFF17352E),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Fill in every field — the form checks your answers before sending.',
              style: TextStyle(
                color: Color(0xFF63716C),
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              validator: validateName,
              decoration: _fieldDecoration.copyWith(
                labelText: 'Full name *',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              decoration: _fieldDecoration.copyWith(
                labelText: 'Email address *',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: titleController,
              validator: validateTitle,
              decoration: _fieldDecoration.copyWith(labelText: 'Title *'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: detailsController,
              maxLines: 4,
              validator: validateDetails,
              decoration: _fieldDecoration.copyWith(
                labelText: 'Concern details *',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Report type *',
              style: TextStyle(
                color: Color(0xFF17352E),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final option in ReportService.categories)
                  _CategoryChip(
                    label: option,
                    selected: category == option,
                    onTap: () => onCategoryChanged(option),
                  ),
              ],
            ),
            if (showCategoryError) ...[
              const SizedBox(height: 8),
              const Text(
                'Please choose a report type.',
                style: TextStyle(color: Color(0xFFA34F32), fontSize: 12),
              ),
            ],
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: AppButton(text: 'Submit report', onPressed: onSubmit),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmittingPanel extends StatelessWidget {
  const _SubmittingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E8E2)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            minHeight: 4,
            color: Color(0xFF236B55),
            backgroundColor: Color(0xFFE1E8E2),
          ),
          SizedBox(height: 16),
          Row(
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
                  'Submitting your report...',
                  style: TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Please wait — sending is in progress and duplicate submits are blocked.',
            style: TextStyle(
              color: Color(0xFF63716C),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessPanel extends StatelessWidget {
  const _SuccessPanel({required this.entry, required this.onFileAnother});

  final ReportEntry entry;
  final VoidCallback onFileAnother;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF236B55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFDCEBE2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF236B55),
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Report received',
            style: TextStyle(
              color: Color(0xFF17352E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your report is on its way to your community health worker. '
            'Keep reference ${entry.reference} to follow it up.',
            style: const TextStyle(
              color: Color(0xFF63716C),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${entry.reference}  •  ${entry.category}  •  ${entry.dateLabel}',
              style: const TextStyle(
                color: Color(0xFF236B55),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          AppButton(text: 'File another report', onPressed: onFileAnother),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({
    required this.message,
    required this.onRetry,
    required this.onEdit,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA34F32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Color(0xFFA34F32),
                size: 24,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Could not submit your report',
                  style: TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF63716C),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              AppButton(text: 'Retry', onPressed: onRetry),
              const SizedBox(width: 12),
              TextButton(
                onPressed: onEdit,
                child: const Text(
                  'Edit my report',
                  style: TextStyle(
                    color: Color(0xFF236B55),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ReportsCard extends StatelessWidget {
  const _ReportsCard({
    required this.status,
    required this.reports,
    required this.onStartAction,
  });

  final _ReportsStatus status;
  final List<ReportEntry> reports;
  final VoidCallback onStartAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            'My reports',
            style: TextStyle(
              color: Color(0xFF17352E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Everything you file shows up here.',
            style: TextStyle(
              color: Color(0xFF63716C),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          ..._buildBody(),
        ],
      ),
    );
  }

  List<Widget> _buildBody() {
    switch (status) {
      case _ReportsStatus.loading:
        return const [
          Row(
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
                  'Loading your reports...',
                  style: TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Fetching the reports linked to your account.',
            style: TextStyle(
              color: Color(0xFF63716C),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ];
      case _ReportsStatus.empty:
        return [
          const Icon(
            Icons.inbox_outlined,
            color: Color(0xFF94A29C),
            size: 26,
          ),
          const SizedBox(height: 10),
          const Text(
            'No reports yet',
            style: TextStyle(
              color: Color(0xFF17352E),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Nothing has been filed from this account. This is not an error — '
            'your reports will appear here right after you send one.',
            style: TextStyle(
              color: Color(0xFF63716C),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          AppButton(text: 'Start a report', onPressed: onStartAction),
        ];
      case _ReportsStatus.success:
        return [
          for (final report in reports) ...[
            _ReportTile(report: report),
            const SizedBox(height: 10),
          ],
        ];
    }
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.report});

  final ReportEntry report;

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
            Icons.description_outlined,
            color: Color(0xFF236B55),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${report.reference} — ${report.title}',
                  style: const TextStyle(
                    color: Color(0xFF17352E),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  report.details,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
            report.dateLabel,
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
