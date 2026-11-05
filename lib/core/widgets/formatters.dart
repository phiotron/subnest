import 'package:intl/intl.dart';

import '../../domain/domain.dart';
import '../l10n/l10n.dart';

/// Date labels as drawn in the mockups (design README § Content fundamentals):
/// relative up to 30 days ahead ("in 3 days" / "còn 3 ngày", "today", "tomorrow"), then a date
/// ("2 Feb 2027" / "2/2/2027"). Weeks start on Monday (see [AppDates.firstDayOfWeek]).
///
/// Money stays in `core/utils/format.dart` (`l10n.money(...)`, `Fmt.money`): `₫260,000` (EN) ·
/// `260.000đ` (VI) · `$20.00`.
abstract final class AppDates {
  /// ISO weekday the calendar and date picker start on.
  static const firstDayOfWeek = DateTime.monday;

  static String _lang(AppLocalizations l) => l.localeName.split(RegExp('[_-]')).first;

  static DateTime _dt(LocalDate d) => DateTime(d.year, d.month, d.day);

  /// "today" · "tomorrow" · "in 12 days" · "3 days ago"; beyond 30 days ahead → [short].
  static String relative(AppLocalizations l, LocalDate date, {required LocalDate today}) {
    final n = today.daysUntil(date);
    if (n == 0) return l.coreRelToday;
    if (n == 1) return l.coreRelTomorrow;
    if (n < 0) return l.coreRelDaysAgo(-n);
    if (n <= 30) return l.coreRelInDays(n);
    return short(l, date, today: today);
  }

  /// "4 Nov" / "4/11" — the year is added when it differs from [today]'s: "2 Feb 2027" / "2/2/2027".
  static String short(AppLocalizations l, LocalDate date, {required LocalDate today}) {
    final sameYear = date.year == today.year;
    if (_lang(l) == 'vi') return sameYear ? '${date.day}/${date.month}' : '${date.day}/${date.month}/${date.year}';
    return DateFormat(sameYear ? 'd MMM' : 'd MMM y', 'en').format(_dt(date));
  }

  /// Full date: "4 Nov 2026" / "04/11/2026".
  static String full(AppLocalizations l, LocalDate date) =>
      _lang(l) == 'vi' ? DateFormat('dd/MM/yyyy', 'vi').format(_dt(date)) : DateFormat('d MMM y', 'en').format(_dt(date));

  /// "Wed, 4 Nov" / "T4, 4/11" (year added when not [today]'s).
  static String weekdayShort(AppLocalizations l, LocalDate date, {required LocalDate today}) {
    if (_lang(l) == 'vi') {
      final wd = date.toWeekday == DateTime.sunday ? 'CN' : 'T${date.toWeekday + 1}';
      return '$wd, ${short(l, date, today: today)}';
    }
    return '${DateFormat('EEE', 'en').format(_dt(date))}, ${short(l, date, today: today)}';
  }

  /// Overview eyebrow: "Wednesday, 4 November" / "Thứ Tư, 4 tháng 11".
  static String weekdayLong(AppLocalizations l, LocalDate date) {
    final lang = _lang(l);
    final s = DateFormat('EEEE, d MMMM', lang).format(_dt(date));
    return lang == 'vi' ? _capitalize(s) : s;
  }

  /// Month title: "December 2026" / "Tháng 12 2026".
  static String monthTitle(AppLocalizations l, int year, int month) {
    final lang = _lang(l);
    if (lang == 'vi') return 'Tháng $month $year';
    return DateFormat('MMMM y', lang).format(DateTime(year, month));
  }

  /// Narrow weekday headers starting Monday: M T W T F S S / T2 T3 T4 T5 T6 T7 CN.
  static List<String> weekdayHeaders(AppLocalizations l) => _lang(l) == 'vi'
      ? const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
      : const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  static String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

/// Per-cycle suffix for amounts: "/month", "/year", "/week", "/quarter", "/3 months" (VI "/tháng"…).
String perCycle(AppLocalizations l, BillingCycle c) {
  if (c.every == 1) return l.corePer(c.unit.name);
  if (c.unit == CycleUnit.month && c.every == 3) return l.corePer('quarter');
  final unit = switch (c.unit) {
    CycleUnit.day => l.commonUnitDay,
    CycleUnit.week => l.commonUnitWeek,
    CycleUnit.month => l.commonUnitMonth,
    CycleUnit.year => l.commonUnitYear,
  };
  return l.corePerEvery(c.every, unit);
}

extension on LocalDate {
  int get toWeekday => DateTime(year, month, day).weekday;
}
