import 'package:flutter/material.dart';

class DarkTheme {
  static const Color primary = Color(0xFF10C487);
  static const Color primaryDark = Color(0xFF0BA874);
  static const Color primaryLight = Color(0xFF1E352C);

  static const Color background = Color(0xFF101614);
  static const Color surface = Color(0xFF19221F);
  static const Color card = Color(0xFF1E2824);
  static const Color border = Color(0xFF283631);

  static const Color textPrimary = Color(0xFFEFF5F2);
  static const Color textSecondary = Color(0xFFA1AFA9);
  static const Color textMuted = Color(0xFF6F7E78);

  static const Color income = Color(0xFF20C978);
  static const Color incomeBackground = Color(0xFF153326);
  static const Color expense = Color(0xFFFF6B6B);
  static const Color expenseBackground = Color(0xFF381C1D);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: primaryDark,
      surface: surface,
      error: expense,
      onPrimary: Colors.black,
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
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 1,
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
