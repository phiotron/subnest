import '../../core/l10n/l10n.dart';
import '../../core/widgets/formatters.dart';
import '../../domain/domain.dart';

/// Labels specific to the S4 form (everything else comes from `AppDates` / `l10n.money`).
abstract final class FormFormat {
  /// Quick picks under "Payment method" (png 26) — free text, the user may type anything.
  static const paymentSuggestions = ['MoMo', 'ZaloPay', 'App Store', 'Google Play'];

  /// Max length of Notes ("58/200").
  static const notesMax = 200;

  /// Date button label: "Fri, 4 Dec 2026" / "T6, 04/12/2026".
  static String dateLong(AppLocalizations l, LocalDate d) {
    final weekday = AppDates.weekdayShort(l, d, today: d).split(',').first;
    return '$weekday, ${AppDates.full(l, d)}';
  }

  /// Reminder time "9:00" (24 h, same in EN and VI as in the mockups).
  static String time(int hour, int minute) => '$hour:${minute.toString().padLeft(2, '0')}';
}
