import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/router/routes.dart';
import 'package:subnest/core/utils/format.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/widget_sync/widget_sync.dart';
import 'package:subnest/l10n/generated/app_localizations.dart';

import '../../domain/fixtures.dart';

const today = LocalDate(2026, 11, 4);
final en = lookupAppLocalizations(const Locale('en'));
final vi = lookupAppLocalizations(const Locale('vi'));
const rates = ExchangeRates(usdRates: {'USD': 1, 'VND': 25400});

/// Seven subscriptions in VND + USD: one awaiting, a Trial, one Paused, one Cancelled.
List<Subscription> sample() => [
  sub(id: 'netflix', name: 'Netflix', priceMinor: 260000, anchor: const LocalDate(2026, 11, 2)), // awaiting
  sub(id: 'spotify', name: 'Spotify', priceMinor: 59000, anchor: const LocalDate(2026, 11, 6)),
  sub(id: 'chatgpt', name: 'ChatGPT Plus', priceMinor: 2000, currency: 'USD', anchor: const LocalDate(2026, 11, 7)),
  sub(
    id: 'icloud',
    name: 'iCloud+',
    priceMinor: 59000,
    anchor: const LocalDate(2026, 11, 15),
    status: SubscriptionStatus.trial,
    trialEnd: const LocalDate(2026, 11, 15),
  ),
  sub(id: 'youtube', name: 'YouTube', priceMinor: 35800, anchor: const LocalDate(2026, 11, 22)),
  sub(id: 'viettel', name: 'Viettel 5G', priceMinor: 150000, anchor: const LocalDate(2026, 12, 1)),
  sub(id: 'gym', name: 'Gym', priceMinor: 500000, anchor: const LocalDate(2026, 11, 5), status: SubscriptionStatus.paused),
  sub(id: 'disney', name: 'Disney', priceMinor: 80000, anchor: const LocalDate(2026, 11, 5), status: SubscriptionStatus.cancelled),
];

Map<String, Object?> build(List<Subscription> subs, {AppLocalizations? l, String primary = 'VND'}) {
  final calc = SpendingCalculator(rates: rates, primaryCurrency: primary);
  return WidgetSnapshot.build(
    l: l ?? en,
    subscriptions: subs,
    summary: calc.summary(subs, today),
    primaryCurrency: primary,
    today: today,
  );
}

List<Map<String, Object?>> itemsOf(Map<String, Object?> s) => (s['items']! as List).cast<Map<String, Object?>>();

/// Records what reaches the native store.
class FakeStore implements WidgetStore {
  final writes = <String>[];
  var clears = 0;

  Map<String, Object?> get last => jsonDecode(writes.last) as Map<String, Object?>;

  @override
  Future<void> write(String json) async => writes.add(json);

