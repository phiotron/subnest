import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/rates/fallback_rates.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/domain/stats/calendar_month.dart';
import 'package:subnest/domain/stats/insights_stats.dart';

import 'fixtures.dart';

/// Decision 2026-11-10 #10 (like A002 D-029): exact cross rates, every line rounded half-up to
/// the smallest unit of the Primary currency, every total = sum of the rounded lines.
void main() {
  const today = LocalDate(2026, 11, 4);
  const fallback = ExchangeRates(usdRates: fallbackUsdRates);

  group('Ratio', () {
    test('keeps the decimal a rate was written as, digit for digit', () {
      expect(Ratio.fromDouble(25769.065289), Ratio(BigInt.from(25769065289), BigInt.from(1000000)));
      expect(Ratio.fromDouble(0.0000394), Ratio.ints(394, 10000000));
      expect(Ratio.fromDouble(1e-7), Ratio.ints(1, 10000000));
      expect(Ratio.fromDouble(26000), Ratio.ints(26000));
      expect(Ratio.tryParse('1/3'), Ratio.ints(1, 3));
      expect(Ratio.tryParse('3.85e-5'), Ratio.ints(385, 10000000));
      expect(Ratio.tryParse('0'), isNull);
      expect(Ratio.tryParse('abc'), isNull);
      expect(Ratio.fromDouble(0), isNull);
      expect(Ratio.fromDouble(double.nan), isNull);
    });

    test('rounds half away from zero', () {
      expect(roundHalfUp(BigInt.from(5), BigInt.from(10)), 1);
      expect(roundHalfUp(BigInt.from(49), BigInt.from(100)), 0);
      expect(roundHalfUp(BigInt.from(-5), BigInt.from(10)), -1);
      expect(roundHalfUp(BigInt.from(15), BigInt.from(10)), 2);
    });
  });

  group('exact cross rates', () {
    const codes = ['USD', 'VND', 'JPY', 'EUR', 'KWD', 'BHD', 'GBP', 'IDR'];

    test('A→B and B→A with the same table are exact inverses (bundled table)', () {
      for (final a in codes) {
        for (final b in codes) {
          expect(fallback.exactRate(a, b)! * fallback.exactRate(b, a)!, Ratio.one, reason: '$a↔$b');
        }
      }
      expect(fallback.exactRate('USD', 'VND'), Ratio.tryParse('25769.065289'));
    });

    test('overrides are exact in both directions', () {
      const r = ExchangeRates(usdRates: {'USD': 1, 'VND': 25400}, overrides: {'USD>VND': 26000.5});
      expect(r.exactRate('USD', 'VND'), Ratio.ints(52001, 2));
      expect(r.exactRate('VND', 'USD'), Ratio.ints(2, 52001));
      expect(r.rate('VND', 'USD'), closeTo(1 / 26000.5, 1e-15));
    });

    test('A→B→A of a Converted amount returns the original when B is at least as fine (VND, JPY↔EUR, KWD)', () {
      int there(int m, String a, String b) => fallback.convertMinor(m, a, b)!;
      int back(int m, String a, String b) => there(there(m, a, b), b, a);
      expect(there(1000, 'JPY', 'EUR'), 564);
      expect(back(1000, 'JPY', 'EUR'), 1000);
      expect(there(999, 'USD', 'KWD'), 3109, reason: '9.99 USD = 3.109 KWD');
      expect(back(999, 'USD', 'KWD'), 999);
      expect(back(4990, 'KWD', 'VND'), 4990);
      expect(back(1234, 'EUR', 'USD'), 1234);
      expect(back(1500000, 'VND', 'VND'), 1500000);
    });

    test('switching the Primary currency A→B→A gives the same totals (prices are never overwritten)', () {
      final subs = [
        sub(id: 'a', priceMinor: 50000, currency: 'VND'),
        sub(id: 'b', priceMinor: 1000, currency: 'JPY'),
        sub(id: 'c', priceMinor: 999, currency: 'EUR', cycle: const BillingCycle.yearly()),
        sub(id: 'd', priceMinor: 4990, currency: 'KWD'),
      ];
      int monthly(String primary) =>
          SpendingCalculator(rates: fallback, primaryCurrency: primary).summary(subs, today).monthlyMinor;
      final vnd = monthly('VND');
      final usd = monthly('USD');
      expect(usd, isNot(vnd));
      expect(monthly('VND'), vnd);
      expect(monthly('KWD'), monthly('KWD'));
      expect(monthly('USD'), usd);
    });
  });

  group('convertMinor rounding', () {
    const r = ExchangeRates(usdRates: {'USD': 1}, overrides: {'USD>VND': 20000});

    test('half-up to the smallest unit: 0.005 → 0.01', () {
      expect(r.convertMinor(100, 'VND', 'USD'), 1, reason: '100 ₫ = 0.005 USD');
      expect(r.convertMinor(99, 'VND', 'USD'), 0, reason: '0.00495 USD');
      expect(r.convertMinor(300, 'VND', 'USD'), 2, reason: '0.015 USD');
      expect(r.convertMinor(-100, 'VND', 'USD'), -1);
      expect(r.convert(100, 'VND', 'USD'), 0.01, reason: 'the "≈" helper rounds the same way');
      expect(r.convertMoney(const Money(100, 'VND'), 'USD'), const Money(1, 'USD'));
    });

    test('missing rate → null', () {
      expect(r.convertMinor(100, 'XYZ', 'USD'), isNull);
      expect(r.convert(1, 'USD', 'XYZ'), isNull);
      expect(r.convertMoney(const Money(1, 'XYZ'), 'USD'), isNull);
    });

    test('Monthly / Yearly cost are rounded once from the exact amount', () {
      const calc = SpendingCalculator(rates: r, primaryCurrency: 'USD');
      final yearly = sub(priceMinor: 10000, currency: 'USD', cycle: const BillingCycle.yearly());
      expect(calc.monthlyCostMinor(yearly), 833);
      expect(calc.yearlyCostMinor(yearly), 10000, reason: 'not 833 × 12');
      final weekly = sub(priceMinor: 100, currency: 'USD', cycle: const BillingCycle.weekly());
      expect(calc.monthlyCostMinor(weekly), 433);
      expect(calc.yearlyCostMinor(weekly), 5200);
    });
  });

  group('every total = sum of the rounded lines', () {
    // 10 000 ₫ ÷ 25 400 = 0.3937 USD → each line is 0.39; three lines = 1.17 (not 1.18).
    const rates = ExchangeRates(usdRates: {'USD': 1, 'VND': 25400});
    const calc = SpendingCalculator(rates: rates, primaryCurrency: 'USD');
    final subs = [
      for (final id in ['a', 'b', 'c']) sub(id: id, priceMinor: 10000, anchor: const LocalDate(2026, 11, 20)),
      sub(id: 'odd', priceMinor: 500, currency: 'XYZ', anchor: const LocalDate(2026, 11, 20)),
    ];
    ConfirmedPeriod paid(String id, LocalDate due, {String cur = 'VND', int amount = 10000}) => ConfirmedPeriod(
      id: '$id-$due',
      subscriptionId: id,
      dueDate: due,
      outcome: PeriodOutcome.payment,
      amountMinor: amount,
      currency: cur,
      confirmedAt: fixedNow,
    );
    final periods = [
      for (final id in ['a', 'b', 'c']) paid(id, const LocalDate(2026, 10, 20)),
      paid('odd', const LocalDate(2026, 10, 20), cur: 'XYZ', amount: 500),
    ];

    test('lines', () {
      expect(calc.periodCostMinor(subs.first), 39);
      expect(calc.monthlyCostMinor(subs.first), 39);
      expect(calc.periodCost(subs.first), 0.39);
      expect(calc.monthlyCostMinor(subs.last), isNull);
    });

    test('Home summary, category, top', () {
      final s = calc.summary(subs, today);
      expect(s.monthlyMinor, 117);
      expect(s.monthly, 1.17);
      expect(s.yearlyMinor, 117 * 12);
      expect(s.missingRates, {'XYZ'});
      expect(calc.byCategoryIdMinor(subs, today).single.value, 117);
      expect(calc.top(subs, today).map((e) => e.$2), [0.39, 0.39, 0.39, 0.0]);
    });

    test('Payments: month total and total paid', () {
      expect(calc.actualInMonthMinor(periods, const LocalDate(2026, 10, 1)), 117);
      expect(calc.totalPaidMinor(periods), 117);
      expect(calc.totalPaid(periods), 1.17);
    });

    test('forecast, week strip, budgets', () {
      final f = ForecastCalculator(calc);
      expect(f.nextDaysMinor(subs, today), 117);
      expect(f.nextDays(subs, today), 1.17);
      expect(f.nextMonths(subs, today).first.$2, 1.17);
      final week = f.week(subs, const LocalDate(2026, 11, 17));
      expect(week.totalMinor, 117);
      expect(week.days.expand((d) => d).map((i) => i.amountMinor).toList(), [39, 39, 39, 0]);
      final budget = f.budgets([const Budget(id: 'b', amountMinor: 30000, currency: 'VND')], subs, today).single;
      expect(budget.spent, 1.17);
      expect(budget.limit, 1.18, reason: '30 000 ₫ = 1.1811 USD → 1.18');
    });

    test('Insights and Calendar', () {
      final stats = InsightsStats(calc);
      final t = stats.totals(subs, periods, InsightsRange.thisMonth, today);
      expect(t.expected, 1.17);
      expect(t.previousTotal, 1.17);
      final slices = stats.categories(subs, today, hasOwnSlot: (_) => true);
      expect(slices.single.monthly, 1.17);
      expect(slices.single.subscriptions.map((e) => e.$2), [0.39, 0.39, 0.39]);
      CalendarMonth cal(LocalDate m) => CalendarMonth.build(
        subscriptions: subs,
        periods: periods,
        month: m,
        today: today,
        rates: rates,
        primaryCurrency: 'USD',
      );
      final nov = cal(today);
      expect(nov.totalMinor, 117);
      expect(nov.total, t.total);
      expect(nov.missingRates, {'XYZ'});
      expect(cal(const LocalDate(2026, 10, 1)).totalMinor, 117);
    });
  });
}
