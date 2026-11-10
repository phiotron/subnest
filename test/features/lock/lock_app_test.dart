import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/app.dart';
import 'package:subnest/core/router/app_router.dart';
import 'package:subnest/core/router/routes.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/notifications/notification_service.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/data/secret_store.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/home/home_screen.dart';
import 'package:subnest/features/lock/app_lock.dart';
import 'package:subnest/features/lock/pin_service.dart';
import 'package:subnest/features/onboarding/onboarding_screen.dart';
import 'package:subnest/features/settings/auto_backup_providers.dart';
import 'package:subnest/features/subscription_detail/subscription_detail_screen.dart';
import 'package:subnest/features/widget_sync/widget_sync.dart';
import 'package:subnest/l10n/generated/app_localizations.dart';

import '../../data/backup/backup_test_utils.dart';
import '../settings/settings_harness.dart' show FakeAutoBackupScheduler;

/// Records what reaches the home-screen widget store.
class FakeWidgetStore implements WidgetStore {
  final writes = <String>[];
  var clears = 0;

  Map<String, Object?> get last => jsonDecode(writes.last) as Map<String, Object?>;

  @override
  Future<void> write(String json) async => writes.add(json);

  @override
  Future<void> clear() async => clears++;
}

class FakeWidgetLinks implements WidgetLinkSource {
  Uri? initial;
  final controller = StreamController<Uri?>.broadcast();

  @override
  Future<Uri?> initialLink() async => initial;

  @override
  Stream<Uri?> get taps => controller.stream;
}

final en = lookupAppLocalizations(const Locale('en'));

