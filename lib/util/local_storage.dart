import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _sessionKey = 'session';

  static Future<bool> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionKey) ?? false;
  }

  static Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, true);
    await prefs.setString('username', username);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, false);
    await prefs.remove('username');
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
