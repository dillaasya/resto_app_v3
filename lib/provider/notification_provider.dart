import 'package:flutter/material.dart';
import 'package:resto_app_v3/preferences/notification_preferences.dart';

class NotificationsProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  NotificationsProvider({required this.preferencesHelper}) {
    _getDailyNewsPreferences();
  }

  bool _isDailyNewsActive = false;
  bool get isDailyNewsActive => _isDailyNewsActive;

  void _getDailyNewsPreferences() async {
    _isDailyNewsActive = await preferencesHelper.isDailyNewsActive;
    notifyListeners();
  }

  void enableDailyNews(bool value) {
    preferencesHelper.setDailyNews(value);
    _getDailyNewsPreferences();
  }
}
