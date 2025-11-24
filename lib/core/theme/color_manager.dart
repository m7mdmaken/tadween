// color_manager.dart
import 'package:flutter/material.dart';

/// ColorManager - central palette & theme helpers for Tadween app
class ColorManager {
  // Primary (blue) family
  static const Color primaryBlue = Color(0xFF407BFF);
  static const Color primaryBlueDark = Color(0xFF2B5BCC);
  static const Color primaryBlueLight = Color(0xFF6DA0FF);

  // Neutral / Text colors
  static const Color darkText = Color(0xFF263238); // from SVG
  static const Color lightGray = Color(0xFFBFBFBF); // from SVG

  // Background palette
  static const Color scaffoldBg = Color(0xFFF8FAFF); // soft bluish white
  static const Color cardBg = Colors.white;
  static const Color subtleBg = Color(0xFFF2F4F7);

  // Functional
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFE53935);

  // Muted / disabled
  static const Color disabled = Color(0xFFCBD5E1); // light bluish-gray

  // Icons
  static const Color iconColor = primaryBlueDark;

  // MaterialColor generator for primary swatch (useful for ThemeData)
  static final MaterialColor primarySwatch =
      MaterialColor(primaryBlue.toARGB32(), <int, Color>{
        50: primaryBlueLight,
        100: primaryBlueLight,
        200: primaryBlueLight,
        300: primaryBlue,
        400: primaryBlue,
        500: primaryBlue,
        600: primaryBlueDark,
        700: primaryBlueDark,
        800: primaryBlueDark,
        900: primaryBlueDark,
      });

  /// Light theme ready to use
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: primarySwatch,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: scaffoldBg,
      cardColor: cardBg,
      canvasColor: subtleBg,
      iconTheme: const IconThemeData(color: iconColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: darkText,
        iconTheme: IconThemeData(color: darkText),
      ),
      textTheme: _textTheme(Brightness.light),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlueDark,
      ),
    );
  }

  /// Dark theme (optional)
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      cardColor: const Color(0xFF0F1724),
      canvasColor: const Color(0xFF071024),
      iconTheme: const IconThemeData(color: primaryBlue),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF071024),
        elevation: 0,
        foregroundColor: primaryBlue,
      ),
      textTheme: _textTheme(Brightness.dark),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : darkText,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : darkText,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : darkText,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: isDark ? Colors.white70 : darkText,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white60 : darkText,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? primaryBlue : primaryBlueDark,
      ),
    );
  }
}
