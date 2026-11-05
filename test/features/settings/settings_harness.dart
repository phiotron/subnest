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
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:subnest/core/l10n/l10n.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/backup/backup_service.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/notifications/notification_service.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/data/rates/exchange_rate_repository.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/settings/backup_screen.dart';
import 'package:subnest/features/settings/currency_screen.dart';
import 'package:subnest/features/settings/legal_screen.dart';
import 'package:subnest/features/settings/rates_screen.dart';
import 'package:subnest/features/settings/reminders_screen.dart';
import 'package:subnest/features/settings/settings_platform.dart';
import 'package:subnest/features/settings/settings_screen.dart';

/// "Now" in every Settings test: 5 Nov 2026, 10:00 (the mockups' sample data).
final DateTime kNow = DateTime(2026, 11, 5, 10);

/// Records what Settings asked of the OS.
class FakeSettingsPlatform extends SettingsPlatform {
  FakeSettingsPlatform({this.ios = false, this.externalOk = true, this.notificationSettingsOk = true});

  final bool ios;
  bool externalOk;
  bool notificationSettingsOk;
  bool shareOk = true;
  PickedBackup? nextPick;
  final opened = <Uri>[];
  final shared = <List<ExportFile>>[];
  int notificationSettingsCalls = 0;

  @override
  bool get isIOS => ios;

  @override
  Future<bool> openExternal(Uri uri) async {
    opened.add(uri);
    return externalOk;
  }

  @override
  Future<bool> openNotificationSettings() async {
    notificationSettingsCalls++;
    return notificationSettingsOk;
  }

  @override
  Future<bool> share(List<ExportFile> files, {String? subject}) async {
    shared.add(files);
    return shareOk;
  }

  @override
  Future<PickedBackup?> pickBackup() async => nextPick;
}

/// Sample data like the mockups (§8): VND main currency, Netflix in VND, ChatGPT Plus in USD,
/// last backup 42 days ago, rates fetched 2 h ago.
class SettingsFixture {
  SettingsFixture._(this.db, this.platform);

  final AppDatabase db;
  final FakeSettingsPlatform platform;

  /// `true` → the rates endpoint answers 200, `false` → 503 ("offline").
  bool online = true;

  /// JSON of the sample data (exported once, for the restore flow).
  late final String backupJson;

  late final SettingsRepository settings = SettingsRepository(db, deviceLocale: 'en_US');
  late final ExchangeRateRepository rates = ExchangeRateRepository(
    db,
    settings,
    clock: () => kNow,
    client: MockClient((_) async {
      if (!online) return http.Response('down', 503);
      return http.Response(
        jsonEncode({
          'result': 'success',
          'base_code': 'USD',
          'rates': {'USD': 1, 'VND': 25410},
        }),
        200,
      );
    }),
  );

  static Future<SettingsFixture> create({
    FakeSettingsPlatform? platform,
    DateTime? lastBackup,
    bool neverBackedUp = false,
    Duration ratesAge = const Duration(hours: 2),
    bool withSubscriptions = true,
  }) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final f = SettingsFixture._(AppDatabase(NativeDatabase.memory()), platform ?? FakeSettingsPlatform());
    await f.settings.setPrimaryCurrency('VND');
    await f.settings.setOnboardingDone(true);
    final subs = SubscriptionRepository(f.db, clock: () => kNow);
    if (withSubscriptions) {
      await subs.save(_sub('netflix', 'Netflix', 260000, 'VND', const LocalDate(2026, 11, 8)));
      await subs.save(_sub('chatgpt', 'ChatGPT Plus', 2000, 'USD', const LocalDate(2026, 11, 7)));
    }
    await f.db.batch((b) {
      b.insertAll(f.db.cachedRates, [
        CachedRatesCompanion.insert(code: 'USD', perUsd: 1),
        CachedRatesCompanion.insert(code: 'VND', perUsd: 25400),
        CachedRatesCompanion.insert(code: 'EUR', perUsd: 0.92),
      ]);
    });
    await f.settings.setRatesFetchedAt(kNow.subtract(ratesAge));
    final backup = BackupService(f.db, subs, f.settings, f.rates, clock: () => kNow);
    f.backupJson = (await backup.exportJson()).content;
    if (neverBackedUp) {
      await f.settings.set(SettingsRepository.kLastBackupAt, null);
    } else {
      await f.settings.setLastBackupAt(lastBackup ?? DateTime(2026, 9, 24, 20));
    }
    return f;
  }

  static Subscription _sub(String id, String name, int price, String cur, LocalDate due) => Subscription(
    id: id,
    name: name,
    priceMinor: price,
    currency: cur,
    cycle: const BillingCycle.monthly(),
    anchorDate: due,
    startDate: const LocalDate(2026, 1, 1),
    createdAt: kNow,
    updatedAt: kNow,
  );

  List<Override> overrides({bool? notificationsOn = true}) => [
    databaseProvider.overrideWithValue(db),
    notificationServiceProvider.overrideWithValue(NotificationService()),
    deviceLocaleProvider.overrideWithValue('en_US'),
    clockProvider.overrideWithValue(() => kNow),
    exchangeRateRepositoryProvider.overrideWithValue(rates),
    settingsPlatformProvider.overrideWithValue(platform),
    notificationsEnabledProvider.overrideWith((ref) async => notificationsOn ?? false),
  ];
}

