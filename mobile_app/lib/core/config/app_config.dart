class AppConfig {
  static const String appName = 'BarboYa';
  // Default API URL pointing to FastAPI backend (localhost or production)
  // For web/desktop/emulator flexibility:
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000/api/v1',
  );
  
  static const String wsBaseUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'ws://localhost:8000/api/v1',
  );
}
