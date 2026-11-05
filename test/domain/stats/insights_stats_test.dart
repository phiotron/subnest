import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/domain/stats/insights_stats.dart';

import 'sample_data.dart';

void main() {
  final stats = InsightsStats(Sample.calc);
  const today = Sample.today;
  final subs = Sample.subscriptions;
  final periods = Sample.periods;
  bool slot(SubscriptionCategory c) => const [
    SubscriptionCategory.ai,
    SubscriptionCategory.storage,
    SubscriptionCategory.telecom,
    SubscriptionCategory.software,
    SubscriptionCategory.video,
    SubscriptionCategory.music,
  ].contains(c);

  group('ranges', () {
    test('months of each range', () {
      final m = InsightsStats.monthsOf(InsightsRange.thisMonth, today);
      expect((m.first, m.last, m.length), (const LocalDate(2026, 11, 1), const LocalDate(2026, 11, 1), 1));
      final y = InsightsStats.monthsOf(InsightsRange.last12Months, today);
      expect((y.first, y.last, y.length), (const LocalDate(2025, 12, 1), const LocalDate(2026, 11, 1), 12));
      final cal = InsightsStats.monthsOf(InsightsRange.thisYear, today);
      expect((cal.first, cal.last, cal.length), (const LocalDate(2026, 1, 1), const LocalDate(2026, 12, 1), 12));
      expect(y.previous.first, const LocalDate(2024, 12, 1));
      expect(y.previous.last, const LocalDate(2025, 11, 1));
      expect(y.contains(const LocalDate(2026, 3, 20)), isTrue);
      expect(y.contains(const LocalDate(2025, 11, 30)), isFalse);
    });
  });

  group('totals', () {
    test('12 months: Payments vs periods not confirmed yet', () {
      final t = stats.totals(subs, periods, InsightsRange.last12Months, today);
      // 10 full months of 150k + 65k + 508k + 59k + 35.8k, Oct without YouTube, + Canva + Google One.
      const monthly = 150000 + 65000 + 508000 + 59000 + 35800;
      expect(t.paid, closeTo(10 * monthly + (monthly - 35800) + 1390000 + 1690000, 1e-6));
      expect(t.expected, closeTo(876800, 1e-6));
      expect(t.previousTotal, 0);
      expect(t.changePercent, isNull, reason: 'nothing to compare with');
    });

    test('this month compares with last month', () {
      final t = stats.totals(subs, periods, InsightsRange.thisMonth, today);
      expect(t.paid, 0);
      expect(t.expected, closeTo(876800, 1e-6));
      expect(t.previousTotal, closeTo(782000, 1e-6));
      expect(t.changePercent, 12);
    });

    test('change is rounded and can be negative', () {
      const t = RangeTotals(paid: 50, expected: 0, previousTotal: 200);
      expect(t.changePercent, -75);
      expect(const RangeTotals(paid: 0, expected: 0, previousTotal: 0).changePercent, isNull);
    });
  });

  group('chart', () {
    test('12 months ending this month; this year runs Jan–Dec', () {
      final s = stats.chart(subs, periods, InsightsRange.last12Months, today);
      expect(s.first.month, const LocalDate(2025, 12, 1));
      expect(s.last.month, const LocalDate(2026, 11, 1));
      expect(s.last.actual, 0);
      expect(s.last.projected, closeTo(876800, 1e-6));
      final y = stats.chart(subs, periods, InsightsRange.thisYear, today);
      expect(y.first.month, const LocalDate(2026, 1, 1));
      expect(y.last.month, const LocalDate(2026, 12, 1));
      expect(y.last.projected, greaterThan(0));
      expect(stats.chart(subs, periods, InsightsRange.thisMonth, today).last.month, const LocalDate(2026, 11, 1));
    });

    test('peaks: February and March from the yearly Canva and Google One renewals', () {
      final s = stats.chart(subs, periods, InsightsRange.last12Months, today);
      final p = stats.peaks(subs, periods, s)!;
      expect(p.months, [const LocalDate(2026, 2, 1), const LocalDate(2026, 3, 1)]);
      expect(p.causes.map((c) => c.id), ['google1', 'canva']);
      expect(p.allYearly, isTrue);
    });

    test('no peak when months are even', () {
      final flat = [Sample.viettel];
      final s = stats.chart(
        flat,
        periods.where((p) => p.subscriptionId == 'viettel'),
        InsightsRange.last12Months,
        today,
      );
      expect(stats.peaks(flat, periods, s), isNull);
      expect(stats.peaks(const [], const [], const []), isNull);
    });
  });

  group('categories', () {
    final slices = stats.categories(subs, today, hasOwnSlot: slot);

    test('Active monthly cost per category, largest first, shares add up', () {
      expect(slices.map((s) => s.category), [
        SubscriptionCategory.ai,
        SubscriptionCategory.storage,
        SubscriptionCategory.telecom,
        SubscriptionCategory.software,
        SubscriptionCategory.video,
      ]);
      expect(slices[1].monthly, closeTo(59000 + 1690000 / 12, 1e-6));
      expect(slices[1].subscriptions.map((e) => e.$1.id), ['google1', 'icloud']);
      expect(slices.fold<double>(0, (a, s) => a + s.share), closeTo(1, 1e-9));
      expect(slices.any((s) => s.category == SubscriptionCategory.music), isFalse, reason: 'Spotify is still a Trial');
    });

    test('categories without a slot fold into Other, listed last', () {
      final extra = [...subs, Sample.duolingo.copyWith(status: SubscriptionStatus.active)];
      final s = stats.categories(extra, today, hasOwnSlot: slot);
      expect(s.last.category, SubscriptionCategory.other);
      expect(s.last.subscriptions.single.$1.id, 'duolingo');
    });
  });

  test('overlaps: 2 Active video services, music needs 2 Active', () {
    final o = stats.overlaps(subs, today);
    expect(o, hasLength(1));
    expect(o.single.category, SubscriptionCategory.video);
    expect(o.single.subscriptions.map((s) => s.id), ['netflix', 'youtube']);
    expect(o.single.monthly, closeTo(100800, 1e-6));
  });

  test('cancelled list for the Savings card', () {
    expect(stats.cancelled(subs, today).map((s) => s.id), ['duolingo', 'applemusic']);
  });
}
