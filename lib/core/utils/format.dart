import 'package:intl/intl.dart';

import '../../domain/domain.dart';

/// Locale-aware money & date formatting (product.md §7.5):
/// `₫260,000` (EN) · `260.000đ` (VI) · `$9.99`.
abstract final class Fmt {
  /// [major] amount in [currency]. [localeName] like `en`, `vi`, `vi_VN`.
  static String money(double major, String currency, String localeName, {bool approx = false}) {
    final code = currency.toUpperCase();
    final digits = currencyDecimals(code);
    final lang = localeName.split(RegExp('[_-]')).first;
    String out;
    if (lang == 'vi' && code == 'VND') {
      out = '${NumberFormat.decimalPatternDigits(locale: 'vi', decimalDigits: 0).format(major)}đ';
    } else {
      out = NumberFormat.simpleCurrency(locale: lang, name: code, decimalDigits: digits).format(major);
    }
    return approx ? '≈ $out' : out;
  }

  static String moneyOf(Money m, String localeName, {bool approx = false}) =>
      money(m.major, m.currency, localeName, approx: approx);

  /// Short date: `04/11/2026` (VI) · `Nov 4, 2026` (EN).
  static String date(LocalDate d, String localeName) {
    final lang = localeName.split(RegExp('[_-]')).first;
    final dt = DateTime(d.year, d.month, d.day);
    return lang == 'vi' ? DateFormat('dd/MM/yyyy', 'vi').format(dt) : DateFormat.yMMMd(lang).format(dt);
  }

  /// Month title: `November 2026` / `tháng 11 2026`.
  static String month(LocalDate d, String localeName) {
    final lang = localeName.split(RegExp('[_-]')).first;
    return DateFormat.yMMMM(lang).format(DateTime(d.year, d.month));
  }

  /// Parses a user-typed amount ("260.000", "9,99", "1 690 000") to major units; `null` if invalid.
  /// For 0-decimal currencies every separator is treated as grouping.
  static double? parseAmount(String input, String currency) {
    var s = input.trim().replaceAll(RegExp(r'[\s₫đ$€£¥]'), '');
    if (s.isEmpty) return null;
    final sep = RegExp('[.,]');
    final decimals = currencyDecimals(currency);
    final seps = sep.allMatches(s).toList();
    if (decimals == 0 || seps.isEmpty) {
      s = s.replaceAll(sep, '');
    } else {
      final last = seps.last.start;
      final tail = s.length - last - 1;
      final mixed = s.contains('.') && s.contains(',');
      // "9,99" / "1.234,5" → decimal; "1,000" (3 digits after a lone separator) → grouping.
      final isDecimal = mixed || (seps.length == 1 && tail >= 1 && tail <= decimals && tail != 3);
      s = isDecimal ? '${s.substring(0, last).replaceAll(sep, '')}.${s.substring(last + 1)}' : s.replaceAll(sep, '');
    }
    final v = double.tryParse(s);
    return (v == null || v < 0) ? null : v;
  }

  /// Plain editable text for an amount (no symbol, no grouping).
  static String editable(int minor, String currency) {
    final d = currencyDecimals(currency);
    return toMajorUnits(minor, currency).toStringAsFixed(d);
  }
}
