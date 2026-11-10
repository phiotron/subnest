import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:subnest/core/l10n/l10n.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/notifications/notification_service.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/catalog/catalog_screen.dart';
import 'package:subnest/features/onboarding/onboarding_screen.dart';
import 'package:subnest/features/subscription_form/subscription_form_screen.dart';

/// Shared by the S1 / S3 / S4 widget tests (session H, 2026-11-05).
///
/// Real in-memory database + repositories, the real bundled Catalog, fixed "today" (4 Nov 2026,
/// the mockups' date), VND main currency on a `vi_VN` device, real fonts (Be Vietnam Pro + Lucide)
/// and a small router whose Overview is a stub (S2 belongs to another session).

final DateTime kNow = DateTime(2026, 11, 4, 10);
const LocalDate kToday = LocalDate(2026, 11, 4);
const ExchangeRates kRates = ExchangeRates(usdRates: {'USD': 1, 'VND': 25400, 'EUR': 0.93, 'SGD': 1.30, 'JPY': 153});

/// Records the OS permission request instead of showing it.
class FakeNotifications extends NotificationService {
  FakeNotifications({this.grant = true});

  bool grant;
  int permissionRequests = 0;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<bool> areEnabled() async => grant && permissionRequests > 0;

  @override
  void scheduleSync(List<Subscription> subs, AppSettings settings, {Duration delay = Duration.zero}) {}
}

/// Serves `assets/catalog/services.json` from disk.
class _DiskBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async => ByteData.sublistView(File(key).readAsBytesSync());

  @override
  Future<String> loadString(String key, {bool cache = true}) async => File(key).readAsStringSync();
}

class FixedToday extends TodayNotifier {
  @override
  LocalDate build() => kToday;
}

class AddFixture {
  AddFixture._(this.db);

  final AppDatabase db;
  final notifications = FakeNotifications();
  late final SettingsRepository settings = SettingsRepository(db);
  late final SubscriptionRepository subs = SubscriptionRepository(db, clock: () => kNow);

  static Future<AddFixture> create({bool onboardingDone = true, String? primary = 'VND'}) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final f = AddFixture._(AppDatabase(NativeDatabase.memory()));
    if (primary != null) await f.settings.setPrimaryCurrency(primary);
    await f.settings.setOnboardingDone(onboardingDone);
    return f;
  }

  /// Netflix Premium ₫260,000 monthly, shared by 4, with five Payments (Jul–Nov) → next 4 Dec.
  Future<Subscription> addNetflix() async {
    final s = Subscription(
      id: 'netflix',
      name: 'Netflix Premium',
      serviceId: 'netflix',
      colorValue: 0xFFE50914,
      iconText: 'N',
      category: SubscriptionCategory.video,
      priceMinor: 260000,
      currency: 'VND',
      cycle: const BillingCycle.monthly(),
      anchorDate: const LocalDate(2026, 7, 4),
      sharedWith: 4,
      startDate: const LocalDate(2026, 7, 4),
      createdAt: kNow,
      updatedAt: kNow,
    );
    await subs.save(s);
    await subs.confirmAll(ids: ['netflix']);
    return (await subs.get('netflix'))!;
  }

  List<Override> overrides() => [
    databaseProvider.overrideWithValue(db),
    notificationServiceProvider.overrideWithValue(notifications),
    clockProvider.overrideWithValue(() => kNow),
    todayProvider.overrideWith(FixedToday.new),
    ratesProvider.overrideWith((ref) => Stream.value(kRates)),
    catalogRepositoryProvider.overrideWithValue(CatalogRepository(bundle: _DiskBundle())),
  ];
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

/// Every width × language × theme × text size a screen state must survive (layout check).
final layoutMatrix = [
  for (final width in [360.0, 390.0])
    for (final locale in ['en', 'vi'])
      for (final dark in [false, true])
        for (final scale in [1.0, 1.3, 2.0]) Setup(width: width, locale: locale, dark: dark, textScale: scale),
];

/// [layoutMatrix] plus the smallest phone at the largest text: 320dp × 200%, EN/VI, light/dark
/// (QA 2026-11-05 found most layout bugs there).
final layoutMatrixNarrow = [
  ...layoutMatrix,
  for (final locale in ['en', 'vi'])
    for (final dark in [false, true]) Setup(width: 320, height: 640, locale: locale, dark: dark, textScale: 2),
];

/// Locations the screens navigated to (`/home`, `/subscription/new?…`).
final visited = <String>[];

