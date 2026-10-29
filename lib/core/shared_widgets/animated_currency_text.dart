import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A pure StatelessWidget that smoothly counts up to [amount] with ease-out curve.
class AnimatedCurrencyText extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final String prefix;
  final int decimalDigits;

  const AnimatedCurrencyText({
    super.key,
    required this.amount,
    this.style,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOutCubic,
    this.prefix = '₹ ',
    this.decimalDigits = 2,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: prefix,
      decimalDigits: decimalDigits,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: amount),
      duration: duration,
      curve: curve,
      builder: (context, value, _) {
        return Text(
          formatter.format(value),
          style: style,
        );
      },
    );
  }
}
