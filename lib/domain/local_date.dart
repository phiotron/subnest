/// A calendar date without time or time zone (e.g. a Due date).
///
/// Billing maths works on whole days, so we avoid `DateTime` + `Duration`
/// (which drifts across DST changes) and do arithmetic in UTC internally.
class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.fromDateTime(DateTime dt) => LocalDate(dt.year, dt.month, dt.day);

  factory LocalDate.today([DateTime? now]) => LocalDate.fromDateTime(now ?? DateTime.now());

  /// Parses `YYYY-MM-DD`.
  factory LocalDate.parse(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) throw FormatException('Invalid date', iso);
    return LocalDate(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  static LocalDate? tryParse(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    try {
      return LocalDate.parse(iso);
    } on FormatException {
      return null;
    }
  }

  final int year;
  final int month;
  final int day;

  DateTime get _utc => DateTime.utc(year, month, day);

  /// Local wall-clock `DateTime` at [hour]:[minute] on this date.
  DateTime atTime(int hour, [int minute = 0]) => DateTime(year, month, day, hour, minute);

  LocalDate addDays(int days) => LocalDate.fromDateTime(_utc.add(Duration(days: days)));

  /// Adds calendar months, clamping the day to the target month's length
  /// (Jan 31 + 1 month = Feb 28/29).
  LocalDate addMonths(int months, {int? preferredDay}) {
    final total = year * 12 + (month - 1) + months;
    final y = total ~/ 12;
    final m = total % 12 + 1;
    final d = preferredDay ?? day;
    final last = daysInMonth(y, m);
    return LocalDate(y, m, d > last ? last : d);
  }

  /// Whole days from this date to [other] (positive when [other] is later).
  int daysUntil(LocalDate other) => other._utc.difference(_utc).inDays;

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;
  bool isOnOrBefore(LocalDate other) => compareTo(other) <= 0;
  bool isOnOrAfter(LocalDate other) => compareTo(other) >= 0;

  /// First day of this date's month.
  LocalDate get firstOfMonth => LocalDate(year, month, 1);

  static bool isLeapYear(int y) => (y % 4 == 0 && y % 100 != 0) || y % 400 == 0;

  static int daysInMonth(int y, int m) {
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (m == 2 && isLeapYear(y)) return 29;
    return days[m - 1];
  }

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  /// ISO `YYYY-MM-DD` — also the storage/backup format.
  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
