import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../error/exceptions.dart';

class ApiClient {
  static const String baseUrl = "https://mallusmart.com";
  static const Duration timeoutDuration = Duration(seconds: 10);
  static const int maxRetries = 2;

  /// Performs a GET request with retry logic and timeout
  static Future<dynamic> get(String endpoint) async {
    return _executeWithRetry(() async {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': token,
        },
      ).timeout(timeoutDuration);

      return _handleResponse(response);
    });
  }

  /// Performs a POST request with retry logic and timeout
  static Future<dynamic> post(String endpoint, dynamic body) async {
    return _executeWithRetry(() async {
      final token = await AuthService.getToken();
      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': token,
        },
        body: jsonEncode(body),
      ).timeout(timeoutDuration);

      return _handleResponse(response);
    });
  }

  /// Helper to handle standard response validation
  static dynamic _handleResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      
      final data = jsonDecode(res.body);
      if (data == null) {
        throw ApiException("Received null response from server");
      }
      
      // Some APIs return { "success": false, "message": "..." } with 200 OK
      if (data is Map && data.containsKey('success') && data['success'] == false) {
        throw ApiException(data['message'] ?? "Operation failed");
      }
      
      return data;
    } else {
      throw ApiException(
        "Server Error: ${res.statusCode}",
        statusCode: res.statusCode,
      );
    }
  }

  /// Generic retry logic wrapper
  static Future<T> _executeWithRetry<T>(Future<T> Function() action) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await action();
      } catch (e) {
        if (attempts > maxRetries || e is ApiException) {
          rethrow;
        }
        // Wait a bit before retrying (simple exponential backoff could be added if needed)
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      }
    }
  }
}