/// App lock through the REAL root widget ([SubnestApp] + the real router): cold start, deep links
/// (home-screen widget, notification), relock after 1 minute, Forgot PIN, home-screen widget.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  setUpAll(initializeDateFormatting);

  late AppDatabase db;
  late MemorySecretStore secrets;
  late FakeWidgetStore widgetStore;
  late FakeWidgetLinks links;
  late NotificationService notifications;
  late DateTime now;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    secrets = MemorySecretStore();
    widgetStore = FakeWidgetStore();
    links = FakeWidgetLinks();
    notifications = NotificationService();
    now = DateTime.now();
    final settings = SettingsRepository(db);
    await settings.setOnboardingDone(true);
    await settings.setPrimaryCurrency('USD');
    final today = LocalDate.fromDateTime(now);
    await SubscriptionRepository(db).save(
      Subscription(
        id: 'netflix',
        name: 'Netflix',
        priceMinor: 1599,
        currency: 'USD',
        cycle: const BillingCycle.monthly(),
        anchorDate: today.addDays(3),
        startDate: today.addDays(-30),
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  Future<void> setPin(String pin) => PinService(secrets, settings: () => SettingsRepository(db), iterations: 50).setPin(pin);

  Future<void> settle(WidgetTester tester) =>
      tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 10));

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(420, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        notificationServiceProvider.overrideWithValue(notifications),
        clockProvider.overrideWithValue(() => now),
        secretStoreProvider.overrideWithValue(secrets),
        pinServiceProvider.overrideWith(
          (ref) => PinService(
            ref.watch(secretStoreProvider),
            settings: () => ref.read(settingsRepositoryProvider),
            iterations: 50,
          ),
        ),
        widgetStoreProvider.overrideWithValue(widgetStore),
        widgetLinkSourceProvider.overrideWithValue(links),
        backupFolderServiceProvider.overrideWithValue(FakeFolder()),
        autoBackupSchedulerProvider.overrideWithValue(FakeAutoBackupScheduler()),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: SubnestApp(router: createRouter(initialLocation: AppRoutes.home)),
      ),
    );
    await settle(tester);
  }

  Future<void> enterPin(WidgetTester tester, String pin) async {
    for (final d in pin.split('')) {
      await tester.tap(find.byKey(ValueKey('pin-key-$d')));
      await tester.pump();
    }
    await settle(tester);
  }

  /// Dispose providers (cancels the midnight timer) and drop the in-memory DB (awaiting close()
  /// inside the test zone never completes) — as `app_flow_test.dart`.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    unawaited(db.close());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('no PIN: the app opens straight away and the widget shows the data', (tester) async {
    await pumpApp(tester);
    expect(find.text(en.securityEnterPin), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(widgetStore.last['state'], 'list');
    await unmount(tester);
  });

  testWidgets('cold start with a PIN: lock screen first, app hidden; widget only "Locked with PIN"', (tester) async {
    await setPin('1234');
    await pumpApp(tester);
    expect(find.text(en.securityEnterPin), findsOneWidget);
    expect(find.text(en.securityForgotPin), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing, reason: 'routes are offstage');
    expect(find.text('Netflix'), findsNothing);
    final snapshot = widgetStore.last;
    expect(snapshot['state'], 'locked');
    expect(widgetStore.writes.any((w) => w.contains('Netflix')), isFalse, reason: 'no name ever written');

    await enterPin(tester, '9999');
    expect(find.text(en.securityWrongPin), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);

    await enterPin(tester, '1234');
    expect(find.text(en.securityEnterPin), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(widgetStore.last['state'], 'locked', reason: 'unlocking does not show amounts on the widget');
    await unmount(tester);
  });

  testWidgets('widget tap on cold start: lock screen, then that subscription', (tester) async {
    await setPin('1234');
    links.initial = Uri.parse(WidgetLinks.subscription('netflix'));
    await pumpApp(tester);
    expect(find.text(en.securityEnterPin), findsOneWidget);
    expect(find.byType(SubscriptionDetailScreen), findsNothing);
    await enterPin(tester, '1234');
    expect(find.byType(SubscriptionDetailScreen), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('notification tap on cold start: lock screen, then that subscription', (tester) async {
    await setPin('1234');
    notifications.launchRoute = AppRoutes.subscriptionDetail('netflix');
    await pumpApp(tester);
    expect(find.text(en.securityEnterPin), findsOneWidget);
    expect(find.byType(SubscriptionDetailScreen), findsNothing);
    await enterPin(tester, '1234');
    expect(find.byType(SubscriptionDetailScreen), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('back after more than 1 minute: locked again; a widget tap meanwhile opens after the PIN', (
    tester,
  ) async {
    await setPin('1234');
    await pumpApp(tester);
    await enterPin(tester, '1234');
    expect(find.byType(HomeScreen), findsOneWidget);

    // Away 30 s → no lock.
    for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    now = now.add(const Duration(seconds: 30));
    for (final s in [AppLifecycleState.inactive, AppLifecycleState.resumed]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    await settle(tester);
    expect(find.text(en.securityEnterPin), findsNothing);

    // Away 2 min → locked.
    for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    now = now.add(const Duration(minutes: 2));
    for (final s in [AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    await settle(tester);
    expect(find.text(en.securityEnterPin), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);

    links.controller.add(Uri.parse(WidgetLinks.subscription('netflix')));
    await settle(tester);
    expect(find.byType(SubscriptionDetailScreen), findsNothing, reason: 'behind the lock screen');
    await enterPin(tester, '1234');
    expect(find.byType(SubscriptionDetailScreen), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('system Back on the lock screen never pops the hidden routes', (tester) async {
    await setPin('1234');
    links.initial = Uri.parse(WidgetLinks.subscription('netflix'));
    final calls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call.method);
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    await pumpApp(tester);
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(calls, contains('SystemNavigator.pop'), reason: 'Back leaves the app');
    expect(find.text(en.securityEnterPin), findsOneWidget);
    await enterPin(tester, '1234');
    expect(find.byType(SubscriptionDetailScreen), findsOneWidget, reason: 'the hidden route was not popped');
    await unmount(tester);
  });

  testWidgets('Forgot PIN → Delete all data (2 more steps) → onboarding, PIN off, widget cleared', (tester) async {
    await setPin('1234');
    await pumpApp(tester);
    await tester.tap(find.text(en.securityForgotPin));
    await settle(tester);
    expect(find.text(en.securityForgotPinTitle), findsOneWidget);

    // Cancel at the explanation → back on the lock screen, nothing deleted.
    await tester.tap(find.text(en.commonCancel));
    await settle(tester);
    expect(find.text(en.securityEnterPin), findsOneWidget);
    expect(await SubscriptionRepository(db).all(), hasLength(1));

    // Cancel at the second confirmation → still locked, nothing deleted.
    await tester.tap(find.text(en.securityForgotPin));
    await settle(tester);
    await tester.tap(find.text(en.settingsDeleteAll));
    await settle(tester);
    expect(find.text(en.settingsDeleteAllTitle), findsOneWidget);
    await tester.tap(find.text(en.settingsDelete));
    await settle(tester);
    await tester.tap(find.text(en.commonCancel));
    await settle(tester);
    expect(find.text(en.securityEnterPin), findsOneWidget);
    expect(await SubscriptionRepository(db).all(), hasLength(1));

    // All the way.
    await tester.tap(find.text(en.securityForgotPin));
    await settle(tester);
    await tester.tap(find.text(en.settingsDeleteAll));
    await settle(tester);
    await tester.tap(find.text(en.settingsDelete));
    await settle(tester);
    expect(find.text(en.settingsCannotUndo), findsOneWidget);
    await tester.tap(find.text(en.settingsDeleteEverything));
    await settle(tester);

    expect(find.text(en.securityEnterPin), findsNothing);
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(await SubscriptionRepository(db).all(), isEmpty);
    for (final k in [PinService.hashKey, PinService.saltKey, PinService.installKey]) {
      expect(secrets.values.containsKey(k), isFalse, reason: k);
    }
    expect((await SettingsRepository(db).raw()).containsKey(PinService.settingsInstallKey), isFalse);
    expect(widgetStore.writes.any((w) => w.contains('Netflix')), isFalse);
    await unmount(tester);
  });
}
