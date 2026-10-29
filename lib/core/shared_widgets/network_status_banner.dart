import 'package:flutter/material.dart';
import 'package:out_split_in/core/service_locator/di.dart';
import 'package:out_split_in/core/services/network_service.dart';

/// A sleek, reactive network status banner that displays when the device
/// lacks internet connectivity, with an instant retry action.
class NetworkStatusBanner extends StatelessWidget {
  final EdgeInsetsGeometry margin;

  const NetworkStatusBanner({
    super.key,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  @override
  Widget build(BuildContext context) {
    final networkService = sl<NetworkService>();

    return ValueListenableBuilder<bool>(
      valueListenable: networkService.isConnectedNotifier,
      builder: (context, isConnected, _) {
        if (isConnected) {
          return const SizedBox.shrink();
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          margin: margin,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF2E1C0C)
                : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
                  : const Color(0xFFFBBF24),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.15 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 18,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No Network Connection',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFFFDE68A)
                            : const Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Operating in offline mode. Changes will auto-sync when reconnected.',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFFE5D5BA)
                            : const Color(0xFF78350F),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: Color(0xFFD97706),
                ),
                tooltip: 'Check Connection',
                onPressed: () => networkService.checkIsConnected(),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
              ),
            ],
          ),
        );
      },
    );
  }
}
