import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vibe/models/message_model.dart';
import 'package:vibe/models/user_model.dart';
import 'package:vibe/services/auth_service.dart';

class MessageService {
  static const String baseUrl = 'http://localhost:5000/api/messages';

  // Send a message
  static Future<Message> sendMessage(String receiverId, String content, {String messageType = 'text'}) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'receiverId': receiverId,
          'content': content,
          'messageType': messageType,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Message.fromJson(data['data']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to send message');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get chat history with a specific user
  static Future<Map<String, dynamic>> getChatHistory(String userId, {int page = 1, int limit = 50}) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/history/$userId?page=$page&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'messages': (data['data']['messages'] as List)
              .map((msg) => Message.fromJson(msg))
              .toList(),
          'pagination': data['data']['pagination'],
          'otherUser': User.fromJson(data['data']['otherUser']),
        };
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get chat history');
      }
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  // Get user's chat list (recent conversations)
  static Future<List<Map<String, dynamic>>> getChatList() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/chats'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get chat list');
      }
    } catch (e) {
      throw Exception('Failed to get chat list: $e');
    }
  }

  // Get unread messages count
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

  // Mark messages from a user as read
  static Future<int> markMessagesAsRead(String userId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.put(
        Uri.parse('$baseUrl/read/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['modifiedCount'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to mark messages as read');
      }
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  // Delete a message
  static Future<void> deleteMessage(String messageId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/$messageId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete message');
      }
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }
}