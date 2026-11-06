import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/backup_codec.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/domain/stats/calendar_month.dart';
import 'package:subnest/domain/stats/insights_stats.dart';

/// Prints every S9 number for a real backup and checks they agree (card = bars, S9 = Calendar,
/// slices = Home). Skipped unless a backup is given — the file holds personal data, never commit it:
///
///   flutter test test/domain/stats/s9_backup_report_test.dart \
///     --dart-define=S9_BACKUP=C:/path/subnest-backup.json --dart-define=S9_TODAY=2026-11-06 \
///     --dart-define=S9_VND_PER_USD=25701
///
/// Exchange rates are not in the backup (only overrides): pass the phone's rate (Settings).
const _path = String.fromEnvironment('S9_BACKUP');
const _today = String.fromEnvironment('S9_TODAY', defaultValue: '2026-11-06');
const _vnd = String.fromEnvironment('S9_VND_PER_USD', defaultValue: '25701');

void main() {
  test('S9 report for a real backup', skip: _path.isEmpty ? 'pass --dart-define=S9_BACKUP=<file>' : false, () {
    final j = jsonDecode(File(_path).readAsStringSync()) as Map<String, Object?>;
    final settings = (j['settings'] as Map).cast<String, Object?>();
    final primary = (settings['primaryCurrency'] as String?) ?? 'USD';
    final subs = [
      for (final s in j['subscriptions'] as List) BackupCodec.subscriptionFromJson((s as Map).cast<String, Object?>()),
    ];
    final periods = [
      for (final p in j['periods'] as List) BackupCodec.periodFromJson((p as Map).cast<String, Object?>()),
    ];
    final rates = ExchangeRates(usdRates: {'USD': 1, 'VND': double.parse(_vnd)});
    final today = LocalDate.parse(_today);
    final calc = SpendingCalculator(rates: rates, primaryCurrency: primary);
    final stats = InsightsStats(calc);
    String f(double v) => v.toStringAsFixed(2);

    final out = StringBuffer('Primary $primary · today $today · ${subs.length} subs · ${periods.length} periods\n');
    for (final s in subs) {
      out.writeln(
        '  ${s.name} [${s.status.name}] ${s.price.major} ${s.currency} /${s.cycle.every} ${s.cycle.unit.name}'
        ' share ${s.sharedWith} due ${s.dueDate} → monthly ${f(calc.monthlyCost(s) ?? -1)}',
      );
    }
    out.writeln('history starts ${InsightsStats.historyStart(periods)}');
    for (final r in InsightsRange.values) {
      final t = stats.totals(subs, periods, r, today);
      final series = stats.chart(subs, periods, r, today);
      final span = InsightsStats.monthsOf(r, today);
      final bars = series.where((m) => span.contains(m.month));
      out.writeln(
        '$r total ${f(t.total)} = paid ${f(t.paid)} + expected ${f(t.expected)}; before ${t.previousTotal?.toStringAsFixed(2)}'
        ' → ${t.changePercent}%',
      );
      for (final m in series) {
        out.writeln('   ${m.month} paid ${f(m.actual)} expected ${f(m.projected)}');
      }
      for (final p in stats.peaks(subs, periods, series, today)) {
        out.writeln('   peak ${p.months} ${p.causes.map((s) => s.name).toList()} expected=${p.expected}');
      }
      expect(t.paid, closeTo(bars.map((m) => m.actual).sum, 1e-6));
      expect(t.expected, closeTo(bars.map((m) => m.projected).sum, 1e-6));
    }
    final cal = CalendarMonth.build(
      subscriptions: subs,
      periods: periods,
      month: today,
      today: today,
      rates: rates,
      primaryCurrency: primary,
    );
    final month = stats.totals(subs, periods, InsightsRange.thisMonth, today);
    out.writeln('Calendar this month ${f(cal.total)} vs S9 ${f(month.total)}');
    expect(month.total, closeTo(cal.total, 1e-6));
    final slices = stats.categories(subs, today, hasOwnSlot: (_) => true);
    final home = calc.summary(subs, today);
    for (final s in slices) {
      out.writeln('  ${s.category.key} ${f(s.monthly)} ${(s.share * 100).round()}% ${s.subscriptions.map((e) => e.$1.name)}');
    }
    out.writeln('Home monthly ${f(home.monthly)} · savings/yr ${f(home.savingsYearly)}');
    expect(slices.map((s) => s.monthly).sum, closeTo(home.monthly, 1e-6));
    // ignore: avoid_print
    print(out);
  });
}
