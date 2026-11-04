import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';
import 'backup/backup_service.dart';
import 'catalog_repository.dart';
import 'db/app_database.dart';
import 'notifications/notification_service.dart';
import 'rates/exchange_rate_repository.dart';
import 'settings_repository.dart';
import 'subscription_repository.dart';

// =============================================================================================
// App-wide providers. Feature UIs only *read* these; they never construct repositories.
// `databaseProvider`, `notificationServiceProvider` and `deviceLocaleProvider` are overridden
// in main.dart (and in tests).
// =============================================================================================

// ---- Infrastructure ------------------------------------------------------------------------

final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('override in main'));

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('override in main'),
);

/// Device locale name, e.g. `vi_VN` (default Primary currency).
final deviceLocaleProvider = Provider<String>((ref) => 'en_US');

/// Region for Catalog prices (`VN`, `US`…) from the device locale; plans fall back to `US`.
final catalogRegionProvider = Provider<String>((ref) {
  final parts = ref.watch(deviceLocaleProvider).split(RegExp('[_-]'));
  return parts.length > 1 ? parts[1].toUpperCase() : 'US';
});

/// Injectable clock for tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

// ---- Repositories --------------------------------------------------------------------------

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(ref.watch(databaseProvider), clock: ref.watch(clockProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider), deviceLocale: ref.watch(deviceLocaleProvider)),
);

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>(
  (ref) => ExchangeRateRepository(
    ref.watch(databaseProvider),
    ref.watch(settingsRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) => CatalogRepository());

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    ref.watch(databaseProvider),
    ref.watch(subscriptionRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(exchangeRateRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

// ---- Streams of data -----------------------------------------------------------------------

final subscriptionsProvider = StreamProvider<List<Subscription>>(
  (ref) => ref.watch(subscriptionRepositoryProvider).watchAll(),
);

final subscriptionProvider = StreamProvider.family<Subscription?, String>(
  (ref, id) => ref.watch(subscriptionRepositoryProvider).watch(id),
);

/// All Payments + Skipped periods, newest first.
final periodsProvider = StreamProvider<List<ConfirmedPeriod>>(
  (ref) => ref.watch(subscriptionRepositoryProvider).watchPeriods(),
);

/// History of one subscription, newest first.
final subscriptionPeriodsProvider = StreamProvider.family<List<ConfirmedPeriod>, String>(
  (ref, id) => ref.watch(subscriptionRepositoryProvider).watchPeriods(subscriptionId: id),
);

final settingsProvider = StreamProvider<AppSettings>((ref) => ref.watch(settingsRepositoryProvider).watch());

final ratesProvider = StreamProvider<ExchangeRates>((ref) => ref.watch(exchangeRateRepositoryProvider).watch());

final catalogProvider = FutureProvider<List<CatalogService>>((ref) => ref.watch(catalogRepositoryProvider).load());

/// Whether the OS allows our notifications. Invalidate on app resume.
final notificationsEnabledProvider = FutureProvider<bool>(
  (ref) => ref.watch(notificationServiceProvider).areEnabled(),
);

// ---- Derived -------------------------------------------------------------------------------

/// "Today" — refreshed on app resume and at midnight (see App lifecycle in lib/app.dart).
final todayProvider = NotifierProvider<TodayNotifier, LocalDate>(TodayNotifier.new);

class TodayNotifier extends Notifier<LocalDate> {
  Timer? _timer;

  @override
  LocalDate build() {
    final now = ref.watch(clockProvider)();
    _timer?.cancel();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _timer = Timer(nextMidnight.difference(now) + const Duration(seconds: 1), refresh);
    ref.onDispose(() => _timer?.cancel());
    return LocalDate.fromDateTime(now);
  }

  void refresh() {
    final today = LocalDate.fromDateTime(ref.read(clockProvider)());
    if (today != state) state = today;
  }
}

/// Primary currency (falls back to the device default while settings load).
final primaryCurrencyProvider = Provider<String>((ref) {
  final s = ref.watch(settingsProvider).value;
  return s?.primaryCurrency ?? defaultCurrencyForLocale(ref.watch(deviceLocaleProvider));
});

final spendingCalculatorProvider = Provider<SpendingCalculator>(
  (ref) => SpendingCalculator(
    rates: ref.watch(ratesProvider).value ?? ExchangeRates.empty,
    primaryCurrency: ref.watch(primaryCurrencyProvider),
  ),
);

/// Home header totals; `null` while subscriptions load.
final spendingSummaryProvider = Provider<SpendingSummary?>((ref) {
  final subs = ref.watch(subscriptionsProvider).value;
  if (subs == null) return null;
  return ref.watch(spendingCalculatorProvider).summary(subs, ref.watch(todayProvider));
});

/// Pending Billing periods across all subscriptions (S7), oldest first: (subscription, due date).
final awaitingPeriodsProvider = Provider<List<(Subscription, LocalDate)>>((ref) {
  final subs = ref.watch(subscriptionsProvider).value ?? const <Subscription>[];
  final today = ref.watch(todayProvider);
  final out = [
    for (final s in subs)
      for (final d in BillingRules.pendingDueDates(s, today)) (s, d),
  ]..sort((a, b) => a.$2.compareTo(b.$2));
  return out;
});

/// Keeps scheduled reminders in sync with data. Watched once by the root widget.
final reminderSyncProvider = Provider<void>((ref) {
  final subs = ref.watch(subscriptionsProvider).value;
  final settings = ref.watch(settingsProvider).value;
  ref.watch(todayProvider);
  if (subs == null || settings == null) return;
  ref.watch(notificationServiceProvider).scheduleSync(subs, settings);
});
