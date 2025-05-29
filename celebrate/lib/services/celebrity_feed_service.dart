import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/celebrity.dart';
import '../utils/constants.dart';
import 'package:celebrate/AuthService.dart';

class CelebrityFeedService {
  static const String baseUrl = ApiConstants.baseUrl;

  // Fetch all celebrities
  Future<List<Celebrity>> getAllCelebrities() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/celebrities'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Celebrity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load celebrities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load celebrities: $e');
    }
  }

  // Fetch celebrity by ID
  Future<Celebrity> getCelebrityById(int id) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/celebrities/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Celebrity.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load celebrity: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load celebrity: $e');
    }
  }

  // Search celebrities
  Future<List<Celebrity>> searchCelebrities(String query) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/celebrities/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Celebrity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search celebrities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search celebrities: $e');
    }
  }
}
