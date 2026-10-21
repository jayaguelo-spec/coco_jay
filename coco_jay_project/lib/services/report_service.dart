import '../models/report_entry.dart';

/// Failure surfaced by [ReportService]; carries a user-facing message.
class ReportException implements Exception {
  const ReportException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Placeholder data source for user reports.
///
/// Simulates network latency so the UI can render its loading state. No HTTP
/// request is performed yet; the real REST API replaces this later.
class ReportService {
  ReportService({this.latency = const Duration(milliseconds: 1500)});

  final Duration latency;

  static const List<String> categories = [
    'Appointment',
    'Medication',
    'Other',
  ];

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  final List<ReportEntry> _stored = [];
  int _nextId = 1;

  /// Simulates loading the reports the user already filed.
  Future<List<ReportEntry>> fetchMyReports() async {
    await Future<void>.delayed(latency);
    return List<ReportEntry>.unmodifiable(_stored);
  }

  /// Simulates submitting one report.
  ///
  /// The `Other` category always fails to demonstrate the error state: the
  /// simulated backend keeps that channel under maintenance.
  Future<ReportEntry> submitReport({
    required String name,
    required String email,
    required String title,
    required String category,
    required String details,
  }) async {
    await Future<void>.delayed(latency);

    if (category == 'Other') {
      throw const ReportException(
        'The Other channel is currently under maintenance. '
        'Please choose Appointment or Medication, or retry later.',
      );
    }

    final now = DateTime.now();
    final entry = ReportEntry(
      id: _nextId,
      reference: 'RPT-${_nextId.toString().padLeft(4, '0')}',
      title: title,
      category: category,
      details: details,
      dateLabel: '${_months[now.month - 1]} ${now.day}, ${now.year}',
    );
    _nextId += 1;
    _stored.insert(0, entry);
    return entry;
  }
}
