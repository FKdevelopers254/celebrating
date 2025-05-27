class FeedPost {
  final int id;
  final String authorName;
  final String authorRole;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final double rating;
  final DateTime createdAt;

  FeedPost({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.rating,
    required this.createdAt,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'],
      authorName: json['authorName'],
      authorRole: json['authorRole'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      likes: json['likes'],
      comments: json['comments'],
      rating: json['rating'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
