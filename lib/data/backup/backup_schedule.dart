/// Payload of the iOS "time to back up" notification; tapping it runs the catch-up.
const autoBackupPayload = 'subnest:auto-backup';

/// Daily auto-backup time in local time (F7).
/// Every day has one slot at [hour]:[minute] in the phone's current time zone.
/// "At most once a day" is per slot: each slot is handled at most once (backup,
/// a failed attempt, or finding the data unchanged). Handling at `t` covers every
/// slot up to `t`, so missing several days still catches up only once.
class BackupTime {
  const BackupTime(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  /// Prefilled when auto backup is turned on.
  static const defaultTime = BackupTime(21, 0);

  final int hour;
  final int minute;

  /// Stored form: `HH:MM`.
  String encode() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Reads `HH:MM`; null when malformed or out of range.
  static BackupTime? parse(String? text) {
    final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(text ?? '');
    if (m == null) return null;
    final h = int.parse(m[1]!);
    final min = int.parse(m[2]!);
    if (h > 23 || min > 59) return null;
    return BackupTime(h, min);
  }

  @override
  bool operator ==(Object other) => other is BackupTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => encode();
}

/// Builds a local time. Default is [DateTime.new] (phone time); tests pass a
/// `TZDateTime` builder for a time zone to check time-zone changes and DST.
typedef LocalDateTimeBuilder = DateTime Function(int year, int month, int day, int hour, int minute);

DateTime _local(int y, int mo, int d, int h, int mi) => DateTime(y, mo, d, h, mi);

/// The slot of the day containing [day] (in [day]'s local time). A nonexistent
/// time (DST jump) is pushed past the gap by the library.
DateTime slotOn(DateTime day, BackupTime time, {LocalDateTimeBuilder at = _local}) =>
    at(day.year, day.month, day.day, time.hour, time.minute);

/// The next slot strictly after [now] (today if the time has not passed, else tomorrow).
DateTime nextSlot(DateTime now, BackupTime time, {LocalDateTimeBuilder at = _local}) {
  final today = slotOn(now, time, at: at);
  if (today.isAfter(now)) return today;
  return at(now.year, now.month, now.day + 1, time.hour, time.minute);
}

/// The most recent slot not after [now]: today if the time has passed, else yesterday.
DateTime lastSlot(DateTime now, BackupTime time, {LocalDateTimeBuilder at = _local}) {
  final today = slotOn(now, time, at: at);
  if (!today.isAfter(now)) return today;
  return at(now.year, now.month, now.day - 1, time.hour, time.minute);
}

/// Whether to run (or catch up) a backup now: the latest slot has not been handled.
/// [handledAt] is the last handled moment (an attempt, or finding the data
/// unchanged); null means never.
bool isBackupDue({
  required DateTime now,
  required BackupTime time,
  DateTime? handledAt,
  LocalDateTimeBuilder at = _local,
}) {
  if (handledAt == null) return true;
  return handledAt.isBefore(lastSlot(now, time, at: at));
}

/// Whether the next slot is today or tomorrow (for the "Next: …" line); compares
/// calendar days in [now]'s local time.
bool isToday(DateTime now, DateTime slot) => slot.year == now.year && slot.month == now.month && slot.day == now.day;
