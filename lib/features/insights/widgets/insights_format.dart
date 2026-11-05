import 'dart:math' as math;

import 'package:intl/intl.dart';

import '../../../core/l10n/l10n.dart';
import '../../../domain/domain.dart';
import '../../../domain/stats/insights_stats.dart';

/// Number / list wording for S9 (axis labels, donut centre, sentences).
extension InsightsFormat on AppLocalizations {
  String get _lang => localeName.split(RegExp('[_-]')).first;

  /// "1.07M" / "1,07tr", "500K" / "500k", "45".
  String compactNumber(double v) {
    final a = v.abs();
    final (unit, div) = a >= 1e9
        ? ('b', 1e9)
        : a >= 1e6
        ? ('m', 1e6)
        : a >= 1e3
        ? ('k', 1e3)
        : ('', 1.0);
    final n = NumberFormat(div == 1 ? '#,##0' : '#,##0.##', _lang).format(v / div);
    return insightsCompact(unit.isEmpty ? 'none' : unit, n);
  }

  /// Donut centre: full amount below one million, otherwise compact with the currency sign —
  /// "≈ ₫1.07M" (EN) · "≈ 1,07tr" (VI, VND).
  String compactMoney(double v, String currency, {bool approx = false}) {
    if (v.abs() < 1e6) return amount(v, currency, approx: approx);
    final n = compactNumber(v);
    final code = currency.toUpperCase();
    final out = _lang == 'vi' && code == 'VND'
        ? n
        : '${NumberFormat.simpleCurrency(locale: _lang, name: code).currencySymbol}$n';
    return approx ? '≈ $out' : out;
  }

  /// "A", "A and B", "A, B and C" (VI "và").
  String joinNames(List<String> names) {
    if (names.length <= 1) return names.join();
    return '${names.sublist(0, names.length - 1).join(', ')} $insightsAnd ${names.last}';
  }

  /// "February and March" · VI "Tháng 2 và 3".
  String monthList(List<LocalDate> months) => insightsMonthList(
    joinNames([for (final m in months) DateFormat('MMMM', _lang).format(DateTime(m.year, m.month))]),
    joinNames([for (final m in months) '${m.month}']),
  );

  /// "Nov 2026" / "T11/2026" (chart tooltip).
  String shortMonth(LocalDate m) =>
      _lang == 'vi' ? 'T${m.month}/${m.year}' : DateFormat('MMM y', _lang).format(DateTime(m.year, m.month));

  /// Bar label under the chart: "N" / "11".
  String barLabel(LocalDate m) =>
      _lang == 'vi' ? '${m.month}' : DateFormat('MMMMM', _lang).format(DateTime(m.year, m.month));

  /// `select` key used by the range strings.
  static String rangeKey(InsightsRange r) => switch (r) {
    InsightsRange.thisMonth => 'month',
    InsightsRange.last12Months => 'months12',
    InsightsRange.thisYear => 'year',
  };
}

/// Grid lines for the bar chart: up to three "nice" steps (1 · 2 · 2.5 · 5 × 10ⁿ) covering [max].
List<double> niceTicks(double max) {
  if (max <= 0) return const [];
  final raw = max / 3;
  final p = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
  final step = [1, 2, 2.5, 5, 10].map((f) => f * p).firstWhere((s) => s >= raw);
  final count = (max / step).ceil().clamp(1, 3);
  return [for (var i = 1; i <= count; i++) step * i];
}
