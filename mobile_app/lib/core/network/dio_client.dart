import 'package:dio/dio.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/errors/exceptions.dart';
import 'package:mobile_app/core/security/secure_storage.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          final statusCode = e.response?.statusCode;
          String message = 'Ocurrió un error inesperado';
          String? errorCode;

          if (e.response?.data != null && e.response?.data is Map) {
            final data = e.response?.data as Map<String, dynamic>;
            if (data.containsKey('detail')) {
              message = data['detail'].toString();
            } else if (data.containsKey('error')) {
              final errMap = data['error'];
              if (errMap is Map) {
                message = errMap['message']?.toString() ?? message;
                errorCode = errMap['code']?.toString();
              } else {
                message = errMap.toString();
              }
            }
          } else {
            switch (e.type) {
              case DioExceptionType.connectionTimeout:
              case DioExceptionType.sendTimeout:
              case DioExceptionType.receiveTimeout:
                message = 'Tiempo de espera agotado. Verifique su conexión.';
                break;
              case DioExceptionType.connectionError:
                message = 'No se pudo conectar con el servidor BarboYa.';
                break;
              default:
                message = e.message ?? message;
            }
          }

          if (statusCode == 401) {
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: UnauthorizedException(message),
                response: e.response,
                type: e.type,
              ),
            );
          }

          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: ApiException(
                message: message,
                statusCode: statusCode,
                errorCode: errorCode,
              ),
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    );
  }
}
