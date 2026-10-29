import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetService extends ChangeNotifier {
  static const String _prefKey = 'user_monthly_budget_limit';
  static const double defaultBudget = 25000.0;

  double _budgetLimit = defaultBudget;

  double get budgetLimit => _budgetLimit;

  static final BudgetService instance = BudgetService._internal();

  BudgetService._internal() {
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getDouble(_prefKey);
      if (saved != null && saved > 0) {
        _budgetLimit = saved;
        notifyListeners();
      }

      // Sync from Firestore if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists && doc.data()?.containsKey('monthlyBudget') == true) {
          final cloudBudget = (doc.data()!['monthlyBudget'] as num?)?.toDouble();
          if (cloudBudget != null && cloudBudget > 0) {
            _budgetLimit = cloudBudget;
            await prefs.setDouble(_prefKey, cloudBudget);
            notifyListeners();
          }
        }
      }
    } catch (_) {}
  }

  Future<void> setBudget(double newLimit) async {
    if (newLimit <= 0 || _budgetLimit == newLimit) return;
    _budgetLimit = newLimit;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_prefKey, newLimit);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'monthlyBudget': newLimit}, SetOptions(merge: true));
      }
    } catch (_) {}
  }
}
