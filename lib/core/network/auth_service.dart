import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthService {
  static const String _tokenKey = "auth_token";

  /// 🔐 GENERATE TOKEN (Mallu Smart Backend)
  static Future<bool> generateToken() async {
    try {
      final response = await ApiClient.post("/User/GenerateToken", {
        "email": "prince@mallusmart",
        "password": "123"
      });

      if (response != null && response is Map && response.containsKey('token')) {
        final token = response['token'].toString();
        // Backend returns the raw token, we need to format it for Authorization header
        // If the backend already includes "Bearer ", use it, otherwise prepend.
        final formattedToken = token.startsWith("Bearer ") ? token : "Bearer $token";
        await saveToken(formattedToken);
        print("✅ Auth Success: Token generated and saved.");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Auth Failed: $e");
      return false;
    }
  }

  /// Saves the token to local storage
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Retrieves the token from local storage
  static Future<String?> getToken() async {
    // 🚀 NO LOGIN: Token retrieval disabled.
    return null;
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString(_tokenKey);
  }

  /// Checks if a user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clears the token (Logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
