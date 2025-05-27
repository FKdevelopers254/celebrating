import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum UserRole {
  celebrity,
  regularUser,
}

class AuthService {
  final storage = const FlutterSecureStorage();
  static const String baseUrl = ApiConstants.baseUrl;

  // Register a new user
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required bool isCelebrity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'fullName': fullName,
          'username': username,
          'role': isCelebrity ? 'CELEBRITY' : 'USER',
        }),
      );

      if (response.statusCode != 201) {
        final error =
            jsonDecode(response.body)['message'] ?? 'Registration failed';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Login user
  Future<UserRole?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final role = data['role'];

        // Store the token and user info
        await storage.write(key: 'auth_token', value: token);
        await storage.write(key: 'user_role', value: role);
        await storage.write(key: 'user_email', value: email);

        // Return the user role
        return role == 'CELEBRITY' ? UserRole.celebrity : UserRole.regularUser;
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Login failed';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserRole?> getCurrentUserRole() async {
    try {
      final role = await storage.read(key: 'user_role');
      if (role == null) return null;
      return role == 'CELEBRITY' ? UserRole.celebrity : UserRole.regularUser;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await storage.deleteAll(); // Clear all stored data
  }
}
