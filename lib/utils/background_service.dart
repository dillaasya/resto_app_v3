import 'dart:math';
import 'dart:ui';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:resto_app_v3/api/api_service.dart';
import 'package:resto_app_v3/main.dart';
import 'package:resto_app_v3/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    if (kDebugMode) {
      print('Alarm fired!');
    }
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().restaurantList();

    int randomizedNum = Random().nextInt(result.restaurants.length);
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result.restaurants[randomizedNum]);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
