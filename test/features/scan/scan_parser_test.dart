import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/scan/scan_parser.dart';

const today = LocalDate(2026, 11, 10);
const parser = ScanParser(today: today, dayFirst: false);
const parserVi = ScanParser(today: today);

void main() {
  group('amounts', () {
    final cases = <String, (int, String)>{
      r'$9.99/month': (999, 'USD'),
      r'US$12.99': (1299, 'USD'),
      '9,99 € / Monat': (999, 'EUR'),
      '£4.99 per month': (499, 'GBP'),
      'VND 260,000': (260000, 'VND'),
      '₫260,000': (260000, 'VND'),
      '260.000đ/tháng': (260000, 'VND'),
      '1.299.000 ₫/năm': (1299000, 'VND'),
      '1,234.56 USD': (123456, 'USD'),
      'Netflix  \$15.49/month': (1549, 'USD'),
    };
    cases.forEach((row, want) {
      test(row, () {
        final a = parser.amountIn(row);
        expect(a, isNotNull);
        expect((a!.minor, a.currency), want);
      });
    });

    test('no currency → no amount; "PREMIUM" is no currency', () {
      expect(parser.amountIn('100 GB'), isNull);
      expect(parser.amountIn('YOUTUBE PREMIUM 2'), isNull);
      expect(parser.amountIn('9:41'), isNull);
    });
  });

  group('dates and cycles', () {
    test('EN, VI, numeric; a year-less renewal is the next one, a charge the last one', () {
      expect(parser.dateIn('Renews on Nov 24, 2026')!.date, const LocalDate(2026, 11, 24));
      expect(parser.dateIn('Renews on Nov 24, 2026')!.renewal, isTrue);
      expect(parser.dateIn('24 Nov 2026')!.date, const LocalDate(2026, 11, 24));
      expect(parserVi.dateIn('Gia hạn vào 12 thg 10, 2027')!.date, const LocalDate(2027, 10, 12));
      expect(parserVi.dateIn('Ngày 24/11/2026')!.date, const LocalDate(2026, 11, 24));
      expect(parser.dateIn('11/24/2026')!.date, const LocalDate(2026, 11, 24));
      expect(parser.dateIn('2026-11-24')!.date, const LocalDate(2026, 11, 24));
      expect(parser.dateIn('Renews Jan 14')!.date, const LocalDate(2027, 1, 14));
      expect(parser.dateIn('Paid Dec 2')!.date, const LocalDate(2025, 12, 2));
      expect(parser.dateIn(r'$12.11/month'), isNull);
      expect(parser.dateIn('Marvel Unlimited 2'), isNull);
    });

    test('cycles', () {
      expect(parser.cycleIn(r'$9.99/month'), const BillingCycle.monthly());
      expect(parser.cycleIn(r'$99.99/year'), const BillingCycle.yearly());
      expect(parser.cycleIn('Yearly'), const BillingCycle.yearly());
      expect(parser.cycleIn('1.299.000 ₫/năm'), const BillingCycle.yearly());
      expect(parser.cycleIn('Hằng tháng'), const BillingCycle.monthly());
      expect(parser.cycleIn('every 3 months'), const BillingCycle.quarterly());
      expect(parser.cycleIn('Microsoft 365'), isNull);
    });
  });

  group('screens', () {
    test('Google Play subscriptions page (EN): three renewals with names, prices and cycles', () {
      final out = parser.parse([
        '9:41',
        'Payments & subscriptions',
        'Subscriptions',
        'Active',
        'Max',
        r'$9.99/month',
        'Renews on Nov 24, 2026',
        'Notion Plus',
        r'$10.00/month',
        'Next payment Nov 25, 2026',
        'Microsoft 365 Personal',
        r'$99.99/year',
        'Renews Jan 14, 2027',
      ]);
      expect(out.map((c) => c.name), ['Max', 'Notion Plus', 'Microsoft 365 Personal']);
      expect(out.map((c) => c.amountMinor), [999, 1000, 9999]);
      expect(out.every((c) => c.isRenewal && c.currency == 'USD' && c.source == DetectionSource.scan), isTrue);
      expect(out.map((c) => c.cycle), [
        const BillingCycle.monthly(),
        const BillingCycle.monthly(),
        const BillingCycle.yearly(),
      ]);
      expect(out.last.date, const LocalDate(2027, 1, 14));
    });

    test('App Store page in Vietnamese, name and price on one row', () {
      final out = parserVi.parse([
        'Gói đăng ký',
        'Đang hoạt động',
        'Duolingo Super  1.299.000 ₫/năm',
        'Gia hạn vào 12 thg 10, 2027',
      ]);
      expect(out, hasLength(1));
      expect(out.single.name, 'Duolingo Super');
      expect(out.single.amountMinor, 1299000);
      expect(out.single.currency, 'VND');
      expect(out.single.cycle, const BillingCycle.yearly());
      expect(out.single.isRenewal, isTrue);
    });

    test('receipt: a past charge; tax ignored; the cycle from the item line', () {
      final out = parser.parse([
        'Order receipt',
        'Max · Monthly',
        r'$9.99',
        'Nov 8, 2026',
        r'Tax $0.00',
        r'Total $9.99',
      ]);
      expect(out, hasLength(1));
      final c = out.single;
      expect(c.name, 'Max');
      expect(c.amountMinor, 999);
      expect(c.date, const LocalDate(2026, 11, 8));
      expect(c.isRenewal, isFalse);
      expect(c.cycle, const BillingCycle.monthly());
    });

    test('nothing to read → nothing; a price without a date or a name is dropped', () {
      expect(parser.parse(['Photos', 'Hello world', '100 GB']), isEmpty);
      expect(parser.parse(['Netflix', r'$15.49/month']), isEmpty);
      expect(parser.parse([r'$15.49', 'Renews Nov 24, 2026']), isEmpty);
    });
  });
}