/// Routes of the Settings branch (+ test-only paths for the screens pushed with Navigator).
GoRouter settingsTestRouter(String initial) => GoRouter(
  initialLocation: initial,
  routes: [
    GoRoute(
      path: '/settings',
      builder: (_, _) => const SettingsScreen(),
      routes: [
        GoRoute(path: 'currency', builder: (_, _) => const CurrencyScreen()),
        GoRoute(path: 'rates', builder: (_, _) => const RatesScreen()),
        GoRoute(path: 'backup', builder: (_, _) => const BackupScreen()),
        GoRoute(path: 'reminders', builder: (_, _) => const RemindersScreen()),
        GoRoute(
          path: 'privacy',
          builder: (_, _) => const LegalScreen(doc: LegalDoc.privacy),
        ),
        GoRoute(
          path: 'terms',
          builder: (_, _) => const LegalScreen(doc: LegalDoc.terms),
        ),
      ],
    ),
  ],
);

final shotKey = GlobalKey();

/// Pumps the Settings UI at [location] like on a phone: real fonts, theme, locale, text scale.
Future<void> pumpSettings(
  WidgetTester tester,
  SettingsFixture f, {
  String location = '/settings',
  bool dark = false,
  String locale = 'en',
  double textScale = 1,
  Size size = const Size(390, 844),
  double dpr = 2,
  bool? notificationsOn = true,
}) async {
  tester.view
    ..physicalSize = size * dpr
    ..devicePixelRatio = dpr
    ..padding = FakeViewPadding(top: 47 * dpr, bottom: 34 * dpr)
    ..viewPadding = FakeViewPadding(top: 47 * dpr, bottom: 34 * dpr);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    RepaintBoundary(
      key: shotKey,
      child: ProviderScope(
        overrides: f.overrides(notificationsOn: notificationsOn),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(locale),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, w) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
            child: w!,
          ),
          routerConfig: settingsTestRouter(location),
        ),
      ),
    ),
  );
  await settle(tester);
}

Future<void> settle(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 50),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 10),
);

AppLocalizations l10nFor(String code) => lookupAppLocalizations(Locale(code));

/// Be Vietnam Pro (bundled) + the Lucide icon font, so text measures and icons draw like on a phone.
Future<void> loadSettingsFonts() async {
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

/// Saves the current frame as a PNG when run with `--dart-define=SHOTS=true`.
const bool kShots = bool.fromEnvironment('SHOTS');
const String kShotDir = 'notes/img/2026-11-05-ui-settings';

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

/// `testWidgets` that unmounts the app at the end and flushes the zero-length timers drift
/// schedules when its query streams close (otherwise "A Timer is still pending").
void settingsTest(String description, Future<void> Function(WidgetTester tester) body) {
  testWidgets(description, (tester) async {
    await body(tester);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  });
}

/// Scrolls [finder] fully into view, then taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 300);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await settle(tester);
}
