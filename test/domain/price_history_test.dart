import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import 'fixtures.dart';

LocalDate d(int y, int m, [int day = 1]) => LocalDate(y, m, day);

ConfirmedPeriod pay(LocalDate due, int amount, {String currency = 'USD', DetectionSource? source, String sub = 's1'}) =>
    ConfirmedPeriod(
      id: 'p-$due',
      subscriptionId: sub,
      dueDate: due,
      outcome: PeriodOutcome.payment,
      amountMinor: amount,
      currency: currency,
      confirmedAt: fixedNow,
      source: source,
    );

PriceChange change(int from, int to, LocalDate at, {String sub = 's1', String? oldCurrency}) => PriceChange(
  id: 'c-$sub-$at',
  subscriptionId: sub,
  oldPriceMinor: from,
  newPriceMinor: to,
  currency: 'USD',
  oldCurrency: oldCurrency,
  effectiveFrom: at,
  source: PriceChangeSource.manual,
  createdAt: fixedNow,
);

void main() {
  // Monthly USD subscription, current price 12.00, next Due date 2026-12-01.
  final s = sub(priceMinor: 1200, currency: 'USD', anchor: d(2026, 12, 1));

  List<PriceChange> backfill(List<ConfirmedPeriod> periods, {Subscription? of}) =>
      PriceHistory.backfill(of ?? s, periods, now: fixedNow, newId: idGen());

  group('backfill from Payments', () {
    test('two runs of different amounts → one change on the first Payment of the new run', () {
      final c = backfill([
        pay(d(2026, 7, 1), 1000),
        pay(d(2026, 8, 1), 1000),
        pay(d(2026, 9, 1), 1200),
        pay(d(2026, 10, 1), 1200),
      ]);
      expect(c, hasLength(1));
      expect((c.single.oldPriceMinor, c.single.newPriceMinor, c.single.effectiveFrom), (1000, 1200, d(2026, 9, 1)));
      expect(c.single.source, PriceChangeSource.backfill);
      expect(c.single.currency, 'USD');
    });

    test('a single odd Payment (discount, typo) is noise', () {
      expect(
        backfill([pay(d(2026, 7, 1), 1200), pay(d(2026, 8, 1), 1200), pay(d(2026, 9, 1), 500), pay(d(2026, 10, 1), 1200)]),
        isEmpty,
      );
    });

    test('a last single Payment counts when it equals the current price', () {
      final c = backfill([pay(d(2026, 8, 1), 1000), pay(d(2026, 9, 1), 1000), pay(d(2026, 10, 1), 1200)]);
      expect(c.single.effectiveFrom, d(2026, 10, 1));
    });

    test('price edited after the last Payments without a record → change on the next Due date', () {
      final c = backfill([pay(d(2026, 9, 1), 1000), pay(d(2026, 10, 1), 1000), pay(d(2026, 11, 1), 1300)]);
      // 13.00 once is noise; the kept run is 10.00 ≠ current 12.00 → from the Payment after that run.
      expect((c.single.oldPriceMinor, c.single.newPriceMinor, c.single.effectiveFrom), (1000, 1200, d(2026, 11, 1)));
      final next = backfill([pay(d(2026, 9, 1), 1000), pay(d(2026, 10, 1), 1000)]);
      expect(next.single.effectiveFrom, d(2026, 12, 1)); // current Due date
    });

    test('ignores auto-confirmed amounts, other currencies, other subscriptions, Skipped periods', () {
      final c = backfill([
        pay(d(2026, 7, 1), 1200),
        pay(d(2026, 8, 1), 1200),
        pay(d(2026, 9, 1), 1290, source: DetectionSource.scan),
        pay(d(2026, 10, 1), 1290, source: DetectionSource.scan),
        pay(d(2026, 10, 2), 30000, currency: 'VND'),
        pay(d(2026, 10, 3), 30000, currency: 'VND'),
        pay(d(2026, 10, 1), 999, sub: 'other'),
        pay(d(2026, 11, 1), 999, sub: 'other'),
      ]);
      expect(c, isEmpty);
      expect(backfill(const []), isEmpty);
    });

    test('Shared plan: amounts are My share → plan price × people (current share → exact price)', () {
      final shared = sub(priceMinor: 1999, currency: 'USD', sharedWith: 2, anchor: d(2026, 12, 1)); // share 10.00
      final c = PriceHistory.backfill(
        shared,
        [pay(d(2026, 8, 1), 750), pay(d(2026, 9, 1), 750), pay(d(2026, 10, 1), 1000), pay(d(2026, 11, 1), 1000)],
        now: fixedNow,
        newId: idGen(),
      );
      expect((c.single.oldPriceMinor, c.single.newPriceMinor), (1500, 1999));
    });
  });

  group('priceAt', () {
    final h = PriceHistory([change(1000, 1100, d(2026, 3, 1)), change(1100, 1200, d(2026, 9, 1))]);

    test('before the first change → its old price; between → that change; after the last → current', () {
      expect(h.priceAt(s, d(2026, 2, 28)), (priceMinor: 1000, currency: 'USD'));
      expect(h.priceAt(s, d(2026, 3, 1)), (priceMinor: 1100, currency: 'USD'));
      expect(h.priceAt(s, d(2026, 8, 31)), (priceMinor: 1100, currency: 'USD'));
      expect(h.priceAt(s, d(2026, 9, 1)), (priceMinor: 1200, currency: 'USD'));
      expect(PriceHistory.empty.priceAt(s, d(2020, 1, 1)), (priceMinor: 1200, currency: 'USD'));
    });

    test('My share and currency change', () {
      final shared = sub(priceMinor: 1999, currency: 'USD', sharedWith: 3);
      final hh = PriceHistory([change(25000, 1999, d(2026, 6, 1), oldCurrency: 'VND')]);
      expect(hh.myShareAt(shared, d(2026, 5, 1)), (priceMinor: 8333, currency: 'VND'));
      expect(hh.myShareAt(shared, d(2026, 7, 1)), (priceMinor: 666, currency: 'USD'));
      expect(hh.of('s1').single.currencyChanged, isTrue);
      expect(hh.of('s1').single.isIncrease, isNull);
    });
  });
}
