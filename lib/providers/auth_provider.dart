import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  String? _token;
  String? _userRole;
  bool _isActive = false;
  bool _isLoading = true;

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String get userRole => _userRole ?? 'user'; // Default to 'user' if null
  bool get isActive => _isActive;
  
  // Check if user is admin
  bool get isAdmin => userRole == 'admin';

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'auth_token');
    _userRole = await _storage.read(key: 'user_role');
    
    // Convert string to bool
    final isActiveStr = await _storage.read(key: 'user_is_active');
    _isActive = isActiveStr == '1' || isActiveStr == 'true';
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String token, {String? role, bool isActive = true}) async {
    _token = token;
    _userRole = role ?? 'user';
    _isActive = isActive;
    
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_role', value: _userRole);
    await _storage.write(key: 'user_is_active', value: isActive ? '1' : '0');
    
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userRole = null;
    _isActive = false;
    
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_role');
    await _storage.delete(key: 'user_is_active');
    
    notifyListeners();
  }
}