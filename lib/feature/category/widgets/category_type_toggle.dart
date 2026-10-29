import 'package:flutter/material.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

class CategoryTypeToggle extends StatelessWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onTypeChanged;

  const CategoryTypeToggle({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
        ),
      ),
      child: Row(
        children: [
          _buildPill(
            context: context,
            title: 'Expenses',
            icon: Icons.arrow_downward_rounded,
            type: TransactionType.expense,
            activeColor: const Color(0xFFE05A62),
          ),
          _buildPill(
            context: context,
            title: 'Income',
            icon: Icons.arrow_upward_rounded,
            type: TransactionType.income,
            activeColor: const Color(0xFF0BA874),
          ),
        ],
      ),
    );
  }

  Widget _buildPill({
    required BuildContext context,
    required String title,
    required IconData icon,
    required TransactionType type,
    required Color activeColor,
  }) {
    final isSelected = selectedType == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F)),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
