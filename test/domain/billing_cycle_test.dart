import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

void main() {
  const d = LocalDate.new;

  group('LocalDate', () {
    test('parse / toString round-trip', () {
      expect(LocalDate.parse('2026-02-09'), d(2026, 2, 9));
      expect(d(2026, 2, 9).toString(), '2026-02-09');
      expect(LocalDate.tryParse('nope'), isNull);
    });

    test('addDays crosses months, years and DST-free', () {
      expect(d(2026, 12, 31).addDays(1), d(2027, 1, 1));
      expect(d(2026, 3, 1).addDays(-1), d(2026, 2, 28));
      expect(d(2024, 3, 1).addDays(-1), d(2024, 2, 29));
    });

    test('daysUntil', () {
      expect(d(2026, 11, 4).daysUntil(d(2026, 11, 7)), 3);
      expect(d(2026, 11, 4).daysUntil(d(2026, 11, 1)), -3);
    });

    test('leap years', () {
      expect(LocalDate.isLeapYear(2024), isTrue);
      expect(LocalDate.isLeapYear(2026), isFalse);
      expect(LocalDate.isLeapYear(1900), isFalse);
      expect(LocalDate.isLeapYear(2000), isTrue);
    });
  });

  group('BillingCycle.occurrence', () {
    test('monthly on the 31st clamps to short months but returns to the 31st', () {
      const c = BillingCycle.monthly();
      final a = d(2026, 1, 31);
      expect(c.occurrence(a, 0), d(2026, 1, 31));
      expect(c.occurrence(a, 1), d(2026, 2, 28));
      expect(c.occurrence(a, 2), d(2026, 3, 31));
      expect(c.occurrence(a, 3), d(2026, 4, 30));
      expect(c.occurrence(a, 4), d(2026, 5, 31));
    });

    test('monthly on the 31st in a leap year gives Feb 29', () {
      expect(const BillingCycle.monthly().occurrence(d(2028, 1, 31), 1), d(2028, 2, 29));
    });

    test('yearly on Feb 29 → Feb 28 in common years, Feb 29 again in leap years', () {
      const c = BillingCycle.yearly();
      final a = d(2024, 2, 29);
      expect(c.occurrence(a, 1), d(2025, 2, 28));
      expect(c.occurrence(a, 2), d(2026, 2, 28));
      expect(c.occurrence(a, 4), d(2028, 2, 29));
    });

    test('every 3 months (quarterly)', () {
      const c = BillingCycle.quarterly();
      expect(c.occurrence(d(2026, 11, 30), 1), d(2027, 2, 28));
      expect(c.occurrence(d(2026, 11, 30), 2), d(2027, 5, 30));
    });

    test('every N days / weeks', () {
      expect(const BillingCycle(28, CycleUnit.day).occurrence(d(2026, 11, 4), 1), d(2026, 12, 2));
      expect(const BillingCycle(2, CycleUnit.week).occurrence(d(2026, 12, 25), 1), d(2027, 1, 8));
      expect(const BillingCycle.weekly().occurrence(d(2026, 11, 4), 3), d(2026, 11, 25));
    });

    test('every 2 years', () {
      expect(const BillingCycle(2, CycleUnit.year).occurrence(d(2026, 6, 15), 1), d(2028, 6, 15));
    });
  });

  group('BillingCycle.periodsPerMonth', () {
    test('year ÷ 12, week × 52 ÷ 12, day × 365 ÷ 12', () {
      expect(const BillingCycle.monthly().periodsPerMonth, 1);
      expect(const BillingCycle.quarterly().periodsPerMonth, closeTo(1 / 3, 1e-9));
      expect(const BillingCycle.yearly().periodsPerMonth, closeTo(1 / 12, 1e-9));
      expect(const BillingCycle.weekly().periodsPerMonth, closeTo(52 / 12, 1e-9));
      expect(const BillingCycle(28, CycleUnit.day).periodsPerMonth, closeTo(365 / 12 / 28, 1e-9));
    });
  });

  group('Money', () {
    test('minor units per currency', () {
      expect(currencyDecimals('VND'), 0);
      expect(currencyDecimals('usd'), 2);
      expect(currencyDecimals('KWD'), 3);
      expect(toMinorUnits(9.99, 'USD'), 999);
      expect(toMinorUnits(260000, 'VND'), 260000);
      expect(toMajorUnits(999, 'USD'), 9.99);
      expect(Money.major(1.005, 'KWD').minor, 1005);
    });
  });
}
