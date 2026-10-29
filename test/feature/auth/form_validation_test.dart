import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/core/shared_widgets/auth_textfield.dart';

void main() {
  group('Auth Form Validations', () {
    testWidgets('AuthTextField displays inline validation error when invalid', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  AuthTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    icon: Icons.email,
                    controller: controller,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Email is required'), findsNothing);

      // Trigger submit with empty field
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);

      // Now enter valid text
      await tester.enterText(find.byType(TextFormField), 'user@test.com');
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsNothing);
    });

    test('Email regex validation correctly identifies valid and invalid emails', () {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      // Valid emails
      expect(emailRegex.hasMatch('test@gmail.com'), isTrue);
      expect(emailRegex.hasMatch('john.doe@company.org'), isTrue);
      expect(emailRegex.hasMatch('user+tag@domain.co.in'), isTrue);

      // Invalid emails
      expect(emailRegex.hasMatch(''), isFalse);
      expect(emailRegex.hasMatch('invalid'), isFalse);
      expect(emailRegex.hasMatch('invalid@'), isFalse);
      expect(emailRegex.hasMatch('invalid@domain'), isFalse);
      expect(emailRegex.hasMatch('@domain.com'), isFalse);
      expect(emailRegex.hasMatch('test@.com'), isFalse);
    });

    test('Password validation enforces 6 characters minimum', () {
      String? validatePassword(String? val) {
        if (val == null || val.isEmpty) {
          return 'Please enter your password';
        }
        if (val.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      }

      expect(validatePassword(null), 'Please enter your password');
      expect(validatePassword(''), 'Please enter your password');
      expect(validatePassword('12345'), 'Password must be at least 6 characters');
      expect(validatePassword('123456'), isNull);
      expect(validatePassword('securePass123'), isNull);
    });

    test('Confirm password validator ensures equality', () {
      String? validateConfirmPassword(String? val, String original) {
        if (val == null || val.isEmpty) {
          return 'Please confirm your password';
        }
        if (val != original) {
          return 'Passwords do not match';
        }
        return null;
      }

      const original = 'secret123';
      expect(validateConfirmPassword(null, original), 'Please confirm your password');
      expect(validateConfirmPassword('', original), 'Please confirm your password');
      expect(validateConfirmPassword('wrong', original), 'Passwords do not match');
      expect(validateConfirmPassword(original, original), isNull);
    });
  });

  group('Transaction Amount Validations', () {
    String? validateAmount(String value) {
      final input = value.trim();

      if (input.isEmpty) return 'Please enter an amount';

      final normalized = input.replaceAll(',', '.');
      final amount = double.tryParse(normalized);

      if (amount == null || !amount.isFinite) {
        return 'Please enter a valid amount';
      }

      if (amount <= 0) return 'Amount must be greater than zero';

      if (amount > 100000000) {
        return 'Amount cannot exceed ₹100,000,000';
      }

      final dotIndex = normalized.indexOf('.');
      if (dotIndex != -1 && (normalized.length - dotIndex - 1) > 2) {
        return 'Amount can have at most 2 decimal places';
      }

      return null;
    }

    test('Validates empty and non-numeric inputs', () {
      expect(validateAmount(''), 'Please enter an amount');
      expect(validateAmount('   '), 'Please enter an amount');
      expect(validateAmount('abc'), 'Please enter a valid amount');
      expect(validateAmount('12.3.4'), 'Please enter a valid amount');
    });

    test('Validates zero and negative amounts', () {
      expect(validateAmount('0'), 'Amount must be greater than zero');
      expect(validateAmount('-50'), 'Amount must be greater than zero');
      expect(validateAmount('-0.01'), 'Amount must be greater than zero');
    });

    test('Accepts valid amounts and handles commas', () {
      expect(validateAmount('250'), isNull);
      expect(validateAmount('250.50'), isNull);
      expect(validateAmount('250,50'), isNull);
      expect(validateAmount('1000.00'), isNull);
    });

    test('Rejects more than 2 decimal places and excessive amounts', () {
      expect(validateAmount('25.999'), 'Amount can have at most 2 decimal places');
      expect(validateAmount('200000000'), 'Amount cannot exceed ₹100,000,000');
    });
  });

  group('Category Name Validations', () {
    String? validateCategory(String? value) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isEmpty) {
        return 'Please enter category name';
      }
      if (trimmed.length < 2) {
        return 'Name must be at least 2 characters';
      }
      if (trimmed.length > 30) {
        return 'Name cannot exceed 30 characters';
      }
      return null;
    }

    test('Validates category name length constraints', () {
      expect(validateCategory(null), 'Please enter category name');
      expect(validateCategory(''), 'Please enter category name');
      expect(validateCategory('   '), 'Please enter category name');
      expect(validateCategory('A'), 'Name must be at least 2 characters');
      expect(validateCategory('Groceries'), isNull);
      expect(
        validateCategory('A very long category name that exceeds thirty characters'),
        'Name cannot exceed 30 characters',
      );
    });
  });
}
