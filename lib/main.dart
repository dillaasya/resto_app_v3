import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/api/api_service.dart';
import 'package:resto_app_v3/db/database_helper.dart';
import 'package:resto_app_v3/model/restaurant.dart';
import 'package:resto_app_v3/preferences/notification_preferences.dart';
import 'package:resto_app_v3/provider/database_provider.dart';
import 'package:resto_app_v3/provider/list_provider.dart';
import 'package:resto_app_v3/provider/notification_provider.dart';
import 'package:resto_app_v3/provider/schedulling_provider.dart';
import 'package:resto_app_v3/provider/theme_provider.dart';
import 'package:resto_app_v3/ui/detail_page.dart';
import 'package:resto_app_v3/ui/list_all_page.dart';
import 'package:resto_app_v3/ui/navbar_page.dart';
import 'package:resto_app_v3/ui/search_page.dart';
import 'package:resto_app_v3/ui/setting_page.dart';
import 'package:resto_app_v3/utils/background_service.dart';
import 'package:resto_app_v3/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(
          create: (_) => ListProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationsProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, child) => MaterialApp(
          title: 'resto app v3',
          debugShowCheckedModeBanner: false,
          theme: theme.getTheme(),
          home: const NavbarPage(),
          initialRoute: NavbarPage.routeName,
          routes: {
            NavbarPage.routeName: (context) => const NavbarPage(),
            ListAllPage.routeName: (context) => const ListAllPage(),
            SettingPage.routeName: (context) => const SettingPage(),
            SearchPage.routeName: (context) => const SearchPage(),
            DetailPage.routeName: (context) => DetailPage(
                  restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
                ),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
