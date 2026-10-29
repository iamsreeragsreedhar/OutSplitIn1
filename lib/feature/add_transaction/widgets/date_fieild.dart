import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onpresss;

  const DateField({
    super.key,
    required this.text,
    required this.icon,
    required this.onpresss,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onpresss,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2824) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF84918B),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF18231F),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF84918B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
