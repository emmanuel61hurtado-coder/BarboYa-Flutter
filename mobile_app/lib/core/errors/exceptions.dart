class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => 'ApiException: $message (Code: $statusCode, ErrorCode: $errorCode)';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Error de conexión con el servidor. Verifique su red.']);
  
  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Sesión expirada o no autorizada.']);
  
  @override
  String toString() => message;
}
