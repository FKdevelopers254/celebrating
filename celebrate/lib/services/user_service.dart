import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio);

  // Get current user's profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConfig.userProfile);
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user profile');
    }
  }

  // Update user profile
  Future<User> updateProfile({
    String? bio,
    String? profileImage,
  }) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateProfile,
        data: {
          if (bio != null) 'bio': bio,
          if (profileImage != null) 'profileImage': profileImage,
        },
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile');
    }
  }

  // Search users
  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await _dio.get(
        ApiConfig.searchUsers,
        queryParameters: {'q': query},
      );
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users');
    }
  }

  // Follow user
  Future<bool> followUser(int userId) async {
    try {
      await _dio.post('/api/users/$userId/follow');
      return true;
    } catch (e) {
      throw Exception('Failed to follow user');
    }
  }

  // Unfollow user
  Future<bool> unfollowUser(int userId) async {
    try {
      await _dio.delete('/api/users/$userId/follow');
      return true;
    } catch (e) {
      throw Exception('Failed to unfollow user');
    }
  }

  // Get user's followers
  Future<List<User>> getFollowers(int userId) async {
    try {
      final response = await _dio.get('/api/users/$userId/followers');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get followers');
    }
  }

  // Get user's following
  Future<List<User>> getFollowing(int userId) async {
    try {
      final response = await _dio.get('/api/users/$userId/following');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get following');
    }
  }
}
