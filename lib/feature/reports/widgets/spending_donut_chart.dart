import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:out_split_in/core/shared_widgets/animated_currency_text.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/widgets/functions/function.dart';

class SpendingDonutChart extends StatelessWidget {
  final Map<TransactionCategory, double> categoryTotals;
  final double totalExpense;

  const SpendingDonutChart({
    super.key,
    required this.categoryTotals,
    required this.totalExpense,
  });

  static const List<Color> sliceColors = [
    Color(0xFF0BA874), // Primary emerald
    Color(0xFFF47A45), // Orange
    Color(0xFF4A89DC), // Blue
    Color(0xFF967ADC), // Purple
    Color(0xFFE9573F), // Red
    Color(0xFF3BAFDA), // Teal
    Color(0xFFF6BB42), // Yellow
    Color(0xFFD770AD), // Pink
    Color(0xFF8CC152), // Lime
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (categoryTotals.isEmpty || totalExpense <= 0) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        child: Text(
          'No expense data to display',
          style: TextStyle(
            color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF84918B),
            fontSize: 13,
          ),
        ),
      );
    }

    final entries = categoryTotals.entries.toList();

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 65,
                  startDegreeOffset: -90,
                  sections: List.generate(entries.length, (index) {
                    final entry = entries[index];
                    final color = sliceColors[index % sliceColors.length];

                    return PieChartSectionData(
                      color: color,
                      value: entry.value,
                      radius: 26,
                      showTitle: false,
                    );
                  }),
                ),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeInOutCubic,
              ),
              // Center Label
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TOTAL SPENT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF84918B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedCurrencyText(
                    amount: totalExpense,
                    decimalDigits: 0,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF17201D),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Color Legends
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(entries.length, (index) {
            final entry = entries[index];
            final percentage = (entry.value / totalExpense) * 100;
            final color = sliceColors[index % sliceColors.length];

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${categoryToString(entry.key)} (${percentage.toStringAsFixed(0)}%)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF5A6964),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
