import 'package:flutter/material.dart';

class NotificationEmptyView extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationEmptyView({
    super.key,
    this.title = 'All caught up! 🎉',
    this.subtitle = 'You have no notifications right now.',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2824) : const Color(0xFFE8F8F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 42,
                color: Color(0xFF0BA874),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF18231F),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
