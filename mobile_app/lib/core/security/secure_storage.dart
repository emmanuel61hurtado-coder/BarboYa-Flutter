import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  
  static const String _keyAccessToken = 'access_token';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';

  static Future<void> saveAccessToken(String token) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyAccessToken, token);
      } else {
        await _secureStorage.write(key: _keyAccessToken, value: token);
      }
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAccessToken, token);
    }
  }

  static Future<String?> getAccessToken() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(_keyAccessToken);
      } else {
        return await _secureStorage.read(key: _keyAccessToken);
      }
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyAccessToken);
    }
  }

  static Future<void> saveUserRole(String role) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyUserRole, role);
      } else {
        await _secureStorage.write(key: _keyUserRole, value: role);
      }
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserRole, role);
    }
  }

  static Future<String?> getUserRole() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(_keyUserRole);
      } else {
        return await _secureStorage.read(key: _keyUserRole);
      }
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserRole);
    }
  }

  static Future<void> saveUserId(String id) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyUserId, id);
      } else {
        await _secureStorage.write(key: _keyUserId, value: id);
      }
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, id);
    }
  }

  static Future<String?> getUserId() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(_keyUserId);
      } else {
        return await _secureStorage.read(key: _keyUserId);
      }
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserId);
    }
  }

  static Future<void> saveUserDetails({required String email, required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserName, name);
  }

  static Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyUserEmail) ?? '',
      'name': prefs.getString(_keyUserName) ?? '',
    };
  }

  static Future<void> clearSession() async {
    try {
      await _secureStorage.delete(key: _keyAccessToken);
      await _secureStorage.delete(key: _keyUserRole);
      await _secureStorage.delete(key: _keyUserId);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
  }
}
