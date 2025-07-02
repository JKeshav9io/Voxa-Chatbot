import 'package:flutter/material.dart';
class DarkTheme {
  static const double _designWidth = 375;

  static ThemeData theme(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / _designWidth;

    // Colors
    const primary = Color(0xFF4A90E2);
    const secondary = Color(0xFF50E3C2);
    const neutralDark = Color(0xFF2A2D34);
    const error = Color(0xFFE94B35);

    // Scaled typography
    final textTheme = TextTheme(
      displayLarge: TextStyle(fontFamily: 'RobotoSlab', fontSize: 24 * scale, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'RobotoSlab', fontSize: 20 * scale, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16 * scale, fontWeight: FontWeight.normal),
      titleMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14 * scale, fontWeight: FontWeight.w500),
      bodySmall:   TextStyle(fontFamily: 'Roboto', fontSize: 12 * scale, fontWeight: FontWeight.w300),
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primaryColor: primary,
      scaffoldBackgroundColor: neutralDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: neutralDark,
        error: error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onError: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1E1E1E)),
      iconTheme: IconThemeData(size: 24 * scale, color: Colors.white),
      textTheme: textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        contentPadding: EdgeInsets.symmetric(vertical: 12 * scale, horizontal: 16 * scale),
        labelStyle: textTheme.titleMedium?.copyWith(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8 * scale)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8 * scale)),
          padding: EdgeInsets.symmetric(vertical: 12 * scale, horizontal: 24 * scale),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondary, textStyle: textTheme.titleMedium?.copyWith(color: Colors.white70),
        ),
      ),
    );
  }
}