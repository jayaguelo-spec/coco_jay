import '../constants/app_constants.dart';

/// Placeholder for the planned REST API client.
///
/// Activity 8 only initializes the Flutter Web client. No network request is
/// performed yet; the backend (instructor-approved REST API) is planned for a
/// later activity.
class ApiClient {
  const ApiClient({this.baseUrl = AppConstants.apiBaseUrl});

  final String baseUrl;

  Future<String> healthCheck() async {
    // Planned: GET $baseUrl/health once the REST API exists.
    throw UnimplementedError('REST API client is planned, not implemented yet.');
  }
}
