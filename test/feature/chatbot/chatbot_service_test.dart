import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/feature/chatbot/services/chatbot_service.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

void main() {
  group('ChatbotService Unit Tests', () {
    late ChatbotService service;

    final sampleTransactions = [
      TransactionModel(
        id: '1',
        smsId: 'sms_1',
        amount: 50000,
        type: TransactionType.income,
        category: TransactionCategory.salary,
        title: 'TechCorp Salary',
        source: 'HDFC',
        date: DateTime(2026, 10, 1),
      ),
      TransactionModel(
        id: '2',
        smsId: 'sms_2',
        amount: 1200,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        title: 'Zomato Biryani',
        source: 'GPay',
        date: DateTime(2026, 10, 5),
      ),
      TransactionModel(
        id: '3',
        smsId: 'sms_3',
        amount: 2500,
        type: TransactionType.expense,
        category: TransactionCategory.shopping,
        title: 'Zara Jeans',
        source: 'PhonePe',
        date: DateTime(2026, 10, 10),
      ),
    ];

    setUp(() {
      service = ChatbotService();
    });

    test('responds warmly to greetings', () async {
      final res = await service.generateResponse(
        prompt: 'Hi there',
        transactions: sampleTransactions,
        isConnected: true,
      );

      expect(res['text'], contains('OutSplitIn AI Financial Assistant'));
      expect(res['suggestions'], isNotEmpty);
    });

    test('calculates correct net balance and totals', () async {
      final res = await service.generateResponse(
        prompt: 'What is my current balance?',
        transactions: sampleTransactions,
        isConnected: true,
      );

      final text = res['text'] as String;
      expect(text, contains('Net Balance'));
      expect(text, contains('Total Income'));
      expect(text, contains('Total Expenses'));
      // 50000 - (1200 + 2500) = 46,300
      expect(text, contains('46,300'));
    });

    test('breaks down food expenses accurately', () async {
      final res = await service.generateResponse(
        prompt: 'How much did I spend on food?',
        transactions: sampleTransactions,
        isConnected: true,
      );

      final text = res['text'] as String;
      expect(text, contains('Food & Dining Expenses'));
      expect(text, contains('1,200'));
    });

    test('explains offline saving and auto-sync', () async {
      final res = await service.generateResponse(
        prompt: 'How does offline sync work?',
        transactions: sampleTransactions,
        isConnected: false,
      );

      final text = res['text'] as String;
      expect(text, contains('Offline Saving & Auto-Sync'));
      expect(text, contains('Offline Mode Active'));
    });

    test('explains UPI notification auto-detect', () async {
      final res = await service.generateResponse(
        prompt: 'Tell me about UPI detection',
        transactions: sampleTransactions,
        isConnected: true,
      );

      final text = res['text'] as String;
      expect(text, contains('UPI Auto-Detection'));
      expect(text, contains('Google Pay'));
    });

    test('provides financial saving tips', () async {
      final res = await service.generateResponse(
        prompt: 'Any budget advice or saving tips?',
        transactions: sampleTransactions,
        isConnected: true,
      );

      final text = res['text'] as String;
      expect(text, contains('50/30/20 Rule'));
      expect(text, contains('Emergency Fund'));
    });
  });
}
