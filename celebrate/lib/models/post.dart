class Post {
  final int? id;
  final String content;
  final List<String> hashtags;
  final List<String> mentions;
  final String? imageUrl;
  final String authorName;
  final String? authorProfileImage;
  final DateTime? createdAt;
  final int likes;
  final int comments;
  final bool isPrivate;

  Post({
    this.id,
    required this.content,
    this.hashtags = const [],
    this.mentions = const [],
    this.imageUrl,
    required this.authorName,
    this.authorProfileImage,
    this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isPrivate = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      mentions: List<String>.from(json['mentions'] ?? []),
      imageUrl: json['imageUrl'],
      authorName: json['authorName'],
      authorProfileImage: json['authorProfileImage'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      isPrivate: json['isPrivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'content': content,
      'hashtags': hashtags,
      'mentions': mentions,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'authorName': authorName,
      if (authorProfileImage != null) 'authorProfileImage': authorProfileImage,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'isPrivate': isPrivate,
    };
  }
}
