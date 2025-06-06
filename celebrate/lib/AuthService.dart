import 'dart:convert';
import 'dart:html' if (dart.library.html) 'dart:html' show window;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb, ChangeNotifier;
import 'config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
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

  static String get baseUrl => ApiConfig.baseUrl;
  static String get origin =>
      kIsWeb ? window.location.origin : 'app://celebrate';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

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
            // For OPTIONS request, we'll use a custom request
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
      String username, String email, String password) async {
    try {
      print('Starting registration process...'); // Debug log
      print('Attempting registration for user: $username'); // Debug log
      print('Using base URL: $baseUrl'); // Debug log
      print('Origin: $origin'); // Debug log

      // First make an OPTIONS request to check CORS
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

      print(
          'OPTIONS response status: ${optionsStreamedResponse.statusCode}'); // Debug log
      print(
          'OPTIONS response headers: ${optionsStreamedResponse.headers}'); // Debug log
      print('OPTIONS response body: $optionsResponseBody'); // Debug log

      if (optionsStreamedResponse.statusCode != 200) {
        print('OPTIONS request failed: $optionsResponseBody'); // Debug log
        return {
          'success': false,
          'message':
              'Request failed with status ${optionsStreamedResponse.statusCode}',
          'details': optionsResponseBody
        };
      }

      // Make the actual POST request
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
      print('Starting login process...'); // Debug log
      print('Attempting login for user: $username'); // Debug log
      print('Using base URL: $baseUrl'); // Debug log
      print('Origin: $origin'); // Debug log

      // First make an OPTIONS request to check CORS
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

      print(
          'OPTIONS response status: ${optionsStreamedResponse.statusCode}'); // Debug log
      print(
          'OPTIONS response headers: ${optionsStreamedResponse.headers}'); // Debug log
      print('OPTIONS response body: $optionsResponseBody'); // Debug log

      if (optionsStreamedResponse.statusCode != 200) {
        print('OPTIONS request failed: $optionsResponseBody'); // Debug log
        return {
          'success': false,
          'message':
              'Request failed with status ${optionsStreamedResponse.statusCode}',
          'details': optionsResponseBody
        };
      }

      // Make the actual POST request
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

      print('Login response status: ${response.statusCode}'); // Debug log
      print('Login response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _saveToken(data['token']);
        }
        return {'success': true, 'message': 'Login successful', 'data': data};
      } else {
        Map<String, dynamic> error;
        try {
          error = jsonDecode(response.body);
          print('Login error response: $error'); // Debug log
        } catch (e) {
          print('Error parsing login response: $e'); // Debug log
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
      print('Login error: $e'); // Debug log
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

  // Helper method to get auth headers
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
      'Origin': origin,
    };
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Origin': origin,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'User data retrieved successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to get user data',
          'details': response.body
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error getting user data',
        'details': e.toString()
      };
    }
  }
}
