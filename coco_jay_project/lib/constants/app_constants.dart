class AppConstants {
  static const String appName = 'PRENATAL';
  static const String appTitle = 'Prenatal Care System';

  // Planned REST API base URL. Set this when the instructor approves the
  // backend. Never store API keys, tokens, or database passwords here.
  static const String apiBaseUrl = 'http://localhost:8000/api';

  static const Duration apiTimeout = Duration(seconds: 10);
}
