import 'package:flutter/material.dart';

class EmptyTransactionWidget extends StatelessWidget {
  const EmptyTransactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161F1C) : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: isDark ? const Color(0xFF80928B) : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No transactions yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF18231F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your income and expenses will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFFA1AFA9) : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