GoRouter _router(String initial) => GoRouter(
  initialLocation: initial,
  routes: [
    GoRoute(path: '/home', builder: (_, s) => _Stub('home', s.uri.toString())),
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/catalog', builder: (_, _) => const CatalogScreen()),
    GoRoute(
      path: '/subscription/new',
      builder: (_, state) => SubscriptionFormScreen(
        serviceId: state.uri.queryParameters['service'],
        planId: state.uri.queryParameters['plan'],
        initialName: state.uri.queryParameters['name'],
      ),
    ),
    GoRoute(path: '/subscription/:id', builder: (_, s) => _Stub('detail', s.uri.toString())),
    GoRoute(
      path: '/subscription/:id/edit',
      builder: (_, state) => SubscriptionFormScreen(subscriptionId: state.pathParameters['id']),
    ),
  ],
);

class _Stub extends StatelessWidget {
  _Stub(this.kind, String location) {
    visited.add(location);
  }

  final String kind;

  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('stub:$kind')));
}

final shotKey = GlobalKey();

/// Pumps the app at [location] (push [push] on top of it, so pops land on the stub).
Future<void> pumpAdd(
  WidgetTester tester,
  AddFixture f, {
  required String location,
  String? push,
  Setup setup = const Setup(),
  double dpr = 2,
}) async {
  visited.clear();
  tester.view
    ..physicalSize = Size(setup.width, setup.height) * dpr
    ..devicePixelRatio = dpr
    ..padding = FakeViewPadding(top: 47 * dpr, bottom: 34 * dpr)
    ..viewPadding = FakeViewPadding(top: 47 * dpr, bottom: 34 * dpr);
  addTearDown(tester.view.reset);
  final router = _router(location);
  await tester.pumpWidget(
    RepaintBoundary(
      key: shotKey,
      child: ProviderScope(
        overrides: f.overrides(),
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
          routerConfig: router,
        ),
      ),
    ),
  );
  await settle(tester);
  if (push != null) {
    router.push(push);
    await settle(tester);
  }
}

Future<void> settle(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 50),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 10),
);

/// `testWidgets` that unmounts the app and flushes drift's stream-close timers at the end.
void addTest(String description, Future<void> Function(WidgetTester tester) body, {bool skip = false}) {
  testWidgets(description, (tester) async {
    final semantics = tester.ensureSemantics();
    await body(tester);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    semantics.dispose();
  }, skip: skip);
}

/// Scrolls [finder] into view (first scrollable that contains it), then taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder, {Finder? scrollable}) async {
  await tester.scrollUntilVisible(finder, 200, scrollable: scrollable ?? find.byType(Scrollable).first);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await settle(tester);
}

/// Fails on any layout exception (overflow) raised while pumping.
void expectNoLayoutErrors(WidgetTester tester, String label) {
  final e = tester.takeException();
  if (e == null) return;
  final msg = e is FlutterError ? e.toStringDeep().split('\n').take(6).join(' | ') : '$e';
  fail('$label: $msg');
}

AppLocalizations l10nFor(String code) => lookupAppLocalizations(Locale(code));

/// Be Vietnam Pro (bundled) + the Lucide icon font, so text measures and icons draw like on a phone.
Future<void> loadFonts() async {
  final font = FontLoader(AppType.fontFamily);
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    font.addFont(_bytes('assets/fonts/BeVietnamPro/BeVietnamPro-$w.ttf'));
  }
  await font.load();
  final lucide = _packageRoot('lucide_icons_flutter');
  if (lucide != null) {
    await (FontLoader('packages/lucide_icons_flutter/Lucide')..addFont(_bytes('$lucide/assets/lucide.ttf'))).load();
  }
}

Future<ByteData> _bytes(String path) async => ByteData.sublistView(File(path).readAsBytesSync());

String? _packageRoot(String name) {
  final config = jsonDecode(File('.dart_tool/package_config.json').readAsStringSync()) as Map<String, Object?>;
  for (final p in (config['packages'] as List).cast<Map<String, Object?>>()) {
    if (p['name'] == name) return Uri.parse(p['rootUri'] as String).toFilePath();
  }
  return null;
}

/// Renders are written only with `--dart-define=ADD_SHOTS=true` (PNG output differs per OS, so
/// normal runs check layout only).
const bool kShots = bool.fromEnvironment('ADD_SHOTS');
const String kShotDir = 'notes/img/2026-11-05-ui-add/render';

Future<void> shot(WidgetTester tester, String name) async {
  if (!kShots) return;
  await tester.runAsync(() async {
    final image = await captureImage(shotKey.currentContext! as Element);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final file = File('$kShotDir/$name.png');
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(png!.buffer.asUint8List());
  });
}
