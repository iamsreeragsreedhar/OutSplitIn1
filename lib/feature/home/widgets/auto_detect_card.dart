import 'package:flutter/material.dart';
import 'package:out_split_in/core/shared_widgets/animated_pulse_icon.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';

class AutoDetectCard extends StatelessWidget {
  final VoidCallback? onTap;
  const AutoDetectCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppFadeSlide(
      direction: SlideDirection.fromTop,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B2B24) : const Color(0xFFE9F8F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF284036) : const Color(0xFFC7EFE0),
          ),
        ),
        child: Row(
          children: [
            const AnimatedPulseIcon(
              icon: Icons.notifications_active_rounded,
              backgroundColor: Color(0xFF0BA874),
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-detect UPI Payments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF182522),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Automatically capture payments from Google Pay, PhonePe, Paytm & Bank alerts.',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF5F6E69),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0BA874),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enable',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
