import 'package:flutter/material.dart';

class Notification {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final String? relatedId;
  final String? relatedType;
  final bool isRead;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.relatedId,
    this.relatedType,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      relatedId: json['relatedId'],
      relatedType: json['relatedType'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'relatedId': relatedId,
      'relatedType': relatedType,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? message,
    String? relatedId,
    String? relatedType,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      relatedId: relatedId ?? this.relatedId,
      relatedType: relatedType ?? this.relatedType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper method to get notification icon based on type
  IconData getIcon() {
    switch (type) {
      case 'message':
        return Icons.message;
      case 'comment':
        return Icons.comment;
      case 'like':
        return Icons.favorite;
      case 'match_suggestion':
        return Icons.people;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  // Helper method to get notification color based on type
  Color getColor() {
    switch (type) {
      case 'message':
        return Colors.blue;
      case 'comment':
        return Colors.green;
      case 'like':
        return Colors.red;
      case 'match_suggestion':
        return Colors.purple;
      case 'system':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Helper method to check if notification is recent (within last hour)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 1;
  }
}