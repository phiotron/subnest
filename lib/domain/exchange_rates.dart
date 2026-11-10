import 'money.dart';
import 'ratio.dart';

/// Exchange rates used to convert amounts to the Primary currency.
///
/// [usdRates] are "units of currency per 1 USD" from the rate provider (cached).
/// [overrides] are user-set rates for a pair: `overrides['USD>VND'] = 25400`
/// means 1 USD = 25 400 VND. Overrides always win over provider rates.
///
/// Rates are stored as `double` but read back as the exact decimal they were written as
/// ([Ratio.fromDouble]); cross rates are the exact fraction `rate(to) / rate(from)`, so
/// converting A→B→A with the same table gives the original amount (decision 2026-11-10 #10).
class ExchangeRates {
  const ExchangeRates({this.usdRates = const {}, this.overrides = const {}, this.fetchedAt});

  static const ExchangeRates empty = ExchangeRates();

  final Map<String, double> usdRates;
  final Map<String, double> overrides;

  /// When [usdRates] were last fetched; `null` = never (offline since install).
  final DateTime? fetchedAt;

  static String pairKey(String from, String to) => '${from.toUpperCase()}>${to.toUpperCase()}';

  Ratio? _perUsd(String code) {
    final v = usdRates[code];
    if (v != null) return Ratio.fromDouble(v);
    return code == 'USD' ? Ratio.one : null;
  }

  /// Exact rate "1 [from] = ? [to]"; `null` when unknown.
  Ratio? exactRate(String from, String to) {
    from = from.toUpperCase();
    to = to.toUpperCase();
    if (from == to) return Ratio.one;
    final direct = overrides[pairKey(from, to)];
    if (direct != null) return Ratio.fromDouble(direct);
    final inverse = overrides[pairKey(to, from)];
    if (inverse != null) return Ratio.fromDouble(inverse)?.inverse;
    final f = _perUsd(from), t = _perUsd(to);
    if (f == null || t == null) return null;
    return t / f;
  }

  /// Rate to multiply an amount in [from] by to get [to]; `null` when unknown.
  /// For display (rate screens); convert money with [convertMinor].
  double? rate(String from, String to) => exactRate(from, to)?.toDouble();

  /// Converts [minor] units of [from] to minor units of [to] — exactly, then rounded half away
  /// from zero to the smallest unit of [to] (a *Converted amount*). [times] scales the amount
  /// before rounding (e.g. periods per month for a Monthly cost). `null` when the rate is unknown.
  int? convertMinor(int minor, String from, String to, {Ratio? times}) {
    final r = exactRate(from, to);
    if (r == null) return null;
    final ten = BigInt.from(10);
    final scale = times ?? Ratio.one;
    final n = BigInt.from(minor) * r.numerator * scale.numerator * ten.pow(currencyDecimals(to));
    final d = r.denominator * scale.denominator * ten.pow(currencyDecimals(from));
    return roundHalfUp(n, d);
  }

  /// [m] as a Converted amount in [to]; `null` when the rate is unknown.
  Money? convertMoney(Money m, String to) {
    final v = convertMinor(m.minor, m.currency, to);
    return v == null ? null : Money(v, to.toUpperCase());
  }

  /// Converts a major-unit [amount] (e.g. a price being typed) the same way as [convertMinor]:
  /// the result is rounded to the smallest unit of [to], so a "≈" shown next to a field matches
  /// the number that will count in totals. `null` when the rate is unknown.
  double? convert(double amount, String from, String to) {
    final v = convertMinor(toMinorUnits(amount, from), from, to);
    return v == null ? null : toMajorUnits(v, to);
  }

  bool isOverridden(String from, String to) =>
      overrides.containsKey(pairKey(from, to)) || overrides.containsKey(pairKey(to, from));

  /// Whether the provider rates are older than [maxAge] (or missing).
  bool isStale(DateTime now, {Duration maxAge = const Duration(days: 1)}) =>
      fetchedAt == null || now.difference(fetchedAt!) >= maxAge;

  ExchangeRates copyWith({Map<String, double>? usdRates, Map<String, double>? overrides, DateTime? fetchedAt}) =>
      ExchangeRates(
        usdRates: usdRates ?? this.usdRates,
        overrides: overrides ?? this.overrides,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
}
