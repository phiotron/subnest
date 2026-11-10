import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/router/routes.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/service_tile_logo.dart';
import 'data/logos/app_logo_source.dart';
import 'data/providers.dart';
import 'data/settings_repository.dart';
import 'features/lock/lock_screen.dart';
import 'features/lock/privacy_screen.dart';
import 'features/widget_sync/widget_sync.dart';
import 'l10n/generated/app_localizations.dart';

/// Root widget: theme, locale, router, and app-lifecycle housekeeping
/// (Trial → Active, daily rate refresh, reminder and home-widget re-sync, notification and widget
/// deep links).
class SubnestApp extends ConsumerStatefulWidget {
  const SubnestApp({super.key, required this.router});

  final GoRouter router;

  @override
  ConsumerState<SubnestApp> createState() => _SubnestAppState();
}

class _SubnestAppState extends ConsumerState<SubnestApp> with WidgetsBindingObserver {
  StreamSubscription<String>? _tapSub;
  StreamSubscription<Uri?>? _widgetTapSub;
  (String, DateTime)? _lastWidgetLink;
  static const _widgetLinkRepeat = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final notifications = ref.read(notificationServiceProvider);
    _tapSub = notifications.taps.listen(_openDeepLink);
    final launch = notifications.launchRoute;
    if (launch != null) {
      notifications.launchRoute = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openDeepLink(launch));
    }
    // Home-screen widget taps: the link that launched the app, then taps while it runs.
    final widgetLinks = ref.read(widgetLinkSourceProvider);
    _widgetTapSub = widgetLinks.taps.listen(_openWidgetLink);
    WidgetsBinding.instance.addPostFrameCallback((_) async => _openWidgetLink(await widgetLinks.initialLink()));
    unawaited(_housekeeping());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tapSub?.cancel();
    _widgetTapSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(todayProvider.notifier).refresh();
      ref.invalidate(notificationsEnabledProvider);
      unawaited(_housekeeping());
    }
  }

  Future<void> _housekeeping() async {
    await ref.read(subscriptionRepositoryProvider).normalizeAll();
    await ref.read(exchangeRateRepositoryProvider).refreshIfStale();
    // Custom logos: read which exist, drop files of subscriptions deleted meanwhile.
    final logos = AppLogoSource.instance.custom;
    await logos.load();
    await logos.keepOnly({for (final s in await ref.read(subscriptionRepositoryProvider).all()) s.id});
  }

  void _openDeepLink(String location) => widget.router.push(location);

  /// A widget row opens that subscription's detail over the current screen; anything else on the
  /// widget opens the Overview. Ignored before onboarding is done (nothing to show yet).
  /// The same tap can arrive twice right after a cold start (start-up read + stream): skip a repeat
  /// of the last link within [_widgetLinkRepeat].
  Future<void> _openWidgetLink(Uri? link) async {
    final location = widgetRouteFor(link);
    if (location == null || !mounted) return;
    final now = DateTime.now();
    final last = _lastWidgetLink;
    if (last != null && last.$1 == location && now.difference(last.$2) < _widgetLinkRepeat) return;
    _lastWidgetLink = (location, now);
    final settings = await ref.read(settingsProvider.future);
    if (!settings.onboardingDone || !mounted) return;
    if (location == AppRoutes.home) {
      widget.router.go(location);
    } else {
      widget.router.push(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(reminderSyncProvider);
    ref.watch(widgetSyncProvider);
    ref.watch(privacyScreenSyncProvider);
    final settings = ref.watch(settingsProvider).value;
    // English is the default for every new install; only English and Vietnamese are offered (S-90).
    final code = settings?.localeCode ?? 'en';
    // Service logos for every ServiceTile: bundled Catalog logos + the user's Custom logos (offline).
    return ServiceLogoScope(
      source: AppLogoSource.instance,
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).commonAppName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: switch (settings?.themeMode ?? AppThemeMode.system) {
          AppThemeMode.system => ThemeMode.system,
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
        },
        locale: Locale(code),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: widget.router,
        // App lock: the lock screen covers every route (they stay mounted, hidden, underneath), so
        // notification and widget deep links land behind it and show after the right PIN.
        builder: (context, child) => LockGate(router: widget.router, child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
