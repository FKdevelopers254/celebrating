import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> registerUser(
    String username,
    String email,
    String password, {
    String role = 'USER', // Default to USER if not provided
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        }),
      );
      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        return {
          'success': false,
          'message': 'Registration failed',
          'details': jsonDecode(response.body)['message'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}