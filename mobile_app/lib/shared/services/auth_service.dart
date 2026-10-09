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
        'email': email.trim(),
        'password': password,
      },
    );
    final data = response.data;
    final accessToken = data['access_token'] as String;
    await SecureStorage.saveAccessToken(accessToken);

    return await getMe();
  }

  Future<UserRead> register({
    required String email,
    required String password,
    required String nombre,
    required String telefono,
    required String rol,
  }) async {
    final response = await _dioClient.dio.post(
      '/auth/register',
      data: {
        'email': email.trim(),
        'password': password,
        'nombre': nombre.trim(),
        'telefono': telefono.trim(),
        'rol': rol.toUpperCase(),
      },
    );
    return UserRead.fromJson(response.data);
  }

  Future<UserRead> getMe() async {
    final response = await _dioClient.dio.get('/users/me');
    final user = UserRead.fromJson(response.data);
    await SecureStorage.saveUserId(user.id);
    await SecureStorage.saveUserRole(user.rol);
    await SecureStorage.saveUserDetails(email: user.email, name: user.nombre);
    return user;
  }

  Future<UserRead> updateMe({String? nombre, String? telefono}) async {
    final payload = <String, dynamic>{};
    if (nombre != null && nombre.isNotEmpty) payload['nombre'] = nombre;
    if (telefono != null && telefono.isNotEmpty) payload['telefono'] = telefono;

    final response = await _dioClient.dio.patch('/users/me', data: payload);
    final user = UserRead.fromJson(response.data);
    await SecureStorage.saveUserDetails(email: user.email, name: user.nombre);
    return user;
  }

  Future<void> forgotPassword(String email) async {
    await _dioClient.dio.post(
      '/auth/forgot-password',
      data: {'email': email.trim()},
    );
  }

  Future<void> resetPassword({required String token, required String newPassword}) async {
    await _dioClient.dio.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'new_password': newPassword,
      },
    );
  }

  Future<void> logout() async {
    try {
      await _dioClient.dio.post('/auth/logout');
    } catch (_) {}
    await SecureStorage.clearSession();
  }
}
