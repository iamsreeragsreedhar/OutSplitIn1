import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/feature/auth/widget/google_login_button.dart';

void main() {
  group('GoogleLoginButton Widget Tests', () {
    testWidgets('renders button text and Google custom icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleLoginButton(
              onPressed: () {},
              text: 'Continue with Google',
            ),
          ),
        ),
      );

      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('triggers onPressed when tapped', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleLoginButton(
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GoogleLoginButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('shows loading animation and ignores taps when isLoading is true', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleLoginButton(
              isLoading: true,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (w) => w.runtimeType.toString().contains('StaggeredDotsWave'),
        ),
        findsOneWidget,
      );
      expect(find.text('Continue with Google'), findsNothing);

      await tester.tap(find.byType(GoogleLoginButton));
      await tester.pump();

      expect(pressed, isFalse);
    });
  });
}
