import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/core/sms/sms_parser.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

void main() {
  group('Total Balance Calculation & Credit/Debit Accuracy Tests', () {
    test('Credited transactions increase total balance, debited decrease total balance', () {
      final transactions = <TransactionModel>[];

      double calculateIncome(List<TransactionModel> txs) => txs
          .where((t) => t.type == TransactionType.income)
          .fold<double>(0, (sum, t) => sum + t.amount);

      double calculateExpenses(List<TransactionModel> txs) => txs
          .where((t) => t.type == TransactionType.expense)
          .fold<double>(0, (sum, t) => sum + t.amount);

      double calculateBalance(List<TransactionModel> txs) =>
          calculateIncome(txs) - calculateExpenses(txs);

      // 1. Initial state (0 balance)
      expect(calculateBalance(transactions), 0.0);
      expect(calculateIncome(transactions), 0.0);
      expect(calculateExpenses(transactions), 0.0);

      // 2. Add Credit (Income) of ₹1,000 (e.g. Salary credited)
      transactions.add(
        TransactionModel(
          id: 'tx_1',
          smsId: '',
          type: TransactionType.income,
          amount: 1000.0,
          title: 'Salary',
          source: 'HDFC',
          date: DateTime.now(),
          category: TransactionCategory.salary,
        ),
      );
      expect(calculateIncome(transactions), 1000.0);
      expect(calculateExpenses(transactions), 0.0);
      expect(calculateBalance(transactions), 1000.0);

      // 3. Add Debit (Expense) of ₹200 (e.g. Grocery spent)
      transactions.add(
        TransactionModel(
          id: 'tx_2',
          smsId: '',
          type: TransactionType.expense,
          amount: 200.0,
          title: 'Grocery',
          source: 'UPI',
          date: DateTime.now(),
          category: TransactionCategory.shopping,
        ),
      );
      expect(calculateIncome(transactions), 1000.0);
      expect(calculateExpenses(transactions), 200.0);
      expect(calculateBalance(transactions), 800.0); // 1000 - 200 = 800

      // 4. Add Credit (Income) of ₹500 (e.g. Friend paid back / received)
      transactions.add(
        TransactionModel(
          id: 'tx_3',
          smsId: '',
          type: TransactionType.income,
          amount: 500.0,
          title: 'Received from John',
          source: 'PhonePe',
          date: DateTime.now(),
          category: TransactionCategory.transfer,
        ),
      );
      expect(calculateIncome(transactions), 1500.0); // 1000 + 500
      expect(calculateExpenses(transactions), 200.0);
      expect(calculateBalance(transactions), 1300.0); // 1500 - 200 = 1300

      // 5. Add Debit (Expense) of ₹1,500 (e.g. Rent paid)
      transactions.add(
        TransactionModel(
          id: 'tx_4',
          smsId: '',
          type: TransactionType.expense,
          amount: 1500.0,
          title: 'Rent',
          source: 'Bank Transfer',
          date: DateTime.now(),
          category: TransactionCategory.bills,
        ),
      );
      expect(calculateIncome(transactions), 1500.0);
      expect(calculateExpenses(transactions), 1700.0); // 200 + 1500
      expect(calculateBalance(transactions), -200.0); // 1500 - 1700 = -200 (Deficit)
    });

    test('Real-world SMS & notification strings parse to the correct Credit (Income) or Debit (Expense) type', () {
      final testCases = [
        // Credits (Income)
        ('Your A/C *1234 is credited with INR 500.00 on 24-Oct-26', TransactionType.income, 500.0),
        ('Payment of Rs 100 received from Sreerag', TransactionType.income, 100.0),
        ('Payment of ₹1.00 received', TransactionType.income, 1.0),
        ('Received ₹750 from Anjali on PhonePe', TransactionType.income, 750.0),
        ('Rahul sent you ₹500 on Google Pay', TransactionType.income, 500.0),
        ('Cashback of ₹50 credited to your account', TransactionType.income, 50.0),
        ('Paid you ₹250 for dinner', TransactionType.income, 250.0),
        ('Dear UPI user A/C XXXXXX credited by 1.00 on 24-Oct-26', TransactionType.income, 1.0),

        // Debits (Expenses)
        ('Rs. 1,250.50 debited from your account on 09/10/2026 for purchase at Amazon', TransactionType.expense, 1250.5),
        ('Paid ₹250.00 to Swiggy on Google Pay', TransactionType.expense, 250.0),
        ('Paid ₹180 to Starbucks Coffee', TransactionType.expense, 180.0),
        ('Sent ₹500 to Rahul successfully', TransactionType.expense, 500.0),
        ('Your UPI payment of ₹320 to Zomato was successful', TransactionType.expense, 320.0),
        ('Transaction of ₹1 to Geetha was successful', TransactionType.expense, 1.0),
        ('Re. 1.00 debited from A/c XX1234 on 23-Oct-26', TransactionType.expense, 1.0),
      ];

      for (final (msg, expectedType, expectedAmount) in testCases) {
        final tx = SmsParser.parse(
          body: msg,
          message: msg,
          sender: 'TestBank',
          smsId: 'test_sms',
          date: DateTime.now(),
          smsDate: DateTime.now(),
        );

        expect(tx, isNotNull, reason: 'Failed to parse: "$msg"');
        expect(
          tx!.type,
          expectedType,
          reason: 'Expected ${expectedType.name.toUpperCase()} for message: "$msg", but got ${tx.type.name.toUpperCase()}',
        );
        expect(
          tx.amount,
          expectedAmount,
          reason: 'Expected amount $expectedAmount for message: "$msg", but got ${tx.amount}',
        );
      }
    });

    test('Serialization roundtrip preserves TransactionType.income and TransactionType.expense', () {
      final incomeTx = TransactionModel(
        id: 'inc_1',
        smsId: 'sms_1',
        type: TransactionType.income,
        amount: 250.0,
        title: 'Salary Advance',
        source: 'Company',
        date: DateTime(2026, 10, 24),
        category: TransactionCategory.salary,
      );

      final expenseTx = TransactionModel(
        id: 'exp_1',
        smsId: 'sms_2',
        type: TransactionType.expense,
        amount: 80.0,
        title: 'Coffee',
        source: 'UPI',
        date: DateTime(2026, 10, 24),
        category: TransactionCategory.food,
      );

      final incomeMap = incomeTx.toMap();
      final expenseMap = expenseTx.toMap();

      expect(incomeMap['type'], 'income');
      expect(expenseMap['type'], 'expense');

      final incomeRestored = TransactionModel.fromMap(incomeMap);
      final expenseRestored = TransactionModel.fromMap(expenseMap);

      expect(incomeRestored.type, TransactionType.income);
      expect(incomeRestored.amount, 250.0);

      expect(expenseRestored.type, TransactionType.expense);
      expect(expenseRestored.amount, 80.0);
    });
  });
}
