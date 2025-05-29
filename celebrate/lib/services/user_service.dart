import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../utils/constants.dart';
import 'package:celebrate/AuthService.dart';

class UserService {
  static const String baseUrl = ApiConstants.baseUrl;

  // Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  // Update user profile
  Future<User> updateProfile({
    String? fullName,
    String? location,
    String? bio,
    bool? isPrivate,
  }) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (fullName != null) 'fullName': fullName,
          if (location != null) 'location': location,
          if (bio != null) 'bio': bio,
          if (isPrivate != null) 'isPrivate': isPrivate,
        }),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Upload profile image
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final token = await AuthService.getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/users/me/profile-image'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['imageUrl'];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get user's posts
  Future<List<UserPost>> getUserPosts() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/users/me/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserPost.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user posts: $e');
    }
  }

  // Search users
  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  // Follow user
  Future<bool> followUser(int userId) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/$userId/follow'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to follow user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to follow user: $e');
    }
  }

  // Unfollow user
  Future<bool> unfollowUser(int userId) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.delete(
        Uri.parse('$baseUrl/api/users/$userId/follow'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to unfollow user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to unfollow user: $e');
    }
  }

  // Get user's followers
  Future<List<User>> getFollowers(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId/followers'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get followers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get followers: $e');
    }
  }

  // Get user's following
  Future<List<User>> getFollowing(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId/following'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get following: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get following: $e');
    }
  }
}
