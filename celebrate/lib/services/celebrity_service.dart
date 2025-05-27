import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/celebrity.dart';
import '../utils/constants.dart';

class CelebrityService {
  static const String baseUrl = ApiConstants.baseUrl;

  // Create a new celebrity profile
  Future<Celebrity> createCelebrity(Celebrity celebrity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/celebrities'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(celebrity.toJson()),
      );

      if (response.statusCode == 201) {
        return Celebrity.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to create celebrity profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create celebrity profile: $e');
    }
  }

  // Update an existing celebrity profile
  Future<Celebrity> updateCelebrity(int id, Celebrity celebrity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/celebrities/$id'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(celebrity.toJson()),
      );

      if (response.statusCode == 200) {
        return Celebrity.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to update celebrity profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update celebrity profile: $e');
    }
  }

  // Get celebrity profile by ID
  Future<Celebrity> getCelebrity(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/celebrities/$id'),
        headers: {
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Celebrity.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get celebrity profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get celebrity profile: $e');
    }
  }

  // Upload celebrity profile image
  Future<String> uploadProfileImage(int celebrityId, String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/celebrities/$celebrityId/image'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
      ));

      // Add authorization header if needed
      // request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = jsonDecode(responseData);
        return data['imageUrl'];
      } else {
        throw Exception(
            'Failed to upload profile image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }
}
