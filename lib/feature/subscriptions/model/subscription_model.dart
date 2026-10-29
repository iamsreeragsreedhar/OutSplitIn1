enum SubscriptionCycle {
  weekly,
  monthly,
  quarterly,
  yearly;

  String get displayName {
    switch (this) {
      case SubscriptionCycle.weekly:
        return 'Weekly';
      case SubscriptionCycle.monthly:
        return 'Monthly';
      case SubscriptionCycle.quarterly:
        return 'Quarterly';
      case SubscriptionCycle.yearly:
        return 'Yearly';
    }
  }

  static SubscriptionCycle fromString(String val) {
    return SubscriptionCycle.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => SubscriptionCycle.monthly,
    );
  }
}

class SubscriptionModel {
  final String id;
  final String name;
  final double amount;
  final SubscriptionCycle cycle;
  final DateTime nextDueDate;
  final String category;
  final String? notes;
  final bool isActive;
  final int reminderDaysBefore;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.cycle,
    required this.nextDueDate,
    this.category = 'Bills',
    this.notes,
    this.isActive = true,
    this.reminderDaysBefore = 2,
  });

  /// Monthly cost equivalent for unified budgeting calculations
  double get monthlyEquivalent {
    if (!isActive) return 0.0;
    switch (cycle) {
      case SubscriptionCycle.weekly:
        return amount * 4.33;
      case SubscriptionCycle.monthly:
        return amount;
      case SubscriptionCycle.quarterly:
        return amount / 3;
      case SubscriptionCycle.yearly:
        return amount / 12;
    }
  }

  /// Days remaining until the next billing date
  int get daysUntilDue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);
    return due.difference(today).inDays;
  }

  bool get isDueToday => daysUntilDue == 0;
  bool get isDueSoon => daysUntilDue > 0 && daysUntilDue <= 3;
  bool get isOverdue => daysUntilDue < 0;

  DateTime get nextCycleDate {
    switch (cycle) {
      case SubscriptionCycle.weekly:
        return nextDueDate.add(const Duration(days: 7));
      case SubscriptionCycle.monthly:
        return DateTime(
          nextDueDate.year,
          nextDueDate.month + 1,
          nextDueDate.day,
        );
      case SubscriptionCycle.quarterly:
        return DateTime(
          nextDueDate.year,
          nextDueDate.month + 3,
          nextDueDate.day,
        );
      case SubscriptionCycle.yearly:
        return DateTime(
          nextDueDate.year + 1,
          nextDueDate.month,
          nextDueDate.day,
        );
    }
  }

  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? amount,
    SubscriptionCycle? cycle,
    DateTime? nextDueDate,
    String? category,
    String? notes,
    bool? isActive,
    int? reminderDaysBefore,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      cycle: cycle ?? this.cycle,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'cycle': cycle.name,
      'nextDueDate': nextDueDate.toIso8601String(),
      'category': category,
      if (notes != null) 'notes': notes,
      'isActive': isActive,
      'reminderDaysBefore': reminderDaysBefore,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      cycle: SubscriptionCycle.fromString(map['cycle'] ?? 'monthly'),
      nextDueDate: map['nextDueDate'] != null
          ? DateTime.parse(map['nextDueDate'])
          : DateTime.now(),
      category: map['category'] ?? 'Bills',
      notes: map['notes'],
      isActive: map['isActive'] ?? true,
      reminderDaysBefore: map['reminderDaysBefore'] ?? 2,
    );
  }
}
