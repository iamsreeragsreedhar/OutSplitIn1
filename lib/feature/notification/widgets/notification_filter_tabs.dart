import 'package:flutter/material.dart';
import 'package:out_split_in/feature/notification/model/app_notification_model.dart';

class NotificationFilterTabs extends StatelessWidget {
  final NotificationCategory? selectedCategory;
  final ValueChanged<NotificationCategory?> onCategoryChanged;

  const NotificationFilterTabs({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            context: context,
            title: 'All',
            category: null,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context: context,
            title: 'UPI Payments',
            category: NotificationCategory.upiPayment,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context: context,
            title: 'SMS Sync',
            category: NotificationCategory.smsSync,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context: context,
            title: 'Alerts',
            category: NotificationCategory.budgetAlert,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context: context,
            title: 'System',
            category: NotificationCategory.system,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String title,
    required NotificationCategory? category,
  }) {
    final isSelected = selectedCategory == category;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = Color(0xFF0BA874);

    return GestureDetector(
      onTap: () => onCategoryChanged(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primary
              : (isDark ? const Color(0xFF1E2824) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? primary
                : (isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC)),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : const Color(0xFF6E7C77)),
          ),
        ),
      ),
    );
  }
}
