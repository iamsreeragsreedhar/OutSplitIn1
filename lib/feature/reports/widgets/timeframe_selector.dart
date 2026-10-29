import 'package:flutter/material.dart';

enum TimeframeFilter { week, month, all }

class TimeframeSelector extends StatelessWidget {
  final TimeframeFilter selectedFilter;
  final ValueChanged<TimeframeFilter> onFilterChanged;

  const TimeframeSelector({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
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
          _buildChip(TimeframeFilter.week, 'Week', isDark),
          _buildChip(TimeframeFilter.month, 'Month', isDark),
          _buildChip(TimeframeFilter.all, 'All Time', isDark),
        ],
      ),
    );
  }

  Widget _buildChip(TimeframeFilter filter, String label, bool isDark) {
    final isSelected = selectedFilter == filter;
    const primary = Color(0xFF0BA874);

    return Expanded(
      child: GestureDetector(
        onTap: () => onFilterChanged(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F)),
            ),
          ),
        ),
      ),
    );
  }
}
