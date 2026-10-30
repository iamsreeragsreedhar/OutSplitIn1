import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/core/sms/sms_parser.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

void main() {
  const sender = 'HDFCBK';
  const smsId = 'test-1';
  final smsDate = DateTime(2026, 10, 11);

  TransactionModel? parse(String message, {String senderName = sender}) {
    return SmsParser.parse(
      body: message,
      sender: senderName,
      smsId: smsId,
      date: smsDate,
      message: message,
      smsDate: smsDate,
    );
  }

  group('SmsParser', () {
    test('debit SMS becomes expense and extracts amount/date', () {
      final result = parse(
        'Rs. 1,250.50 debited from your account on 09/10/2026 '
        'for purchase at Amazon. Transaction successful.',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 1250.50);
      expect(result.date, DateTime(2026, 10, 9));
      expect(result.title, 'Amazon');
      expect(result.category, TransactionCategory.shopping);
    });

    test('credit SMS becomes income', () {
      final result = parse(
        'INR 25,000 credited to your account as salary on 2026-10-01.',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.income);
      expect(result.amount, 25000);
      expect(result.date, DateTime(2026, 10, 1));
      expect(result.category, TransactionCategory.salary);
    });

    test('rupee symbol and food merchant are detected', () {
      final result = parse(
        'Your UPI payment of ₹320 to Zomato was successful.',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 320);
      expect(result.title, 'Zomato');
      expect(result.category, TransactionCategory.food);
    });

    test('fuel payment is categorized as transport', () {
      final result = parse('Rs 1500 paid at Indian Oil. Payment successful.');

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.category, TransactionCategory.transport);
    });

    test('Google Pay notification is correctly parsed', () {
      final result = parse(
        'Paid ₹250.00 to Swiggy. Completed • ₹250.00 paid from HDFC Bank',
        senderName: 'Google Pay',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 250.00);
      expect(result.title, 'Swiggy');
      expect(result.category, TransactionCategory.food);
    });

    test('PhonePe notification is correctly parsed', () {
      final result = parse(
        'Paid ₹180 to Starbucks Coffee',
        senderName: 'PhonePe',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 180);
      expect(result.category, TransactionCategory.food);
    });

    test('Paytm notification is correctly parsed', () {
      final result = parse(
        '₹120 paid to Sharma Store successfully',
        senderName: 'Paytm',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 120);
    });

    test('UPI Sent transfer is correctly detected', () {
      final result = parse(
        'Sent ₹500 to Rahul successfully',
        senderName: 'PhonePe',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 500);
      expect(result.category, TransactionCategory.transfer);
    });

    test('OTP is ignored', () {
      expect(parse('Your OTP is 123456. Do not share it.'), isNull);
    });

    test('promotional message is ignored', () {
      expect(
        parse('Special offer! Get cashback on your next purchase.'),
        isNull,
      );
    });

    test('failed payment is ignored', () {
      expect(parse('Your payment of Rs 500 to Amazon has failed.'), isNull);
    });

    test('pending payment is ignored', () {
      expect(parse('Your payment of Rs 500 is pending.'), isNull);
    });

    test('message without transaction direction is ignored', () {
      expect(parse('Your account balance is Rs 5000.'), isNull);
    });

    test('message without a currency-marked amount is ignored', () {
      expect(parse('Your account has been debited successfully.'), isNull);
    });

    test('SMS timestamp is used when transaction date is absent', () {
      final result = parse(
        'Rs 99 debited for a purchase at Amazon. Transaction successful.',
      );

      expect(result, isNotNull);
      expect(result!.date, smsDate);
    });

    test('Incoming money transfer "sent you" is recognized as income not expense', () {
      final result = parse(
        'Rahul sent you ₹500 on Google Pay. Transaction successful.',
        senderName: 'Google Pay',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.income);
      expect(result.amount, 500);
    });

    test('Transferred to your account is recognized as income', () {
      final result = parse(
        '₹1,200.00 transferred to your A/c XX4321 on 23-Oct-26. Clear balance is ₹15,000.',
        senderName: 'HDFC Bank',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.income);
      expect(result.amount, 1200);
    });

    test('Received from contact is recognized as income', () {
      final result = parse(
        'Received ₹750 from Anjali on PhonePe. Successful transaction.',
        senderName: 'PhonePe',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.income);
      expect(result.amount, 750);
    });

    test('Cashback credited is recognized as income', () {
      final result = parse(
        'Cashback of ₹50 credited to your account for UPI transaction.',
        senderName: 'CRED',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.income);
      expect(result.amount, 50);
    });

    test('Payment received notification is income with sender name not "view"', () {
      final result = parse(
        'Payment received: ₹1.00 from Geetha. Tap to view transaction.',
        senderName: 'Google Pay',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.income);
      expect(result.amount, 1.00);
      expect(result.title, 'Geetha');
      expect(result.title, isNot('view'));
      expect(result.category, TransactionCategory.transfer);
    });

    test('PhonePe Payment Received title with content is income and extracts sender', () {
      final result = parse(
        'Payment Received ₹1 from Geetha. View details.',
        senderName: 'PhonePe',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.income);
      expect(result.amount, 1.00);
      expect(result.title, 'Geetha');
      expect(result.title, isNot('view'));
    });

    test('Sending 1 rupee via SBI SMS with "Re. 1.00 debited" is expense (debit)', () {
      final result = parse(
        'Dear SBI User, your A/c ending 1234 debited by Re. 1.00 on 23-Oct-26 by transfer to Geetha Ref No 123456789. Bal: Rs. 500.00',
        senderName: 'SBI',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 1.00);
      expect(result.title, 'Geetha');
      expect(result.category, TransactionCategory.transfer);
    });

    test('Sending 1 rupee via "Re 1" format is parsed as expense', () {
      final result = parse(
        'Your A/c ending 1234 debited by Re 1 on 23-Oct-26 to Geetha',
        senderName: 'HDFCBK',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 1.00);
      expect(result.title, 'Geetha');
    });

    test('PhonePe outgoing "Transaction of ₹1 to Geetha was successful" is expense', () {
      final result = parse(
        'Transaction of ₹1 to Geetha was successful',
        senderName: 'PhonePe',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 1.00);
      expect(result.title, 'Geetha');
      expect(result.title, isNot(contains('was')));
    });

    test('Google Pay outgoing "Paid ₹1 to Geetha" is expense', () {
      final result = parse(
        'Paid ₹1 to Geetha',
        senderName: 'Google Pay',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 1.00);
      expect(result.title, 'Geetha');
    });

    test('Bank SMS with UPI reference string extracts recipient and amount', () {
      final result = parse(
        'A/c 1234 Debited for Re. 1.00 on 23-10-26. Info: UPI/329482123456/Geetha/HDFC. Bal Rs. 400',
        senderName: 'ICICI',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 1.00);
      expect(result.title, 'Geetha');
    });
    test('Federal Bank debit SMS via UPI extracts amount, date, and party', () {
      final result = parse(
        'Debited Rs 1.00 from a/c X8914 on 24Oct26 11:13 via UPI to SREERAG P S. Ref 629738664520.Bal Rs 15868.87. Not you?Call 18004251199 -Federal Bank',
        senderName: 'FEDBNK',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.expense);
      expect(result.amount, 1.00);
      expect(result.date, DateTime(2026, 10, 24));
      expect(result.title, 'Sreerag P S');
      expect(result.category, TransactionCategory.transfer);
      expect(result.source, 'Federal Bank');
    });

    test('Notification with "view ---" as candidate never sets title to "view ---"', () {
      final result = parse(
        'Payment received ₹100. Tap to view --- transaction details.',
        senderName: 'View ---',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.income);
      expect(result.amount, 100.0);
      expect(result.title, isNot(contains('view')));
      expect(result.title, isNot(contains('---')));
      expect(result.title, 'Received Payment');
    });
  });
}
