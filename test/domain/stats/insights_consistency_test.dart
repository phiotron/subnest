import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/domain/stats/calendar_month.dart';
import 'package:subnest/domain/stats/insights_stats.dart';

import 'device_sample.dart';

/// S9 numbers on data shaped like the phone on 2026-11-06 (see [DeviceSample]): each test
/// reproduces one wrong / contradictory number seen there (notes/2026-11-06-fix-insights.md).
void main() {
  final calc = DeviceSample.calc;
  final stats = InsightsStats(calc);
  const today = DeviceSample.today;
  final subs = DeviceSample.subscriptions;
  final periods = DeviceSample.periods;
  const usd = 25701.0;

  group('#1 this month: the change compares the number the card shows', () {
    test('nothing paid yet, the whole month is expected; last month is fully tracked', () {
      final t = stats.totals(subs, periods, InsightsRange.thisMonth, today);
      expect(t.paid, 0);
      // Viettel (awaiting) 150k, Netflix 65k, Spotify 59k (Trial ends 7 Nov), ChatGPT $20,
      // iCloud 59k, YouTube 35.8k.
      expect(t.expected, closeTo((150000 + 65000 + 59000 + 59000 + 35800) / usd + 20, 1e-9));
      // October: Viettel, Netflix, iCloud Payments + ChatGPT $20 (YouTube skipped).
      expect(t.previousTotal, closeTo((150000 + 65000 + 59000) / usd + 20, 1e-9));
      expect(t.comparable, isTrue);
      expect(t.changePercent, ((t.total - t.previousTotal!) / t.previousTotal! * 100).round());
    });
  });

  group('#2 no change against a span the history does not cover', () {
    test('history starts December 2025', () {
      expect(InsightsStats.historyStart(periods), const LocalDate(2025, 12, 1));
      expect(InsightsStats.historyStart(const []), isNull);
    });

    test('this year vs last year (only December 2025 tracked) → no %', () {
      final t = stats.totals(subs, periods, InsightsRange.thisYear, today);
      expect(t.comparable, isFalse);
      expect(t.previousTotal, isNull);
      expect(t.changePercent, isNull);
    });

    test('12 months vs the 12 before → no %', () {
      final t = stats.totals(subs, periods, InsightsRange.last12Months, today);
      expect(t.comparable, isFalse);
      expect(t.changePercent, isNull);
    });

    test('compares once the history reaches the start of the span before', () {
      final older = [
        ...periods,
        ConfirmedPeriod(
          id: 'old',
          subscriptionId: 'netflix',
          dueDate: const LocalDate(2025, 1, 5),
          outcome: PeriodOutcome.payment,
          amountMinor: 65000,
          currency: 'VND',
          confirmedAt: DeviceSample.now,
        ),
      ];
      final t = stats.totals(subs, older, InsightsRange.thisYear, today);
      expect(t.comparable, isTrue);
      expect(t.changePercent, isNotNull);
    });

    test('no history at all → nothing to compare, even for this month', () {
      final t = stats.totals(subs, const [], InsightsRange.thisMonth, today);
      expect(t.comparable, isFalse);
      expect(t.changePercent, isNull);
    });
  });

  group('#3 by category = Monthly cost of Active plans (yearly ÷ 12, My share)', () {
    bool slot(SubscriptionCategory c) => c != SubscriptionCategory.education;
    final slices = stats.categories(subs, today, hasOwnSlot: slot);

    test('AI = ChatGPT Plus + ChatGPT Pro 100 yearly ÷ 12; Trial and Cancelled left out', () {
      final ai = slices.firstWhere((s) => s.category == SubscriptionCategory.ai);
      expect(ai.monthly, closeTo(20 + 34188000 / 12 / usd, 1e-9));
      expect(slices.any((s) => s.category == SubscriptionCategory.music), isFalse);
      expect(slices.expand((s) => s.subscriptions).map((e) => e.$1.id), isNot(contains('duolingo')));
      final video = slices.firstWhere((s) => s.category == SubscriptionCategory.video);
      expect(video.monthly, closeTo((65000 + 35800) / usd, 1e-9), reason: 'My share, not the full price');
    });

    test('slices add up to the Home monthly total; Top 5 uses the same Monthly cost', () {
      final home = calc.summary(subs, today);
      expect(slices.map((s) => s.monthly).sum, closeTo(home.monthly, 1e-9));
      expect(calc.top(subs, today).first.$1.id, 'chatgpt-pro');
    });

    test('hasLongCycles tells the card to explain the spreading', () {
      expect(InsightsStats.hasLongCycles(slices), isTrue);
      final monthlyOnly = stats.categories([DeviceSample.viettel, DeviceSample.chatgpt], today, hasOwnSlot: slot);
      expect(InsightsStats.hasLongCycles(monthlyOnly), isFalse);
    });
  });

  group('#4 peaks: months in order, each with its own renewal, future months as expected', () {
    test('this year: March happened (Google One), December is still ahead (ChatGPT Pro 100)', () {
      final series = stats.chart(subs, periods, InsightsRange.thisYear, today);
      final notes = stats.peaks(subs, periods, series, today);
      expect(notes, hasLength(2));
      expect(notes[0].months, [const LocalDate(2026, 3, 1)]);
      expect(notes[0].causes.map((s) => s.id), ['google1']);
      expect(notes[0].expected, isFalse);
      expect(notes[1].months, [const LocalDate(2026, 12, 1)]);
      expect(notes[1].causes.map((s) => s.id), ['chatgpt-pro']);
      expect(notes[1].expected, isTrue);
      expect(notes[1].allYearly, isTrue);
    });

    test('12 months: February and March, named in month order (Canva, then Google One)', () {
      final series = stats.chart(subs, periods, InsightsRange.last12Months, today);
      final notes = stats.peaks(subs, periods, series, today);
      expect(notes, hasLength(1));
      expect(notes.single.months, [const LocalDate(2026, 2, 1), const LocalDate(2026, 3, 1)]);
      expect(notes.single.causes.map((s) => s.id), ['canva', 'google1']);
      expect(notes.single.expected, isFalse);
    });
  });

  group('#5 cross-checks: card = bars, S9 = S8 Calendar for the same month', () {
    for (final range in InsightsRange.values) {
      test('summary = sum of the range bars ($range)', () {
        final t = stats.totals(subs, periods, range, today);
        final span = InsightsStats.monthsOf(range, today);
        final bars = stats.chart(subs, periods, range, today).where((m) => span.contains(m.month));
        expect(bars.length, span.length);
        expect(t.paid, closeTo(bars.map((m) => m.actual).sum, 1e-9));
        expect(t.expected, closeTo(bars.map((m) => m.projected).sum, 1e-9));
      });
    }

    CalendarMonth cal(LocalDate m) => CalendarMonth.build(
      subscriptions: subs,
      periods: periods,
      month: m,
      today: today,
      rates: DeviceSample.rates,
      primaryCurrency: DeviceSample.primary,
    );

    test('this month: S9 total = Calendar header total', () {
      final t = stats.totals(subs, periods, InsightsRange.thisMonth, today);
      expect(t.total, closeTo(cal(today).total, 1e-9));
    });

    test('every past bar = Calendar "Paid in …" of that month (Payments by due date)', () {
      final series = stats.chart(subs, periods, InsightsRange.last12Months, today);
      for (final m in series.where((m) => m.month.isBefore(today.firstOfMonth))) {
        expect(m.actual, closeTo(cal(m.month).total, 1e-9), reason: '${m.month}');
      }
      final march = series.firstWhere((m) => m.month == const LocalDate(2026, 3, 1));
      expect(march.actual, closeTo((150000 + 65000 + 35800 + 59000 + 1690000) / usd + 20, 1e-9));
    });

    test('future bars = Calendar totals (expected periods)', () {
      final series = stats.chart(subs, periods, InsightsRange.thisYear, today);
      final dec = series.last;
      expect(dec.month, const LocalDate(2026, 12, 1));
      expect(dec.actual, 0);
      expect(dec.projected, closeTo(cal(dec.month).total, 1e-9));
    });

    test('Savings = yearly cost of Cancelled plans', () {
      expect(calc.summary(subs, today).savingsYearly, closeTo((699000 + 65000 * 12) / usd, 1e-9));
      // Apple Music 65k × 12 = 780k > Duolingo 699k a year: dearest first.
      expect(stats.cancelled(subs, today).map((s) => s.id), ['applemusic', 'duolingo']);
    });
  });
}
