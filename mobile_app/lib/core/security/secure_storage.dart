import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _secureStorage = FlutterSecureStorage();
  
  static const String _keyAccessToken = 'access_token';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserId = 'user_id';

  static Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _keyAccessToken, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _keyAccessToken);
  }

  static Future<void> saveUserRole(String role) async {
    await _secureStorage.write(key: _keyUserRole, value: role);
  }

  static Future<String?> getUserRole() async {
    return await _secureStorage.read(key: _keyUserRole);
  }

  static Future<void> saveUserId(String id) async {
    await _secureStorage.write(key: _keyUserId, value: id);
  }

  static Future<String?> getUserId() async {
    return await _secureStorage.read(key: _keyUserId);
  }

  static Future<void> clearSession() async {
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyUserRole);
    await _secureStorage.delete(key: _keyUserId);
  }
}
