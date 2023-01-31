import 'package:flutter/foundation.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resto_app_v3/provider/theme_provider.dart';

void main() {
  test('can change theme with changeTheme function in Provider ThemeNotifier', () {
    // Skenario pengujian dituliskan di sini

    var theme = ThemeNotifier();

    theme.changeTheme();

    var result = theme.getTheme();
    if (kDebugMode) {
      print("THEME AFTER VOID CHANGE : $result");
    }

    ThemeData matcher;

    if (result == theme.darkTheme) {
      matcher = theme.darkTheme;
      print('matcher dark');
    } else {
      matcher = theme.lightTheme;
      print('matcher light');
    }

    if (kDebugMode) {
      print("PRINT MATCHER : $matcher");
    }

    expect(result, matcher);
  });
}