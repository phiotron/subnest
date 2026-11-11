import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:subnest/core/l10n/l10n.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';

import '../insights/product_sample.dart';

/// Shared by the Calendar (S8) and Insights (S9) widget tests.
///
/// Renders a tab screen the way the app shows it — inside a Scaffold with the design tab bar
/// and a 47dp status-bar inset — with real fonts (Be Vietnam Pro + Lucide; the default test
/// font draws every glyph 1em wide and reports false overflows), fixed "today" and in-memory
/// data via provider overrides (default: the product.md §6 USD set, today 10 Nov 2026 — the data the
/// v14 mockups are computed from), and a tiny router that records pushed locations.

/// Golden images are written only with `--dart-define=UI_SHOTS=true`
/// (`flutter test --update-goldens --dart-define=UI_SHOTS=true test/features`); rendering differs
/// per OS, so normal runs check layout only.
const uiShots = bool.fromEnvironment('UI_SHOTS');

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

class FixedToday extends TodayNotifier {
  FixedToday(this.value);
  final LocalDate value;

  @override
  LocalDate build() => value;
}

/// Locations pushed by the screen under test (`/subscription/x`, `/confirm/x`, `/catalog`).
final pushed = <String>[];

class ScreenSetup {
  const ScreenSetup({
    this.dark = false,
    this.locale = 'en',
    this.textScale = 1,
    this.width = 390,
    this.height = 844,
    this.tab = 1,
  });

  final bool dark;
  final String locale;
  final double textScale;
  final double width;
  final double height;

  /// Selected tab in the decorative tab bar (1 Calendar, 2 Insights).
  final int tab;

  String get name => '${width.toInt()}-$locale-${dark ? 'dark' : 'light'}-${(textScale * 100).round()}';
}

Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  ScreenSetup setup = const ScreenSetup(),
  List<Subscription>? subscriptions,
  List<ConfirmedPeriod>? periods,
  List<PriceChange>? priceChanges,
  List<Budget>? budgets,
  LocalDate today = Product.today,
  ExchangeRates rates = Product.rates,
  String primary = Product.primary,
  double dpr = 2,
}) async {
  pushed.clear();
  tester.view.physicalSize = Size(setup.width, setup.height) * dpr;
  tester.view.devicePixelRatio = dpr;
  tester.view.padding = FakeViewPadding(top: 47 * dpr, bottom: 0);
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => _Shell(tab: setup.tab, child: screen),
      ),
      GoRoute(path: '/:a', builder: (_, s) => _Pushed(s.uri.toString())),
      GoRoute(path: '/:a/:b', builder: (_, s) => _Pushed(s.uri.toString())),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        subscriptionsProvider.overrideWith((ref) => Stream.value(subscriptions ?? Product.subscriptions)),
        periodsProvider.overrideWith((ref) => Stream.value(periods ?? Product.periods)),
        priceChangesProvider.overrideWith((ref) => Stream.value(priceChanges ?? Product.priceChanges)),
        budgetsProvider.overrideWith((ref) => Stream.value(budgets ?? Product.budgets)),
        categoriesProvider.overrideWith((ref) => Stream.value(Product.categories)),
        ratesProvider.overrideWith((ref) => Stream.value(rates)),
        primaryCurrencyProvider.overrideWithValue(primary),
        todayProvider.overrideWith(() => FixedToday(today)),
      ],
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
  );
  await tester.pumpAndSettle();
}

class _Shell extends StatelessWidget {
  const _Shell({required this.tab, required this.child});

  final int tab;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: child,
      bottomNavigationBar: AppTabBar(
        currentIndex: tab,
        onSelected: (_) {},
        items: [
          AppTabItem(icon: AppIcons.tabHome, label: l.coreTabOverview),
          AppTabItem(icon: AppIcons.tabCalendar, label: l.commonTabCalendar),
          AppTabItem(icon: AppIcons.tabInsights, label: l.commonTabInsights),
          AppTabItem(icon: AppIcons.tabSettings, label: l.commonTabSettings),
        ],
      ),
    );
  }
}

class _Pushed extends StatelessWidget {
  _Pushed(this.location) {
    pushed.add(location);
  }

  final String location;

  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('pushed $location')));
}

/// Writes the current frame to `notes/img/2026-11-11-ui-insights-calendar/<name>.png` (only when
/// [uiShots]; run with `--update-goldens`).
Future<void> shot(String name) async {
  if (!uiShots) return;
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('../../../notes/img/2026-11-11-ui-insights-calendar/$name.png'),
  );
}

/// The text-size × width × theme × language matrix every screen state must survive
/// (360/390 × EN/VI × light/dark × 100/130/200%, plus 320dp × 200%).
final layoutMatrix = [
  for (final width in [360.0, 390.0])
    for (final locale in ['en', 'vi'])
      for (final dark in [false, true])
        for (final scale in [1.0, 1.3, 2.0]) ScreenSetup(width: width, locale: locale, dark: dark, textScale: scale),
  for (final locale in ['en', 'vi']) ScreenSetup(width: 320, height: 720, locale: locale, textScale: 2),
];

/// Scrolls the first scrollable to the end in steps so lazily built children lay out too.
Future<void> scrollThrough(WidgetTester tester) async {
  final list = find.byType(Scrollable).first;
  for (var i = 0; i < 12; i++) {
    await tester.drag(list, const Offset(0, -500));
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

/// Fails on any layout exception (overflow) raised while pumping.
void expectNoLayoutErrors(WidgetTester tester) {
  final e = tester.takeException();
  if (e is FlutterError) {
    final creator = e
        .toStringDeep()
        .split(String.fromCharCode(10))
        .where((d) => d.contains('creator:') || d.contains('file:///'))
        .take(2)
        .join(' | ');
    fail('${e.message.split(String.fromCharCode(10)).first} — $creator');
  }
  expect(e, isNull);
}
