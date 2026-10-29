import 'package:flutter/material.dart';

import 'package:intl/intl.dart';


import 'package:out_split_in/feature/home/model/transation_model.dart';

TransactionCategory stringToCategory(String value) {
  final clean = value.toLowerCase().trim();
  if (clean.contains('salary')) return TransactionCategory.salary;
  if (clean.contains('food') ||
      clean.contains('dining') ||
      clean.contains('restaurant') ||
      clean.contains('cafe')) {
    return TransactionCategory.food;
  }
  if (clean.contains('shopping') ||
      clean.contains('grocery') ||
      clean.contains('market')) {
    return TransactionCategory.shopping;
  }
  if (clean.contains('transport') ||
      clean.contains('travel') ||
      clean.contains('trip') ||
      clean.contains('fuel') ||
      clean.contains('cab')) {
    return TransactionCategory.transport;
  }
  if (clean.contains('bill') ||
      clean.contains('utilities') ||
      clean.contains('recharge')) {
    return TransactionCategory.bills;
  }
  if (clean.contains('entertainment') ||
      clean.contains('movie') ||
      clean.contains('game')) {
    return TransactionCategory.entertainment;
  }
  if (clean.contains('health') ||
      clean.contains('fitness') ||
      clean.contains('gym') ||
      clean.contains('medical')) {
    return TransactionCategory.health;
  }
  if (clean.contains('transfer') ||
      clean.contains('freelance') ||
      clean.contains('investment')) {
    return TransactionCategory.transfer;
  }
  return TransactionCategory.other;
}

IconData getCategoryIcon(TransactionCategory category) {
  switch (category) {
    case TransactionCategory.salary:
      return Icons.account_balance_wallet;
    case TransactionCategory.food:
      return Icons.restaurant;
    case TransactionCategory.shopping:
      return Icons.shopping_bag_outlined;
    case TransactionCategory.transport:
      return Icons.directions_bus;
    case TransactionCategory.bills:
      return Icons.receipt_long;
    case TransactionCategory.entertainment:
      return Icons.sports_esports;
    case TransactionCategory.health:
      return Icons.favorite;
    case TransactionCategory.transfer:
      return Icons.swap_horiz;
    case TransactionCategory.other:
      return Icons.more_horiz;
  }
}

String categoryToString(TransactionCategory category) {
  switch (category) {
    case TransactionCategory.salary:
      return 'Salary';
    case TransactionCategory.food:
      return 'Food';
    case TransactionCategory.shopping:
      return 'Shopping';
    case TransactionCategory.transport:
      return 'Transport';
    case TransactionCategory.bills:
      return 'Bills';
    case TransactionCategory.entertainment:
      return 'Entertainment';
    case TransactionCategory.health:
      return 'Health';
    case TransactionCategory.transfer:
      return 'Transfer';
    case TransactionCategory.other:
      return 'Other';
  }
}

String formatTransactionDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final transactionDay = DateTime(date.year, date.month, date.day);

  final String dayLabel;

  if (transactionDay == today) {
    dayLabel = 'Today';
  } else if (transactionDay == today.subtract(const Duration(days: 1))) {
    dayLabel = 'Yesterday';
  } else {
    dayLabel = DateFormat('dd MMM').format(date);
  }

  return '$dayLabel, ${DateFormat('hh:mm a').format(date)}';
}
