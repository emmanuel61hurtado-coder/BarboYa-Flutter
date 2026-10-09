class AppConfig {
  static const String appName = 'BarboYa';
  
  // URL base apuntando al backend real FastAPI (puerto 8010 en run.py)
  // Soporta inyección en compilación vía: --dart-define=API_URL=https://...
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8010/api/v1',
  );
  
  static const String wsBaseUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'ws://localhost:8010/api/v1/ws',
  );

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isProduction => environment.toLowerCase() == 'production';
}
