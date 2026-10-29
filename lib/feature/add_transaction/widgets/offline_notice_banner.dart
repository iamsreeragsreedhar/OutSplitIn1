import 'package:flutter/material.dart';

/// A modern, professional offline warning banner displayed on the
/// Add Transaction screen when the device lacks internet connectivity.
class OfflineNoticeBanner extends StatelessWidget {
  final bool isConnected;
  final VoidCallback? onRetry;

  const OfflineNoticeBanner({
    super.key,
    required this.isConnected,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF2E1C0C), Color(0xFF221508)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final borderColor = isDark
        ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
        : const Color(0xFFFBBF24);

    final titleColor = isDark
        ? const Color(0xFFFDE68A)
        : const Color(0xFF92400E);

    final bodyColor = isDark
        ? const Color(0xFFE5D5BA)
        : const Color(0xFF78350F);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: bgGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.25 : 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFFD97706),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Offline Mode',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Transactions will be saved safely on your device and auto-synced once your connection returns.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: bodyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                size: 20,
                color: titleColor,
              ),
              onPressed: onRetry,
              tooltip: 'Check Connection',
            ),
          ],
        ],
      ),
    );
  }
}
