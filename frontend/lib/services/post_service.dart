import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import 'auth_service.dart';

class PostService {
  static const String baseUrl = 'http://localhost:5000/api/posts';

  // Create Post
  static Future<Map<String, dynamic>> createPost({
    required String content,
    String? image,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthService.tokenKey);

      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'content': content,
          'image': image,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'post': Post.fromJson(data['post']),
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create post',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get Feed
  static Future<Map<String, dynamic>> getFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/feed?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final posts = (data['posts'] as List)
            .map((p) => Post.fromJson(p))
            .toList();
        return {
          'success': true,
          'posts': posts,
          'pagination': data['pagination'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch feed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get User Posts
  static Future<Map<String, dynamic>> getUserPosts(
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final posts = (data['posts'] as List)
            .map((p) => Post.fromJson(p))
            .toList();
        return {
          'success': true,
          'posts': posts,
          'pagination': data['pagination'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch posts',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get Single Post
  static Future<Map<String, dynamic>> getPost(String postId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$postId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'post': Post.fromJson(data['post']),
        };
      } else {
        return {
          'success': false,
          'message': 'Post not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Update Post
  static Future<Map<String, dynamic>> updatePost({
    required String postId,
    String? content,
    String? image,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthService.tokenKey);

      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final body = {};
      if (content != null) body['content'] = content;
      if (image != null) body['image'] = image;

      final response = await http.put(
        Uri.parse('$baseUrl/$postId/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'post': Post.fromJson(data['post']),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update post',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Delete Post
  static Future<Map<String, dynamic>> deletePost(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthService.tokenKey);

      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/$postId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete post',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Like Post
  static Future<Map<String, dynamic>> likePost(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthService.tokenKey);

      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$postId/like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'post': Post.fromJson(data['post']),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to like post',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Add Comment
  static Future<Map<String, dynamic>> addComment({
    required String postId,
    required String text,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthService.tokenKey);

      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$postId/comment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'post': Post.fromJson(data['post']),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to add comment',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Delete Comment
  static Future<Map<String, dynamic>> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthService.tokenKey);

      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/$postId/comment/$commentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'post': Post.fromJson(data['post']),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete comment',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
