import '../../domain/domain.dart';

/// PLACEHOLDER — home-screen widget data (session W, product.md §10.7).
///
/// W fills this: build a small snapshot from domain data (next subscription: name, logo key, price,
/// days left; upcoming list + monthly total) and push it with the `home_widget` package
/// (`HomeWidget.saveWidgetData` + `updateWidget`). Call [WidgetSync.push] whenever
/// `subscriptionsProvider` / `spendingSummaryProvider` change (watched from the root, like reminderSyncProvider).
class WidgetSync {
  const WidgetSync();

  /// Sends the latest data to the platform widgets. No-op until session W implements it.
  Future<void> push(List<Subscription> subscriptions, SpendingSummary summary, LocalDate today) async {}
}
