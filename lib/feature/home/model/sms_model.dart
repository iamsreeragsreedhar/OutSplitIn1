enum PaymentTransactionType { income, expense, none }

class PaymentTransactionModel {
  final String id;
  final PaymentTransactionType type;
  final double amount;
  final String title;
  final String description;
  final String sender;
  final DateTime date;

  const PaymentTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.title,
    required this.description,
    required this.sender,
    required this.date,
  });
}
