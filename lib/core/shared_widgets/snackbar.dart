import 'package:flutter/material.dart';

class AppSnackbar {
  static void success(BuildContext context, String message, {String? title}) {
    _show(
      context: context,
      message: message,
      title: title ?? 'Success',
      icon: Icons.check_circle_rounded,
      accentColor: const Color(0xFF0BA874),
      badgeBgColor: const Color(0xFF134E39),
    );
  }

  static void error(BuildContext context, String message, {String? title}) {
    _show(
      context: context,
      message: message,
      title: title ?? 'Something went wrong',
      icon: Icons.error_outline_rounded,
      accentColor: const Color(0xFFE05A62),
      badgeBgColor: const Color(0xFF4A1E22),
    );
  }

  static void info(BuildContext context, String message, {String? title}) {
    _show(
      context: context,
      message: message,
      title: title ?? 'Notice',
      icon: Icons.info_outline_rounded,
      accentColor: const Color(0xFF3BAFDA),
      badgeBgColor: const Color(0xFF163242),
    );
  }

  static void warning(BuildContext context, String message, {String? title}) {
    _show(
      context: context,
      message: message,
      title: title ?? 'Attention',
      icon: Icons.warning_amber_rounded,
      accentColor: const Color(0xFFF47A45),
      badgeBgColor: const Color(0xFF4A2A1A),
    );
  }

  static void offline(BuildContext context, [String? message]) {
    _show(
      context: context,
      message: message ?? 'No internet. Saved locally & will sync when online.',
      title: 'Offline Mode Active',
      icon: Icons.wifi_off_rounded,
      accentColor: const Color(0xFFF47A45),
      badgeBgColor: const Color(0xFF4A2A1A),
      duration: const Duration(seconds: 4),
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required String title,
    required IconData icon,
    required Color accentColor,
    required Color badgeBgColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2824) : const Color(0xFF18231F),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: accentColor.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
