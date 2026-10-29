import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/view_model/home/home_bloc.dart';
import 'package:out_split_in/feature/reports/widgets/category_spend_tile.dart';
import 'package:out_split_in/feature/reports/widgets/reports_summary_card.dart';
import 'package:out_split_in/feature/reports/widgets/spending_donut_chart.dart';
import 'package:out_split_in/feature/reports/widgets/timeframe_selector.dart';
import 'package:out_split_in/feature/reports/widgets/weekly_trend_bar_chart.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  TimeframeFilter _timeframe = TimeframeFilter.month;

  static const Color textDark = Color(0xFF18231F);
  static const Color muted = Color(0xFF84918B);

  List<TransactionModel> _filterTransactions(List<dynamic> allDynamic) {
    final now = DateTime.now();
    final all = allDynamic.whereType<TransactionModel>().toList();

    switch (_timeframe) {
      case TimeframeFilter.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final weekStart = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        return all
            .where(
              (t) => t.date.isAfter(
                weekStart.subtract(const Duration(seconds: 1)),
              ),
            )
            .toList();
      case TimeframeFilter.month:
        final monthStart = DateTime(now.year, now.month, 1);
        return all
            .where(
              (t) => t.date.isAfter(
                monthStart.subtract(const Duration(seconds: 1)),
              ),
            )
            .toList();
      case TimeframeFilter.all:
        return all;
    }
  }

  List<DaySpendData> _calculate7DaysData(List<TransactionModel> transactions) {
    final now = DateTime.now();
    final days = <DaySpendData>[];

    for (int i = 6; i >= 0; i--) {
      final targetDate = now.subtract(Duration(days: i));
      final dayStart = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayTx = transactions.where((t) {
        return t.date.isAfter(dayStart.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(dayEnd);
      });

      final dayIncome = dayTx
          .where((t) => t.type == TransactionType.income)
          .fold<double>(0, (sum, t) => sum + t.amount);

      final dayExpense = dayTx
          .where((t) => t.type == TransactionType.expense)
          .fold<double>(0, (sum, t) => sum + t.amount);

      days.add(
        DaySpendData(
          dayName: DateFormat('E').format(targetDate), // Mon, Tue, etc.
          income: dayIncome,
          expense: dayExpense,
        ),
      );
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final filtered = _filterTransactions(state.transactions);

            final income = filtered
                .where((t) => t.type == TransactionType.income)
                .fold<double>(0, (sum, t) => sum + t.amount);

            final expense = filtered
                .where((t) => t.type == TransactionType.expense)
                .fold<double>(0, (sum, t) => sum + t.amount);

            final categoryTotals = <TransactionCategory, double>{};
            for (final t in filtered.where(
              (t) => t.type == TransactionType.expense,
            )) {
              categoryTotals[t.category] =
                  (categoryTotals[t.category] ?? 0) + t.amount;
            }

            final sortedCategories = categoryTotals.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            final daysData = _calculate7DaysData(
              state.transactions.whereType<TransactionModel>().toList(),
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth > 720
                    ? 680.0
                    : double.infinity;

                return RefreshIndicator(
                  color: const Color(0xFF0BA874),
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const fetchsmsTransactions());
                    await Future<void>.delayed(
                      const Duration(milliseconds: 500),
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppFadeSlide(
                              direction: SlideDirection.fromTop,
                              child: _header(isDark),
                            ),
                            const SizedBox(height: 18),

                            // Timeframe filter
                            AppFadeSlide(
                              delay: const Duration(milliseconds: 60),
                              child: TimeframeSelector(
                                selectedFilter: _timeframe,
                                onFilterChanged: (filter) {
                                  setState(() {
                                    _timeframe = filter;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Net savings overview
                            AppFadeSlide(
                              delay: const Duration(milliseconds: 120),
                              child: ReportsSummaryCard(
                                income: income,
                                expense: expense,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Category spending donut chart card
                            AppFadeSlide(
                              delay: const Duration(milliseconds: 180),
                              child: _sectionCard(
                                isDark: isDark,
                                title: 'Spending Breakdown',
                                subtitle:
                                    'Categorized distribution of your expenses',
                                child: SpendingDonutChart(
                                  categoryTotals: categoryTotals,
                                  totalExpense: expense,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Weekly trend bar chart card
                            AppFadeSlide(
                              delay: const Duration(milliseconds: 240),
                              child: _sectionCard(
                                isDark: isDark,
                                title: '7-Day Activity Trend',
                                subtitle:
                                    'Daily comparison of your inflows and outflows',
                                child: WeeklyTrendBarChart(daysData: daysData),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Category breakdown list
                            if (sortedCategories.isNotEmpty)
                              AppFadeSlide(
                                delay: const Duration(milliseconds: 300),
                                child: _sectionCard(
                                  isDark: isDark,
                                  title: 'Category Rankings',
                                  subtitle: 'Highest to lowest expenditure',
                                  child: Column(
                                    children: sortedCategories.map((entry) {
                                      final percentage = expense > 0
                                          ? (entry.value / expense) * 100
                                          : 0.0;
                                      final index = sortedCategories.indexOf(
                                        entry,
                                      );
                                      final color =
                                          SpendingDonutChart.sliceColors[index %
                                              SpendingDonutChart
                                                  .sliceColors
                                                  .length];

                                      return CategorySpendTile(
                                        category: entry.key,
                                        amount: entry.value,
                                        percentage: percentage,
                                        color: color,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _header(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics & Reports',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            color: isDark ? Colors.white : textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Visual breakdown of your financial health.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? const Color(0xFFA1AFA9) : muted,
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({
    required bool isDark,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.025),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : textDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFFA1AFA9) : muted,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
