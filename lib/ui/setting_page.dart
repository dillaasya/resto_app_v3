import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/common/navigation.dart';
import 'package:resto_app_v3/provider/notification_provider.dart';
import 'package:resto_app_v3/provider/schedulling_provider.dart';
import 'package:resto_app_v3/provider/theme_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});
  static const routeName = '/setting_page';
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Settings",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Switch Theme",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Light/Dark",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                        )
                      ],
                    ),
                    Switch(
                      value: theme.getTheme() == theme.darkTheme,
                      activeColor: Colors.redAccent,
                      onChanged: (v) {
                        theme.changeTheme();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Consumer<NotificationsProvider>(
                  builder: (context, provider, child) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Notifications",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Will be appear at 11.00 AM",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                              )
                            ],
                          ),
                          Consumer<SchedulingProvider>(
                            builder: (context, scheduled, _) {
                              return Switch.adaptive(
                                activeColor: Colors.redAccent,
                                value: provider.isDailyNewsActive,
                                onChanged: (value) async {
                                  if (Platform.isIOS) {
                                    customDialog(context);
                                  } else {
                                    scheduled.scheduledRecommendation(value);
                                    provider.enableDailyNews(value);
                                  }
                                },
                              );
                            },
                          ),
                        ]);
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

customDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Coming Soon!'),
        content: const Text('This feature will be coming soon!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigation.back();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
