// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends ApiService {
  final _storage = const FlutterSecureStorage();

  AuthService({GlobalKey<NavigatorState>? navigatorKey}) 
    : super(dotenv.env['API_URL'] ?? 'http://10.0.2.2:8888/api', navigatorKey: navigatorKey);


  Future<Map<String, dynamic>> register( String name, String email, String password, String passwordConfirmation) async {
    final response = await request(
      method: 'POST',
      endpoint: '/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      handleAuth: false, // Don't handle auth here since it's registration
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // You can decide what to do after successful registration (e.g., auto-login, navigate to login screen, etc.)
      return data;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // Login a user
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await request(
      method: 'POST',
      endpoint: '/login',
      body: {
        'email': email,
        'password': password,
      },
      handleAuth: false, // Don't handle 401 for login requests
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'auth_token', value: data['access_token']);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // Logout the user
  Future<bool> logout() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return true;
    
    final response = await request(
      method: 'POST',
      endpoint: '/logout',
      handleAuth: false, // Don't handle 401 for logout
    );
    
    await _storage.delete(key: 'auth_token');
    return response.statusCode == 200 || response.statusCode == 401;
  }

  // Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await request(
      method: 'GET',
      endpoint: '/user',
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user data');
    }
  }
  
  // Check if user is authenticated with valid token
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return false;
    
    try {
      final response = await request(
        method: 'GET',
        endpoint: '/user',
        handleAuth: false, // Handle auth manually here
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}