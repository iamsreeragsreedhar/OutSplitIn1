import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:out_split_in/core/service_locator/di.dart';
import 'package:out_split_in/core/services/firebase_services.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/home/view_model/home/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/feature/subscriptions/model/subscription_model.dart';
import 'package:out_split_in/feature/subscriptions/services/subscription_service.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  static const Color primary = Color(0xFF0BA874);
  static const Color lightGreen = Color(0xFFE8F8F2);
  static const Color alertRed = Color(0xFFE05A62);
  static const Color alertOrange = Color(0xFFE88B2A);
  static const Color textDark = Color(0xFF18231F);
  static const Color textMuted = Color(0xFF84918B);

  late final SubscriptionService _subscriptionService;
  late final FirebaseServices _firebaseServices;

  List<SubscriptionModel> _subscriptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _subscriptionService = sl<SubscriptionService>();
    _firebaseServices = sl<FirebaseServices>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final list = await _subscriptionService.getSubscriptions();
    if (mounted) {
      setState(() {
        _subscriptions = list;
        _isLoading = false;
      });
    }
  }

  double get _totalMonthlyBurn {
    return _subscriptions
        .where((s) => s.isActive)
        .fold(0.0, (sum, s) => sum + s.monthlyEquivalent);
  }

  double get _totalYearlyBurn => _totalMonthlyBurn * 12;

  List<SubscriptionModel> get _upcomingRenewals {
    return _subscriptions
        .where((s) => s.isActive && s.daysUntilDue <= 7)
        .toList()
      ..sort((a, b) => a.daysUntilDue.compareTo(b.daysUntilDue));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121815) : const Color(0xFFF7F9F8),
      appBar: AppBar(
        title: Text(
          'Subscriptions & Bills',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? Colors.white : textDark,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Add Subscription',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E352C) : lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: primary, size: 22),
            ),
            onPressed: () => _openAddEditSheet(isDark),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : RefreshIndicator(
              color: primary,
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Burn Overview Card
                    AppFadeSlide(
                      direction: SlideDirection.fromTop,
                      child: _buildCommitmentCard(isDark, currencyFormat),
                    ),

                    const SizedBox(height: 24),

                    // Upcoming Renewals (Due within 7 days)
                    if (_upcomingRenewals.isNotEmpty) ...[
                      _sectionTitle('UPCOMING BILLS (NEXT 7 DAYS)', isDark),
                      const SizedBox(height: 10),
                      ..._upcomingRenewals.map(
                        (sub) => AppFadeSlide(
                          delay: const Duration(milliseconds: 100),
                          child: _buildUpcomingCard(sub, isDark, currencyFormat),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // All Active Subscriptions
                    _sectionTitle('ACTIVE SUBSCRIPTIONS (${_subscriptions.where((s) => s.isActive).length})', isDark),
                    const SizedBox(height: 10),

                    if (_subscriptions.isEmpty)
                      _buildEmptyState(isDark)
                    else
                      ..._subscriptions.map(
                        (sub) => AppFadeSlide(
                          delay: const Duration(milliseconds: 120),
                          child: _buildSubscriptionTile(sub, isDark, currencyFormat),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: isDark ? const Color(0xFFA1AFA9) : textMuted,
      ),
    );
  }

  Widget _buildCommitmentCard(bool isDark, NumberFormat format) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E352C), const Color(0xFF15261F)]
              : [const Color(0xFF0BA874), const Color(0xFF087F59)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Recurring Burn',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_subscriptions.where((s) => s.isActive).length} Active',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            format.format(_totalMonthlyBurn),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  'Approx. ${format.format(_totalYearlyBurn)} / year',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(
    SubscriptionModel sub,
    bool isDark,
    NumberFormat format,
  ) {
    Color badgeColor;
    String badgeText;

    if (sub.isOverdue) {
      badgeColor = alertRed;
      badgeText = 'Overdue by ${sub.daysUntilDue.abs()}d';
    } else if (sub.isDueToday) {
      badgeColor = alertRed;
      badgeText = 'Due Today!';
    } else {
      badgeColor = alertOrange;
      badgeText = 'Due in ${sub.daysUntilDue}d';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          _categoryIcon(sub.category, isDark),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sub.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${format.format(sub.amount)} • ${DateFormat('dd MMM yyyy').format(sub.nextDueDate)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFFA1AFA9) : textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: primary.withValues(alpha: 0.14),
              foregroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () => _confirmMarkPaid(sub),
            child: const Text(
              'Mark Paid',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionTile(
    SubscriptionModel sub,
    bool isDark,
    NumberFormat format,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
        ),
      ),
      child: Row(
        children: [
          Opacity(
            opacity: sub.isActive ? 1.0 : 0.4,
            child: _categoryIcon(sub.category, isDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Opacity(
              opacity: sub.isActive ? 1.0 : 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sub.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF26332C) : lightGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          sub.cycle.displayName,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Renews ${DateFormat('dd MMM').format(sub.nextDueDate)} • ${format.format(sub.amount)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFFA1AFA9) : textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: isDark ? const Color(0xFFA1AFA9) : textMuted,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (value) {
              if (value == 'pay') {
                _confirmMarkPaid(sub);
              } else if (value == 'toggle') {
                _toggleActive(sub);
              } else if (value == 'edit') {
                _openAddEditSheet(isDark, existing: sub);
              } else if (value == 'delete') {
                _deleteSubscription(sub);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pay',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: primary, size: 20),
                    SizedBox(width: 10),
                    Text('Mark as Paid'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      sub.isActive ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(sub.isActive ? 'Pause' : 'Activate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, color: alertRed, size: 20),
                    SizedBox(width: 10),
                    Text('Delete', style: TextStyle(color: alertRed)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryIcon(String category, bool isDark) {
    IconData icon;
    switch (category.toLowerCase()) {
      case 'entertainment':
      case 'streaming':
        icon = Icons.movie_outlined;
        break;
      case 'utilities':
      case 'bills':
      case 'broadband':
        icon = Icons.wifi_rounded;
        break;
      case 'fitness':
      case 'gym':
        icon = Icons.fitness_center_rounded;
        break;
      case 'software':
      case 'cloud':
        icon = Icons.cloud_outlined;
        break;
      case 'housing':
      case 'rent':
        icon = Icons.home_outlined;
        break;
      default:
        icon = Icons.autorenew_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF26332C) : lightGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: primary, size: 22),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.autorenew_rounded,
            size: 54,
            color: isDark ? const Color(0xFF2E3E37) : const Color(0xFFD4DFDA),
          ),
          const SizedBox(height: 14),
          Text(
            'No Subscriptions Tracked Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Keep track of recurring bills like Netflix, Gym, Rent, Wi-Fi, and software services.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFFA1AFA9) : textMuted,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => _openAddEditSheet(isDark),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Your First Subscription'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmMarkPaid(SubscriptionModel sub) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark Bill as Paid?'),
        content: Text(
          'This will record a ₹${sub.amount.toStringAsFixed(0)} expense in OutSplitIn for "${sub.name}" and advance the next due date by 1 ${sub.cycle.displayName.toLowerCase()}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Mark Paid'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _subscriptionService.markAsPaid(
        subscription: sub,
        firebaseServices: _firebaseServices,
      );
      if (mounted) {
        context.read<HomeBloc>().add(const fetchsmsTransactions());
        AppSnackbar.success(context, 'Marked "${sub.name}" as paid!');
        await _loadData();
      }
    }
  }

  Future<void> _toggleActive(SubscriptionModel sub) async {
    await _subscriptionService.toggleSubscriptionStatus(sub.id);
    if (mounted) {
      AppSnackbar.info(
        context,
        sub.isActive ? 'Paused "${sub.name}"' : 'Activated "${sub.name}"',
      );
      await _loadData();
    }
  }

  Future<void> _deleteSubscription(SubscriptionModel sub) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Subscription?'),
        content: Text('Are you sure you want to delete "${sub.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: alertRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _subscriptionService.deleteSubscription(sub.id);
      if (mounted) {
        AppSnackbar.info(context, 'Deleted "${sub.name}"');
        await _loadData();
      }
    }
  }

  void _openAddEditSheet(bool isDark, {SubscriptionModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddEditSubscriptionModal(
        isDark: isDark,
        existing: existing,
        onSave: (saved) async {
          await _subscriptionService.saveSubscription(saved);
          if (mounted) {
            AppSnackbar.success(
              context,
              existing != null
                  ? 'Updated "${saved.name}"'
                  : 'Added "${saved.name}"',
            );
            await _loadData();
          }
        },
      ),
    );
  }
}

class _AddEditSubscriptionModal extends StatefulWidget {
  final bool isDark;
  final SubscriptionModel? existing;
  final ValueChanged<SubscriptionModel> onSave;

  const _AddEditSubscriptionModal({
    required this.isDark,
    this.existing,
    required this.onSave,
  });

  @override
  State<_AddEditSubscriptionModal> createState() => _AddEditSubscriptionModalState();
}

class _AddEditSubscriptionModalState extends State<_AddEditSubscriptionModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  SubscriptionCycle _cycle = SubscriptionCycle.monthly;
  String _category = 'Entertainment';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));

  final List<String> _categories = [
    'Entertainment',
    'Utilities',
    'Fitness',
    'Software',
    'Housing',
    'Bills',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _amountController = TextEditingController(
      text: widget.existing != null ? widget.existing!.amount.toStringAsFixed(0) : '',
    );
    _notesController = TextEditingController(text: widget.existing?.notes ?? '');
    if (widget.existing != null) {
      _cycle = widget.existing!.cycle;
      _category = widget.existing!.category;
      _dueDate = widget.existing!.nextDueDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? const Color(0xFF1E2824) : Colors.white;
    const textDark = Color(0xFF18231F);
    final textColor = widget.isDark ? Colors.white : textDark;
    const primary = Color(0xFF0BA874);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.existing != null ? 'Edit Subscription' : 'Add New Subscription',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 18),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Subscription / Bill Name',
                  hintText: 'e.g. Netflix, Spotify, Gym, Broadband',
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter subscription name'
                    : null,
              ),

              const SizedBox(height: 14),

              // Amount & Cycle
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      decoration: InputDecoration(
                        labelText: 'Amount (₹)',
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      validator: (val) {
                        final parsed = double.tryParse(val?.trim() ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Valid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<SubscriptionCycle>(
                      initialValue: _cycle,
                      decoration: InputDecoration(
                        labelText: 'Cycle',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      items: SubscriptionCycle.values
                          .map((c) => DropdownMenuItem(value: c, child: Text(c.displayName)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _cycle = val);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),

              const SizedBox(height: 14),

              // Next Due Date
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                  );
                  if (picked != null) {
                    setState(() => _dueDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_rounded, color: primary),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Next Renewal / Due Date',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            DateFormat('dd MMMM yyyy').format(_dueDate),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final amount = double.parse(_amountController.text.trim());
                    final sub = SubscriptionModel(
                      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text.trim(),
                      amount: amount,
                      cycle: _cycle,
                      nextDueDate: _dueDate,
                      category: _category,
                      notes: _notesController.text.trim().isNotEmpty
                          ? _notesController.text.trim()
                          : null,
                      isActive: widget.existing?.isActive ?? true,
                    );
                    widget.onSave(sub);
                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.existing != null ? 'Save Changes' : 'Add Subscription',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
