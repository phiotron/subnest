import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/utils/format.dart';
import 'package:subnest/domain/domain.dart';

void main() {
  setUpAll(initializeDateFormatting);

  test('money per locale (product.md §7.5)', () {
    expect(Fmt.money(260000, 'VND', 'vi'), '260.000đ');
    expect(Fmt.money(260000, 'VND', 'en'), '₫260,000');
    expect(Fmt.money(9.99, 'USD', 'en'), r'$9.99');
    expect(Fmt.money(1284000, 'VND', 'vi_VN', approx: true), '≈ 1.284.000đ');
  });

  test('dates', () {
    expect(Fmt.date(const LocalDate(2026, 11, 4), 'vi'), '04/11/2026');
    expect(Fmt.date(const LocalDate(2026, 11, 4), 'en'), 'Nov 4, 2026');
  });

  test('parseAmount handles both decimal conventions', () {
    expect(Fmt.parseAmount('260.000', 'VND'), 260000);
    expect(Fmt.parseAmount('260,000đ', 'VND'), 260000);
    expect(Fmt.parseAmount('1 690 000', 'VND'), 1690000);
    expect(Fmt.parseAmount('9.99', 'USD'), 9.99);
    expect(Fmt.parseAmount('9,99', 'USD'), 9.99);
    expect(Fmt.parseAmount('1,234.50', 'USD'), 1234.5);
    expect(Fmt.parseAmount('1.234,50', 'EUR'), 1234.5);
    expect(Fmt.parseAmount('1,000', 'USD'), 1000);
    expect(Fmt.parseAmount('20', 'USD'), 20);
    expect(Fmt.parseAmount('', 'USD'), isNull);
    expect(Fmt.parseAmount('abc', 'USD'), isNull);
  });

  test('editable text', () {
    expect(Fmt.editable(65000, 'VND'), '65000');
    expect(Fmt.editable(999, 'USD'), '9.99');
  });
}
