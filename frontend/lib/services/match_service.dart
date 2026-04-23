import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/match_model.dart';
import 'auth_service.dart';

class MatchService {
  static const String baseUrl = 'http://localhost:5000/api/matches';

  // Get suggested matches
  static Future<Map<String, dynamic>> getSuggestedUsers({
    int limit = 10,
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

      final response = await http.get(
        Uri.parse('$baseUrl/suggestions?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matches = (data['matches'] as List)
            .map((m) => Match.fromJson(m))
            .toList();
        return {
          'success': true,
          'matches': matches,
          'totalMatches': data['totalMatches'],
          'message': data['message'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch suggestions',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get matches by interest
  static Future<Map<String, dynamic>> getMatchesByInterest({
    required String interest,
    int limit = 10,
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

      final response = await http.get(
        Uri.parse('$baseUrl/by-interest?interest=$interest&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matches = (data['matches'] as List)
            .map((m) => Match.fromJson(m))
            .toList();
        return {
          'success': true,
          'matches': matches,
          'totalMatches': data['totalMatches'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch matches',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get compatibility score
  static Future<Map<String, dynamic>> getCompatibilityScore(
    String targetUserId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthService.tokenKey);

      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/compatibility/$targetUserId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'score': data['score'],
          'commonInterests': data['commonInterests'],
          'commonHobbies': data['commonHobbies'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to calculate compatibility',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get popular interests
  static Future<Map<String, dynamic>> getPopularInterests() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/interests/popular'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'interests': data['interests'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch interests',
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
