/// Exchange rates used to convert amounts to the Primary currency.
///
/// [usdRates] are "units of currency per 1 USD" from the rate provider (cached).
/// [overrides] are user-set rates for a pair: `overrides['USD>VND'] = 25400`
/// means 1 USD = 25 400 VND. Overrides always win over provider rates.
class ExchangeRates {
  const ExchangeRates({this.usdRates = const {}, this.overrides = const {}, this.fetchedAt});

  static const ExchangeRates empty = ExchangeRates();

  final Map<String, double> usdRates;
  final Map<String, double> overrides;

  /// When [usdRates] were last fetched; `null` = never (offline since install).
  final DateTime? fetchedAt;

  static String pairKey(String from, String to) => '${from.toUpperCase()}>${to.toUpperCase()}';

  /// Rate to multiply an amount in [from] by to get [to]; `null` when unknown.
  double? rate(String from, String to) {
    from = from.toUpperCase();
    to = to.toUpperCase();
    if (from == to) return 1;
    final direct = overrides[pairKey(from, to)];
    if (direct != null) return direct;
    final inverse = overrides[pairKey(to, from)];
    if (inverse != null && inverse != 0) return 1 / inverse;
    final f = usdRates[from] ?? (from == 'USD' ? 1 : null);
    final t = usdRates[to] ?? (to == 'USD' ? 1 : null);
    if (f == null || t == null || f == 0) return null;
    return t / f;
  }

  /// Converts a major-unit [amount]; `null` when the rate is unknown.
  double? convert(double amount, String from, String to) {
    final r = rate(from, to);
    return r == null ? null : amount * r;
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
