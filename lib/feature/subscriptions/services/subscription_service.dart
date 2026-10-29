import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:out_split_in/core/services/firebase_services.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/widgets/functions/function.dart';
import 'package:out_split_in/feature/subscriptions/model/subscription_model.dart';

class SubscriptionService {
  static const String _prefsKey = 'outsplitin_user_subscriptions';

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SubscriptionService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String? get _currentUserId => _auth.currentUser?.uid;

  /// Loads subscriptions from local cache first, then attempts Firestore sync
  Future<List<SubscriptionModel>> getSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final localJson = prefs.getString(_prefsKey);
    List<SubscriptionModel> subscriptions = [];

    if (localJson != null && localJson.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(localJson);
        subscriptions = list.map((item) => SubscriptionModel.fromMap(item)).toList();
      } catch (e) {
        debugPrint('Error parsing cached subscriptions: $e');
      }
    }

    final uid = _currentUserId;
    if (uid != null) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(uid)
            .collection('subscriptions')
            .get()
            .timeout(const Duration(seconds: 4));

        if (snapshot.docs.isNotEmpty) {
          subscriptions = snapshot.docs
              .map((doc) => SubscriptionModel.fromMap(doc.data()))
              .toList();
          // Update local cache
          await _saveToLocalCache(subscriptions);
        }
      } catch (e) {
        debugPrint('Firestore offline or failed to fetch subscriptions: $e');
      }
    }

    // Sort by due date (soonest first)
    subscriptions.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
    return subscriptions;
  }

  /// Adds or updates a subscription locally and in Firestore
  Future<void> saveSubscription(SubscriptionModel subscription) async {
    final current = await getSubscriptions();
    final index = current.indexWhere((s) => s.id == subscription.id);

    if (index >= 0) {
      current[index] = subscription;
    } else {
      current.add(subscription);
    }

    await _saveToLocalCache(current);

    final uid = _currentUserId;
    if (uid != null) {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('subscriptions')
            .doc(subscription.id)
            .set(subscription.toMap())
            .timeout(const Duration(seconds: 4));
      } catch (e) {
        debugPrint('Failed to save subscription to Firestore (cached locally): $e');
      }
    }
  }

  /// Deletes a subscription
  Future<void> deleteSubscription(String id) async {
    final current = await getSubscriptions();
    current.removeWhere((s) => s.id == id);
    await _saveToLocalCache(current);

    final uid = _currentUserId;
    if (uid != null) {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('subscriptions')
            .doc(id)
            .delete()
            .timeout(const Duration(seconds: 4));
      } catch (e) {
        debugPrint('Failed to delete subscription from Firestore: $e');
      }
    }
  }

  /// Toggles active status
  Future<void> toggleSubscriptionStatus(String id) async {
    final current = await getSubscriptions();
    final index = current.indexWhere((s) => s.id == id);
    if (index >= 0) {
      final updated = current[index].copyWith(isActive: !current[index].isActive);
      await saveSubscription(updated);
    }
  }

  /// Marks a subscription bill as paid:
  /// 1. Creates an expense TransactionModel and adds it to OutSplitIn transactions ledger
  /// 2. Advances nextDueDate to the next billing cycle
  Future<void> markAsPaid({
    required SubscriptionModel subscription,
    required FirebaseServices firebaseServices,
  }) async {
    // 1. Create OutSplitIn expense record
    final transaction = TransactionModel(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      smsId: '',
      type: TransactionType.expense,
      amount: subscription.amount,
      title: '${subscription.name} (Subscription)',
      source: 'Subscription Renewal',
      date: DateTime.now(),
      category: stringToCategory(subscription.category),
    );

    await firebaseServices.addTransaction(transaction: transaction);

    // 2. Advance next due date to next cycle
    final updated = subscription.copyWith(
      nextDueDate: subscription.nextCycleDate,
    );

    await saveSubscription(updated);
  }

  Future<void> _saveToLocalCache(List<SubscriptionModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(list.map((s) => s.toMap()).toList());
    await prefs.setString(_prefsKey, jsonStr);
  }
}
