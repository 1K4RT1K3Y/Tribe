import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart' as notification_model;
import 'package:tribe/services/auth_service.dart';

class NotificationService {
  static const String baseUrl = 'http://localhost:5000/api/notifications';

  // Get notifications with optional filtering
  static Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (type != null) 'type': type,
        if (isRead != null) 'isRead': isRead.toString(),
      };

      final uri = Uri.parse('$baseUrl/').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'notifications': (data['data']['notifications'] as List)
              .map((n) => notification_model.Notification.fromJson(n))
              .toList(),
          'pagination': data['data']['pagination'],
        };
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get notifications');
      }
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  // Get unread notifications count
  static Future<int> getUnreadCount() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/unread/count'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['unreadCount'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get unread count');
      }
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  // Mark notification as read
  static Future<notification_model.Notification> markAsRead(String notificationId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.put(
        Uri.parse('$baseUrl/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return notification_model.Notification.fromJson(data['data']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to mark as read');
      }
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }

  // Mark all notifications as read
  static Future<int> markAllAsRead() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.put(
        Uri.parse('$baseUrl/read/all'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['modifiedCount'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to mark all as read');
      }
    } catch (e) {
      throw Exception('Failed to mark all as read: $e');
    }
  }

  // Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/$notificationId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete notification');
      }
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  // Delete all notifications
  static Future<int> deleteAllNotifications() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/all'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['deletedCount'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete all notifications');
      }
    } catch (e) {
      throw Exception('Failed to delete all notifications: $e');
    }
  }
}