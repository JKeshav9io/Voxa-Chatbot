import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  /// Returns a responsive light theme based on current screen width.
  static ThemeData light(BuildContext context) => LightTheme.theme(context);

  /// Returns a responsive dark theme based on current screen width.
  static ThemeData dark(BuildContext context) => DarkTheme.theme(context);
}
