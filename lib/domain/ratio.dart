/// Exact positive fractions for currency conversion (APP.md decision 2026-11-10 #10,
/// like A002 D-029): rates and "periods per month" are kept as `numerator / denominator`
/// so converting never goes through floating point and A→B→A with one table is exact.
library;

/// An exact, positive, reduced fraction `numerator / denominator`.
class Ratio {
  Ratio._(this.numerator, this.denominator);

  /// Builds `n / d` (both > 0), reduced.
  factory Ratio(BigInt n, BigInt d) {
    if (n <= BigInt.zero || d <= BigInt.zero) {
      throw ArgumentError('Ratio must be positive: $n/$d');
    }
    final g = n.gcd(d);
    return Ratio._(n ~/ g, d ~/ g);
  }

  factory Ratio.ints(int n, [int d = 1]) => Ratio(BigInt.from(n), BigInt.from(d));

  static final Ratio one = Ratio._(BigInt.one, BigInt.one);

  final BigInt numerator;
  final BigInt denominator;

  static final Map<double, Ratio?> _fromDoubleCache = {};

  /// The exact decimal a [double] was written as — its shortest round-trip form
  /// (`25769.065289`, `0.0000394`, `1e-7`), so a rate typed by the user, read from the
  /// provider's JSON or from the bundled table is kept digit for digit, not as the binary
  /// approximation. `null` when not finite or ≤ 0.
  static Ratio? fromDouble(double value) {
    if (!value.isFinite || value <= 0) return null;
    if (_fromDoubleCache.length > 4096) _fromDoubleCache.clear();
    return _fromDoubleCache.putIfAbsent(value, () => tryParse(value.toString()));
  }

  /// Parses a decimal like `26000.5`, `0.0000385` or `3.85e-5` ("." as decimal separator,
  /// no grouping), or a fraction `n/d`. `null` when invalid or ≤ 0.
  static Ratio? tryParse(String text) {
    final t = text.trim();
    final frac = RegExp(r'^([0-9]+)/([0-9]+)$').firstMatch(t);
    if (frac != null) {
      final n = BigInt.parse(frac[1]!), d = BigInt.parse(frac[2]!);
      return n > BigInt.zero && d > BigInt.zero ? Ratio(n, d) : null;
    }
    final m = RegExp(r'^\+?([0-9]*)(?:\.([0-9]*))?(?:[eE]([+-]?[0-9]{1,3}))?$').firstMatch(t);
    if (m == null) return null;
    final whole = m[1] ?? '', fraction = m[2] ?? '';
    if (whole.isEmpty && fraction.isEmpty) return null;
    final exponent = int.parse(m[3] ?? '0');
    final ten = BigInt.from(10);
    var n = BigInt.parse('$whole$fraction');
    var d = ten.pow(fraction.length);
    if (exponent > 0) n *= ten.pow(exponent);
    if (exponent < 0) d *= ten.pow(-exponent);
    return n > BigInt.zero ? Ratio(n, d) : null;
  }

  Ratio get inverse => Ratio._(denominator, numerator);

  Ratio operator *(Ratio other) => Ratio(numerator * other.numerator, denominator * other.denominator);

  Ratio operator /(Ratio other) => Ratio(numerator * other.denominator, denominator * other.numerator);

  /// For display only (rate screens); never multiply money by this.
  double toDouble() => numerator / denominator;

  /// `amount × this`, rounded half away from zero to an integer (2.5 → 3, −2.5 → −3).
  int applyRounded(int amount) => roundHalfUp(BigInt.from(amount) * numerator, denominator);

  @override
  bool operator ==(Object other) =>
      other is Ratio && other.numerator == numerator && other.denominator == denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString() => '$numerator/$denominator';
}

/// `n / d` rounded half away from zero (`d > 0`).
int roundHalfUp(BigInt n, BigInt d) {
  assert(d > BigInt.zero);
  final q = (n.abs() * BigInt.two + d) ~/ (d * BigInt.two);
  return (n.isNegative ? -q : q).toInt();
}
