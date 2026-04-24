import 'package:flutter/foundation.dart';
import 'package:tribe/models/user_model.dart';
import 'package:tribe/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.login(email: email, password: password);
      if (result['success']) {
        _user = result['user'];
      }
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<Map<String, dynamic>> register(String name, String email, String password, String confirmPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      if (result['success']) {
        _user = result['user'];
      }
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get current user
  Future<void> getCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.getCurrentUser();
      if (result['success']) {
        _user = result['user'];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }

  // Check if logged in on app start
  Future<void> checkLoginStatus() async {
    if (await AuthService.getToken() != null) {
      await getCurrentUser();
    }
  }
}