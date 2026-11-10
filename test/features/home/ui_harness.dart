import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:subnest/core/l10n/l10n.dart';
import 'package:subnest/core/router/app_router.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/db/mappers.dart';
import 'package:subnest/data/notifications/notification_service.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';

/// Test harness for the Home & confirm screens (S2, S5, S6, S7).
///
/// Runs the **real router** (tab shell, `/confirm/:id` sheet, `/awaiting`, `/subscription/:id`)
/// on an in-memory database seeded with the design's §8 sample data, a fixed clock (Wed 4 Nov
/// 2026, 10:00), real fonts (Be Vietnam Pro + Lucide — the default test font draws every glyph
/// 1em wide and reports false overflows) and a 47dp status-bar inset like the mockups.
///
/// Golden renders are written only with `--dart-define=UI_SHOTS=true --update-goldens`
/// (rendering differs per OS, so normal runs check behaviour + layout only).
const uiShots = bool.fromEnvironment('UI_SHOTS');

const today = LocalDate(2026, 11, 4);
final now = DateTime(2026, 11, 4, 10);
const usdVnd = 25400.0;

Future<void> loadTestFonts() async {
  final family = FontLoader(AppType.fontFamily);
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    final bytes = File('assets/fonts/BeVietnamPro/BeVietnamPro-$w.ttf').readAsBytesSync();
    family.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await family.load();
  final lucide = FontLoader('packages/lucide_icons_flutter/Lucide')
    ..addFont(rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'));
  await lucide.load();
}

/// The mockup's sample data (product.md §8 / design bundle.js): primary VND, 1 USD = 25,400 VND.
abstract final class Mock {
  static Subscription sub(
    String id,
    String name,
    int priceMinor,
    LocalDate due, {
    String currency = 'VND',
    BillingCycle cycle = const BillingCycle.monthly(),
    SubscriptionCategory category = SubscriptionCategory.other,
    int color = 0xFF607D8B,
    String? icon,
    String? serviceId,
    int shared = 1,
    SubscriptionStatus status = SubscriptionStatus.active,
    LocalDate? trialEnd,
    LocalDate? cancelledOn,
    LocalDate start = const LocalDate(2026, 6, 4),
    String? paymentMethod,
    String? notes,
    String? manageUrl,
    int? reminderDays,
  }) => Subscription(
    id: id,
    name: name,
    priceMinor: priceMinor,
    currency: currency,
    cycle: cycle,
    anchorDate: due,
    startDate: start,
    createdAt: now,
    updatedAt: now,
    category: category,
    colorValue: color,
    iconText: icon,
    serviceId: serviceId,
    sharedWith: shared,
    status: status,
    trialEndDate: trialEnd,
    cancelledOn: cancelledOn,
    paymentMethod: paymentMethod,
    notes: notes,
    manageUrl: manageUrl,
    reminderDays: reminderDays,
  );

  static final viettel = sub(
    'viettel',
    'Viettel 5G',
    150000,
    const LocalDate(2026, 11, 1),
    category: SubscriptionCategory.telecom,
    color: 0xFFD7002B,
    icon: 'V',
  );

  /// Two periods behind (1 Oct and 1 Nov) — the catch-up / "many awaiting" state.
  static final viettelBehind = sub(
    'viettel',
    'Viettel 5G',
    150000,
    const LocalDate(2026, 10, 1),
    category: SubscriptionCategory.telecom,
    color: 0xFFD7002B,
    icon: 'V',
  );
  static final netflix = sub(
    'netflix',
    'Netflix Premium',
    260000,
    const LocalDate(2026, 11, 4),
    category: SubscriptionCategory.video,
    color: 0xFFE50914,
    icon: 'N',
    serviceId: 'netflix',
    shared: 4,
    paymentMethod: 'Visa ••4242',
    notes: 'Shared with Minh, Lan and Huy',
  );
  static final spotify = sub(
    'spotify',
    'Spotify Premium',
    59000,
    const LocalDate(2026, 11, 6),
    category: SubscriptionCategory.music,
    color: 0xFF1DB954,
    icon: 'S',
    serviceId: 'spotify',
    status: SubscriptionStatus.trial,
    trialEnd: const LocalDate(2026, 11, 6),
    start: const LocalDate(2026, 10, 6),
  );
  static final chatgpt = sub(
    'chatgpt',
    'ChatGPT Plus',
    2000,
    const LocalDate(2026, 11, 7),
    currency: 'USD',
    category: SubscriptionCategory.ai,
    color: 0xFF202123,
    icon: 'C',
    serviceId: 'chatgpt',
  );
  static final icloud = sub(
    'icloud',
    'iCloud+ 200GB',
    59000,
    const LocalDate(2026, 11, 15),
    category: SubscriptionCategory.storage,
    color: 0xFF2A72D4,
    icon: 'iC',
    serviceId: 'icloud',
  );
  static final youtube = sub(
    'youtube',
    'YouTube Premium Family',
    179000,
    const LocalDate(2026, 11, 22),
    category: SubscriptionCategory.video,
    color: 0xFFE6002E,
    icon: 'YT',
    serviceId: 'youtube-premium',
    shared: 5,
  );
  static final googleOne = sub(
    'google1',
    'Google One 2TB',
    1690000,
    const LocalDate(2027, 3, 20),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.storage,
    color: 0xFF1A73E8,
    icon: 'G1',
    serviceId: 'google-one',
  );
  static final canva = sub(
    'canva',
    'Canva Pro',
    1390000,
    const LocalDate(2027, 2, 2),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.software,
    color: 0xFF7D2AE8,
    icon: 'C',
    serviceId: 'canva',
  );
  static final duolingo = sub(
    'duolingo',
    'Duolingo Super',
    699000,
    const LocalDate(2026, 10, 12),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.education,
    color: 0xFF58CC02,
    icon: 'D',
    serviceId: 'duolingo',
    status: SubscriptionStatus.cancelled,
    cancelledOn: const LocalDate(2026, 10, 12),
    start: const LocalDate(2025, 10, 12),
    paymentMethod: 'Google Play',
  );
  static final appleMusic = sub(
    'applemusic',
    'Apple Music',
    65000,
    const LocalDate(2026, 10, 28),
    category: SubscriptionCategory.music,
    color: 0xFFFA243C,
    icon: 'AM',
    serviceId: 'apple-music',
    status: SubscriptionStatus.cancelled,
    cancelledOn: const LocalDate(2026, 9, 28),
  );

  static final all = [viettel, netflix, spotify, chatgpt, icloud, youtube, googleOne, canva, duolingo, appleMusic];

  /// "many awaiting": Viettel two periods behind.
  static final many = [viettelBehind, ...all.where((s) => s.id != 'viettel')];

  static ConfirmedPeriod period(Subscription s, LocalDate due, {int? amount, bool skip = false, String? id}) =>
      ConfirmedPeriod(
        id: id ?? '${s.id}-$due',
        subscriptionId: s.id,
        dueDate: due,
        outcome: skip ? PeriodOutcome.skipped : PeriodOutcome.payment,
        amountMinor: skip ? 0 : amount ?? s.myShareMinor,
        currency: s.currency,
        confirmedAt: now,
      );

  /// Netflix history of png 29: Oct, Sep paid · Aug didn't pay · Jul, Jun paid. Duolingo: one year.
  static final periods = [
    period(netflix, const LocalDate(2026, 10, 4)),
    period(netflix, const LocalDate(2026, 9, 4)),
    period(netflix, const LocalDate(2026, 8, 4), skip: true),
    period(netflix, const LocalDate(2026, 7, 4)),
    period(netflix, const LocalDate(2026, 6, 4)),
    period(duolingo, const LocalDate(2025, 10, 12)),
  ];

  static final rates = ExchangeRates(usdRates: const {'USD': 1, 'VND': usdVnd}, fetchedAt: now);
}

class FixedToday extends TodayNotifier {
  FixedToday(this.value);
  final LocalDate value;

  @override
  LocalDate build() => value;
}

/// Records permission requests instead of calling the plugin.
class FakeNotifications extends NotificationService {
  int permissionRequests = 0;
  int settingsOpened = 0;

  /// What the OS answers; `false` answers at once, like a permission the user already denied.
  bool grant = true;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<bool> openSettings() async {
    settingsOpened++;
    return true;
  }

  @override
  Future<bool> areEnabled() async => true;
}

class Setup {
  const Setup({this.dark = false, this.locale = 'en', this.textScale = 1, this.width = 390, this.height = 844});

  final bool dark;
  final String locale;
  final double textScale;
  final double width;
  final double height;

  String get name => '${width.toInt()}-$locale-${dark ? 'dark' : 'light'}-${(textScale * 100).round()}';
}

/// Every width × language × theme × text size a screen state must survive without overflow.
final layoutMatrix = [
  for (final width in [360.0, 390.0])
    for (final locale in ['en', 'vi'])
      for (final dark in [false, true])
        for (final scale in [1.0, 1.3, 2.0]) Setup(width: width, locale: locale, dark: dark, textScale: scale),
];

/// Flutter errors reported while the app runs (for readable overflow failures).
final layoutErrors = <FlutterErrorDetails>[];

/// Links opened through url_launcher (method channel mocked to succeed).
final launched = <String>[];

/// A running app for one test.
class TestApp {
  TestApp(this.db, this.container, this.notifications);

  final AppDatabase db;
  final ProviderContainer container;
  final FakeNotifications notifications;

  Future<List<ConfirmedPeriod>> periods() => container.read(subscriptionRepositoryProvider).allPeriods();

  Future<Subscription?> sub(String id) => container.read(subscriptionRepositoryProvider).get(id);
}

List<CatalogService>? _catalog;

/// Pumps the whole app (real router) at [location].
Future<TestApp> pumpApp(
  WidgetTester tester, {
  Setup setup = const Setup(),
  List<Subscription>? subscriptions,
  List<ConfirmedPeriod>? periods,
  String location = '/home',

  /// Pushed on top of [location] after it settles (e.g. the `/confirm/:id` sheet over Overview,
  /// as a notification tap does in `SubnestApp`).
  String? push,
  bool remindersOn = true,
  ExchangeRates? rates,
  double dpr = 2,

  /// Extra data written before the app is built (labels, budgets, settings…).
  Future<void> Function(ProviderContainer container)? seed,
}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  launched.clear();
  layoutErrors.clear();
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    layoutErrors.add(details);
    previousOnError?.call(details);
  };
  addTearDown(() => FlutterError.onError = previousOnError);
  tester.view.physicalSize = Size(setup.width, setup.height) * dpr;
  tester.view.devicePixelRatio = dpr;
  tester.view.padding = FakeViewPadding(top: 47 * dpr, bottom: 0);
  addTearDown(tester.view.reset);
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/url_launcher'),
    (call) async {
      if (call.method == 'launch') launched.add((call.arguments as Map)['url'] as String);
      return true;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/url_launcher'),
      null,
    ),
  );

  _catalog ??= CatalogRepository.parse(File(CatalogRepository.assetPath).readAsStringSync());
  final db = AppDatabase(NativeDatabase.memory());
  final notifications = FakeNotifications();
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      notificationServiceProvider.overrideWithValue(notifications),
      clockProvider.overrideWithValue(() => now),
      todayProvider.overrideWith(() => FixedToday(today)),
      ratesProvider.overrideWith((ref) => Stream.value(rates ?? Mock.rates)),
      primaryCurrencyProvider.overrideWithValue('VND'),
      catalogProvider.overrideWith((ref) async => _catalog!),
      notificationsEnabledProvider.overrideWith((ref) async => remindersOn),
    ],
  );
  await tester.runAsync(() async {
    final repo = container.read(subscriptionRepositoryProvider);
    final subs = subscriptions ?? Mock.all;
    for (final s in subs) {
      await repo.save(s);
    }
    final ids = {for (final s in subs) s.id};
    for (final p in (periods ?? Mock.periods).where((p) => ids.contains(p.subscriptionId))) {
      await db.into(db.confirmedPeriods).insert(p.toCompanion());
    }
    await container.read(settingsRepositoryProvider).setOnboardingDone(true);
    await seed?.call(container);
  });

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: setup.dark ? ThemeMode.dark : ThemeMode.light,
        locale: Locale(setup.locale),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, w) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(setup.textScale)),
          child: w!,
        ),
        routerConfig: createRouter(initialLocation: location),
      ),
    ),
  );
  await settle(tester);
  if (push != null) {
    unawaited(GoRouter.of(tester.element(find.byType(Scaffold).first)).push(push));
    await settle(tester);
  }
  final app = TestApp(db, container, notifications);
  addTearDown(() async {
    container.dispose();
    unawaited(db.close());
  });
  return app;
}

