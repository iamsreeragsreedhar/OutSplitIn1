import 'package:flutter/material.dart';

class Appcolors {
  // Brand
  static const Color primary = Color(0xFF0BA874);
  static const Color darkGreen = Color(0xFF087F59);
  static const Color lightGreen = Color(0xFFE8F8F2);

  // Static Fallbacks
  static const Color background = Color(0xFFF7F9F8);
  static const Color textDark = Color(0xFF182522);
  static const Color textMuted = Color(0xFF7B8984);

  // Dynamic Context-Aware Colors
  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF101614)
        : const Color(0xFFF7F9F8);
  }

  static Color getCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E2824)
        : Colors.white;
  }

  static Color getBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF283631)
        : const Color(0xFFE9EFEC);
  }

  static Color getText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFEFF5F2)
        : const Color(0xFF182522);
  }

  static Color getMuted(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFA1AFA9)
        : const Color(0xFF7B8984);
  }

  static Color getSubtleGreen(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1A3329)
        : const Color(0xFFE8F8F2);
  }
}
