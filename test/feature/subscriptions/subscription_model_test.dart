import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/feature/subscriptions/model/subscription_model.dart';

void main() {
  group('SubscriptionModel Tests', () {
    test('monthlyEquivalent calculates correct monthly burn rate', () {
      final monthly = SubscriptionModel(
        id: '1',
        name: 'Netflix',
        amount: 649,
        cycle: SubscriptionCycle.monthly,
        nextDueDate: DateTime.now().add(const Duration(days: 15)),
      );
      expect(monthly.monthlyEquivalent, equals(649.0));

      final quarterly = SubscriptionModel(
        id: '2',
        name: 'Gym',
        amount: 3000,
        cycle: SubscriptionCycle.quarterly,
        nextDueDate: DateTime.now().add(const Duration(days: 45)),
      );
      expect(quarterly.monthlyEquivalent, equals(1000.0));

      final yearly = SubscriptionModel(
        id: '3',
        name: 'Amazon Prime',
        amount: 1499,
        cycle: SubscriptionCycle.yearly,
        nextDueDate: DateTime.now().add(const Duration(days: 200)),
      );
      expect(yearly.monthlyEquivalent, closeTo(124.91, 0.01));

      final inactive = monthly.copyWith(isActive: false);
      expect(inactive.monthlyEquivalent, equals(0.0));
    });

    test('daysUntilDue and due flags work correctly', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final dueToday = SubscriptionModel(
        id: '1',
        name: 'Spotify',
        amount: 119,
        cycle: SubscriptionCycle.monthly,
        nextDueDate: today,
      );
      expect(dueToday.isDueToday, isTrue);
      expect(dueToday.daysUntilDue, equals(0));

      final dueIn2Days = SubscriptionModel(
        id: '2',
        name: 'Wi-Fi',
        amount: 999,
        cycle: SubscriptionCycle.monthly,
        nextDueDate: today.add(const Duration(days: 2)),
      );
      expect(dueIn2Days.isDueSoon, isTrue);
      expect(dueIn2Days.daysUntilDue, equals(2));

      final overdue = SubscriptionModel(
        id: '3',
        name: 'Rent',
        amount: 15000,
        cycle: SubscriptionCycle.monthly,
        nextDueDate: today.subtract(const Duration(days: 3)),
      );
      expect(overdue.isOverdue, isTrue);
      expect(overdue.daysUntilDue, equals(-3));
    });

    test('nextCycleDate calculates next billing cycle accurately', () {
      final date = DateTime(2026, 5, 10);

      final monthly = SubscriptionModel(
        id: '1',
        name: 'Netflix',
        amount: 499,
        cycle: SubscriptionCycle.monthly,
        nextDueDate: date,
      );
      expect(monthly.nextCycleDate, equals(DateTime(2026, 6, 10)));

      final yearly = SubscriptionModel(
        id: '2',
        name: 'Cloud',
        amount: 2500,
        cycle: SubscriptionCycle.yearly,
        nextDueDate: date,
      );
      expect(yearly.nextCycleDate, equals(DateTime(2027, 5, 10)));
    });

    test('Serialization roundtrip preserves all fields', () {
      final sub = SubscriptionModel(
        id: 'sub_123',
        name: 'GitHub Copilot',
        amount: 850.0,
        cycle: SubscriptionCycle.monthly,
        nextDueDate: DateTime(2026, 11, 15),
        category: 'Software',
        notes: 'Monthly dev tool',
        isActive: true,
        reminderDaysBefore: 3,
      );

      final map = sub.toMap();
      final restored = SubscriptionModel.fromMap(map);

      expect(restored.id, equals(sub.id));
      expect(restored.name, equals(sub.name));
      expect(restored.amount, equals(sub.amount));
      expect(restored.cycle, equals(sub.cycle));
      expect(restored.category, equals(sub.category));
      expect(restored.notes, equals(sub.notes));
      expect(restored.isActive, equals(sub.isActive));
    });
  });
}
