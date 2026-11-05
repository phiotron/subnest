import 'dart:math' as math;

import 'package:intl/intl.dart';

import '../../core/l10n/l10n.dart';
import '../../domain/domain.dart';

/// Small formatting rules used only by the Settings screens.
abstract final class SettingsFormat {
  static String _lang(String localeName) => localeName.split(RegExp('[_-]')).first;

  /// "just now" · "5 min ago" · "2 h ago" (short) / "2 hours ago" · "3 days ago".
  static String ago(AppLocalizations l, DateTime then, DateTime now, {bool short = false}) {
    final d = now.difference(then);
    if (d.inMinutes < 1) return l.settingsAgoJustNow;
    if (d.inHours < 1) return l.settingsAgoMinutes(d.inMinutes);
    if (d.inDays < 1) return short ? l.settingsAgoHoursShort(d.inHours) : l.settingsAgoHours(d.inHours);
    return l.settingsAgoDays(daysBetween(then, now));
  }

  /// Calendar days from [from] to [to] (local dates), never negative.
  static int daysBetween(DateTime from, DateTime to) =>
      math.max(0, LocalDate.fromDateTime(from).daysUntil(LocalDate.fromDateTime(to)));

  /// Backups older than this get the gentle nudge (product.md S10).
  static const backupNudgeDays = 30;

  static bool backupOverdue(DateTime? last, DateTime now) => last == null || daysBetween(last, now) > backupNudgeDays;

  /// Name `BackupService.exportJson` gives the file it shares (`subnest-backup-<local date>.json`).
  static String backupFileName(DateTime exportedAt) => 'subnest-backup-${LocalDate.fromDateTime(exportedAt)}.json';

  /// Exchange rate for display: `25,400` · `25.400` (VI) · `1.0846` · `0.0000394`.
  static String rate(double value, String localeName, {bool grouping = true}) {
    final int digits;
    if (value >= 1000) {
      digits = 0;
    } else if (value >= 1) {
      digits = 4;
    } else {
      // Keep 3 significant digits for tiny rates (1 VND = 0.0000394 USD).
      digits = math.min(10, 2 - (math.log(value) / math.ln10).floor());
    }
    final f = NumberFormat.decimalPattern(_lang(localeName))
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = digits;
    if (!grouping) f.turnOffGrouping();
    return f.format(value);
  }

  /// Parses a typed rate with the locale's separators ("25,400.5" EN · "25.400,5" VI).
  /// `null` when empty, invalid or not above 0.
  static double? parseRate(String input, String localeName) {
    final vi = _lang(localeName) == 'vi';
    var s = input.trim().replaceAll(RegExp(r'[\s  ]'), '');
    if (s.isEmpty) return null;
    s = vi ? s.replaceAll('.', '').replaceAll(',', '.') : s.replaceAll(',', '');
    final v = double.tryParse(s);
    return (v == null || v <= 0 || v.isNaN || v.isInfinite) ? null : v;
  }

  /// Language name in its own language (the picker shows these untranslated).
  static String languageName(String code) => switch (code) {
    'vi' => 'Tiếng Việt',
    _ => 'English',
  };
}