/// pumpAndSettle that also lets the in-memory database answer (its futures complete outside the
/// fake clock) — a few real-async round trips, then settle.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
    await tester.pump();
  }
  await tester.pumpAndSettle(
    const Duration(milliseconds: 50),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 10),
  );
}

/// Ends the test cleanly: unmount (cancels drift stream timers), then let them fire.
Future<void> closeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

/// Taps, then settles (DB writes included).
Future<void> tapAndSettle(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await settle(tester);
}

/// Scrolls the first scrollable to the end in steps so lazily built children lay out too.
Future<void> scrollThrough(WidgetTester tester, {Finder? scrollable}) async {
  final list = scrollable ?? find.byType(Scrollable).first;
  for (var i = 0; i < 10; i++) {
    await tester.drag(list, const Offset(0, -500), warnIfMissed: false);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

/// Fails on any layout exception (overflow) raised while pumping.
void expectNoLayoutErrors(WidgetTester tester) {
  final e = tester.takeException();
  if (e != null) {
    final where = layoutErrors
        .map((d) => d.toString().split(String.fromCharCode(10)))
        .expand((lines) => lines)
        .skipWhile((l) => !l.contains('error-causing widget'))
        .take(6)
        .join(' | ');
    if (const bool.fromEnvironment('DEBUG_OVERFLOW')) {
      File('build/overflow_debug.txt').writeAsStringSync(layoutErrors.map((d) => d.toString()).join('\n----\n'));
    }
    fail('${e is FlutterError ? e.message.split(String.fromCharCode(10)).first : e} — $where');
  }
}

/// Writes the current frame to `notes/img/2026-11-05-ui-home/render/<name>.png` (only with
/// [uiShots] and `--update-goldens`).
Future<void> shot(String name) async {
  if (!uiShots) return;
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('../../../notes/img/2026-11-05-ui-home/render/$name.png'),
  );
}
