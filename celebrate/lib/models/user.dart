class User {
  final int id;
  final String username;
  final String fullName;
  final String? location;
  final String? bio;
  final String? profileImage;
  final bool isPrivate;
  final int postsCount;
  final int friendsCount;
  final int followingCount;
  final List<UserPost> posts;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    this.location,
    this.bio,
    this.profileImage,
    required this.isPrivate,
    required this.postsCount,
    required this.friendsCount,
    required this.followingCount,
    required this.posts,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      location: json['location'],
      bio: json['bio'],
      profileImage: json['profileImage'],
      isPrivate: json['isPrivate'] ?? false,
      postsCount: json['postsCount'] ?? 0,
      friendsCount: json['friendsCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      posts: (json['posts'] as List<dynamic>?)
              ?.map((post) => UserPost.fromJson(post))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'location': location,
      'bio': bio,
      'profileImage': profileImage,
      'isPrivate': isPrivate,
      'postsCount': postsCount,
      'friendsCount': friendsCount,
      'followingCount': followingCount,
      'posts': posts.map((post) => post.toJson()).toList(),
    };
  }
}

class UserPost {
  final int id;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final DateTime createdAt;

  UserPost({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) {
    return UserPost(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
