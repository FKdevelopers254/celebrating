class ApiConfig {
  static const String baseUrl = 'http://localhost:8080'; // API Gateway URL

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // User endpoints
  static const String userProfile = '/api/users/profile';
  static const String updateProfile = '/api/users/profile/update';
  static const String searchUsers = '/api/users/search';

  // Post endpoints
  static const String createPost = '/api/posts/create';
  static const String getFeed = '/api/posts/feed';
  static const String likePost = '/api/posts/like';
  static const String comment = '/api/posts/comment';

  // Messaging endpoints
  static const String getChats = '/api/messages/chats';
  static const String getChatMessages = '/api/messages/chat';
  static const String wsEndpoint = 'ws://localhost:8080/ws/chat';
}
