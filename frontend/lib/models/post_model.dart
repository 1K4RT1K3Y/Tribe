class Comment {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final userIdData = json['userId'];
    final userName = userIdData is Map ? (userIdData['name'] as String? ?? 'Unknown') : 'Unknown';

    return Comment(
      id: json['_id'],
      userId: userIdData is Map ? (userIdData['_id'] ?? userIdData['id'] ?? '') : (userIdData as String? ?? ''),
      userName: userName,
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Post {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final String? image;
  final List<String> likes;
  final List<Comment> comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    this.image,
    this.likes = const [],
    this.comments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  int get likesCount => likes.length;
  int get commentsCount => comments.length;

  factory Post.fromJson(Map<String, dynamic> json) {
    final userIdData = json['userId'];
    final userId = userIdData is Map ? userIdData['_id'] ?? userIdData['id'] ?? '' : (userIdData as String? ?? '');
    final userName = userIdData is Map ? (userIdData['name'] as String? ?? 'Unknown') : 'Unknown';

    // Safely extract likes - handle both string IDs and objects
    List<String> likes = [];
    if (json['likes'] is List) {
      likes = (json['likes'] as List)
          .map((like) {
            if (like is String) return like;
            if (like is Map) return (like['_id'] ?? like['id'] ?? '') as String;
            return '';
          })
          .where((id) => id.isNotEmpty)
          .cast<String>()
          .toList();
    }

    return Post(
      id: json['_id'],
      userId: userId,
      userName: userName,
      content: json['content'] as String? ?? '',
      image: json['image'] as String?,
      likes: likes,
      comments: (json['comments'] as List?)
              ?.map((c) => Comment.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'content': content,
      'image': image,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
