import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:out_split_in/feature/notification/model/app_notification_model.dart';

class NotificationTile extends StatelessWidget {
  final AppNotificationModel notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (icon, color) = switch (notification.category) {
      NotificationCategory.upiPayment => (
          Icons.bolt_rounded,
          const Color(0xFF0BA874),
        ),
      NotificationCategory.smsSync => (
          Icons.sms_rounded,
          const Color(0xFF4A89DC),
        ),
      NotificationCategory.budgetAlert => (
          Icons.warning_amber_rounded,
          const Color(0xFFF47A45),
        ),
      NotificationCategory.system => (
          Icons.notifications_active_rounded,
          const Color(0xFF967ADC),
        ),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? const Color(0xFF1E2824) : Colors.white)
              : (isDark ? const Color(0xFF22322C) : const Color(0xFFF0F9F5)),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: notification.isRead
                ? (isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC))
                : color.withValues(alpha: 0.35),
            width: notification.isRead ? 1.0 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF18231F),
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0BA874),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: isDark ? Colors.white70 : const Color(0xFF5F6E69),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(notification.timestamp),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF84918B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd MMM, hh:mm a').format(date);
    }
  }
}
