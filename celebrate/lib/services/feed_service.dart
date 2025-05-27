import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feed_post.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class FeedService {
  static const String baseUrl = ApiConstants.baseUrl;
  final AuthService _authService = AuthService();

  // Fetch feed posts by category
  Future<List<FeedPost>> getFeedPosts(String category) async {
    try {
      final token = await _authService.storage.read(key: 'auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/api/feed?category=$category'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FeedPost.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load feed posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load feed posts: $e');
    }
  }

  // Like a post
  Future<void> likePost(int postId) async {
    try {
      final token = await _authService.storage.read(key: 'auth_token');

      final response = await http.post(
        Uri.parse('$baseUrl/api/feed/$postId/like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to like post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  // Add comment to a post
  Future<void> addComment(int postId, String comment) async {
    try {
      final token = await _authService.storage.read(key: 'auth_token');

      final response = await http.post(
        Uri.parse('$baseUrl/api/feed/$postId/comment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'content': comment}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }
}
