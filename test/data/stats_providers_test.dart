import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';

import '../domain/fixtures.dart';

void main() {
  test('stats providers: month spend, cash flow, price history, increases, forecast', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final c = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => DateTime(2026, 11, 10, 10)),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    final repo = c.read(subscriptionRepositoryProvider);
    await repo.save(
      sub(id: 'a', priceMinor: 1000, currency: 'USD', anchor: const LocalDate(2026, 11, 25))
          .copyWith(startDate: const LocalDate(2025, 1, 1)),
    );
    await repo.changePrice('a', 1300);

    // Keep the streams alive and wait for their first values.
    for (final p in [subscriptionsProvider, periodsProvider, priceChangesProvider, settingsProvider, ratesProvider]) {
      c.listen(p, (_, _) {});
    }
    for (final (n, f) in [
      ('subs', c.read(subscriptionsProvider.future)),
      ('periods', c.read(periodsProvider.future)),
      ('price', c.read(priceChangesProvider.future)),
      ('settings', c.read(settingsProvider.future)),
      ('rates', c.read(ratesProvider.future)),
    ]) {
      await f.timeout(const Duration(seconds: 3), onTimeout: () => throw StateError('timeout $n'));
    }

    final month = c.read(selectedStatsMonthProvider);
    expect(month, const LocalDate(2026, 11, 1));
    expect(c.read(monthSpendProvider(month))!.totalMinor, 1300); // new price effective 11-25, in November
    expect(c.read(monthSpendProvider(const LocalDate(2026, 10, 1)))!.totalMinor, 1000);
    expect(c.read(monthSpendSeriesProvider((month, 6)))!, hasLength(6));
    expect(c.read(yearSpendProvider(2026))!.months, hasLength(12));
    expect(c.read(monthCashFlowProvider(month))!.remainingMinor, 1300);
    expect(c.read(priceIncreasesProvider)!.monthlyDeltaMinor, 300);
    expect(c.read(recentlyIncreasedIdsProvider), {'a'});
    expect(c.read(yearForecastProvider)!.nextMinor, 12 * 1300);
    c.listen(subscriptionPriceHistoryProvider('a'), (_, _) {});
    final history = await c.read(subscriptionPriceHistoryProvider('a').future);
    expect(history.single.newPriceMinor, 1300);

    c.read(selectedStatsMonthProvider.notifier).previous();
    expect(c.read(selectedStatsMonthProvider), const LocalDate(2026, 10, 1));
  });
}
