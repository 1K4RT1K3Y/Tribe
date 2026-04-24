class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String messageType;
  final bool isRead;
  final DateTime createdAt;
  final MessageUser? sender;
  final MessageUser? receiver;

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
    // Extract senderId - handle both string and object formats
    final senderIdData = json['senderId'];
    final senderId = senderIdData is Map ? (senderIdData['_id'] ?? senderIdData['id'] ?? '') : (senderIdData as String? ?? '');
    
    // Extract receiverId - handle both string and object formats
    final receiverIdData = json['receiverId'];
    final receiverId = receiverIdData is Map ? (receiverIdData['_id'] ?? receiverIdData['id'] ?? '') : (receiverIdData as String? ?? '');

    return Message(
      id: json['_id'] ?? json['id'] as String? ?? '',
      senderId: senderId,
      receiverId: receiverId,
      content: json['content'] as String? ?? '',
      messageType: json['messageType'] as String? ?? 'text',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      sender: senderIdData is Map ? MessageUser.fromJson(senderIdData) : null,
      receiver: receiverIdData is Map ? MessageUser.fromJson(receiverIdData) : null,
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
      'sender': sender?.toJson(),
      'receiver': receiver?.toJson(),
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
    MessageUser? sender,
    MessageUser? receiver,
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
class MessageUser {
  final String id;
  final String username;
  final String? profilePicture;

  MessageUser({
    required this.id,
    required this.username,
    this.profilePicture,
  });

  factory MessageUser.fromJson(Map<String, dynamic> json) {
    return MessageUser(
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