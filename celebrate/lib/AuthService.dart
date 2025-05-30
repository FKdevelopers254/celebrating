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
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  static const String tokenKey = 'auth_token';

  static Future<void> _saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(tokenKey, token);
    } else {
      await prefs.remove(tokenKey);
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  static Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  ) async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        print(
            'Attempting $method request to $endpoint (attempt ${retryCount + 1})');

        final uri = Uri.parse('$baseUrl$endpoint');
        final requestHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': origin,
          if (method != 'OPTIONS') 'Access-Control-Request-Method': method,
          if (method != 'OPTIONS')
            'Access-Control-Request-Headers':
                'content-type,accept,origin,authorization',
          ...?headers,
        };

        http.Response response;
        switch (method.toUpperCase()) {
          case 'GET':
            response = await http.get(uri, headers: requestHeaders);
            break;
          case 'POST':
            response = await http.post(
              uri,
              headers: requestHeaders,
              body: body != null ? jsonEncode(body) : null,
            );
            break;
          case 'PUT':
            response = await http.put(
              uri,
              headers: requestHeaders,
              body: body != null ? jsonEncode(body) : null,
            );
            break;
          case 'DELETE':
            response = await http.delete(uri, headers: requestHeaders);
            break;
          case 'OPTIONS':
            final request = http.Request('OPTIONS', uri);
            request.headers.addAll(requestHeaders);
            final streamedResponse = await request.send();
            response = await http.Response.fromStream(streamedResponse);
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        print('Response status: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return {
            'success': true,
            'data': jsonDecode(response.body),
            'message': 'Request successful'
          };
        } else {
          return {
            'success': false,
            'message': 'Request failed with status ${response.statusCode}',
            'details': response.body
          };
        }
      } catch (e) {
        print('Request error (attempt ${retryCount + 1}): $e');
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(retryDelay);
        } else {
          return {
            'success': false,
            'message': 'Network error occurred after $maxRetries attempts',
            'details': e.toString()
          };
        }
      }
    }
    return {
      'success': false,
      'message': 'Maximum retry attempts reached',
      'details': 'Failed after $maxRetries attempts'
    };
  }

  static Future<Map<String, dynamic>> registerUser(
      String username, String email, String password,
      {String role = "USER"}) async {
    try {
      print('Starting registration process...');
      print('Attempting registration for user: $username');
      print('Using base URL: $baseUrl');
      print('Origin: $origin');

      final optionsResponse =
          await http.Request('OPTIONS', Uri.parse('$baseUrl/api/auth/register'))
            ..headers.addAll({
              'Origin': origin,
              'Access-Control-Request-Method': 'POST',
              'Access-Control-Request-Headers': 'content-type,accept,origin',
            });
      final optionsStreamedResponse = await optionsResponse.send();
      final optionsResponseBody =
          await optionsStreamedResponse.stream.bytesToString();

      print('OPTIONS response status: ${optionsStreamedResponse.statusCode}');
      print('OPTIONS response headers: ${optionsStreamedResponse.headers}');
      print('OPTIONS response body: $optionsResponseBody');

      if (optionsStreamedResponse.statusCode != 200) {
        print('OPTIONS request failed: $optionsResponseBody');
        return {
          'success': false,
          'message':
              'Request failed with status ${optionsStreamedResponse.statusCode}',
          'details': optionsResponseBody
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': origin,
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return {
          'success': true,
          'message': 'Registration successful',
          'data': data
        };
      } else {
        Map<String, dynamic> error;
        try {
          error = jsonDecode(response.body);
          print('Registration error response: $error');
        } catch (e) {
          print('Error parsing registration response: $e');
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
      print('Registration error: $e');
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
      print('Starting login process...');
      print('Attempting login for user: $username');
      print('Using base URL: $baseUrl');
      print('Origin: $origin');

      final optionsResponse =
          await http.Request('OPTIONS', Uri.parse('$baseUrl/api/auth/login'))
            ..headers.addAll({
              'Origin': origin,
              'Access-Control-Request-Method': 'POST',
              'Access-Control-Request-Headers': 'content-type,accept,origin',
            });
      final optionsStreamedResponse = await optionsResponse.send();
      final optionsResponseBody =
          await optionsStreamedResponse.stream.bytesToString();

      print('OPTIONS response status: ${optionsStreamedResponse.statusCode}');
      print('OPTIONS response headers: ${optionsStreamedResponse.headers}');
      print('OPTIONS response body: $optionsResponseBody');

      if (optionsStreamedResponse.statusCode != 200) {
        print('OPTIONS request failed: $optionsResponseBody');
        return {
          'success': false,
          'message':
              'Request failed with status ${optionsStreamedResponse.statusCode}',
          'details': optionsResponseBody
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': origin,
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return {
          'success': true,
          'message': 'Login successful',
          'data': {
            'token': data['token'],
            'role': data['role'],
          }
        };
      } else {
        Map<String, dynamic> error;
        try {
          error = jsonDecode(response.body);
          print('Login error response: $error');
        } catch (e) {
          print('Error parsing login response: $e');
          error = {
            'message': 'Login failed: Server returned ${response.statusCode}',
            'details': response.body
          };
        }
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed: ${response.statusCode}',
          'details': error['details'] ?? response.body
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message':
            'Network error occurred. Please check your connection and try again.',
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

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
      'Origin': origin,
    };
  }

  static const String ROLE_CELEBRITY = 'CELEBRITY';
  static const String ROLE_USER = 'USER';
}