import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../data/providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../lock/app_lock.dart';
import 'widget_snapshot.dart';

export 'widget_link.dart';
export 'widget_snapshot.dart';

/// THE single source of "is App lock (PIN) on?" for the home-screen widgets.
///
/// Follows the App lock setting ([pinEnabledProvider], invalidated when the PIN is turned on or
/// off, and by "Delete all data"). Loading or an error counts as ON: the widget then shows only
/// "Locked with PIN" and nothing of the user's data is computed or written.
final appLockEnabledProvider = Provider<AsyncValue<bool>>((ref) => ref.watch(pinEnabledProvider));

/// Where the widget snapshot is stored and how the widgets are told to redraw.
abstract class WidgetStore {
  /// Replaces the stored snapshot with [json] and redraws every widget.
  Future<void> write(String json);

  /// Deletes the stored snapshot and redraws every widget.
  Future<void> clear();
}

/// `home_widget` plugin: Android SharedPreferences `HomeWidgetPreferences` (private to the app),
/// iOS UserDefaults of the App Group [appGroupId] shared with the `SubnestWidget` extension.
class HomeWidgetStore implements WidgetStore {
  HomeWidgetStore();

  static const appGroupId = 'group.com.phiotron.subnest';

  /// iOS widget kind (`SubnestWidget.swift`).
  static const iOSKind = 'SubnestWidget';

  /// Android providers, one per size (`android/app/src/main/kotlin/.../SubnestWidgetProvider.kt`).
  static const androidProviders = [
    'com.phiotron.subnest.SubnestWidgetSmall',
    'com.phiotron.subnest.SubnestWidgetMedium',
    'com.phiotron.subnest.SubnestWidgetLarge',
  ];

  Future<void>? _groupSet;

  @override
  Future<void> write(String json) => _guard(() async {
    await (_groupSet ??= HomeWidget.setAppGroupId(appGroupId));
    await HomeWidget.saveWidgetData<String>(WidgetSnapshot.storageKey, json);
    await _redraw();
  });

  @override
  Future<void> clear() => _guard(() async {
    await (_groupSet ??= HomeWidget.setAppGroupId(appGroupId));
    await HomeWidget.saveWidgetData<String>(WidgetSnapshot.storageKey, null);
    await _redraw();
  });

  Future<void> _redraw() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await HomeWidget.updateWidget(iOSName: iOSKind);
      return;
    }
    for (final name in androidProviders) {
      await HomeWidget.updateWidget(qualifiedAndroidName: name);
    }
  }

  /// No plugin (tests, desktop) or a refusal: the widget keeps its old state and the next
  /// change tries again. A failed `setAppGroupId` is retried next time.
  Future<void> _guard(Future<void> Function() body) async {
    try {
      await body();
    } on MissingPluginException {
      _groupSet = null;
    } on PlatformException catch (e) {
      _groupSet = null;
      debugPrint('widget sync: ${e.code}');
    }
  }
}

final widgetStoreProvider = Provider<WidgetStore>((ref) => HomeWidgetStore());

/// Writes snapshots, skipping one identical to the last write (providers recompute often).
class WidgetSync {
  WidgetSync(this._store);

  final WidgetStore _store;
  String? _last;
  Future<void> _queue = Future.value();

  /// Last JSON written (tests, debugging).
  String? get lastWritten => _last;

  Future<void> push(Map<String, Object?> snapshot) {
    final json = jsonEncode(snapshot);
    if (json == _last) return _queue;
    _last = json;
    return _queue = _queue.then((_) => _store.write(json));
  }

  /// Removes everything the widgets hold (e.g. "Delete all data"); they draw their empty state.
  Future<void> clear() {
    _last = null;
    return _queue = _queue.then((_) => _store.clear());
  }
}

final widgetSyncServiceProvider = Provider<WidgetSync>((ref) => WidgetSync(ref.watch(widgetStoreProvider)));

/// Keeps the home-screen widgets in step with the app. Watched once by the root widget (like
/// `reminderSyncProvider`); recomputes when subscriptions or payments change (both move the Due
/// date), when the Primary currency, a rate or the language changes, at midnight / on resume
/// (`todayProvider`), and when App lock is switched.
///
/// App lock on, loading or unreadable → only the locked snapshot is written: amounts and names are
/// never computed in that case and the previous snapshot is overwritten.
final widgetSyncProvider = Provider<void>((ref) {
  final sync = ref.watch(widgetSyncServiceProvider);
  // Subscribe to every source on the first build, before any early return: a stream first watched
  // in a later rebuild did not always trigger the next rebuild with its first value (Riverpod 3).
  final settings = ref.watch(settingsProvider).value;
  final lock = ref.watch(appLockEnabledProvider);
  final subs = ref.watch(subscriptionsProvider).value;
  final ratesReady = ref.watch(ratesProvider).hasValue;
  // Payments move the Due date through the subscription row; watching them too keeps the widget
  // right if that ever changes.
  ref.watch(periodsProvider);
  final today = ref.watch(todayProvider);
  if (settings == null) return; // Wait for the language.
  final l = lookupAppLocalizations(Locale(settings.localeCode == 'vi' ? 'vi' : 'en'));

  final lockKnownOff = lock.hasValue && !lock.isLoading && !lock.hasError && lock.requireValue == false;
  if (!lockKnownOff) {
    unawaited(sync.push(WidgetSnapshot.locked(l)));
    return;
  }

  // Rates still loading would leave converted subscriptions out of the total for a moment.
  if (subs == null || !ratesReady) return; // Wait for data.
  final summary = ref.watch(spendingSummaryProvider);
  if (summary == null) return;
  unawaited(
    sync.push(
      WidgetSnapshot.build(
        l: l,
        subscriptions: subs,
        summary: summary,
        primaryCurrency: ref.watch(primaryCurrencyProvider),
        today: today,
      ),
    ),
  );
});
