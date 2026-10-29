import 'package:equatable/equatable.dart';

enum NotificationCategory { upiPayment, smsSync, budgetAlert, system }

class AppNotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationCategory category;
  final bool isRead;
  final double? amount;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.category,
    this.isRead = false,
    this.amount,
  });

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    NotificationCategory? category,
    bool? isRead,
    double? amount,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'category': category.name,
      'isRead': isRead,
      'amount': amount,
    };
  }

  factory AppNotificationModel.fromMap(Map<String, dynamic> map) {
    return AppNotificationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      category: NotificationCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => NotificationCategory.system,
      ),
      isRead: map['isRead'] ?? false,
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        timestamp,
        category,
        isRead,
        amount,
      ];
}
