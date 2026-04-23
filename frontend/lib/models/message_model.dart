class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String messageType;
  final bool isRead;
  final DateTime createdAt;
  final User? sender;
  final User? receiver;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.messageType,
    required this.isRead,
    required this.createdAt,
    this.sender,
    this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      messageType: json['messageType'] ?? 'text',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      sender: json['senderId'] != null && json['senderId'] is Map
          ? User.fromJson(json['senderId'])
          : null,
      receiver: json['receiverId'] != null && json['receiverId'] is Map
          ? User.fromJson(json['receiverId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'messageType': messageType,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'senderId': sender?.toJson(),
      'receiverId': receiver?.toJson(),
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    String? messageType,
    bool? isRead,
    DateTime? createdAt,
    User? sender,
    User? receiver,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
    );
  }

  // Helper method to check if message is from current user
  bool isFromCurrentUser(String currentUserId) {
    return senderId == currentUserId;
  }

  // Helper method to get display name for the other user
  String getOtherUserDisplayName(String currentUserId) {
    if (isFromCurrentUser(currentUserId)) {
      return receiver?.username ?? 'Unknown';
    } else {
      return sender?.username ?? 'Unknown';
    }
  }
}

// Import User model for references
class User {
  final String id;
  final String username;
  final String? profilePicture;

  User({
    required this.id,
    required this.username,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'profilePicture': profilePicture,
    };
  }
}