import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/widgets/functions/function.dart';

void main() {
  group('Edit Transaction Logic & Model Tests', () {
    test('TransactionModel copyWith correctly edits all fields', () {
      final original = TransactionModel(
        id: 'tx_original_101',
        smsId: 'sms_123',
        amount: 250.0,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        title: 'Original Lunch',
        source: 'Federal Bank',
        sender: 'UPI',
        date: DateTime(2026, 10, 20),
        receiptPath: null,
      );

      // User edits amount, title, category, type, date, and adds a receipt
      final updatedDate = DateTime(2026, 10, 24);
      final edited = original.copyWith(
        amount: 320.75,
        title: 'Dinner with Colleagues',
        category: TransactionCategory.entertainment,
        type: TransactionType.expense,
        date: updatedDate,
        receiptPath: '/storage/emulated/0/receipts/bill_456.jpg',
      );

      // Verify original is unchanged
      expect(original.amount, equals(250.0));
      expect(original.title, equals('Original Lunch'));
      expect(original.category, equals(TransactionCategory.food));
      expect(original.receiptPath, isNull);

      // Verify edited has all new values
      expect(edited.id, equals(original.id));
      expect(edited.smsId, equals(original.smsId));
      expect(edited.amount, equals(320.75));
      expect(edited.title, equals('Dinner with Colleagues'));
      expect(edited.category, equals(TransactionCategory.entertainment));
      expect(edited.date, equals(updatedDate));
      expect(edited.receiptPath, equals('/storage/emulated/0/receipts/bill_456.jpg'));
    });

    test('Switching transaction type preserves non-type fields', () {
      final expense = TransactionModel(
        id: 'tx_switch_102',
        smsId: '',
        amount: 500.0,
        type: TransactionType.expense,
        category: TransactionCategory.shopping,
        title: 'Refund or return',
        source: 'HDFC Bank',
        sender: 'Amazon',
        date: DateTime(2026, 10, 25),
      );

      final convertedToIncome = expense.copyWith(type: TransactionType.income);

      expect(convertedToIncome.type, equals(TransactionType.income));
      expect(convertedToIncome.amount, equals(500.0));
      expect(convertedToIncome.title, equals('Refund or return'));
      expect(convertedToIncome.category, equals(TransactionCategory.shopping));
      expect(convertedToIncome.id, equals(expense.id));
    });

    test('Category string converters support all transaction categories', () {
      final categories = [
        TransactionCategory.salary,
        TransactionCategory.food,
        TransactionCategory.shopping,
        TransactionCategory.transport,
        TransactionCategory.bills,
        TransactionCategory.entertainment,
        TransactionCategory.health,
        TransactionCategory.transfer,
        TransactionCategory.other,
      ];

      for (final cat in categories) {
        final str = categoryToString(cat);
        expect(str, isNotEmpty);
        final restored = stringToCategory(str);
        expect(restored, equals(cat));
      }
    });

    test('Amount formatting handles integers and decimal precision for edit form', () {
      const intAmount = 500.0;
      final intFormatted = intAmount.toStringAsFixed(
        intAmount.truncateToDouble() == intAmount ? 0 : 2,
      );
      expect(intFormatted, equals('500'));

      const decAmount = 500.75;
      final decFormatted = decAmount.toStringAsFixed(
        decAmount.truncateToDouble() == decAmount ? 0 : 2,
      );
      expect(decFormatted, equals('500.75'));
    });
  });
}
