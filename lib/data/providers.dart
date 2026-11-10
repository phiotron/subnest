import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';
import 'backup/backup_service.dart';
import 'catalog_repository.dart';
import 'db/app_database.dart';
import 'notifications/notification_service.dart';
import 'organize_repository.dart';
import 'rates/exchange_rate_repository.dart';
import 'settings_repository.dart';
import 'subscription_repository.dart';

// =============================================================================================
// App-wide providers. Feature UIs only *read* these; they never construct repositories.
// `databaseProvider` and `notificationServiceProvider` are overridden in main.dart (and in tests).
// =============================================================================================

// ---- Infrastructure ------------------------------------------------------------------------

final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('override in main'));

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('override in main'),
);

/// Region for Catalog prices: only `US` and `VN` exist (ADR 0002 / product.md §10.1). Prices open on
/// the global section (`US`) and the Vietnam tab is never inferred from the device (S-90).
final catalogRegionProvider = Provider<String>((ref) => 'US');

/// Injectable clock for tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

// ---- Repositories --------------------------------------------------------------------------

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(ref.watch(databaseProvider), clock: ref.watch(clockProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>(
  (ref) => ExchangeRateRepository(
    ref.watch(databaseProvider),
    ref.watch(settingsRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final organizeRepositoryProvider = Provider<OrganizeRepository>(
  (ref) => OrganizeRepository(ref.watch(databaseProvider), clock: ref.watch(clockProvider)),
);

/// What the user has unlocked. 1.0: everything (Pro open); IAP overrides this later.
final entitlementProvider = Provider<Entitlement>((ref) => Entitlement.launch);

final isProProvider = Provider<bool>((ref) => ref.watch(entitlementProvider).isPro);

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

/// The user's Categories in display order (11 built-ins seeded + custom ones).
final categoriesProvider = StreamProvider<List<Category>>((ref) => ref.watch(organizeRepositoryProvider).watchCategories());

/// Category by id (falls back to "other" for unknown ids); `null` while loading.
final categoryByIdProvider = Provider<Map<String, Category>>(
  (ref) => {for (final c in ref.watch(categoriesProvider).value ?? const <Category>[]) c.id: c},
);

final labelsProvider = StreamProvider<List<Label>>((ref) => ref.watch(organizeRepositoryProvider).watchLabels());

final paymentMethodsProvider = StreamProvider<List<PaymentMethod>>(
  (ref) => ref.watch(organizeRepositoryProvider).watchPaymentMethods(),
);

final budgetsProvider = StreamProvider<List<Budget>>((ref) => ref.watch(organizeRepositoryProvider).watchBudgets());

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

/// Primary currency (USD — the global default, S-90 — while settings load).
final primaryCurrencyProvider = Provider<String>((ref) {
  final s = ref.watch(settingsProvider).value;
  return s?.primaryCurrency ?? SettingsRepository.defaultPrimaryCurrency;
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

/// Forecast / cost rates / week strip / budgets / "drop Not worth" savings (product.md §10.2, §10.4).
final forecastCalculatorProvider = Provider<ForecastCalculator>(
  (ref) => ForecastCalculator(ref.watch(spendingCalculatorProvider)),
);

/// "Due this week" strip from today; `null` while loading.
final weekStripProvider = Provider<WeekStrip?>((ref) {
  final subs = ref.watch(subscriptionsProvider).value;
  if (subs == null) return null;
  return ref.watch(forecastCalculatorProvider).week(subs, ref.watch(todayProvider));
});

/// Usage of every budget (overall + per category); empty while loading.
final budgetUsageProvider = Provider<List<BudgetUsage>>((ref) {
  final subs = ref.watch(subscriptionsProvider).value;
  final budgets = ref.watch(budgetsProvider).value;
  if (subs == null || budgets == null) return const [];
  return ref.watch(forecastCalculatorProvider).budgets(budgets, subs, ref.watch(todayProvider));
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
