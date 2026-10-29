import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A modern, professional Google Sign-In button built as a pure [StatelessWidget].
/// Adheres to Material 3 and Google Brand guidelines with light and dark mode adaptation.
class GoogleLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const GoogleLoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'Continue with Google',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF1E2824) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2E3E37) : const Color(0xFFE1E8E4);
    final textColor = isDark ? Colors.white : const Color(0xFF18211E);

    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFF0BA874).withValues(alpha: 0.1),
          highlightColor: const Color(0xFF0BA874).withValues(alpha: 0.05),
          child: Center(
            child: isLoading
                ? LoadingAnimationWidget.staggeredDotsWave(
                    color: const Color(0xFF0BA874),
                    size: 26,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGoogleIcon(),
                      const SizedBox(width: 12),
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Builds the official Google 'G' multicolored icon programmatically
  /// without requiring external SVG or asset dependencies.
  Widget _buildGoogleIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(20, 20),
          painter: _GoogleIconPainter(),
        ),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Red: Top curve
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;
    final redPath = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..cubicTo(w * 0.68, h * 0.1, w * 0.81, h * 0.17, w * 0.9, h * 0.26)
      ..lineTo(w * 0.74, h * 0.42)
      ..cubicTo(w * 0.68, h * 0.36, w * 0.6, h * 0.31, w * 0.5, h * 0.31)
      ..cubicTo(w * 0.36, h * 0.31, w * 0.24, h * 0.41, w * 0.19, h * 0.53)
      ..lineTo(w * 0.03, h * 0.41)
      ..cubicTo(w * 0.11, h * 0.23, w * 0.29, h * 0.1, w * 0.5, h * 0.1)
      ..close();
    canvas.drawPath(redPath, redPaint);

    // Yellow: Left curve
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;
    final yellowPath = Path()
      ..moveTo(w * 0.19, h * 0.53)
      ..cubicTo(w * 0.18, h * 0.57, w * 0.17, h * 0.61, w * 0.17, h * 0.65)
      ..cubicTo(w * 0.17, h * 0.69, w * 0.18, h * 0.73, w * 0.19, h * 0.77)
      ..lineTo(w * 0.03, h * 0.89)
      ..cubicTo(w * 0.01, h * 0.81, 0, h * 0.73, 0, h * 0.65)
      ..cubicTo(0, h * 0.57, w * 0.01, h * 0.49, w * 0.03, h * 0.41)
      ..lineTo(w * 0.19, h * 0.53)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Green: Bottom curve
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;
    final greenPath = Path()
      ..moveTo(w * 0.5, h * 1.2)
      ..cubicTo(w * 0.7, h * 1.2, w * 0.87, h * 1.07, w * 0.94, h * 0.89)
      ..lineTo(w * 0.77, h * 0.76)
      ..cubicTo(w * 0.71, h * 0.83, w * 0.62, h * 0.89, w * 0.5, h * 0.89)
      ..cubicTo(w * 0.36, h * 0.89, w * 0.24, h * 0.79, w * 0.19, h * 0.67)
      ..lineTo(w * 0.03, h * 0.79)
      ..cubicTo(w * 0.11, h * 0.97, w * 0.29, h * 1.2, w * 0.5, h * 1.2)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Blue: Center bar and right curve
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final bluePath = Path()
      ..moveTo(w * 0.98, h * 0.65)
      ..cubicTo(w * 0.98, h * 0.61, w * 0.97, h * 0.57, w * 0.96, h * 0.53)
      ..lineTo(w * 0.5, h * 0.53)
      ..lineTo(w * 0.5, h * 0.74)
      ..lineTo(w * 0.77, h * 0.74)
      ..cubicTo(w * 0.76, h * 0.82, w * 0.71, h * 0.88, w * 0.65, h * 0.92)
      ..lineTo(w * 0.82, h * 1.05)
      ..cubicTo(w * 0.92, h * 0.95, w * 0.98, h * 0.81, w * 0.98, h * 0.65)
      ..close();
    canvas.drawPath(bluePath, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
