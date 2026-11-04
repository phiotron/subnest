/// Money helpers. Amounts are stored as integer *minor units* of their currency
/// (VND has 0 decimals, USD 2, BHD 3…) so sums of Payments are exact.
library;

/// ISO 4217 currencies whose minor unit is not 2 decimals.
const Map<String, int> _nonTwoDecimalCurrencies = {
  // 0 decimals
  'BIF': 0, 'CLP': 0, 'DJF': 0, 'GNF': 0, 'ISK': 0, 'JPY': 0, 'KMF': 0, 'KRW': 0,
  'PYG': 0, 'RWF': 0, 'UGX': 0, 'UYI': 0, 'VND': 0, 'VUV': 0, 'XAF': 0, 'XOF': 0,
  'XPF': 0, 'IDR': 0, 'HUF': 0, 'TWD': 0,
  // 3 decimals
  'BHD': 3, 'IQD': 3, 'JOD': 3, 'KWD': 3, 'LYD': 3, 'OMR': 3, 'TND': 3,
};

/// Number of decimals used for [currency] amounts in this app.
///
/// Note: IDR, HUF and TWD officially have 2 decimals but are never priced with
/// cents in practice, so we treat them as whole units.
int currencyDecimals(String currency) => _nonTwoDecimalCurrencies[currency.toUpperCase()] ?? 2;

int _pow10(int n) {
  var r = 1;
  for (var i = 0; i < n; i++) {
    r *= 10;
  }
  return r;
}

/// Converts a major-unit amount (e.g. 9.99 USD) to minor units (999), rounding half away from zero.
int toMinorUnits(double major, String currency) => (major * _pow10(currencyDecimals(currency))).round();

/// Converts minor units back to a major-unit `double` (999 → 9.99).
double toMajorUnits(int minor, String currency) => minor / _pow10(currencyDecimals(currency));

/// An amount in a specific currency, in minor units.
class Money {
  const Money(this.minor, this.currency);

  factory Money.major(double major, String currency) => Money(toMinorUnits(major, currency), currency);

  final int minor;
  final String currency;

  double get major => toMajorUnits(minor, currency);

  @override
  bool operator ==(Object other) => other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  @override
  String toString() => '$major $currency';
}
