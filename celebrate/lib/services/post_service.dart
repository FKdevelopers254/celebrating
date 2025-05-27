import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/post.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class PostService {
  static const String baseUrl = ApiConstants.baseUrl;
  final AuthService _authService = AuthService();
  WebSocketChannel? _channel;

  // Create a new post
  Future<Post> createPost({
    required String content,
    List<String> hashtags = const [],
    List<String> mentions = const [],
    String? imagePath,
    bool isPrivate = false,
  }) async {
    try {
      final token = await _authService.storage.read(key: 'auth_token');

      // If there's an image, upload it first
      String? imageUrl;
      if (imagePath != null) {
        imageUrl = await _uploadImage(imagePath, token!);
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'content': content,
          'hashtags': hashtags,
          'mentions': mentions,
          if (imageUrl != null) 'imageUrl': imageUrl,
          'isPrivate': isPrivate,
        }),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Upload image for a post
  Future<String> _uploadImage(String imagePath, String token) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/posts/upload-image'),
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

  // Connect to WebSocket for real-time updates
  void connectToWebSocket(Function(Post) onPostReceived) async {
    final token = await _authService.storage.read(key: 'auth_token');
    final wsUrl = baseUrl.replaceFirst('http', 'ws');

    _channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl/ws/posts?token=$token'),
    );

    _channel!.stream.listen(
      (message) {
        final post = Post.fromJson(jsonDecode(message));
        onPostReceived(post);
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onPostReceived);
        });
      },
      onDone: () {
        print('WebSocket connection closed');
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          connectToWebSocket(onPostReceived);
        });
      },
    );
  }

  // Disconnect from WebSocket
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  // Get posts by hashtag
  Future<List<Post>> getPostsByHashtag(String hashtag) async {
    try {
      final token = await _authService.storage.read(key: 'auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/api/posts/hashtag/$hashtag'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  // Get recent posts
  Future<List<Post>> getRecentPosts() async {
    try {
      final token = await _authService.storage.read(key: 'auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/api/posts/recent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get recent posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get recent posts: $e');
    }
  }
}
