import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:resto_app_v3/preferences/theme_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primaryColor: Colors.black,
    backgroundColor: const Color(0xFF212121),
    dividerColor: Colors.white38,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
      secondary: Colors.white,
      brightness: Brightness.dark,
    ),
  );

  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    backgroundColor: const Color(0xFFE5E5E5),
    dividerColor: Colors.black12,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
      secondary: Colors.black,
      brightness: Brightness.light,
    ),
  );

  ThemeData? _themeData;
  ThemeData? getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      if (kDebugMode) {
        print('value read from storage: $value');
      }
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        if (kDebugMode) {
          print('setting dark theme');
        }
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  void changeTheme() {
    if (_themeData == darkTheme) {
      setLightMode();
      notifyListeners();
    } else {
      setDarkMode();
      notifyListeners();
    }
  }
}