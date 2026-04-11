import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveTheme();
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeStr = prefs.getString('theme_mode');
    if (themeStr != null) {
      if (themeStr == 'dark') _themeMode = ThemeMode.dark;
      if (themeStr == 'light') _themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String themeStr = 'system';
    if (_themeMode == ThemeMode.dark) themeStr = 'dark';
    if (_themeMode == ThemeMode.light) themeStr = 'light';
    await prefs.setString('theme_mode', themeStr);
  }
}
