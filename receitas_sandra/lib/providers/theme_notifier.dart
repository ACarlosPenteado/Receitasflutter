import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  late ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  getThemeMode() => _themeMode;

  setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
  }
}

class AppTheme {
  get darkTheme => ThemeData.from(
        colorScheme: const ColorScheme(
          onPrimary: Colors.red,
          primaryVariant: Colors.grey,
          primary: Colors.black,
          brightness: Brightness.dark,
          onBackground: Colors.pink,
          background: Color(0xFF212121),
          secondary: Colors.white,
          onSecondary: Colors.amber,
          secondaryVariant: Colors.cyan,
          surface: Colors.blue,
          onSurface: Colors.black12,
          onError: Colors.green,
          error: Colors.greenAccent,
        ),
      );

  get lightTheme => ThemeData.from(
        colorScheme: ColorScheme(
          onPrimary: Colors.red.shade50,
          primaryVariant: Colors.grey.shade100,
          primary: Colors.black26,
          brightness: Brightness.light,
          onBackground: Colors.pink.shade50,
          background: const Color(0xff121212),
          secondary: Colors.black,
          onSecondary: Colors.amber.shade50,
          secondaryVariant: Colors.cyan.shade50,
          surface: Colors.blue.shade50,
          onSurface: Colors.black54,
          onError: Colors.green.shade50,
          error: Colors.teal.shade100,
        ),
      );
}