  @override
  Future<void> clear() async => clears++;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('vi');
  });

  group('snapshot — list (small / medium / large)', () {
    test('upcoming = Active + Trial, soonest first (awaiting first), at most 5; Paused/Cancelled left out', () {
      final s = build(sample());
      expect(s['state'], 'list');
      final items = itemsOf(s);
      expect(items.map((i) => i['id']), ['netflix', 'spotify', 'chatgpt', 'icloud', 'youtube']);
      expect(items.map((i) => i['name']), isNot(contains('Gym')));
      expect(items.map((i) => i['name']), isNot(contains('Disney')));
    });

    test('small widget data: next item with name, own-currency price, monogram, colours, due date', () {
      final s = build(sample());
      final next = itemsOf(s)[1]; // Spotify (Netflix awaits)
      expect(next['name'], 'Spotify');
      expect(next['price'], '₫59,000');
      expect(next['mono'], 'S');
      expect(next['color'], isA<int>());
      expect(next['onColor'], isA<int>());
      expect(next['date'], 'Fri, 6 Nov');
      expect(next['due'], '2026-11-06');
      expect(next['trial'], isFalse);
      expect(itemsOf(s)[2]['price'], r'$20.00');
      expect(itemsOf(s)[2]['mono'], 'CP');
      expect(s['next'], 'Next');
    });

    test('medium / large: monthly total is the Overview number (≈ when converted), badge counts awaiting', () {
      final subs = sample();
      final s = build(subs);
      final summary = const SpendingCalculator(rates: rates, primaryCurrency: 'VND').summary(subs, today);
      final total = Fmt.money(summary.monthly, 'VND', 'en', approx: true);
      expect(s['total'], total);
      expect(s['totalPerMonth'], '$total/mo');
      expect(s['totalA11y'], 'Monthly total $total');
      expect(s['badge'], '${summary.awaitingCount} to confirm');
      expect(s['title'], 'This month');
      expect(s['upcoming'], 'Upcoming');
    });

    test('no "≈" when every Active subscription is in the Primary currency; no badge without awaiting', () {
      final s = build([sub(id: 'a', name: 'Spotify', priceMinor: 59000, anchor: const LocalDate(2026, 11, 6))]);
      expect(s['total'], '₫59,000');
      expect(s.containsKey('badge'), isFalse);
    });

    test('Trial is flagged; relative due text mirrors the native rule', () {
      final s = build(sample());
      expect(itemsOf(s).firstWhere((i) => i['id'] == 'icloud')['trial'], isTrue);
      expect(s['firstCharge'], 'first charge');
      expect(WidgetSnapshot.dueText(s, -2), 'To confirm');
      expect(WidgetSnapshot.dueText(s, 0), 'To confirm');
      expect(WidgetSnapshot.dueText(s, 1), 'Tomorrow');
      expect(WidgetSnapshot.dueText(s, 11), 'In 11 days');
    });

    test('Vietnamese strings and formats', () {
      final s = build(sample(), l: vi);
      expect(s['lang'], 'vi');
      expect(s['upcoming'], 'Sắp trả');
      expect(itemsOf(s)[1]['price'], '59.000đ');
      expect(itemsOf(s)[1]['date'], 'T6, 6/11');
      expect(s['totalPerMonth'], endsWith('/tháng'));
      expect(WidgetSnapshot.dueText(s, 3), 'Còn 3 ngày');
      expect(WidgetSnapshot.dueText(s, 0), 'Chờ xác nhận');
    });
  });

  group('snapshot — empty', () {
    test('no subscriptions → empty state, no amounts', () {
      final s = build(const []);
      expect(s['state'], 'empty');
      expect(s['emptyTitle'], 'No renewals yet');
      expect(s.containsKey('items'), isFalse);
      expect(s.containsKey('total'), isFalse);
    });

    test('only Paused / Cancelled → empty state', () {
      final s = build(sample().where((x) => x.status == SubscriptionStatus.paused || x.status == SubscriptionStatus.cancelled).toList());
      expect(s['state'], 'empty');
    });
  });

  group('snapshot — App lock', () {
    for (final (name, l) in [('EN', en), ('VI', vi)]) {
      test('$name: only "Locked with PIN" — no amount, currency sign, digit or subscription name', () {
        final json = jsonEncode(WidgetSnapshot.locked(l));
        final s = jsonDecode(json) as Map<String, Object?>;
        expect(s['state'], 'locked');
        expect(s['locked'], l.widgetLocked);
        expect(s.keys.toSet(), {'v', 'state', 'lang', 'locked', 'open'});
        final text = '${s['locked']} ${s['open']}';
        expect(text, isNot(matches(RegExp(r'[0-9$₫đ€£¥≈]'))));
        for (final x in sample()) {
          expect(json, isNot(contains(x.name)));
        }
      });
    }
  });

  group('deep links', () {
    test('row → subscription detail; overview → Overview', () {
      expect(widgetRouteFor(Uri.parse(WidgetLinks.subscription('3f1c-ab_9'))), AppRoutes.subscriptionDetail('3f1c-ab_9'));
      expect(widgetRouteFor(Uri.parse(WidgetLinks.overview)), AppRoutes.home);
    });

    test('anything else is refused', () {
      for (final link in [
        null,
        'https://widget/overview',
        'subnest://other/overview',
        'subnest://widget/settings',
        'subnest://widget/subscription/a/edit',
        'subnest://widget/subscription/..%2Fsettings',
        'subnest://widget/subscription/',
      ]) {
        expect(widgetRouteFor(link == null ? null : Uri.parse(link)), isNull, reason: '$link');
      }
    });
  });

  group('widgetSyncProvider', () {
    late StreamController<List<Subscription>> subs;
    late StreamController<AppSettings> settings;
    late FakeStore store;
    late ProviderContainer container;
    var lock = const AsyncValue<bool>.data(false);

    setUp(() {
      subs = StreamController.broadcast();
      settings = StreamController.broadcast();
      store = FakeStore();
      lock = const AsyncData(false);
      container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(() => DateTime(2026, 11, 4, 10)),
          subscriptionsProvider.overrideWith((ref) => subs.stream),
          settingsProvider.overrideWith((ref) => settings.stream),
          ratesProvider.overrideWith((ref) => Stream.value(rates)),
          periodsProvider.overrideWith((ref) => Stream.value(const [])),
          widgetStoreProvider.overrideWithValue(store),
          appLockEnabledProvider.overrideWith((ref) => lock),
        ],
      );
      container.listen(widgetSyncProvider, (_, _) {}, onError: (e, st) => fail('$e $st'));
    });

    tearDown(() {
      container.dispose();
      subs.close();
      settings.close();
    });

    Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 10));

    AppSettings settingsWith({String locale = 'en', String currency = 'VND'}) =>
        AppSettings(primaryCurrency: currency, localeCode: locale, onboardingDone: true);

    test('writes nothing until settings and data are loaded, then the list; identical data is not rewritten', () async {
      await settle();
      expect(store.writes, isEmpty);
      settings.add(settingsWith());
      await settle();
      expect(store.writes, isEmpty);
      subs.add(sample());
      await settle();
      expect(store.last['state'], 'list');
      final count = store.writes.length;
      subs.add(sample());
      await settle();
      expect(store.writes.length, count);
    });

    test('follows data, language and Primary currency changes', () async {
      settings.add(settingsWith());
      subs.add(sample());
      await settle();
      subs.add(sample().take(2).toList());
      await settle();
      expect(itemsOf(store.last).length, 2);
      settings.add(settingsWith(locale: 'vi'));
      await settle();
      expect(store.last['lang'], 'vi');
      settings.add(settingsWith(locale: 'vi', currency: 'USD'));
      await settle();
      expect(store.last['total'], allOf(startsWith('≈ '), endsWith(r'$'))); // vi: "≈ 12,56 $"
    });

    test('App lock on → the locked snapshot overwrites the data; off again → data back', () async {
      settings.add(settingsWith());
      subs.add(sample());
      await settle();
      expect(store.last['state'], 'list');

      lock = const AsyncData(true);
      container.invalidate(appLockEnabledProvider);
      await settle();
      expect(store.last['state'], 'locked');
      expect(store.writes.last, isNot(contains('Spotify')));
      expect(store.writes.last, isNot(contains('₫')));

      lock = const AsyncData(false);
      container.invalidate(appLockEnabledProvider);
      await settle();
      expect(store.last['state'], 'list');
    });

    test('lock state loading or failed counts as locked (no data written)', () async {
      lock = const AsyncLoading();
      container.invalidate(appLockEnabledProvider);
      settings.add(settingsWith(locale: 'vi'));
      subs.add(sample());
      await settle();
      expect(store.last['state'], 'locked');
      expect(store.last['locked'], 'Đã khoá bằng PIN');

      lock = AsyncError(StateError('keystore'), StackTrace.empty);
      container.invalidate(appLockEnabledProvider);
      await settle();
      expect(store.last['state'], 'locked');
    });

    test('WidgetSync.clear empties the store and the next push is written again', () async {
      final sync = container.read(widgetSyncServiceProvider);
      await sync.push(WidgetSnapshot.locked(en));
      await sync.clear();
      expect(store.clears, 1);
      await sync.push(WidgetSnapshot.locked(en));
      expect(store.writes.length, 2);
    });
  });
}
