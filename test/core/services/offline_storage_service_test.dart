import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/core/services/offline_storage_service.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OfflineStorageService Pending Sync Tests', () {
    late OfflineStorageService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = OfflineStorageService();
    });

    final testTxn = TransactionModel(
      id: 'txn_offline_123',
      smsId: 'sms_123',
      amount: 450.0,
      type: TransactionType.expense,
      category: TransactionCategory.food,
      title: 'Cafe Coffee Day',
      source: 'Offline Entry',
      date: DateTime(2026, 10, 23),
    );

    test('queues and retrieves pending sync transactions', () async {
      await service.savePendingSyncTransaction(testTxn);

      final pending = await service.getPendingSyncTransactions();
      expect(pending.length, 1);
      expect(pending.first.id, 'txn_offline_123');
      expect(pending.first.amount, 450.0);
      expect(pending.first.title, 'Cafe Coffee Day');

      final count = await service.getPendingSyncCount();
      expect(count, 1);
    });

    test('removes pending transaction upon cloud sync completion', () async {
      await service.savePendingSyncTransaction(testTxn);
      expect(await service.getPendingSyncCount(), 1);

      await service.removePendingSyncTransaction('txn_offline_123');
      final remaining = await service.getPendingSyncTransactions();
      expect(remaining, isEmpty);
      expect(await service.getPendingSyncCount(), 0);
    });

    test('clears entire pending sync queue', () async {
      await service.savePendingSyncTransaction(testTxn);
      final testTxn2 = testTxn.copyWith(id: 'txn_offline_456');
      await service.savePendingSyncTransaction(testTxn2);

      expect(await service.getPendingSyncCount(), 2);

      await service.clearPendingSyncTransactions();
      expect(await service.getPendingSyncCount(), 0);
    });
  });
}
