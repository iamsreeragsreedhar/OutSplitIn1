import 'package:flutter/material.dart';

class LightTheme {
  // Brand
  static const Color primary = Color(0xFF0BA874);
  static const Color primaryDark = Color(0xFF087F59);
  static const Color primaryLight = Color(0xFFE8F8F2);

  // Backgrounds & Surface
  static const Color background = Color(0xFFF7F9F8);
  static const Color card = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF17201D);
  static const Color textSecondary = Color(0xFF78837F);
  static const Color textMuted = Color(0xFFA0AAA6);

  // Transactions
  static const Color income = Color(0xFF16A765);
  static const Color incomeBackground = Color(0xFFE8F8F0);
  static const Color expense = Color(0xFFEF5B63);
  static const Color expenseBackground = Color(0xFFFFEEEE);

  // Borders
  static const Color border = Color(0xFFE7ECEA);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: primaryDark,
      surface: card,
      error: expense,
      onPrimary: Colors.white,
      onSurface: textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: border),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 15, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 13, color: textSecondary),
      bodySmall: TextStyle(fontSize: 11, color: textMuted),
    ),
  );
}
