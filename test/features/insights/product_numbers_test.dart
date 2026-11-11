import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import 'product_sample.dart';

/// The fixture reproduces the numbers the v14 mockups show (product.md §6).
void main() {
  const calc = SpendingCalculator(rates: Product.rates, primaryCurrency: Product.primary);
  final history = PriceHistory(Product.priceChanges);
  final stats = MonthStatsCalculator(calc, history: history);
  const nov = LocalDate(2026, 11, 1);

  test('November: ≈ \$144.89 in 10 subscriptions, −\$4.00 vs October', () {
    final m = stats.month(Product.subscriptions, nov);
    expect(m.totalMinor, 14489);
    expect(m.count, 10);
    expect(m.changeMinor, -400);
    expect(m.dailyAverageMinor, 483);
  });

  test('November cash flow: Paid \$41.99, Still to pay \$74.58', () {
    final c = stats.cashFlow(Product.subscriptions, Product.periods, nov, Product.today);
    expect(c.paidMinor, 4199);
    expect(c.remainingMinor, 7458);
  });

  test('price rises +\$3.50 a month', () {
    final r = PriceIncreaseCalculator(calc, history).report(Product.subscriptions, Product.today);
    expect(r.monthlyDeltaMinor, 350);
    expect(r.biggest!.subscription.id, 'netflix');
  });
}
