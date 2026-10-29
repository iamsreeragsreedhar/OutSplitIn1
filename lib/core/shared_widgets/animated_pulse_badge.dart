import 'package:flutter/material.dart';

/// A pure StatelessWidget that renders an animated live status badge with an ambient pulse.
class AnimatedPulseBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color primaryColor;
  final Color backgroundColor;
  final Color borderColor;

  const AnimatedPulseBadge({
    super.key,
    required this.label,
    this.icon = Icons.bolt_rounded,
    this.primaryColor = const Color(0xFF0BA874),
    this.backgroundColor = const Color(0xFFE8F8F2),
    this.borderColor = const Color(0xFFC7EFE0),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.85, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.18 * scale),
                  blurRadius: 8 * scale,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: primaryColor),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
