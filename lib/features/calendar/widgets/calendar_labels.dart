import 'package:intl/intl.dart';

import '../../../core/l10n/l10n.dart';
import '../../../domain/domain.dart';

/// Month wording for S8. EN strings use the month name, VI strings the month number
/// ("November 2026" / "Tháng 11/2026", "November total" / "Tổng tháng 11").
extension CalendarMonthLabels on AppLocalizations {
  String _name(LocalDate m) => DateFormat('MMMM', localeName).format(DateTime(m.year, m.month));

  String calMonthYear(LocalDate m) => calendarMonthYear(_name(m), '${m.month}', '${m.year}');
  String calMonthName(LocalDate m) => calendarMonthName(_name(m), '${m.month}');
  String calMonthTotal(LocalDate m) => calendarMonthTotal(_name(m), '${m.month}');
  String calPaidIn(LocalDate m) => calendarPaidIn(_name(m), '${m.month}');
  String calGroupLater(LocalDate m) => calendarGroupLater(_name(m), '${m.month}');
  String calGroupEarlier(LocalDate m) => calendarGroupEarlier(_name(m), '${m.month}');

  /// Short weekday for the grid header and the agenda date column: Mon … Sun / T2 … CN.
  String calWeekday(int isoWeekday) {
    if (localeName.startsWith('vi')) return isoWeekday == DateTime.sunday ? 'CN' : 'T${isoWeekday + 1}';
    return DateFormat('EEE', localeName).format(DateTime(2024, 1, isoWeekday)); // 1 Jan 2024 = Monday
  }

  String entryState(CalendarEntryKind k) => switch (k) {
    CalendarEntryKind.paid => calendarPaid,
    CalendarEntryKind.skipped => calendarSkipped,
    CalendarEntryKind.awaiting => commonStatusAwaiting,
    CalendarEntryKind.upcoming => calendarUpcoming,
  };
}
