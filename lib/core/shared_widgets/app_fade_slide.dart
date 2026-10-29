import 'package:flutter/material.dart';

enum SlideDirection { fromBottom, fromTop, fromLeft, fromRight, scaleOnly }

/// A lightweight, performant entrance animation widget.
/// Fades and slides [child] into view smoothly without requiring a StatefulWidget.
class AppFadeSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final SlideDirection direction;
  final double offsetDistance;

  const AppFadeSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.direction = SlideDirection.fromBottom,
    this.offsetDistance = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    final totalMs = (duration + delay).inMilliseconds;
    final delayFraction = totalMs == 0
        ? 0.0
        : (delay.inMilliseconds / totalMs).clamp(0.0, 0.99);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration + delay,
      curve: Interval(delayFraction, 1.0, curve: curve),
      builder: (context, value, child) {
        Offset offset;
        switch (direction) {
          case SlideDirection.fromBottom:
            offset = Offset(0, (1.0 - value) * offsetDistance);
            break;
          case SlideDirection.fromTop:
            offset = Offset(0, -(1.0 - value) * offsetDistance);
            break;
          case SlideDirection.fromLeft:
            offset = Offset(-(1.0 - value) * offsetDistance, 0);
            break;
          case SlideDirection.fromRight:
            offset = Offset((1.0 - value) * offsetDistance, 0);
            break;
          case SlideDirection.scaleOnly:
            offset = Offset.zero;
            break;
        }

        final scale = direction == SlideDirection.scaleOnly
            ? 0.92 + (0.08 * value)
            : 1.0;

        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
