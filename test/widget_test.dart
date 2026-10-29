import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/core/shared_widgets/animated_currency_text.dart';
import 'package:out_split_in/core/shared_widgets/animated_pulse_badge.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/core/theme/view_model/theme_bloc.dart';
import 'package:out_split_in/feature/category/model/category_item_model.dart';
import 'package:out_split_in/feature/category/widgets/category_card.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/widgets/auto_detect_card.dart';
import 'package:out_split_in/feature/home/widgets/empty_transaction_widget.dart';
import 'package:out_split_in/feature/notification/model/app_notification_model.dart';
import 'package:out_split_in/feature/notification/widgets/notification_tile.dart';
import 'package:out_split_in/feature/profile/widgets/theme_selector_modal.dart';

void main() {
  testWidgets('AutoDetectCard renders title and triggers onTap', (
    WidgetTester tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AutoDetectCard(
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Auto-detect UPI Payments'), findsOneWidget);
    expect(find.text('Enable'), findsOneWidget);

    await tester.tap(find.text('Enable'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('EmptyTransactionWidget displays empty state text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EmptyTransactionWidget())),
    );

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(
      find.text('Your income and expenses will appear here.'),
      findsOneWidget,
    );
  });

  testWidgets('AppFadeSlide renders child and animates in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppFadeSlide(
            child: Text('Fade slide content'),
          ),
        ),
      ),
    );

    expect(find.text('Fade slide content'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Fade slide content'), findsOneWidget);
  });

  testWidgets('AnimatedCurrencyText counts up and formats currency', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedCurrencyText(amount: 1500.00),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.textContaining('1,500.00'), findsOneWidget);
  });

  testWidgets('AnimatedPulseBadge renders label and icon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedPulseBadge(
            label: 'Auto-Sync Active',
            icon: Icons.bolt,
          ),
        ),
      ),
    );

    expect(find.text('Auto-Sync Active'), findsOneWidget);
    expect(find.byIcon(Icons.bolt), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('CategoryCard renders category name and type', (
    WidgetTester tester,
  ) async {
    const category = CategoryItemModel(
      id: 'test_food',
      name: 'Dining & Drinks',
      iconCodePoint: 0xe532,
      colorValue: 0xFFF47A45,
      type: TransactionType.expense,
      isCustom: true,
    );

    var deleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryCard(
            category: category,
            onDelete: () => deleted = true,
          ),
        ),
      ),
    );

    expect(find.text('Dining & Drinks'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pump();
    expect(deleted, isTrue);
  });

  testWidgets('NotificationTile renders title and body', (
    WidgetTester tester,
  ) async {
    final notif = AppNotificationModel(
      id: 'notif_1',
      title: 'UPI Transfer',
      body: '₹500.00 sent to Alice',
      timestamp: DateTime.now(),
      category: NotificationCategory.upiPayment,
      isRead: false,
    );

    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationTile(
            notification: notif,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('UPI Transfer'), findsOneWidget);
    expect(find.text('₹500.00 sent to Alice'), findsOneWidget);

    await tester.tap(find.text('UPI Transfer'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('ThemeSelectorModal displays theme options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create: (_) => ThemeBloc(),
            child: const ThemeSelectorModal(),
          ),
        ),
      ),
    );

    expect(find.text('Choose Theme'), findsOneWidget);
    expect(find.text('Light Theme'), findsOneWidget);
    expect(find.text('Dark Theme'), findsOneWidget);
    expect(find.text('System Default'), findsOneWidget);
  });
}
