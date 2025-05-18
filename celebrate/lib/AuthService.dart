import 'dart:convert';
import 'dart:html' if (dart.library.html) 'dart:html' show window;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'config/api_config.dart';

class AuthService {
  static String get baseUrl => ApiConfig.baseUrl;
  static String get origin =>
      kIsWeb ? window.location.origin : 'app://celebrate';

  static const String tokenKey = 'auth_token';

  // Store the token in SharedPreferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Get the stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Clear the stored token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  static Future<Map<String, dynamic>> registerUser(
      String username, String email, String password) async {
    try {
      print('Attempting registration for user: $username'); // Debug log
      print('Using base URL: $baseUrl'); // Debug log

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': origin,
          'Access-Control-Request-Method': 'POST',
          'Access-Control-Request-Headers': 'content-type,accept,origin',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      print(
          'Registration response status: ${response.statusCode}'); // Debug log
      print('Registration response body: ${response.body}'); // Debug log

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _saveToken(data['token']);
        }
        return {
          'success': true,
          'message': 'Registration successful',
          'data': data
        };
      } else {
        Map<String, dynamic> error;
        try {
          error = jsonDecode(response.body);
          print('Registration error response: $error'); // Debug log
        } catch (e) {
          print('Error parsing registration response: $e'); // Debug log
          error = {
            'message':
                'Registration failed: Server returned ${response.statusCode}',
            'details': response.body
          };
        }
        return {
          'success': false,
          'message':
              error['message'] ?? 'Registration failed: ${response.statusCode}',
          'details': error['details'] ?? response.body
        };
      }
    } catch (e) {
      print('Registration error: $e'); // Debug log
      return {
        'success': false,
        'message':
            'Network error occurred. Please check your connection and try again.',
        'details': e.toString()
      };
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    try {
      print('Attempting login for user: $username'); // Debug log
      print('Using base URL: $baseUrl'); // Debug log

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': kIsWeb ? 'http://localhost:56789' : 'app://celebrate',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}'); // Debug log
      print('Login response body: ${response.body}'); // Debug log

      if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Access denied',
          'details': 'Please check your credentials and try again'
        };
      }

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response',
          'details': 'Status code: ${response.statusCode}'
        };
      }

      Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        print('Error parsing response body: $e'); // Debug log
        print('Raw response body: ${response.body}'); // Debug log
        return {
          'success': false,
          'message': 'Failed to parse server response',
          'details': 'Raw response: ${response.body}'
        };
      }

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (responseData['token'] != null) {
          await _saveToken(responseData['token']);
          return {
            'success': true,
            'message': responseData['message'] ?? 'Login successful',
            'user': responseData['user']
          };
        } else {
          return {
            'success': false,
            'message': 'Invalid server response',
            'details': 'Token missing from response'
          };
        }
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
          'details': responseData['details'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      print('Login error: $e'); // Debug log
      return {
        'success': false,
        'message': 'Network error occurred',
        'details': e.toString()
      };
    }
  }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  static Future<void> logout() async {
    await clearToken();
  }

  // Helper method to get auth headers
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
      'Origin': kIsWeb ? 'http://localhost:56789' : 'app://celebrate',
    };
  }
}
