import 'package:flutter/material.dart';
class LightTheme {
  // Base design width for scaling (e.g., Figma artboard width)
  static const double designWidth = 375;

  static ThemeData theme(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / designWidth;

    // Colors
    const primary = Color(0xFF4A90E2);
    const secondary = Color(0xFF50E3C2);
    const neutralLight = Color(0xFFF5F7FA);
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
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: primary,
      scaffoldBackgroundColor: neutralLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: neutralLight,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: neutralDark,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
      iconTheme: IconThemeData(size: 24 * scale, color: neutralDark),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 12 * scale, horizontal: 16 * scale),
        labelStyle: textTheme.titleMedium,
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
          foregroundColor: secondary, textStyle: textTheme.titleMedium,
        ),
      ),
    );
  }
}

