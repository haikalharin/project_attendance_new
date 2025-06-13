
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String isLoggedInKey = 'isLoggedIn';
  static const String usernameKey = 'username';
  static const String tokenAccess = 'token';

  /// Set login status
  static Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, value);
  }

  /// Get login status
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  /// Set username
  static Future<void> setUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(usernameKey, username);
  }

  /// Get username
  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }
  /// Delete username
  static Future<void> deleteUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(usernameKey);
  }

  /// Set username
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenAccess, token);
  }

  /// Get username
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenAccess);
  }
  /// Delete username
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenAccess);
  }

  /// Clear all preferences (e.g., for logout)
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
