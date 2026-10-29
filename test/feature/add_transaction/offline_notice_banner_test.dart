import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/feature/add_transaction/widgets/offline_notice_banner.dart';

void main() {
  group('OfflineNoticeBanner Widget Tests', () {
    testWidgets('renders SizedBox.shrink when connected', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OfflineNoticeBanner(isConnected: true),
          ),
        ),
      );

      expect(find.text('No Internet Connection'), findsNothing);
      expect(find.text('Offline Mode'), findsNothing);
    });

    testWidgets('renders warning banner and text when offline', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OfflineNoticeBanner(isConnected: false),
          ),
        ),
      );

      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.text('Offline Mode'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
    });

    testWidgets('triggers onRetry callback when retry button is tapped', (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfflineNoticeBanner(
              isConnected: false,
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      final retryFinder = find.byIcon(Icons.refresh_rounded);
      expect(retryFinder, findsOneWidget);

      await tester.tap(retryFinder);
      await tester.pump();

      expect(retried, isTrue);
    });
  });
}
