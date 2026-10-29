import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DaySpendData {
  final String dayName;
  final double income;
  final double expense;

  const DaySpendData({
    required this.dayName,
    required this.income,
    required this.expense,
  });
}

class WeeklyTrendBarChart extends StatelessWidget {
  final List<DaySpendData> daysData;

  const WeeklyTrendBarChart({super.key, required this.daysData});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    double maxVal = 100;
    for (final d in daysData) {
      maxVal = max(maxVal, max(d.income, d.expense));
    }
    // Round up max value for nice top line
    final maxY = (maxVal * 1.25);

    const incomeColor = Color(0xFF0BA874);
    const expenseColor = Color(0xFFF47A45);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _legendItem('Income', incomeColor, isDark),
            const SizedBox(width: 14),
            _legendItem('Expense', expenseColor, isDark),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) =>
                      isDark ? const Color(0xFF283631) : const Color(0xFF17201D),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final isIncome = rodIndex == 0;
                    final label = isIncome ? 'Income' : 'Expense';
                    return BarTooltipItem(
                      '$label: ₹${rod.toY.toStringAsFixed(0)}',
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= daysData.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          daysData[index].dayName,
                          style: TextStyle(
                            color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF84918B),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 3,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: isDark ? const Color(0xFF283631) : const Color(0xFFEFF2F0),
                  strokeWidth: 1,
                  dashArray: const [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(daysData.length, (index) {
                final day = daysData[index];
                return BarChartGroupData(
                  x: index,
                  barsSpace: 4,
                  barRods: [
                    // Income Rod
                    BarChartRodData(
                      toY: day.income,
                      color: incomeColor,
                      width: 9,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                    // Expense Rod
                    BarChartRodData(
                      toY: day.expense,
                      color: expenseColor,
                      width: 9,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                  ],
                );
              }),
            ),
            duration: const Duration(milliseconds: 550),
            curve: Curves.easeOutCubic,
          ),
        ),
      ],
    );
  }

  Widget _legendItem(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF6E7C77),
          ),
        ),
      ],
    );
  }
}
