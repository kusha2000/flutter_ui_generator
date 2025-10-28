class ApiConfig {
  // CHANGE THIS TO YOUR BACKEND IP ADDRESS
  static const String BASE_URL = 'http://10.242.41.80:8000';

  // API Endpoints
  static const String GENERATE_UI = '$BASE_URL/generate-ui';
  static const String GENERATE_UI_STREAM = '$BASE_URL/generate-ui-stream';
  static const String HEALTH_CHECK = '$BASE_URL/health';
  static const String MODELS = '$BASE_URL/models';

  // Timeout duration
  static const Duration REQUEST_TIMEOUT = Duration(seconds: 120);
}
