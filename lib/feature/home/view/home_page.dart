import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:out_split_in/core/localization/app_localizations.dart';
import 'package:out_split_in/core/service_locator/di.dart';
import 'package:out_split_in/core/services/budget_service.dart';
import 'package:out_split_in/core/services/firebase_services.dart';
import 'package:out_split_in/core/services/network_service.dart';
import 'package:out_split_in/core/services/upi_notification_service.dart';
import 'package:out_split_in/core/shared_widgets/animated_currency_text.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/core/shared_widgets/export_statement_sheet.dart';
import 'package:out_split_in/core/shared_widgets/monthly_budget_dialog.dart';
import 'package:out_split_in/core/shared_widgets/network_status_banner.dart';
import 'package:out_split_in/core/shared_widgets/receipt_viewer_dialog.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/core/theme/app_colors.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/view_model/home/home_bloc.dart';
import 'package:out_split_in/feature/home/widgets/auto_detect_card.dart';
import 'package:out_split_in/feature/home/widgets/empty_transaction_widget.dart';
import 'package:out_split_in/feature/home/widgets/functions/function.dart';
import 'package:out_split_in/feature/notification/model/app_notification_model.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_bloc.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_event.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_state.dart';

enum HomeTransactionFilter { all, today, yesterday, thisWeek, thisMonth, expense, income }

class HomeScreen extends StatefulWidget {
  final VoidCallback? onAdd;

