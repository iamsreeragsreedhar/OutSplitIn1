import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/feature/chatbot/model/chat_message_model.dart';
import 'package:out_split_in/feature/chatbot/widgets/chat_message_bubble.dart';

void main() {
  group('ChatMessageBubble Widget Tests', () {
    testWidgets('renders user message bubble on right without bot avatar', (tester) async {
      final msg = ChatMessageModel(
        id: '1',
        text: 'What is my total spending?',
        isUser: true,
        timestamp: DateTime(2026, 10, 23, 14, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatMessageBubble(message: msg, isDark: false),
          ),
        ),
      );

      expect(find.text('What is my total spending?'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsNothing);
      expect(find.byIcon(Icons.copy_rounded), findsNothing);
    });

    testWidgets('renders bot message bubble with assistant avatar and copy icon', (tester) async {
      final msg = ChatMessageModel(
        id: '2',
        text: 'Your net balance is ₹45,000.',
        isUser: false,
        timestamp: DateTime(2026, 10, 23, 14, 31),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatMessageBubble(message: msg, isDark: true),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('Your net balance is ₹45,000.'),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
    });
  });
}
