import 'package:dio/dio.dart';
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/core/security/secure_storage.dart';
import 'package:mobile_app/shared/models/models.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  Future<UserRead> login({required String email, required String password}) async {
    final response = await _dioClient.dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    // Backend returns {"access_token": "...", "token_type": "bearer"}
    final data = response.data;
    final accessToken = data['access_token'] as String;
    await SecureStorage.saveAccessToken(accessToken);

    // Fetch user profile
    return await getMe();
  }

  Future<UserRead> register({
    required String email,
    required String password,
    required String nombre,
    String? telefono,
    required String rol,
  }) async {
    final response = await _dioClient.dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'nombre': nombre,
        'telefono': telefono,
        'rol': rol,
      },
    );
    return UserRead.fromJson(response.data);
  }

  Future<UserRead> getMe() async {
    final response = await _dioClient.dio.get('/users/me');
    final user = UserRead.fromJson(response.data);
    await SecureStorage.saveUserId(user.id);
    await SecureStorage.saveUserRole(user.rol);
    return user;
  }

  Future<void> logout() async {
    try {
      await _dioClient.dio.post('/auth/logout');
    } catch (_) {}
    await SecureStorage.clearSession();
  }
}
