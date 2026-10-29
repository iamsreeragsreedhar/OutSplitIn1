import 'package:flutter/material.dart';
import 'package:out_split_in/core/shared_widgets/animated_currency_text.dart';

class ReportsSummaryCard extends StatelessWidget {
  final double income;
  final double expense;

  const ReportsSummaryCard({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0BA874);
    const darkGreen = Color(0xFF087F59);
    final netSavings = income - expense;
    final savingsRate = income > 0
        ? ((netSavings / income) * 100).clamp(0, 100)
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primary, darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.2),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'NET SAVINGS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${savingsRate.toStringAsFixed(0)}% Saved',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedCurrencyText(
            amount: netSavings,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.18)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _statItem(
                  label: 'Income',
                  amount: income,
                  icon: Icons.south_west_rounded,
                  color: const Color(0xFFB5F2D9),
                ),
              ),
              Container(
                height: 36,
                width: 1,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _statItem(
                  label: 'Expenses',
                  amount: expense,
                  icon: Icons.north_east_rounded,
                  color: const Color(0xFFFFB4B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required String label,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedCurrencyText(
              amount: amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
