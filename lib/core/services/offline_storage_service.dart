import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineStorageService {
  static const String _transactionsCacheKey = 'cached_offline_transactions';
  static const String _pendingSyncKey = 'pending_sync_transactions';

  /// Save full list of transactions into local disk cache
  Future<void> cacheTransactions(List<TransactionModel> transactions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = transactions.map((t) => t.toMap()).toList();
      final encoded = jsonEncode(jsonList);
      await prefs.setString(_transactionsCacheKey, encoded);
      debugPrint(
        'Successfully cached ${transactions.length} transactions locally.',
      );
    } catch (e) {
      debugPrint('Error caching transactions offline: $e');
    }
  }

  /// Retrieve cached transactions from local disk
  Future<List<TransactionModel>> getCachedTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_transactionsCacheKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map(
            (item) => TransactionModel.fromMap(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Error reading offline cached transactions: $e');
      return [];
    }
  }

  /// Add a single transaction into local cache immediately (optimistic UI & offline saving)
  Future<void> saveSingleTransactionLocally(
    TransactionModel transaction,
  ) async {
    try {
      final currentList = await getCachedTransactions();
      // Remove any existing with same id to prevent duplicate
      currentList.removeWhere((t) => t.id == transaction.id);
      currentList.insert(0, transaction);
      await cacheTransactions(currentList);
    } catch (e) {
      debugPrint('Error adding single transaction locally: $e');
    }
  }

  /// Delete a transaction from local cache
  Future<void> deleteTransactionLocally(String transactionId) async {
    try {
      final currentList = await getCachedTransactions();
      currentList.removeWhere((t) => t.id == transactionId);
      await cacheTransactions(currentList);
    } catch (e) {
      debugPrint('Error deleting transaction from local cache: $e');
    }
  }

  /// Save transaction to the pending sync queue (when offline)
  Future<void> savePendingSyncTransaction(TransactionModel transaction) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingList = await getPendingSyncTransactions();
      pendingList.removeWhere((t) => t.id == transaction.id);
      pendingList.insert(0, transaction);

      final jsonList = pendingList.map((t) => t.toMap()).toList();
      await prefs.setString(_pendingSyncKey, jsonEncode(jsonList));
      debugPrint(
        'Transaction queued for offline sync: ${transaction.id} (total pending: ${pendingList.length})',
      );

      // Also ensure it is saved in local cache so user immediately sees it
      await saveSingleTransactionLocally(transaction);
    } catch (e) {
      debugPrint('Error queuing pending sync transaction: $e');
    }
  }

  /// Retrieve all transactions waiting to be synced to cloud
  Future<List<TransactionModel>> getPendingSyncTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_pendingSyncKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map(
            (item) => TransactionModel.fromMap(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Error reading pending sync transactions: $e');
      return [];
    }
  }

  /// Remove a transaction from the pending sync queue after successful sync
  Future<void> removePendingSyncTransaction(String transactionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingList = await getPendingSyncTransactions();
      final initialCount = pendingList.length;
      pendingList.removeWhere((t) => t.id == transactionId);

      if (pendingList.length != initialCount) {
        final jsonList = pendingList.map((t) => t.toMap()).toList();
        await prefs.setString(_pendingSyncKey, jsonEncode(jsonList));
        debugPrint(
          'Removed transaction $transactionId from offline pending queue (${pendingList.length} remaining)',
        );
      }
    } catch (e) {
      debugPrint('Error removing pending sync transaction: $e');
    }
  }

  /// Clear the entire pending sync queue
  Future<void> clearPendingSyncTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingSyncKey);
    } catch (e) {
      debugPrint('Error clearing pending sync queue: $e');
    }
  }

  /// Get count of pending transactions awaiting sync
  Future<int> getPendingSyncCount() async {
    final list = await getPendingSyncTransactions();
    return list.length;
  }
}
