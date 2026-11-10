import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/catalog/price_notices.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/domain/domain.dart';

import '../../domain/fixtures.dart';
import 'catalog_fixtures.dart';

void main() {
  List<CatalogService> catalog({
    double standardUs = 17.99,
    double premiumUs = 24.99,
    int standardVn = 220000,
    String boxStatus = 'active',
    String? boxRenamedFrom,
    String boxName = 'Basic',
  }) => CatalogRepository.parse(
    jsonEncode(
      catalogMap(
        standardUs: standardUs,
        premiumUs: premiumUs,
        standardVn: standardVn,
        boxStatus: boxStatus,
        boxRenamedFrom: boxRenamedFrom,
        boxName: boxName,
      ),
    ),
    today: const LocalDate(2026, 11, 10),
  );

  Subscription linked(String name, int price, {String currency = 'USD', String id = 's1', String service = 'netflix'}) =>
      sub(id: id, name: name, priceMinor: price, currency: currency).copyWith(serviceId: service);

  final v12 = catalog();
  final v13 = catalog(premiumUs: 26.99, standardVn: 260000);

  PriceLedger ledgerOf(List<List<CatalogService>> seen) {
    final l = PriceLedger();
    for (final c in seen) {
      l.record(c);
    }
    return l;
  }

  test('notice only while the price still equals an earlier Catalog price', () {
    final ledger = ledgerOf([v12, v13]);
    final subs = [
      linked('Netflix Premium', 2499, id: 'old-price'), // still on v12 price → notice
      linked('Netflix Premium', 2699, id: 'new-price'), // already on v13 price
      linked('Netflix Premium', 2000, id: 'typed'), // user typed their own price → never
      linked('Netflix Standard', 220000, currency: 'VND', id: 'vn'), // VN region
      linked('Netflix Premium', 2499, id: 'custom').copyWith(serviceId: null), // no Catalog link
      linked('Netflix Premium', 2499, id: 'cancelled').copyWith(status: SubscriptionStatus.cancelled),
    ];
    final notices = findPriceChangeNotices(subscriptions: subs, services: v13, ledger: ledger);
    expect({for (final n in notices) n.subscription.id: (n.oldPriceMinor, n.newPriceMinor, n.currency, n.region)}, {
      'old-price': (2499, 2699, 'USD', 'US'),
      'vn': (220000, 260000, 'VND', 'VN'),
    });
    expect(notices.first.isIncrease, isTrue);
    expect(notices.first.plan.id, 'premium');
  });

  test('a ledger without the old price (first launch after a change elsewhere) → no notice', () {
    final notices = findPriceChangeNotices(
      subscriptions: [linked('Netflix Premium', 2499)],
      services: v13,
      ledger: ledgerOf([v13]),
    );
    expect(notices, isEmpty);
  });

  test('Keep old price: not asked again for that price; a later different price asks again', () {
    final s = linked('Netflix Premium', 2499);
    final first = findPriceChangeNotices(subscriptions: [s], services: v13, ledger: ledgerOf([v12, v13])).single;
    final kept = {first.decisionKey};
    expect(findPriceChangeNotices(subscriptions: [s], services: v13, ledger: ledgerOf([v12, v13]), kept: kept), isEmpty);
    final v14 = catalog(premiumUs: 27.99);
    final again = findPriceChangeNotices(subscriptions: [s], services: v14, ledger: ledgerOf([v12, v13, v14]), kept: kept);
    expect(again.single.newPriceMinor, 2799);
  });

  test('a price back to an older one asks to go back too (ledger keeps every price)', () {
    final s = linked('Netflix Premium', 2699);
    final notices = findPriceChangeNotices(subscriptions: [s], services: v12, ledger: ledgerOf([v12, v13]));
    expect((notices.single.newPriceMinor, notices.single.isIncrease), (2499, false));
  });

  group('plan matching', () {
    final svc = v12.firstWhere((s) => s.id == 'netflix');

    test('by name (case/accents/spaces), else by unique price + cycle; ambiguous → none', () {
      final ledger = ledgerOf([v12]);
      expect(CatalogPlanMatcher.match(linked('netflix  premium', 1), svc, ledger)!.plan.id, 'premium');
      final byPrice = CatalogPlanMatcher.match(linked('My Netflix', 1799), svc, ledger)!;
      expect((byPrice.plan.id, byPrice.byName), ('standard', false));
      expect(CatalogPlanMatcher.match(linked('My Netflix', 999), svc, ledger), isNull);
      // Yearly subscription: no monthly plan by price.
      final yearly = linked('My Netflix', 1799).copyWith(cycle: const BillingCycle.yearly());
      expect(CatalogPlanMatcher.match(yearly, svc, ledger), isNull);
      // Ambiguous: two plans priced the same.
      final same = catalog(standardUs: 24.99).firstWhere((s) => s.id == 'netflix');
      expect(CatalogPlanMatcher.match(linked('My Netflix', 2499), same, ledger), isNull);
    });

    test('a one-plan service matches its bare name', () {
      final spotify = v12.firstWhere((s) => s.id == 'spotify');
      expect(CatalogPlanMatcher.match(linked('Spotify', 1, service: 'spotify'), spotify, PriceLedger())!.plan.id, 'individual');
    });
  });

  group('discontinued plan', () {
    Map<String, CatalogPlanNote> notes(List<CatalogService> c, List<Subscription> subs) =>
        findPlanNotes(subscriptions: subs, services: c, ledger: ledgerOf([v12, c]));

    final subs = [
      linked('Old Box Basic', 500, service: 'old-box', id: 'basic'),
      linked('Old Box Plus', 900, service: 'old-box', id: 'plus'),
      linked('Netflix Premium', 2499, id: 'nf'),
    ];

    test('active plans → no note', () => expect(notes(v12, subs), isEmpty));

    test('discontinued / closed to new customers → note on that subscription only', () {
      final d = notes(catalog(boxStatus: 'discontinued'), subs);
      expect(d.keys, ['basic']);
      expect((d['basic']!.kind, d['basic']!.plan.id), (CatalogPlanNoteKind.discontinued, 'basic'));
      expect(notes(catalog(boxStatus: 'closed_to_new'), subs)['basic']!.kind, CatalogPlanNoteKind.closedToNew);
    });

    test('renamed plan → note with the old name; matched by price when named freely', () {
      final c = catalog(boxName: 'Starter', boxRenamedFrom: 'Basic');
      final r = notes(c, subs)['basic']!;
      expect((r.kind, r.previousName, r.plan.name), (CatalogPlanNoteKind.renamed, 'Basic', 'Starter'));
      final free = [linked('My box', 500, service: 'old-box', id: 'free')];
      expect(notes(catalog(boxStatus: 'discontinued'), free)['free']!.kind, CatalogPlanNoteKind.discontinued);
    });

    test('cycle changed by the user still gets the note (matched by name)', () {
      final yearly = subs.first.copyWith(cycle: const BillingCycle.yearly());
      expect(notes(catalog(boxStatus: 'discontinued'), [yearly]).keys, ['basic']);
    });
  });

  test('ledger JSON round trip; capped per key', () {
    final l = ledgerOf([v12, v13]);
    final back = PriceLedger.fromJson(jsonDecode(jsonEncode(l.toJson())));
    expect(back.contains(PriceLedger.key('netflix', 'premium', 'US', 'USD'), 2499), isTrue);
    expect(back.contains(PriceLedger.key('netflix', 'premium', 'US', 'USD'), 2699), isTrue);
    for (var i = 0; i < 20; i++) {
      l.record(catalog(premiumUs: 30.0 + i));
    }
    expect(l.contains(PriceLedger.key('netflix', 'premium', 'US', 'USD'), 2499), isFalse);
    expect(l.contains(PriceLedger.key('netflix', 'premium', 'US', 'USD'), 4900), isTrue);
  });
}
