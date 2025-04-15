// api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class ApiService {
  final String baseUrl;
  final _storage = const FlutterSecureStorage();
  final GlobalKey<NavigatorState>? navigatorKey;
  
  ApiService(this.baseUrl, {this.navigatorKey});
  
  // Get headers with authorization if token exists
  Future<Map<String, String>> getHeaders({String? token}) async {
    token ??= await _storage.read(key: 'auth_token');
    
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  // Generic request method for all HTTP methods
  Future<http.Response> request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    bool handleAuth = true,
  }) async {
    final String url = '$baseUrl$endpoint';
    final headers = await getHeaders();
    http.Response response;
    
    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(Uri.parse(url), headers: headers);
          break;
        case 'POST':
          response = await http.post(
            Uri.parse(url), 
            headers: headers, 
            body: body != null ? jsonEncode(body) : null
          );
          break;
        case 'PUT':
          response = await http.put(
            Uri.parse(url), 
            headers: headers, 
            body: body != null ? jsonEncode(body) : null
          );
          break;
        case 'DELETE':
          response = await http.delete(Uri.parse(url), headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
      
      // Handle token expiration (401 Unauthorized)
      if (response.statusCode == 401 && handleAuth) {
        await _handleTokenExpiry();
        // After handling expiry, you could retry the request if needed
      }
      
      return response;
    } catch (e) {
      // Handle connection errors
      rethrow;
    }
  }
  
  // Handle token expiration
  Future<void> _handleTokenExpiry() async {
    // Clear token from storage
    await _storage.delete(key: 'auth_token');
    
    // Navigate to login screen if navigatorKey is provided
    if (navigatorKey?.currentState != null) {
      navigatorKey!.currentState!.pushNamedAndRemoveUntil(
        '/login', // Use your login route name
        (route) => false,
      );
    }
    // You could also use an event bus or similar to notify the app
    // EventBus().fire(SessionExpiredEvent());
  }
}