  const HomeScreen({super.key, this.onAdd});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _hideBalance = false;
  bool _hasUpiPermission = true;
  HomeTransactionFilter _activeFilter = HomeTransactionFilter.all;
  late final UpiNotificationService _upiService;
  late final NetworkService _networkService;
  late final FirebaseServices _firebaseServices;
  StreamSubscription<TransactionModel>? _upiSubscription;
  StreamSubscription<bool>? _networkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _upiService = sl<UpiNotificationService>();
    _networkService = sl<NetworkService>();
    _firebaseServices = sl<FirebaseServices>();
    context.read<HomeBloc>().add(const fetchsmsTransactions());
    _initUpiListener();
    _initAutoSync();
  }

  void _initAutoSync() {
    _networkSubscription = _networkService.onConnectivityChanged.listen((connected) async {
      if (connected) {
        if (mounted) {
          AppSnackbar.success(context, 'Internet connection restored!');
        }
        await _performPendingSync();
      } else {
        if (mounted) {
          AppSnackbar.info(context, 'No internet connection. Operating in offline mode.');
        }
      }
    });
    // Check pending sync on load
    _performPendingSync();
  }

  Future<void> _performPendingSync() async {
    try {
      final syncedCount = await _firebaseServices.syncPendingTransactions();
      if (syncedCount > 0 && mounted) {
        AppSnackbar.success(
          context,
          'Auto-synced $syncedCount offline transaction${syncedCount > 1 ? 's' : ''} to cloud!',
        );
        context.read<HomeBloc>().add(const fetchsmsTransactions());
      }
    } catch (e) {
      debugPrint('Error syncing pending transactions: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _upiSubscription?.cancel();
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationPermission();
    }
  }

  Future<void> _initUpiListener() async {
    await _checkNotificationPermission();

    _upiSubscription = _upiService.onTransactionDetected.listen((transaction) {
      if (!mounted) return;
      context.read<HomeBloc>().add(const fetchsmsTransactions());
      context.read<NotificationBloc>().add(
        AddNotificationEvent(
          AppNotificationModel(
            id: 'upi_${DateTime.now().millisecondsSinceEpoch}',
            title: 'Payment Detected',
            body: '₹${transaction.amount.toStringAsFixed(2)} at ${transaction.title}',
            timestamp: DateTime.now(),
            category: NotificationCategory.upiPayment,
            amount: transaction.amount,
          ),
        ),
      );
      AppSnackbar.success(
        context,
        'Auto-detected ₹${transaction.amount.toStringAsFixed(2)} at ${transaction.title}!',
      );
    });
  }

  Future<void> _checkNotificationPermission() async {
    final granted = await _upiService.isPermissionGranted();
    if (mounted) {
      setState(() {
        _hasUpiPermission = granted;
      });
    }
    if (granted) {
      await _upiService.startListening();
    }
  }

  Future<void> _enableAutoDetect() async {
    await _upiService.requestPermission();
    final granted = await _upiService.isPermissionGranted();
    if (!mounted) return;
    setState(() => _hasUpiPermission = granted);
    if (granted) {
      await _upiService.startListening();
      if (!mounted) return;
      AppSnackbar.success(
        context,
        'UPI Auto-detection enabled',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final rawName = user?.displayName?.trim();
    final greetingName = (rawName != null && rawName.isNotEmpty)
        ? rawName
        : (user?.email?.split('@').first ?? 'there');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final transactions = state.transactions.whereType<TransactionModel>().toList();

            final income = transactions
                .where((t) => t.type == TransactionType.income)
                .fold<double>(0, (sum, t) => sum + t.amount);

            final expenses = transactions
                .where((t) => t.type == TransactionType.expense)
                .fold<double>(0, (sum, t) => sum + t.amount);

            final balance = income - expenses;

            final now = DateTime.now();
            final monthlyExpenses = transactions
                .where(
                  (t) =>
                      t.type == TransactionType.expense &&
                      t.date.year == now.year &&
                      t.date.month == now.month,
                )
                .fold<double>(0, (sum, t) => sum + t.amount);

            final filteredTransactions = _applyFilter(transactions);
            final dayGroups = _groupDayWise(filteredTransactions);

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 650;
                final horizontalPadding = isWide ? 32.0 : 20.0;

                return RefreshIndicator(
                  color: Appcolors.primary,
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const fetchsmsTransactions());
                    await Future<void>.delayed(const Duration(milliseconds: 500));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 110),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppFadeSlide(
                              direction: SlideDirection.fromTop,
                              child: _header(greetingName, isDark, l10n),
                            ),
                            const SizedBox(height: 16),

                            const NetworkStatusBanner(),

                            if (!_hasUpiPermission) ...[
                              const SizedBox(height: 12),
                              AutoDetectCard(onTap: _enableAutoDetect),
                            ],

                            AppFadeSlide(
                              delay: const Duration(milliseconds: 80),
                              child: _balanceCard(balance, l10n),
                            ),
                            const SizedBox(height: 18),

                            if (isWide)
                              AppFadeSlide(
                                delay: const Duration(milliseconds: 140),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _summaryCard(
                                        title: l10n.income,
                                        amount: income,
                                        icon: Icons.south_west_rounded,
                                        color: Appcolors.primary,
                                        isDark: isDark,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _summaryCard(
                                        title: l10n.expenses,
                                        amount: expenses,
                                        icon: Icons.north_east_rounded,
                                        color: const Color(0xFFE05A62),
                                        isDark: isDark,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              AppFadeSlide(
                                delay: const Duration(milliseconds: 140),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _summaryCard(
                                        title: l10n.income,
                                        amount: income,
                                        icon: Icons.south_west_rounded,
                                        color: Appcolors.primary,
                                        isDark: isDark,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _summaryCard(
                                        title: l10n.expenses,
                                        amount: expenses,
                                        icon: Icons.north_east_rounded,
                                        color: const Color(0xFFE05A62),
                                        isDark: isDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 18),

                            // Monthly Budget Progress Card
                            AppFadeSlide(
                              delay: const Duration(milliseconds: 190),
                              child: _monthlyBudgetCard(
                                monthlyExpenses: monthlyExpenses,
                                isDark: isDark,
                                l10n: l10n,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Subscriptions & Recurring Bills Quick Access
                            AppFadeSlide(
                              delay: const Duration(milliseconds: 205),
                              child: InkWell(
                                onTap: () => context.push('/subscriptions'),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E2824) : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFF24332D) : Appcolors.lightGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.autorenew_rounded,
                                          color: Appcolors.primary,
                                          size: 19,
                                        ),
                                      ),
                                      const SizedBox(width: 13),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Subscriptions & Recurring Bills',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: isDark ? Colors.white : Appcolors.textDark,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Manage Netflix, Gym, Rent & renewals',
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Recent Transactions Header
                            AppFadeSlide(
                              delay: const Duration(milliseconds: 220),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      l10n.recentTransactions,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? Colors.white : Appcolors.textDark,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                  ),
                                  if (transactions.isNotEmpty) ...[
                                    Text(
                                      '${filteredTransactions.length} ${l10n.records}',
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFA1AFA9)
                                            : Appcolors.textMuted,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      tooltip: 'Export Statement (PDF & Excel)',
                                      onPressed: () => ExportStatementSheet.show(
                                        context,
                                        transactions: transactions,
                                        periodTitle: 'Transactions Statement',
                                      ),
                                      icon: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF1E352C)
                                              : Appcolors.lightGreen,
                                          borderRadius: BorderRadius.circular(9),
                                          border: Border.all(
                                            color: isDark
                                                ? const Color(0xFF274D3B)
                                                : const Color(0xFFCBEFDF),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.description_outlined,
                                          size: 16,
                                          color: Appcolors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Filter Chips
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _filterChip(HomeTransactionFilter.all, l10n.filterAll, isDark),
                                  _filterChip(
                                    HomeTransactionFilter.today,
                                    l10n.filterToday,
                                    isDark,
                                  ),
                                  _filterChip(
                                    HomeTransactionFilter.yesterday,
                                    l10n.filterYesterday,
                                    isDark,
                                  ),
                                  _filterChip(
                                    HomeTransactionFilter.thisWeek,
                                    l10n.filterThisWeek,
                                    isDark,
                                  ),
                                  _filterChip(
                                    HomeTransactionFilter.thisMonth,
                                    l10n.filterThisMonth,
                                    isDark,
                                  ),
                                  _filterChip(
                                    HomeTransactionFilter.expense,
                                    l10n.filterExpense,
                                    isDark,
                                  ),
                                  _filterChip(
                                    HomeTransactionFilter.income,
                                    l10n.filterIncome,
                                    isDark,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Day-wise Grouped Transactions or Empty state
                            if (filteredTransactions.isEmpty)
                              AppFadeSlide(
                                delay: const Duration(milliseconds: 260),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E2824) : Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF283631)
                                          : const Color(0xFFE9EFEC),
                                    ),
                                  ),
                                  child: const EmptyTransactionWidget(),
                                ),
                              )
                            else
                              AppFadeSlide(
                                delay: const Duration(milliseconds: 260),
                                child: Column(
                                  children: dayGroups.entries.take(7).map((entry) {
                                    final day = entry.key;
                                    final dayList = entry.value;

                                    final dayIncome = dayList
                                        .where((t) => t.type == TransactionType.income)
                                        .fold<double>(0, (sum, t) => sum + t.amount);
                                    final dayExpense = dayList
                                        .where((t) => t.type == TransactionType.expense)
                                        .fold<double>(0, (sum, t) => sum + t.amount);
                                    final dayNet = dayIncome - dayExpense;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 14),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E2824) : Colors.white,
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF283631)
                                              : const Color(0xFFE9EFEC),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: isDark ? 0.15 : 0.03,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Day header
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today_rounded,
                                                      size: 13,
                                                      color: isDark
                                                          ? const Color(0xFFA1AFA9)
                                                          : Appcolors.textMuted,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      _getDayGroupTitle(day, l10n),
                                                      style: TextStyle(
                                                        fontSize: 12.5,
                                                        fontWeight: FontWeight.w700,
                                                        color: isDark
                                                            ? Colors.white70
                                                            : Appcolors.textDark,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '${dayNet >= 0 ? '+' : '-'} ₹${dayNet.abs().toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w800,
                                                    color: dayNet >= 0
                                                        ? const Color(0xFF0BA874)
                                                        : const Color(0xFFE05A62),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: isDark
                                                ? const Color(0xFF283631)
                                                : const Color(0xFFF0F3F1),
                                          ),
                                          ListView.separated(
                                            itemCount: dayList.length,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 4,
                                            ),
                                            separatorBuilder: (_, _) => Divider(
                                              height: 1,
                                              indent: 62,
                                              color: isDark
                                                  ? const Color(0xFF283631)
                                                  : const Color(0xFFF0F3F1),
                                            ),
                                            itemBuilder: (context, index) {
                                              final transaction = dayList[index];
                                              return _transactionTile(transaction, isDark);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            const SizedBox(height: 20),
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

  List<TransactionModel> _applyFilter(List<TransactionModel> list) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final startOfWeek = today.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);

    switch (_activeFilter) {
      case HomeTransactionFilter.all:
        return list;
      case HomeTransactionFilter.today:
        return list.where((t) {
          final d = DateTime(t.date.year, t.date.month, t.date.day);
          return d.isAtSameMomentAs(today);
        }).toList();
      case HomeTransactionFilter.yesterday:
        return list.where((t) {
          final d = DateTime(t.date.year, t.date.month, t.date.day);
          return d.isAtSameMomentAs(yesterday);
        }).toList();
      case HomeTransactionFilter.thisWeek:
        return list.where((t) => !t.date.isBefore(startOfWeek)).toList();
      case HomeTransactionFilter.thisMonth:
        return list.where((t) => !t.date.isBefore(startOfMonth)).toList();
      case HomeTransactionFilter.expense:
        return list.where((t) => t.type == TransactionType.expense).toList();
      case HomeTransactionFilter.income:
        return list.where((t) => t.type == TransactionType.income).toList();
    }
  }

  Map<DateTime, List<TransactionModel>> _groupDayWise(List<TransactionModel> list) {
    final sorted = List<TransactionModel>.from(list)..sort((a, b) => b.date.compareTo(a.date));

    final groups = <DateTime, List<TransactionModel>>{};
    for (final tx in sorted) {
      final dayKey = DateTime(tx.date.year, tx.date.month, tx.date.day);
      groups.putIfAbsent(dayKey, () => []).add(tx);
    }
    return groups;
  }

  String _getDayGroupTitle(DateTime day, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (day.isAtSameMomentAs(today)) {
      return '${l10n.todayHeader} · ${DateFormat('dd MMM').format(day)}';
    } else if (day.isAtSameMomentAs(yesterday)) {
      return '${l10n.yesterdayHeader} · ${DateFormat('dd MMM').format(day)}';
    } else {
      return DateFormat('EEE, dd MMM yyyy').format(day);
    }
  }

  Widget _filterChip(HomeTransactionFilter filter, String label, bool isDark) {
    final isSelected = _activeFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _activeFilter = filter);
          }
        },
        selectedColor: isDark ? const Color(0xFF1E352C) : Appcolors.lightGreen,
        backgroundColor: isDark ? const Color(0xFF1E2824) : Colors.white,
        labelStyle: TextStyle(
          color: isSelected
              ? Appcolors.primary
              : (isDark ? const Color(0xFFA1AFA9) : Appcolors.textDark),
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? Appcolors.primary
                : (isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC)),
          ),
        ),
      ),
    );
  }

  Widget _monthlyBudgetCard({
    required double monthlyExpenses,
    required bool isDark,
    required AppLocalizations l10n,
  }) {
    return ListenableBuilder(
      listenable: BudgetService.instance,
      builder: (context, _) {
        final budget = BudgetService.instance.budgetLimit;
        final remaining = budget - monthlyExpenses;
        final isOver = remaining < 0;
        final progress = (budget > 0 ? (monthlyExpenses / budget) : 0.0).clamp(0.0, 1.0);
        final percent = ((monthlyExpenses / (budget > 0 ? budget : 1)) * 100).clamp(0, 999).toInt();

        final progressColor = isOver
            ? const Color(0xFFE05A62)
            : (progress > 0.8 ? const Color(0xFFF47A45) : Appcolors.primary);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2824) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isOver
                  ? const Color(0xFFE05A62).withValues(alpha: 0.35)
                  : (isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: progressColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: progressColor,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.monthlyBudget,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Appcolors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isOver
                              ? '${l10n.overBudget} by ₹${NumberFormat('#,##,###.##').format(remaining.abs())}'
                              : '₹${NumberFormat('#,##,###.##').format(remaining)} ${l10n.remaining.toLowerCase()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isOver
                                ? const Color(0xFFE05A62)
                                : (isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => MonthlyBudgetDialog.show(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161F1C) : const Color(0xFFF0F4F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? const Color(0xFF283631) : const Color(0xFFE0E5E2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 13,
                            color: isDark ? Colors.white70 : Appcolors.textDark,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.edit,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white70 : Appcolors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '₹${NumberFormat('#,##,###.##').format(monthlyExpenses)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Appcolors.textDark,
                      ),
                      children: [
                        TextSpan(
                          text: ' / ₹${NumberFormat('#,##,###').format(budget)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: progressColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  (IconData, String) _getTimeOfDayGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return (Icons.wb_sunny_rounded, 'Good Morning');
    } else if (hour >= 12 && hour < 17) {
      return (Icons.wb_sunny_outlined, 'Good Afternoon');
    } else if (hour >= 17 && hour < 21) {
      return (Icons.nights_stay_rounded, 'Good Evening');
    } else {
      return (Icons.bedtime_rounded, 'Hello');
    }
  }

  double _calculateGreetingFontSize(String name) {
    if (name.length > 25) return 18.0;
    if (name.length > 18) return 21.0;
    if (name.length > 12) return 24.0;
    return 27.0;
  }

  Widget _header(String name, bool isDark, AppLocalizations l10n) {
    final (timeIcon, timeGreeting) = _getTimeOfDayGreeting(l10n);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E352C)
                      : const Color(0xFFE8F8F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF284036)
                        : const Color(0xFFD6F0E4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(timeIcon, size: 12.5, color: Appcolors.primary),
                    const SizedBox(width: 5),
                    Text(
                      timeGreeting.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.9,
                        color: Appcolors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: _calculateGreetingFontSize(name),
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                        color: isDark ? Colors.white : Appcolors.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('👋', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                l10n.keepTrackCashflow,
                style: TextStyle(
                  fontSize: 12.5,
                  color:
                      isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final unread = state.unreadCount;

            return IconButton(
              onPressed: () => context.push('/notifications'),
              icon: Badge(
                isLabelVisible: unread > 0,
                label: Text(
                  unread > 9 ? '9+' : '$unread',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFFE05A62),
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2824) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF283631)
                          : const Color(0xFFE9EFEC),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    size: 21,
                    color: isDark ? Colors.white : Appcolors.textDark,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        IconButton(
          tooltip: 'AI Financial Assistant',
          onPressed: () => context.push('/chatbot'),
          icon: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Appcolors.primary, Color(0xFF077E57)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Appcolors.primary.withValues(alpha: 0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome,
                size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _balanceCard(double balance, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Appcolors.primary, Appcolors.darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Appcolors.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.totalBalance.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _hideBalance = !_hideBalance;
                  });
                },
                icon: Icon(
                  _hideBalance ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _hideBalance
              ? const Text(
                  '••••••••',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                )
              : AnimatedCurrencyText(
                  amount: balance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      balance >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      balance >= 0 ? 'Healthy' : 'Deficit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedCurrencyText(
              amount: amount,
              style: TextStyle(
                color: isDark ? Colors.white : Appcolors.textDark,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Total $title'.toLowerCase(),
            style: TextStyle(
              color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionTile(TransactionModel transaction, bool isDark) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? const Color(0xFF0BA874) : const Color(0xFFE05A62);

    final iconBgColor = isIncome
        ? (isDark ? const Color(0xFF1B3629) : const Color(0xFFE8F8F2))
        : (isDark ? const Color(0xFF381C1D) : const Color(0xFFFFF0F0));

    final iconBorderColor = isIncome
        ? (isDark ? const Color(0xFF274D3B) : const Color(0xFFCBEFDF))
        : (isDark ? const Color(0xFF4D2426) : const Color(0xFFFCDADA));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showTransactionDetailsModal(transaction, isDark),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: iconBorderColor),
                ),
                child: Icon(getCategoryIcon(transaction.category), color: amountColor, size: 22),
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
                            transaction.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white : Appcolors.textDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (transaction.autoDetected)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E352C) : Appcolors.lightGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'AUTO',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Appcolors.primary,
                              ),
                            ),
                          ),
                        if (transaction.receiptPath != null && transaction.receiptPath!.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF26332C) : const Color(0xFFE8F4EE),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.receipt_rounded, size: 10, color: Appcolors.primary),
                                SizedBox(width: 3),
                                Text(
                                  'BILL',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: Appcolors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
                          size: 11,
                          color: amountColor,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${categoryToString(transaction.category)} · '
                            '${formatTransactionDate(transaction.date)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${isIncome ? '+' : '-'} ₹${transaction.amount.toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: amountColor, fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTransactionDetailsModal(TransactionModel transaction, bool isDark) async {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? const Color(0xFF0BA874) : const Color(0xFFE05A62);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2824) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isIncome
                            ? (isDark ? const Color(0xFF1B3629) : const Color(0xFFE8F8F2))
                            : (isDark ? const Color(0xFF381C1D) : const Color(0xFFFFF0F0)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        getCategoryIcon(transaction.category),
                        color: amountColor,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  transaction.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : Appcolors.textDark,
                                  ),
                                ),
                              ),
                              if (transaction.autoDetected)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E352C) : Appcolors.lightGreen,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: const Text(
                                    'AUTO',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Appcolors.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatTransactionDate(transaction.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161F1C) : const Color(0xFFF7F9F8),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AMOUNT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                              color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${isIncome ? '+' : '-'} ₹${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: amountColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isIncome
                              ? (isDark ? const Color(0xFF1B3629) : const Color(0xFFE8F8F2))
                              : (isDark ? const Color(0xFF381C1D) : const Color(0xFFFFF0F0)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
                              size: 14,
                              color: amountColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isIncome ? 'Income' : 'Expense',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: amountColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _detailRow(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  value: categoryToString(transaction.category),
                  isDark: isDark,
                ),
                if (transaction.source.isNotEmpty)
                  _detailRow(
                    icon: Icons.account_balance_outlined,
                    label: 'Source',
                    value: transaction.source,
                    isDark: isDark,
                  ),
                if (transaction.receiptPath != null && transaction.receiptPath!.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Appcolors.primary.withValues(alpha: 0.12),
                        foregroundColor: Appcolors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      onPressed: () {
                        ReceiptViewerDialog.show(
                          context,
                          receiptPath: transaction.receiptPath!,
                          title: transaction.title,
                        );
                      },
                      icon: const Icon(Icons.receipt_long_rounded, size: 20),
                      label: const Text(
                        'View Attached Receipt / Bill',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                // Actions: Switch Type + Delete
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final newType = isIncome
                              ? TransactionType.expense
                              : TransactionType.income;
                          final updated = transaction.copyWith(type: newType);
                          await _firebaseServices.updateTransaction(transaction: updated);
                          if (bottomSheetContext.mounted) {
                            Navigator.pop(bottomSheetContext);
                          }
                          if (mounted) {
                            context.read<HomeBloc>().add(const fetchsmsTransactions());
                            AppSnackbar.success(
                              context,
                              'Changed to ${newType == TransactionType.income ? 'Income (+)' : 'Expense (-)'}',
                            );
                          }
                        },
                        icon: Icon(
                          isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                          size: 18,
                        ),
                        label: Text(
                          isIncome ? 'Switch to Expense' : 'Switch to Income',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isIncome ? const Color(0xFFE05A62) : Appcolors.primary,
                          side: BorderSide(
                            color: isIncome ? const Color(0xFFE05A62) : Appcolors.primary,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF0F0),
                        foregroundColor: const Color(0xFFE05A62),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.all(14),
                      ),
                      tooltip: 'Delete transaction',
                      icon: const Icon(Icons.delete_outline_rounded, size: 22),
                      onPressed: () => _confirmDeleteTransaction(bottomSheetContext, transaction),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Appcolors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteTransaction(
    BuildContext bottomSheetContext,
    TransactionModel transaction,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: Text(
          'Are you sure you want to delete "${transaction.title}" (₹${transaction.amount.toStringAsFixed(2)})?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE05A62)),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      await _firebaseServices.deleteTransaction(transactionId: transaction.id);
      if (bottomSheetContext.mounted) {
        Navigator.pop(bottomSheetContext);
      }
      if (mounted) {
        context.read<HomeBloc>().add(const fetchsmsTransactions());
        AppSnackbar.success(context, 'Transaction deleted');
      }
    }
  }
}
