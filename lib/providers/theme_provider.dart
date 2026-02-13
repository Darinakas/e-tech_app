import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  int _themeIndex = 0;

  int get themeIndex => _themeIndex;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeIndex = prefs.getInt('themeIndex') ?? 0;
    notifyListeners();
  }

  Future<void> setTheme(int index) async {
    _themeIndex = index;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeIndex', index);
  }

  ThemeData getThemeData(int index) {
    switch (_themeIndex) {
      case 1:
        return ThemeData.dark(useMaterial3: true);
      case 2:
        return ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.purple[50],
          appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          ),
          useMaterial3: true,
        );
      default:
        return ThemeData.light(useMaterial3: true);
    }
  }

  bool get isDarkMode => _themeIndex == 1;
}
