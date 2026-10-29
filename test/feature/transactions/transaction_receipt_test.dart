import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

void main() {
  group('TransactionModel Receipt Tests', () {
    test('TransactionModel stores, serializes and restores receiptPath', () {
      final tx = TransactionModel(
        id: 'tx_rec_001',
        smsId: '',
        amount: 320.50,
        type: TransactionType.expense,
        category: TransactionCategory.shopping,
        title: 'Grocery Bill',
        source: 'Card',
        date: DateTime(2026, 10, 20),
        receiptPath: '/data/user/0/in.outsplit.app/receipts/bill_123.jpg',
      );

      expect(tx.receiptPath, equals('/data/user/0/in.outsplit.app/receipts/bill_123.jpg'));

      final map = tx.toMap();
      expect(map['receiptPath'], equals('/data/user/0/in.outsplit.app/receipts/bill_123.jpg'));

      final restored = TransactionModel.fromMap(map);
      expect(restored.receiptPath, equals(tx.receiptPath));
    });

    test('copyWith updates or preserves receiptPath correctly', () {
      final tx = TransactionModel(
        id: 'tx_rec_002',
        smsId: '',
        amount: 150.0,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        title: 'Cafe Coffee',
        source: 'Cash',
        date: DateTime(2026, 10, 22),
      );

      expect(tx.receiptPath, isNull);

      final withReceipt = tx.copyWith(receiptPath: '/path/to/receipt.jpg');
      expect(withReceipt.receiptPath, equals('/path/to/receipt.jpg'));

      final updatedAmount = withReceipt.copyWith(amount: 180.0);
      expect(updatedAmount.receiptPath, equals('/path/to/receipt.jpg'));
      expect(updatedAmount.amount, equals(180.0));
    });
  });
}
