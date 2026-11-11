import 'dart:async';
import 'dart:io';

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
import 'package:subnest/core/router/app_router.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/db/mappers.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';

import '../home/ui_harness.dart';

export '../home/ui_harness.dart';

List<CatalogService>? _catalog;

/// The S5 Detail tests' own pump: [pumpApp] from the shared harness plus extra provider
/// [overrides] (library price notice, plan notes — they come from the remote Catalog layer, which
/// has no test double in the shared harness) and Price history rows ([priceChanges]).
Future<TestApp> pumpDetail(
  WidgetTester tester, {
  Setup setup = const Setup(),
  List<Subscription>? subscriptions,
  List<ConfirmedPeriod>? periods,
  List<PriceChange> priceChanges = const [],
  String location = '/home',
  String? push,
  List<Override> overrides = const [],
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
  const dpr = 2.0;
  tester.view.physicalSize = Size(setup.width, setup.height) * dpr;
  tester.view.devicePixelRatio = dpr;
  tester.view.padding = FakeViewPadding(top: 47 * dpr, bottom: 0);
  addTearDown(tester.view.reset);
  const channel = MethodChannel('plugins.flutter.io/url_launcher');
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
    if (call.method == 'launch') launched.add((call.arguments as Map)['url'] as String);
    return true;
  });
  addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null));

  _catalog ??= CatalogRepository.parse(File(CatalogRepository.assetPath).readAsStringSync());
  final db = AppDatabase(NativeDatabase.memory());
  final notifications = FakeNotifications();
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      notificationServiceProvider.overrideWithValue(notifications),
      clockProvider.overrideWithValue(() => now),
      todayProvider.overrideWith(() => FixedToday(today)),
      ratesProvider.overrideWith((ref) => Stream.value(Mock.rates)),
      primaryCurrencyProvider.overrideWithValue('VND'),
      catalogProvider.overrideWith((ref) async => _catalog!),
      notificationsEnabledProvider.overrideWith((ref) async => true),
      ...overrides,
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
    for (final c in priceChanges) {
      await repo.insertPriceChange(c);
    }
    await container.read(settingsRepositoryProvider).setOnboardingDone(true);
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

/// A Price history row for [s] (plan price, minor units).
PriceChange priceChange(
  Subscription s, {
  required int from,
  required int to,
  required LocalDate on,
  PriceChangeSource source = PriceChangeSource.manual,
}) => PriceChange(
  id: '${s.id}-$on',
  subscriptionId: s.id,
  oldPriceMinor: from,
  newPriceMinor: to,
  currency: s.currency,
  effectiveFrom: on,
  source: source,
  createdAt: now,
);
