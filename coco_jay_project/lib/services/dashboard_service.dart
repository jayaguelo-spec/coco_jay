import '../models/health_record.dart';

/// Which async screen state the dashboard preview should show.
///
/// The real REST API will replace this once the instructor approves the
/// backend; the scenarios let the group demo loading, success, empty, and
/// error without a server.
enum DashboardScenario { success, empty, error }

/// Failure surfaced by [DashboardService]; carries a user-facing message.
class DashboardException implements Exception {
  const DashboardException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Placeholder data source for the dashboard records.
///
/// Simulates network latency so the UI can render its loading state. No HTTP
/// request is performed yet.
class DashboardService {
  const DashboardService({this.latency = const Duration(milliseconds: 1200)});

  final Duration latency;

  Future<List<HealthRecord>> fetchRecords({
    DashboardScenario scenario = DashboardScenario.success,
  }) async {
    await Future<void>.delayed(latency);

    switch (scenario) {
      case DashboardScenario.success:
        return const [
          HealthRecord(
            id: 1,
            title: 'Prenatal check-up',
            date: 'Oct 18, 2026',
            note: 'BP 118/76, weight gain on track.',
          ),
          HealthRecord(
            id: 2,
            title: 'Iron supplement refill',
            date: 'Oct 21, 2026',
            note: 'Next refill due in two weeks.',
          ),
        ];
      case DashboardScenario.empty:
        return const [];
      case DashboardScenario.error:
        throw const DashboardException(
          'Could not reach the records service. Check your connection and try again.',
        );
    }
  }
}
