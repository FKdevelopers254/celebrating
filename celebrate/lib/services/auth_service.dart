import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? _token;
  String? _role;

  String? get token => _token;
  String? get role => _role;

  // Initialize the service
  Future<void> init() async {
    _token = await storage.read(key: 'auth_token');
    _role = await storage.read(key: 'user_role');
    notifyListeners();
  }

  // Set token and role
  Future<void> setToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
    _token = token;
    notifyListeners();
  }

  Future<void> setRole(String role) async {
    await storage.write(key: 'user_role', value: role);
    _role = role;
    notifyListeners();
  }

  // Clear token and role (logout)
  static Future<void> logout() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_role');
  }

  // Get token
  static Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }
}
