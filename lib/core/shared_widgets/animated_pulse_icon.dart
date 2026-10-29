import 'package:flutter/material.dart';

/// A pure StatelessWidget that displays an icon with an elastic entrance pulse and glow.
class AnimatedPulseIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;

  const AnimatedPulseIcon({
    super.key,
    required this.icon,
    this.iconColor = Colors.white,
    this.backgroundColor = const Color(0xFF0BA874),
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.7, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.32 * scale),
                  blurRadius: 10 * scale,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: size,
            ),
          ),
        );
      },
    );
  }
}
