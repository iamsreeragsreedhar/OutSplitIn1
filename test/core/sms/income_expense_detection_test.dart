import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/core/sms/sms_parser.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

void main() {
  TransactionModel? parse(String message, {String sender = 'Google Pay'}) {
    return SmsParser.parse(
      body: message,
      sender: sender,
      smsId: 'test-1',
      date: DateTime.now(),
      message: message,
      smsDate: DateTime.now(),
    );
  }

  group('Incoming variations', () {
    final incomingMessages = [
      'Payment of Rs 100 received from Sreerag',
      'Payment of ₹100 from Sreerag received',
      'Payment of ₹1.00 received',
      'Payment received Rs 100 from Sreerag',
      'Money received: Rs 100 from Sreerag',
      'You received ₹100 from Sreerag',
      'Received ₹100 from Sreerag',
      'Received Rs 100 on PhonePe from Ramesh',
      'Payment received: ₹100 from Ramesh',
      'Received payment of ₹100 from Ramesh',
      'Ramesh sent you ₹100',
      'Paid you ₹100',
      '₹100 credited to your account',
      'A/c *1234 credited by Rs. 100 on 24-Oct-26 by transfer from Ramesh',
      'Dear UPI user A/C XXXXXX credited by 1.00 on 24-Oct-26 by (UPI Ref no 123456)',
      'Your A/C *1234 is credited with INR 1.00 on 24-Oct-26. Info: UPI/Geetha/Paid by Geetha',
      'Received ₹500 via UPI payment from John',
      'Payment of ₹500 received for order #123',
    ];

    for (final msg in incomingMessages) {
      test('Test: $msg', () {
        final tx = parse(msg);
        expect(tx, isNotNull, reason: 'Failed to parse: "$msg"');
        expect(
          tx!.type,
          TransactionType.income,
          reason: 'Message was wrongly parsed as ${tx.type.name.toUpperCase()}: "$msg"',
        );
      });
    }
  });
}
