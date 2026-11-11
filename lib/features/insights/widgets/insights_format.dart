import 'package:flutter/painting.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/domain.dart';

/// Wording + colour helpers shared by the S9 cards.
extension InsightsFormat on AppLocalizations {
  String get _lang => localeName.split(RegExp('[_-]')).first;
  bool get _vi => _lang == 'vi';

  /// Minor units in [currency]: "$144.89" / "≈ $144.89".
  String minor(int minor, String currency, {bool approx = false}) => money(Money(minor, currency), approx: approx);

  /// "+$2.50" / "−$4.00" (U+2212) — the sign is part of the number.
  String signedMinor(int minor, String currency, {bool approx = false}) {
    final abs = this.minor(minor.abs(), currency);
    final sign = minor > 0 ? '+' : (minor < 0 ? '−' : '');
    return '${approx ? '≈ ' : ''}$sign$abs';
  }

  String _monthName(LocalDate m) => DateFormat('MMMM', _lang).format(DateTime(m.year, m.month));
  String _monthShortName(LocalDate m) => DateFormat('MMM', _lang).format(DateTime(m.year, m.month));

  /// "November 2026" / "Tháng 11, 2026".
  String statsMonthYear(LocalDate m) => _vi ? 'Tháng ${m.month}, ${m.year}' : '${_monthName(m)} ${m.year}';

  /// Month as a period inside a sentence: "November" / "tháng 11".
  String statsMonthInline(LocalDate m) => _vi ? 'tháng ${m.month}' : _monthName(m);

  /// Month as a title: "November" / "Tháng 11".
  String statsMonthTitle(LocalDate m) => _vi ? 'Tháng ${m.month}' : _monthName(m);

  String costOfMonth(LocalDate m) => insightsCostOfMonth(_monthName(m), '${m.month}');
  String vsMonth(LocalDate m) => insightsVsMonth(_monthShortName(m), '${m.month}');
  String sameMonth(LocalDate m) => insightsSameMonth(_monthShortName(m), '${m.month}');
  String nothingInMonth(LocalDate m) => insightsNothingInMonth(_monthName(m), '${m.month}');

  /// Bar label under the 12 columns: "Jan" / "1".
  String barLabel(LocalDate m) => _vi ? '${m.month}' : _monthShortName(m);

  /// Bar label when "Jan" doesn't fit a column (320dp, large text): "J" / "1".
  String barLabelNarrow(LocalDate m) =>
      _vi ? '${m.month}' : DateFormat('MMMMM', _lang).format(DateTime(m.year, m.month));

  /// Coming-up month bar: "Nov" / "T11".
  String upcomingMonthLabel(LocalDate m) => _vi ? 'T${m.month}' : _monthShortName(m);

  /// Spoken month of a bar: "November 2026" / "Tháng 11, 2026".
  String spokenMonth(LocalDate m) => statsMonthYear(m);

  /// "A, B and C" (VI "A, B và C").
  String joinNames(List<String> names) {
    if (names.length <= 1) return names.join();
    final and = _vi ? 'và' : 'and';
    return '${names.sublist(0, names.length - 1).join(', ')} $and ${names.last}';
  }

  /// Name of a Category id (built-in or the user's own).
  String categoryOf(String id, Map<String, Category> byId) {
    final cat = byId[id];
    if (cat != null) return categoryName(cat);
    return category(SubscriptionCategory.fromKey(id));
  }
}

/// Width of [text] in [style] at the current text scale.
double textWidth(String text, TextStyle style, TextScaler scaler) => (TextPainter(
  text: TextSpan(text: text, style: style),
  textDirection: TextDirection.ltr,
  textScaler: scaler,
  maxLines: 1,
)..layout()).width;

/// Column width of [count] bars with [gap] between them inside a S9 card on this screen.
double statsColumnWidth(double screenWidth, int count, double gap) =>
    (screenWidth - 4 * 16 - gap * (count - 1)) / count;

/// ISO-8601 week number of [d] (week 1 holds the year's first Thursday).
int isoWeek(LocalDate d) {
  final date = DateTime.utc(d.year, d.month, d.day);
  final thursday = date.add(Duration(days: DateTime.thursday - date.weekday));
  final firstJan = DateTime.utc(thursday.year, 1, 1);
  return thursday.difference(firstJan).inDays ~/ 7 + 1;
}

/// Category colour in charts (design README v2): AI `chart-1`, Storage `chart-2`, Health `chart-3`,
/// Software `chart-4`, Video `chart-5`, Music `tile-violet`, Telecom `tile-sky`; other built-ins
/// `chart-other`; a category the user made keeps the colour picked for it in Settings.
Color statsCategoryColor(AppColors c, String id, Map<String, Category> byId) {
  final builtIn = SubscriptionCategory.tryKey(id) ?? byId[id]?.builtIn;
  if (builtIn == null) {
    final own = byId[id];
    return own == null ? c.chartOther : Color(own.colorValue);
  }
  return switch (builtIn) {
    SubscriptionCategory.ai => c.chart1,
    SubscriptionCategory.storage => c.chart2,
    SubscriptionCategory.health => c.chart3,
    SubscriptionCategory.software => c.chart4,
    SubscriptionCategory.video => c.chart5,
    SubscriptionCategory.music => c.tileViolet,
    SubscriptionCategory.telecom => c.tileSky,
    _ => c.chartOther,
  };
}
