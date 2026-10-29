import 'package:out_split_in/feature/home/widgets/functions/function.dart';

enum TransactionType { income, expense }

enum TransactionCategory {
  salary,
  food,
  shopping,
  transport,
  bills,
  entertainment,
  health,
  transfer,
  other,
}

class TransactionModel {
  final String id;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final String title;
  final String source;
  final DateTime date;
  final bool autoDetected;
  final String? message;
  final String? sender;
  final String smsId;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.title,
    required this.source,
    required this.date,
    this.autoDetected = false,
    this.message,
    this.sender,
    required this.smsId,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    final typeStr = map['type']?.toString().toLowerCase() ?? '';
    final isIncome = typeStr == 'income' ||
        typeStr == 'credit' ||
        typeStr == 'cr' ||
        typeStr == 'credited';

    return TransactionModel(
      id: map['id'] ?? '',
      smsId: map['smsId'] ?? '',
      type: isIncome ? TransactionType.income : TransactionType.expense,
      amount: (map['amount'] as num).toDouble(),
      title: map['title'] ?? '',
      source: map['description'] ?? '',
      sender: map['sender'] ?? '',
      date: DateTime.parse(map['date']),
      autoDetected: map['autoDetected'] ?? false,
      category: stringToCategory(map['category'] ?? 'other'),
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    String? title,
    String? source,
    DateTime? date,
    bool? autoDetected,
    String? message,
    String? sender,
    String? smsId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      source: source ?? this.source,
      date: date ?? this.date,
      autoDetected: autoDetected ?? this.autoDetected,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      smsId: smsId ?? this.smsId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'smsId': smsId,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'amount': amount,
      'title': title,
      'description': source,
      'sender': sender,
      'date': date.toIso8601String(),
      'autoDetected': autoDetected,
      'category': category.toString().split('.').last,
    };
  }
}
