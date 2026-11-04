import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/domain/domain.dart';

import 'fixtures.dart';

void main() {
  const d = LocalDate.new;
  const today = LocalDate(2026, 11, 4);

  group('SubscriptionDraft', () {
    test('validation', () {
      final draft = SubscriptionDraft.blank(currency: 'VND', today: today);
      expect(draft.validate(today), [DraftError.nameEmpty, DraftError.priceNotPositive]);
      draft
        ..name = 'Netflix'
        ..priceMinor = 260000
        ..trial = true
        ..trialEnd = d(2026, 11, 3);
      expect(draft.validate(today), [DraftError.trialEndInPast]);
      draft.trialEnd = today;
      expect(draft.validate(today), isEmpty);
    });

    test('new subscription; trial end is the first Due date', () {
      final draft = SubscriptionDraft.blank(currency: 'VND', today: today)
        ..name = ' Spotify '
        ..priceMinor = 59000
        ..trial = true
        ..trialEnd = d(2026, 11, 10)
        ..notes = '  ';
      final s = draft.toNew(id: 'x', today: today, now: fixedNow);
      expect(s.name, 'Spotify');
      expect(s.status, SubscriptionStatus.trial);
      expect(s.dueDate, d(2026, 11, 10));
      expect(s.notes, isNull);
      expect(s.startDate, today);
    });

    test('blank draft: next due date one month from today', () {
      expect(SubscriptionDraft.blank(currency: 'USD', today: today).dueDate, d(2026, 12, 4));
    });

    test('edit: changing the due date re-anchors; unchanged keeps index', () {
      final original = sub(anchor: d(2026, 1, 31), periodIndex: 10); // due 2026-11-30
      final same = SubscriptionDraft.fromSubscription(original, today)..priceMinor = 300000;
      final kept = same.applyTo(original, now: fixedNow);
      expect(kept.periodIndex, 10);
      expect(kept.priceMinor, 300000);

      final moved = SubscriptionDraft.fromSubscription(original, today)..dueDate = d(2026, 11, 15);
      final rebased = moved.applyTo(original, now: fixedNow);
      expect(rebased.dueDate, d(2026, 11, 15));
      expect(rebased.periodIndex, 0);
    });

    test('edit: changing the cycle re-anchors on the current due date', () {
      final original = sub(anchor: d(2026, 11, 20));
      final edited = SubscriptionDraft.fromSubscription(original, today)..cycle = const BillingCycle.yearly();
      final s = edited.applyTo(original, now: fixedNow);
      expect(s.dueDate, d(2026, 11, 20));
      expect(BillingRules.dueDatesBetween(s, today, d(2027, 12, 31)), [d(2026, 11, 20), d(2027, 11, 20)]);
    });

    test('edit: turning the trial off makes it Active', () {
      final original = BillingRules.startTrial(sub(), d(2026, 11, 20), fixedNow);
      final s = (SubscriptionDraft.fromSubscription(original, today)..trial = false).applyTo(original, now: fixedNow);
      expect(s.status, SubscriptionStatus.active);
      expect(s.trialEndDate, isNull);
      expect(s.dueDate, d(2026, 11, 20));
    });

    test('an ended trial is edited as Active (no "trial end in the past" error)', () {
      final original = BillingRules.startTrial(sub(), d(2026, 11, 1), fixedNow);
      final draft = SubscriptionDraft.fromSubscription(original, today);
      expect(draft.trial, isFalse);
      expect(draft.validate(today), isEmpty);
    });

    test('my share and next due dates preview', () {
      final draft = SubscriptionDraft.blank(currency: 'VND', today: today)
        ..priceMinor = 260000
        ..sharedWith = 4
        ..dueDate = d(2026, 1, 31);
      expect(draft.myShareMinor, 65000);
      expect(draft.nextDueDates(), [d(2026, 1, 31), d(2026, 2, 28), d(2026, 3, 31)]);
    });
  });

  group('Catalog', () {
    const json = '''
{"version":1,"services":[
 {"id":"netflix","name":"Netflix","category":"video","color":"#E50914","monogram":"N","aliases":["phim"],
  "cancelUrl":"https://www.netflix.com/cancelplan","manageUrl":null,
  "plans":[{"id":"mobile","name":"Mobile","cycle":{"unit":"month","count":1},"prices":{"VN":{"currency":"VND","amount":74000}}},
           {"id":"premium","name":"Premium","cycle":{"unit":"month","count":1},"prices":{"VN":{"currency":"VND","amount":260000},"US":{"currency":"USD","amount":24.99}},"members":4}]},
 {"id":"zing","name":"Zing MP3","category":"music","color":"#8A2BE2","monogram":"Z","market":"vn","aliases":["nghe nhac"],
  "cancelUrl":null,"manageUrl":null,
  "plans":[{"id":"vip","name":"VIP","cycle":{"unit":"year","count":1},"prices":{"VN":{"currency":"VND","amount":240000}}}]},
 {"id":"broken","name":"Broken"}
]}''';

    test('parses services, skips broken entries', () {
      final list = CatalogRepository.parse(json);
      expect(list.map((s) => s.id), ['netflix', 'zing']);
      final n = list.first;
      expect(n.colorValue, 0xFFE50914);
      expect(n.plans[1].members, 4);
      expect(list[1].isVietnamese, isTrue);
    });

    test('accent-insensitive search on name and aliases', () {
      final list = CatalogRepository.parse(json);
      expect(list.where((s) => s.matches('nghe nhạc')).map((s) => s.id), ['zing']);
      expect(list.where((s) => s.matches('NETF')).map((s) => s.id), ['netflix']);
      expect(normalizeForSearch('Đồng Việt Nam'), 'dong viet nam');
    });

    test('price by region falls back to US; from-per-month uses the cheapest plan', () {
      final n = CatalogRepository.parse(json).first;
      expect(n.plans[1].priceFor('VN')!.amount, 260000);
      expect(n.plans[1].priceFor('JP')!.currency, 'USD');
      expect(n.plans[0].priceFor('US'), isNull);
      expect(n.fromPerMonth('VN'), ('VND', 74000.0));
      final zing = CatalogRepository.parse(json)[1];
      expect(zing.fromPerMonth('VN')!.$2, closeTo(20000, 1e-9));
    });

    test('subscriptionFromCatalog', () {
      final n = CatalogRepository.parse(json).first;
      final s = subscriptionFromCatalog(n, n.plans[1], region: 'VN', id: 'x', today: today, now: fixedNow)!;
      expect(s.name, 'Netflix Premium');
      expect(s.priceMinor, 260000);
      expect(s.currency, 'VND');
      expect(s.dueDate, d(2026, 12, 4));
      expect(s.manageUrl, 'https://www.netflix.com/cancelplan');
      expect(s.serviceId, 'netflix');
      expect(subscriptionFromCatalog(n, n.plans[0], region: 'US', id: 'y', today: today, now: fixedNow), isNull);
    });
  });
}
